import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
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
      pays: drift.Value(data['pays'] as String? ?? 'Gabon'),
      numeroTva: drift.Value(data['numero_tva'] as String?),
      rccm: drift.Value(data['rccm'] as String?),
      nif: drift.Value(data['nif'] as String?),
      notes: drift.Value(data['notes'] as String?),
      reference: drift.Value(data['reference'] as String?),
      refOleaUnique: drift.Value(data['ref_olea_unique'] as String?),
      refAgl: drift.Value(data['ref_agl'] as String?),
      refDs: drift.Value(data['ref_ds'] as String?),
      cabinetBce: drift.Value(data['cabinet_bce'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );
    await _db.clientsDao.upsert(companion);

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, {...data, 'id': id}, 'create');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.clientsDao.upsert(ClientsCompanion(
      id: drift.Value(id),
      typeClient: data.containsKey('type_client') ? drift.Value(data['type_client'] as String) : const drift.Value.absent(),
      nom: data.containsKey('nom') ? drift.Value(data['nom'] as String) : const drift.Value.absent(),
      contactNom: data.containsKey('contact_nom') ? drift.Value(data['contact_nom'] as String?) : const drift.Value.absent(),
      email: data.containsKey('email') ? drift.Value(data['email'] as String?) : const drift.Value.absent(),
      telephone: data.containsKey('telephone') ? drift.Value(data['telephone'] as String?) : const drift.Value.absent(),
      adresse: data.containsKey('adresse') ? drift.Value(data['adresse'] as String?) : const drift.Value.absent(),
      ville: data.containsKey('ville') ? drift.Value(data['ville'] as String?) : const drift.Value.absent(),
      pays: data.containsKey('pays') ? drift.Value(data['pays'] as String?) : const drift.Value.absent(),
      numeroTva: data.containsKey('numero_tva') ? drift.Value(data['numero_tva'] as String?) : const drift.Value.absent(),
      rccm: data.containsKey('rccm') ? drift.Value(data['rccm'] as String?) : const drift.Value.absent(),
      nif: data.containsKey('nif') ? drift.Value(data['nif'] as String?) : const drift.Value.absent(),
      notes: data.containsKey('notes') ? drift.Value(data['notes'] as String?) : const drift.Value.absent(),
      reference: data.containsKey('reference') ? drift.Value(data['reference'] as String?) : const drift.Value.absent(),
      refOleaUnique: data.containsKey('ref_olea_unique') ? drift.Value(data['ref_olea_unique'] as String?) : const drift.Value.absent(),
      refAgl: data.containsKey('ref_agl') ? drift.Value(data['ref_agl'] as String?) : const drift.Value.absent(),
      refDs: data.containsKey('ref_ds') ? drift.Value(data['ref_ds'] as String?) : const drift.Value.absent(),
      cabinetBce: data.containsKey('cabinet_bce') ? drift.Value(data['cabinet_bce'] as String?) : const drift.Value.absent(),
      syncStatus: const drift.Value(AppConstants.syncPending),
      updatedAt: drift.Value(DateTime.now()),
    ));
    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, data, 'update');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
  }

  Future<void> _trySync(String id, Map<String, dynamic> data, String op) async {
    try {
      if (op == 'create') {
        await _supabase.from('clients').insert(toJsonSafe(data));
      } else {
        await _supabase.from('clients').update(toJsonSafe(data)).eq('id', id);
      }
      await _db.clientsDao.markSynced(id);
      AppLogger.i('ClientRepository', 'Client $id synchronisé avec Supabase');
    } catch (e, s) {
      AppLogger.e('ClientRepository', 'Échec sync Supabase client $id ($op)', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: op, payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
  }

  // ─── Contacts ────────────────────────────────────────────────────────────

  Future<List<ClientContact>> getContacts(String clientId) =>
      _db.clientContactsDao.getByClient(clientId);

  Future<String> addContact({
    required String clientId,
    required String nom,
    String? fonction,
    String? telephone,
    String? email,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _db.clientContactsDao.upsert(ClientContactsCompanion.insert(
      id: id,
      clientId: clientId,
      nom: nom,
      fonction: drift.Value(fonction),
      telephone: drift.Value(telephone),
      email: drift.Value(email),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    ));

    final syncData = {
      'id': id,
      'client_id': clientId,
      'nom': nom,
      'fonction': fonction,
      'telephone': telephone,
      'email': email,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };
    await _trySyncContact(id, syncData, 'create');
    return id;
  }

  Future<void> updateContact(String id, Map<String, dynamic> data) async {
    await _db.clientContactsDao.upsert(ClientContactsCompanion(
      id: drift.Value(id),
      nom: data.containsKey('nom') ? drift.Value(data['nom'] as String) : const drift.Value.absent(),
      fonction: data.containsKey('fonction') ? drift.Value(data['fonction'] as String?) : const drift.Value.absent(),
      telephone: data.containsKey('telephone') ? drift.Value(data['telephone'] as String?) : const drift.Value.absent(),
      email: data.containsKey('email') ? drift.Value(data['email'] as String?) : const drift.Value.absent(),
      syncStatus: const drift.Value(AppConstants.syncPending),
      updatedAt: drift.Value(DateTime.now()),
    ));
    await _trySyncContact(id, data, 'update');
  }

  Future<void> deleteContact(String id) async {
    await _db.clientContactsDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('client_contacts').delete().eq('id', id);
        return;
      } catch (e, s) {
        AppLogger.e('ClientRepository', 'Échec suppression Supabase contact $id', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: 'client_contact', entityId: id, operation: 'delete', payload: '{}');
  }

  Future<void> _trySyncContact(String id, Map<String, dynamic> data, String op) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        if (op == 'create') {
          await _supabase.from('client_contacts').insert(toJsonSafe({...data, 'id': id}));
        } else {
          await _supabase.from('client_contacts').update(toJsonSafe(data)).eq('id', id);
        }
        await _db.clientContactsDao.markSynced(id);
        AppLogger.i('ClientRepository', 'Contact $id synchronisé avec Supabase');
        return;
      } catch (e, s) {
        AppLogger.e('ClientRepository', 'Échec sync Supabase contact $id ($op)', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: 'client_contact', entityId: id, operation: op, payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }
}
