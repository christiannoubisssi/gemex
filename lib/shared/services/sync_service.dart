import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/services/app_logger.dart';
import '../../database/app_database.dart';
import '../../features/clients/presentation/providers/client_provider.dart';

enum SyncStatus { idle, syncing, error, offline }

final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.idle);

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class SyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;
  Timer? _retryTimer;
  bool _isSyncing = false;

  SyncService({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  void start() {
    // Pull initial si déjà connecté au démarrage (ex : rechargement page web)
    if (_ref.read(isOnlineProvider)) syncNow();

    _ref.listen<bool>(isOnlineProvider, (prev, isOnline) {
      if (isOnline && prev != true) {
        syncNow();
      }
      if (!isOnline) {
        _ref.read(syncStatusProvider.notifier).state = SyncStatus.offline;
      }
    });
    _retryTimer = Timer.periodic(const Duration(seconds: AppConstants.syncIntervalSeconds), (_) {
      if (_ref.read(isOnlineProvider)) syncNow();
    });
  }

  void dispose() {
    _retryTimer?.cancel();
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _ref.read(syncStatusProvider.notifier).state = SyncStatus.syncing;

    try {
      AppLogger.i('SyncService', 'Début de la synchronisation');
      // 1. Récupérer depuis Supabase → base locale (partage entre utilisateurs)
      await _pullClients();
      await _pullClientContacts();

      // 2. Pousser les modifications locales en attente vers Supabase
      final pending = await _db.syncQueueDao.getPending(maxAttempts: AppConstants.maxSyncAttempts);
      AppLogger.d('SyncService', '${pending.length} élément(s) en attente');
      for (final item in pending) {
        await _processItem(item);
      }
      AppLogger.i('SyncService', 'Synchronisation terminée');
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.idle;
    } catch (e, s) {
      AppLogger.e('SyncService', 'Erreur de synchronisation', error: e, stack: s);
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.error;
    } finally {
      _isSyncing = false;
    }
  }

  // ─── Pull : Supabase → Drift local ──────────────────────────────────────

  /// Récupère tous les clients depuis Supabase et les upsert en local.
  /// Permet à tout utilisateur de voir les clients créés par les autres.
  Future<void> _pullClients() async {
    try {
      final rows = await _supabase.from('clients').select() as List;
      for (final raw in rows) {
        final m = Map<String, dynamic>.from(raw as Map);
        await _db.clientsDao.upsert(ClientsCompanion(
          id:           drift.Value(m['id'] as String),
          entrepriseId: drift.Value(m['entreprise_id'] as String? ?? 'default'),
          typeClient:   drift.Value(m['type_client'] as String? ?? AppConstants.clientEntreprise),
          nom:          drift.Value(m['nom'] as String? ?? ''),
          contactNom:   drift.Value(m['contact_nom'] as String?),
          email:        drift.Value(m['email'] as String?),
          telephone:    drift.Value(m['telephone'] as String?),
          adresse:      drift.Value(m['adresse'] as String?),
          ville:        drift.Value(m['ville'] as String?),
          pays:         drift.Value(m['pays'] as String? ?? 'Gabon'),
          numeroTva:    drift.Value(m['numero_tva'] as String?),
          rccm:         drift.Value(m['rccm'] as String?),
          nif:          drift.Value(m['nif'] as String?),
          notes:        drift.Value(m['notes'] as String?),
          syncStatus:   const drift.Value('synced'),
        ));
      }
      // Rafraîchir les providers liés aux clients dans l'UI
      _ref.invalidate(clientsProvider);
      _ref.invalidate(clientsMapProvider);
    } catch (_) {
      // Échec silencieux — les données locales restent intactes
    }
  }

  /// Récupère tous les contacts clients depuis Supabase et les upsert en local.
  Future<void> _pullClientContacts() async {
    try {
      final rows = await _supabase.from('client_contacts').select() as List;
      for (final raw in rows) {
        final m = Map<String, dynamic>.from(raw as Map);
        await _db.clientContactsDao.upsert(ClientContactsCompanion(
          id:         drift.Value(m['id'] as String),
          clientId:   drift.Value(m['client_id'] as String),
          nom:        drift.Value(m['nom'] as String? ?? ''),
          fonction:   drift.Value(m['fonction'] as String?),
          telephone:  drift.Value(m['telephone'] as String?),
          email:      drift.Value(m['email'] as String?),
          syncStatus: const drift.Value('synced'),
        ));
      }
    } catch (_) {
      // Échec silencieux — les données locales restent intactes
    }
  }

  // ─── Push : Drift local → Supabase ──────────────────────────────────────

  /// Tables Supabase dont le nom ne suit pas la convention `${entityType}s`.
  static const Map<String, String> _tableOverrides = {
    'piece_jointe': 'pieces_jointes',
    'charge_modele': 'charges_modeles',
    'personnel': 'personnel',
  };

  /// Types d'entités correspondant aux lignes de documents (payload = liste).
  static const Set<String> _lignesTypes = {'devis_lignes', 'factures_lignes', 'charges_modele_lines'};

  Future<void> _processItem(SyncQueueData item) async {
    try {
      if (item.operation == 'upload' && item.entityType == 'piece_jointe') {
        await _uploadPieceJointe(item);
      } else if (_lignesTypes.contains(item.entityType)) {
        await _processLignesItem(item);
      } else {
        final table = _tableOverrides[item.entityType] ?? '${item.entityType}s';
        switch (item.operation) {
          case 'create':
            await _supabase.from(table).insert(_parsePayload(item.payload));
          case 'update':
            await _supabase.from(table).update(_parsePayload(item.payload)).eq('id', item.entityId);
          case 'delete':
            await _supabase.from(table).delete().eq('id', item.entityId);
        }
      }
      await _db.syncQueueDao.deleteItem(item.id);
      await _markEntitySynced(item.entityType, item.entityId);
    } catch (e) {
      AppLogger.w('SyncService',
          'Échec sync ${item.entityType}#${item.entityId} (tentative ${item.attempts + 1})',
          error: e);
      await _db.syncQueueDao.incrementAttempts(item.id);
      if (item.attempts + 1 >= AppConstants.maxSyncAttempts) {
        await _markEntityConflict(item.entityType, item.entityId);
      }
    }
  }

  /// Pousse les lignes d'un devis/facture/modèle (payload : `{'lignes': [...]}`).
  /// Si `replace_key`/`replace_value` sont fournis, supprime d'abord les lignes
  /// existantes correspondantes (remplacement complet, ex : modèles de charges).
  Future<void> _processLignesItem(SyncQueueData item) async {
    final payload = _parsePayload(item.payload);
    final lignes = (payload['lignes'] as List? ?? [])
        .map((l) => Map<String, dynamic>.from(l as Map))
        .toList();
    final replaceKey = payload['replace_key'] as String?;
    final replaceValue = payload['replace_value'] as String?;
    if (replaceKey != null && replaceValue != null) {
      await _supabase.from(item.entityType).delete().eq(replaceKey, replaceValue);
    }
    if (lignes.isEmpty) return;
    await _supabase.from(item.entityType).upsert(lignes);
  }

  Future<void> _uploadPieceJointe(SyncQueueData item) async {
    final data = _parsePayload(item.payload);
    final cheminLocal = data['chemin_local'] as String?;
    final dossierId = data['dossier_id'] as String?;
    final nom = data['nom'] as String?;
    if (cheminLocal == null || dossierId == null || nom == null) return;

    final file = File(cheminLocal);
    if (!await file.exists()) return;

    final path = 'dossiers/$dossierId/$nom';
    await _supabase.storage.from('pieces-jointes').upload(path, file);
    final url = _supabase.storage.from('pieces-jointes').getPublicUrl(path);
    await _db.piecesJointesDao.updateUrlStorage(item.entityId, url);
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      return Map<String, dynamic>.from(jsonDecode(payload) as Map<String, dynamic>);
    } catch (_) {
      return {};
    }
  }

  Future<void> _markEntitySynced(String entityType, String entityId) async {
    switch (entityType) {
      case 'dossier': await _db.dossiersDao.markSynced(entityId);
      case 'client': await _db.clientsDao.markSynced(entityId);
      case 'devis': await _db.devisDao.markSynced(entityId);
      case 'facture': await _db.facturesDao.markSynced(entityId);
      case 'charge': await _db.chargesDao.markSynced(entityId);
      case 'charge_modele': await _db.chargesModelesDao.markSynced(entityId);
      case 'personnel': await _db.personnelDao.markSynced(entityId);
      case 'conge': await _db.congesDao.markSynced(entityId);
      case 'salaire': await _db.salairesDao.markSynced(entityId);
      case 'piece_jointe': await _db.piecesJointesDao.markSynced(entityId);
      case 'client_contact': await _db.clientContactsDao.markSynced(entityId);
    }
  }

  Future<void> _markEntityConflict(String entityType, String entityId) async {
    // Pour l'instant : log uniquement — en V2 on exposera un UI de résolution
  }
}
