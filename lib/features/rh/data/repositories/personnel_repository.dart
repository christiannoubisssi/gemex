import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';

final personnelRepositoryProvider = Provider<PersonnelRepository>((ref) {
  return PersonnelRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class PersonnelRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  PersonnelRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<PersonnelData>> getAll({bool? actif}) =>
      _db.personnelDao.getAll(actif: actif);

  Stream<List<PersonnelData>> watchAll({bool? actif}) =>
      _db.personnelDao.watchAll(actif: actif);

  Future<PersonnelData?> getById(String id) => _db.personnelDao.getById(id);

  Future<void> add({
    required String nom,
    String? prenom,
    String? poste,
    String? departement,
    String typeContrat = 'CDI',
    DateTime? dateEmbauche,
    DateTime? dateFinContrat,
    double? salaireBase,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _db.personnelDao.upsert(PersonnelCompanion.insert(
      id: id,
      entrepriseId: 'default',
      nom: nom,
      prenom: Value(prenom),
      poste: Value(poste),
      departement: Value(departement),
      typeContrat: Value(typeContrat),
      dateEmbauche: Value(dateEmbauche),
      dateFinContrat: Value(dateFinContrat),
      salaireBase: Value(salaireBase),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    final syncData = {
      'id': id,
      'entreprise_id': 'default',
      'nom': nom,
      'prenom': prenom,
      'poste': poste,
      'departement': departement,
      'type_contrat': typeContrat,
      'date_embauche': dateEmbauche?.toIso8601String(),
      'date_fin_contrat': dateFinContrat?.toIso8601String(),
      'salaire_base': salaireBase,
      'actif': true,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await _trySyncCreate('personnel', 'personnel', id, syncData);
  }

  Future<void> update(PersonnelCompanion companion) async {
    final id = companion.id.value;
    await _db.personnelDao.upsert(companion);
    final p = await _db.personnelDao.getById(id);
    if (p == null) return;

    final syncData = {
      'entreprise_id': p.entrepriseId,
      'utilisateur_id': p.utilisateurId,
      'nom': p.nom,
      'prenom': p.prenom,
      'poste': p.poste,
      'departement': p.departement,
      'type_contrat': p.typeContrat,
      'date_embauche': p.dateEmbauche?.toIso8601String(),
      'date_fin_contrat': p.dateFinContrat?.toIso8601String(),
      'salaire_base': p.salaireBase,
      'actif': p.actif,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _trySyncUpdate('personnel', 'personnel', id, syncData);
  }

  Future<void> toggleActif(String id, bool actif) async {
    await _db.personnelDao.toggleActif(id, actif);
    await _trySyncUpdate('personnel', 'personnel', id, {'actif': actif, 'updated_at': DateTime.now().toIso8601String()});
  }

  // Congés
  Future<List<Conge>> getCongesByPersonnel(String personnelId) =>
      _db.congesDao.getByPersonnel(personnelId);

  Future<List<Conge>> getAllConges({String? statut}) =>
      _db.congesDao.getAll(statut: statut);

  Future<List<Conge>> getCongesForRange(DateTime from, DateTime to) =>
      _db.congesDao.getForRange(from, to);

  Future<void> addConge({
    required String personnelId,
    required DateTime dateDebut,
    required DateTime dateFin,
    String type = 'conge_annuel',
    String? motif,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _db.congesDao.upsert(CongesCompanion.insert(
      id: id,
      personnelId: personnelId,
      dateDebut: dateDebut,
      dateFin: dateFin,
      type: Value(type),
      motif: Value(motif),
      // Nouveau statut par défaut
      statut: const Value('programme'),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    final syncData = {
      'id': id,
      'personnel_id': personnelId,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'type': type,
      'motif': motif,
      'statut': 'programme',
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await _trySyncCreate('conge', 'conges', id, syncData);
  }

  Future<void> updateStatutConge(String id, String statut, {String? validePar}) async {
    await _db.congesDao.updateStatut(id, statut, validePar: validePar);
    await _trySyncUpdate('conge', 'conges', id, {
      'statut': statut,
      if (validePar != null) 'valide_par': validePar,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteConge(String id) async {
    await _db.congesDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('conges').delete().eq('id', id);
        return;
      } catch (e, s) {
        AppLogger.e('PersonnelRepository', 'Échec suppression Supabase congé $id', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: 'conge', entityId: id, operation: 'delete', payload: '{}');
  }

  /// Synchronise une création vers Supabase. Échec silencieux mis en file
  /// d'attente : pour `personnel`/`conges`, l'utilisateur peut ne pas avoir
  /// les droits RLS (admin/rh uniquement) — la mise en file est attendue.
  Future<void> _trySyncCreate(String entityType, String table, String id, Map<String, dynamic> data) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from(table).insert(toJsonSafe(data));
        if (entityType == 'personnel') await _db.personnelDao.markSynced(id);
        if (entityType == 'conge') await _db.congesDao.markSynced(id);
        AppLogger.i('PersonnelRepository', '$entityType $id synchronisé avec Supabase');
        return;
      } catch (e, s) {
        AppLogger.e('PersonnelRepository', 'Échec sync Supabase $entityType $id (create)', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: entityType, entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }

  Future<void> _trySyncUpdate(String entityType, String table, String id, Map<String, dynamic> data) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from(table).update(toJsonSafe(data)).eq('id', id);
        if (entityType == 'personnel') await _db.personnelDao.markSynced(id);
        if (entityType == 'conge') await _db.congesDao.markSynced(id);
        AppLogger.i('PersonnelRepository', '$entityType $id synchronisé avec Supabase');
        return;
      } catch (e, s) {
        AppLogger.e('PersonnelRepository', 'Échec sync Supabase $entityType $id (update)', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: entityType, entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }
}
