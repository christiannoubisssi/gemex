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
import '../../../../shared/services/audit_service.dart';

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

  /// Normalise une valeur de formulaire : chaîne vide → null.
  static String? _str(Map<String, dynamic> data, String key) {
    final v = data[key] as String?;
    return (v == null || v.trim().isEmpty) ? null : v.trim();
  }

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final companion = ClientsCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? 'default',
      typeClient: data['type_client'] as String? ?? AppConstants.clientEntreprise,
      nom: data['nom'] as String,
      contactNom: drift.Value(_str(data, 'contact_nom')),
      email: drift.Value(_str(data, 'email')),
      telephone: drift.Value(_str(data, 'telephone')),
      adresse: drift.Value(_str(data, 'adresse')),
      ville: drift.Value(_str(data, 'ville')),
      pays: drift.Value(_str(data, 'pays') ?? 'Gabon'),
      numeroTva: drift.Value(_str(data, 'numero_tva')),
      rccm: drift.Value(_str(data, 'rccm')),
      nif: drift.Value(_str(data, 'nif')),
      notes: drift.Value(_str(data, 'notes')),
      reference: drift.Value(_str(data, 'reference')),
      refOleaUnique: drift.Value(_str(data, 'ref_olea_unique')),
      refAgl: drift.Value(_str(data, 'ref_agl')),
      refDs: drift.Value(_str(data, 'ref_ds')),
      cabinetBce: drift.Value(_str(data, 'cabinet_bce')),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );
    await _db.clientsDao.upsert(companion);

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, {...data, 'id': id}, 'create');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }

    _ref.read(auditServiceProvider).log(
      actionType: AuditActions.clientCree,
      entityType: 'client',
      entityId: id,
      entityLabel: data['nom'] as String?,
      description: 'Client créé : ${data['nom'] ?? id}',
    );
    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    // Helper local : normalise et présente si la clé est présente, absent sinon
    drift.Value<String?> _v(String key) =>
        data.containsKey(key) ? drift.Value(_str(data, key)) : const drift.Value.absent();

    await _db.clientsDao.upsert(ClientsCompanion(
      id: drift.Value(id),
      typeClient: data.containsKey('type_client') ? drift.Value(data['type_client'] as String) : const drift.Value.absent(),
      nom: data.containsKey('nom') ? drift.Value(data['nom'] as String) : const drift.Value.absent(),
      contactNom: _v('contact_nom'),
      email: _v('email'),
      telephone: _v('telephone'),
      adresse: _v('adresse'),
      ville: _v('ville'),
      pays: data.containsKey('pays') ? drift.Value(_str(data, 'pays') ?? 'Gabon') : const drift.Value.absent(),
      numeroTva: _v('numero_tva'),
      rccm: _v('rccm'),
      nif: _v('nif'),
      notes: _v('notes'),
      reference: _v('reference'),
      refOleaUnique: _v('ref_olea_unique'),
      refAgl: _v('ref_agl'),
      refDs: _v('ref_ds'),
      cabinetBce: _v('cabinet_bce'),
      syncStatus: const drift.Value(AppConstants.syncPending),
      updatedAt: drift.Value(DateTime.now()),
    ));
    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, data, 'update');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'client', entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }

    _ref.read(auditServiceProvider).log(
      actionType: AuditActions.clientModifie,
      entityType: 'client',
      entityId: id,
      entityLabel: data['nom'] as String?,
      description: 'Client modifié : ${data['nom'] ?? id}',
    );
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
