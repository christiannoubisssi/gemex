import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class ClientRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  ClientRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<Client>> getAll({String? search, String? typeClient}) =>
      _db.clientsDao.getAll(search: search, typeClient: typeClient);

  Stream<List<Client>> watchAll() => _db.clientsDao.watchAll();

  Future<Client?> getById(String id) => _db.clientsDao.getById(id);

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final companion = ClientsCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? 'default',
      typeClient: data['type_client'] as String? ?? AppConstants.clientEntreprise,
      nom: data['nom'] as String,
      contactNom: drift.Value(data['contact_nom'] as String?),
      email: drift.Value(data['email'] as String?),
      telephone: drift.Value(data['telephone'] as String?),
      adresse: drift.Value(data['adresse'] as String?),
      ville: drift.Value(data['ville'] as String?),
      pays: const drift.Value('Gabon'),
      notes: drift.Value(data['notes'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );
    await _db.clientsDao.upsert(companion);

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, {...data, 'id': id}, 'create');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'create', payload: jsonEncode({...data, 'id': id}));
    }
    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.clientsDao.upsert(ClientsCompanion(
      id: drift.Value(id),
      nom: data.containsKey('nom') ? drift.Value(data['nom'] as String) : const drift.Value.absent(),
      email: data.containsKey('email') ? drift.Value(data['email'] as String?) : const drift.Value.absent(),
      telephone: data.containsKey('telephone') ? drift.Value(data['telephone'] as String?) : const drift.Value.absent(),
      adresse: data.containsKey('adresse') ? drift.Value(data['adresse'] as String?) : const drift.Value.absent(),
      ville: data.containsKey('ville') ? drift.Value(data['ville'] as String?) : const drift.Value.absent(),
      notes: data.containsKey('notes') ? drift.Value(data['notes'] as String?) : const drift.Value.absent(),
      syncStatus: const drift.Value(AppConstants.syncPending),
      updatedAt: drift.Value(DateTime.now()),
    ));
    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, data, 'update');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'update', payload: jsonEncode({...data, 'id': id}));
    }
  }

  Future<void> _trySync(String id, Map<String, dynamic> data, String op) async {
    try {
      if (op == 'create') {
        await _supabase.from('clients').insert(data);
      } else {
        await _supabase.from('clients').update(data).eq('id', id);
      }
      await _db.clientsDao.markSynced(id);
    } catch (_) {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: op, payload: jsonEncode({...data, 'id': id}));
    }
  }
}
