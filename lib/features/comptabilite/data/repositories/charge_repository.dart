import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';
import 'package:drift/drift.dart' show Value;

final chargeRepositoryProvider = Provider<ChargeRepository>((ref) {
  return ChargeRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class ChargeRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  ChargeRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<Charge>> getAll({int? mois, int? annee, String? categorie}) {
    return _db.chargesDao.getAll(mois: mois, annee: annee, categorie: categorie);
  }

  Future<List<Charge>> getByDossier(String dossierId) {
    return _db.chargesDao.getByDossier(dossierId);
  }

  Future<void> add({
    required String entrepriseId,
    required String categorie,
    required String libelle,
    required double montant,
    required DateTime dateCharge,
    String? dossierId,
    String? saisiPar,
    String? notes,
    String recurrence = 'unique',
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _db.chargesDao.upsert(ChargesCompanion.insert(
      id: id,
      entrepriseId: entrepriseId,
      categorie: categorie,
      libelle: libelle,
      montant: montant,
      dateCharge: dateCharge,
      mois: dateCharge.month,
      annee: dateCharge.year,
      dossierId: Value(dossierId),
      saisiPar: Value(saisiPar),
      notes: Value(notes),
      recurrence: Value(recurrence),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    final syncData = {
      'id': id,
      'entreprise_id': entrepriseId,
      'dossier_id': dossierId,
      'saisi_par': saisiPar,
      'categorie': categorie,
      'libelle': libelle,
      'montant': montant,
      'date_charge': dateCharge.toIso8601String(),
      'mois': dateCharge.month,
      'annee': dateCharge.year,
      'notes': notes,
      'recurrence': recurrence,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, syncData, 'create');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
    }
  }

  Future<void> update(ChargesCompanion companion) async {
    final id = companion.id.value;
    await _db.chargesDao.upsert(companion);
    final charge = await _db.chargesDao.getById(id);
    if (charge == null) return;

    final syncData = {
      'entreprise_id': charge.entrepriseId,
      'dossier_id': charge.dossierId,
      'saisi_par': charge.saisiPar,
      'categorie': charge.categorie,
      'libelle': charge.libelle,
      'montant': charge.montant,
      'date_charge': charge.dateCharge.toIso8601String(),
      'mois': charge.mois,
      'annee': charge.annee,
      'justificatif_url': charge.justificatifUrl,
      'notes': charge.notes,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, syncData, 'update');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...syncData, 'id': id})));
    }
  }

  Future<void> delete(String id) async {
    await _db.chargesDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('charges').delete().eq('id', id);
      } catch (e, s) {
        AppLogger.e('ChargeRepository', 'Échec suppression Supabase charge $id', error: e, stack: s);
        await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: id, operation: 'delete', payload: '{}');
      }
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: id, operation: 'delete', payload: '{}');
    }
  }

  Future<double> getTotalParMois(int mois, int annee) {
    return _db.chargesDao.getTotalParMois(mois, annee);
  }

  Future<Map<String, double>> getTotalParCategorie(int mois, int annee) {
    return _db.chargesDao.getTotalParCategorie(mois, annee);
  }

  /// Génère les charges récurrentes depuis une période source vers une cible.
  /// Retourne le nombre de charges générées.
  Future<int> generateRecurrentes({
    required int moisSource,
    required int anneeSource,
    required int moisCible,
    required int anneeCible,
  }) async {
    final recurrentes =
        await _db.chargesDao.getRecurrentes(moisSource, anneeSource);
    int count = 0;

    for (final charge in recurrentes) {
      // Vérifie si la récurrence correspond à la période cible
      if (!_shouldRecur(charge.recurrence, moisSource, anneeSource,
          moisCible, anneeCible)) {
        continue;
      }
      // Vérifie qu'il n'existe pas déjà une charge similaire
      final existing = await _db.chargesDao
          .getAll(mois: moisCible, annee: anneeCible, categorie: charge.categorie);
      final alreadyExists = existing.any((c) =>
          c.libelle == charge.libelle &&
          c.montant == charge.montant);
      if (alreadyExists) continue;

      final newDate = DateTime(anneeCible, moisCible, charge.dateCharge.day.clamp(1, 28));
      await add(
        entrepriseId: charge.entrepriseId,
        categorie: charge.categorie,
        libelle: charge.libelle,
        montant: charge.montant,
        dateCharge: newDate,
        dossierId: charge.dossierId,
        notes: charge.notes,
        recurrence: charge.recurrence,
      );
      count++;
    }
    return count;
  }

  /// Détermine si une charge récurrente doit être dupliquée pour la période cible
  bool _shouldRecur(String recurrence, int moisSrc, int anneeSrc,
      int moisDst, int anneeDst) {
    switch (recurrence) {
      case 'mensuel':
        return true;
      case 'trimestriel':
        final diffMois = (anneeDst - anneeSrc) * 12 + (moisDst - moisSrc);
        return diffMois % 3 == 0;
      case 'annuel':
        return moisDst == moisSrc && anneeDst != anneeSrc;
      default:
        return false;
    }
  }

  Future<void> _trySync(String id, Map<String, dynamic> data, String op) async {
    try {
      if (op == 'create') {
        await _supabase.from('charges').insert(toJsonSafe(data));
      } else {
        await _supabase.from('charges').update(toJsonSafe(data)).eq('id', id);
      }
      await _db.chargesDao.markSynced(id);
      AppLogger.i('ChargeRepository', 'Charge $id synchronisée avec Supabase');
    } catch (e, s) {
      AppLogger.e('ChargeRepository', 'Échec sync Supabase charge $id ($op)', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: id, operation: op, payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
  }
}
