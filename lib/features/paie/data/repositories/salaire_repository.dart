import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';

final salaireRepositoryProvider = Provider<SalaireRepository>((ref) {
  return SalaireRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class SalaireRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  SalaireRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<Salaire>> getByMoisAnnee(int mois, int annee) =>
      _db.salairesDao.getByMoisAnnee(mois, annee);

  Future<List<Salaire>> getByPersonnel(String personnelId) =>
      _db.salairesDao.getByPersonnel(personnelId);

  /// Crée une fiche de paie vierge pour chaque actif qui n'en a pas encore ce mois.
  Future<void> initierMois(int mois, int annee) async {
    final actifs = await _db.personnelDao.getAll(actif: true);
    for (final p in actifs) {
      final existing = await _db.salairesDao.getByPersonnelMois(p.id, mois, annee);
      if (existing != null) continue;
      final base = p.salaireBase ?? 0.0;
      final id = const Uuid().v4();
      final now = DateTime.now();
      await _db.salairesDao.upsert(SalairesCompanion.insert(
        id: id,
        entrepriseId: p.entrepriseId,
        personnelId: p.id,
        mois: mois,
        annee: annee,
        salaireBrut: Value(base),
        salaireNet: base,
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      await _trySyncCreate(id, {
        'id': id,
        'entreprise_id': p.entrepriseId,
        'personnel_id': p.id,
        'mois': mois,
        'annee': annee,
        'salaire_brut': base,
        'salaire_net': base,
        'statut': 'en_attente',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });
    }
  }

  Future<void> updateSalaire(SalairesCompanion companion) async {
    final id = companion.id.value;
    await _db.salairesDao.upsert(companion);
    final s = await _db.salairesDao.getById(id);
    if (s == null) return;

    await _trySyncUpdate(id, {
      'entreprise_id': s.entrepriseId,
      'personnel_id': s.personnelId,
      'mois': s.mois,
      'annee': s.annee,
      'salaire_brut': s.salaireBrut,
      'cnps': s.cnps,
      'irpp': s.irpp,
      'autres_retenues': s.autresRetenues,
      'salaire_net': s.salaireNet,
      'statut': s.statut,
      'mode_paiement': s.modePaiement,
      'notes': s.notes,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> valider(String id) async {
    await _db.salairesDao.updateStatut(id, 'valide');
    await _trySyncUpdate(id, {
      'statut': 'valide',
      'date_validation': DateTime.now().toIso8601String(),
    });
  }

  /// Marque payé et crée une charge "Salaires" correspondante.
  Future<void> marquerPaye(String id) async {
    final salaire = await _db.salairesDao.getById(id);
    final now = DateTime.now();
    await _db.salairesDao.updateStatut(id, 'paye');
    await _trySyncUpdate(id, {
      'statut': 'paye',
      'date_paiement': now.toIso8601String(),
    });

    if (salaire != null && !salaire.comptabilise) {
      final chargeId = const Uuid().v4();
      await _db.chargesDao.upsert(ChargesCompanion.insert(
        id: chargeId,
        entrepriseId: salaire.entrepriseId,
        categorie: 'Salaires',
        libelle: 'Salaire ${salaire.mois}/${salaire.annee}',
        montant: salaire.salaireNet,
        dateCharge: now,
        mois: salaire.mois,
        annee: salaire.annee,
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
      await _db.salairesDao.marquerComptabilise(id, chargeId);

      // Synchronise la charge générée
      if (_ref.read(isOnlineProvider)) {
        try {
          await _supabase.from('charges').insert(toJsonSafe({
            'id': chargeId,
            'entreprise_id': salaire.entrepriseId,
            'categorie': 'Salaires',
            'libelle': 'Salaire ${salaire.mois}/${salaire.annee}',
            'montant': salaire.salaireNet,
            'date_charge': now.toIso8601String(),
            'mois': salaire.mois,
            'annee': salaire.annee,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          }));
          await _db.chargesDao.markSynced(chargeId);
        } catch (e, s) {
          AppLogger.e('SalaireRepository', 'Échec sync Supabase charge $chargeId (salaire)', error: e, stack: s);
          await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: chargeId, operation: 'create', payload: jsonEncode(toJsonSafe({
            'id': chargeId,
            'entreprise_id': salaire.entrepriseId,
            'categorie': 'Salaires',
            'libelle': 'Salaire ${salaire.mois}/${salaire.annee}',
            'montant': salaire.salaireNet,
            'date_charge': now.toIso8601String(),
            'mois': salaire.mois,
            'annee': salaire.annee,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })));
        }
      } else {
        await _db.syncQueueDao.enqueue(entityType: 'charge', entityId: chargeId, operation: 'create', payload: jsonEncode(toJsonSafe({
          'id': chargeId,
          'entreprise_id': salaire.entrepriseId,
          'categorie': 'Salaires',
          'libelle': 'Salaire ${salaire.mois}/${salaire.annee}',
          'montant': salaire.salaireNet,
          'date_charge': now.toIso8601String(),
          'mois': salaire.mois,
          'annee': salaire.annee,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        })));
      }

      await _trySyncUpdate(id, {'comptabilise': true, 'charge_id': chargeId});
    }
  }

  Future<double> getMasseSalariale(int mois, int annee) =>
      _db.salairesDao.getMasseSalariale(mois, annee);

  /// Synchronise la création d'un salaire vers Supabase (réservé admin/rh
  /// côté RLS — échec mis en file d'attente sans bloquer l'UI).
  Future<void> _trySyncCreate(String id, Map<String, dynamic> data) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('salaires').insert(toJsonSafe(data));
        await _db.salairesDao.markSynced(id);
        AppLogger.i('SalaireRepository', 'Salaire $id synchronisé avec Supabase');
        return;
      } catch (e, s) {
        AppLogger.e('SalaireRepository', 'Échec sync Supabase salaire $id (create)', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: 'salaire', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }

  Future<void> _trySyncUpdate(String id, Map<String, dynamic> data) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('salaires').update(toJsonSafe(data)).eq('id', id);
        await _db.salairesDao.markSynced(id);
        AppLogger.i('SalaireRepository', 'Salaire $id synchronisé avec Supabase');
        return;
      } catch (e, s) {
        AppLogger.e('SalaireRepository', 'Échec sync Supabase salaire $id (update)', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: 'salaire', entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }
}
