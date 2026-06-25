import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';

final referentielRepositoryProvider = Provider<ReferentielRepository>((ref) {
  return ReferentielRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class ReferentielRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  ReferentielRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<Referentiel>> getAll({required String type, bool? actif}) {
    return _db.referentielsDao.getAll(type: type, actif: actif);
  }

  Stream<List<Referentiel>> watchAll({required String type}) {
    return _db.referentielsDao.watchAll(type: type);
  }

  Future<String> add({
    required String type,
    required String nom,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    await _db.referentielsDao.upsert(ReferentielsCompanion.insert(
      id: id,
      type: type,
      nom: nom,
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    ));

    final syncData = {
      'id': id,
      'entreprise_id': 'default',
      'type': type,
      'nom': nom,
      'actif': true,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, syncData, 'create');
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'referentiel',
        entityId: id,
        operation: 'create',
        payload: jsonEncode(toJsonSafe(syncData)),
      );
    }
    return id;
  }

  Future<void> updateNom(String id, String nom) async {
    final now = DateTime.now();
    await _db.referentielsDao.upsert(ReferentielsCompanion(
      id: drift.Value(id),
      nom: drift.Value(nom),
      syncStatus: const drift.Value('pending'),
      updatedAt: drift.Value(now),
    ));

    final syncData = {'nom': nom, 'updated_at': now.toIso8601String()};

    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase
            .from('referentiels')
            .update(toJsonSafe(syncData))
            .eq('id', id);
        await _db.referentielsDao.markSynced(id);
      } catch (e, s) {
        AppLogger.e('ReferentielRepository', 'Échec sync update $id',
            error: e, stack: s);
        await _db.syncQueueDao.enqueue(
          entityType: 'referentiel',
          entityId: id,
          operation: 'update',
          payload: jsonEncode(toJsonSafe({...syncData, 'id': id})),
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'referentiel',
        entityId: id,
        operation: 'update',
        payload: jsonEncode(toJsonSafe({...syncData, 'id': id})),
      );
    }
  }

  Future<void> deleteById(String id) async {
    await _db.referentielsDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('referentiels').delete().eq('id', id);
      } catch (e, s) {
        AppLogger.e('ReferentielRepository', 'Échec suppression Supabase $id',
            error: e, stack: s);
        await _db.syncQueueDao.enqueue(
          entityType: 'referentiel',
          entityId: id,
          operation: 'delete',
          payload: '{}',
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'referentiel',
        entityId: id,
        operation: 'delete',
        payload: '{}',
      );
    }
  }

  Future<void> _trySync(
      String id, Map<String, dynamic> data, String op) async {
    try {
      await _supabase.from('referentiels').insert(toJsonSafe(data));
      await _db.referentielsDao.markSynced(id);
      AppLogger.i(
          'ReferentielRepository', 'Référentiel $id synchronisé');
    } catch (e, s) {
      AppLogger.e('ReferentielRepository', 'Échec sync $id ($op)',
          error: e, stack: s);
      await _db.syncQueueDao.enqueue(
        entityType: 'referentiel',
        entityId: id,
        operation: op,
        payload: jsonEncode(toJsonSafe({...data, 'id': id})),
      );
    }
  }
}
