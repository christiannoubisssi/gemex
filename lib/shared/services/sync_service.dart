import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/connectivity_service.dart';
import '../../database/app_database.dart';

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
      final pending = await _db.syncQueueDao.getPending(maxAttempts: AppConstants.maxSyncAttempts);
      for (final item in pending) {
        await _processItem(item);
      }
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.idle;
    } catch (e) {
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.error;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    try {
      switch (item.operation) {
        case 'create':
          await _supabase.from('${item.entityType}s').insert(_parsePayload(item.payload));
        case 'update':
          await _supabase.from('${item.entityType}s').update(_parsePayload(item.payload)).eq('id', item.entityId);
        case 'delete':
          await _supabase.from('${item.entityType}s').update({'deleted_at': DateTime.now().toIso8601String()}).eq('id', item.entityId);
      }
      await _db.syncQueueDao.deleteItem(item.id);
      await _markEntitySynced(item.entityType, item.entityId);
    } catch (_) {
      await _db.syncQueueDao.incrementAttempts(item.id);
      if (item.attempts + 1 >= AppConstants.maxSyncAttempts) {
        await _markEntityConflict(item.entityType, item.entityId);
      }
    }
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
    }
  }

  Future<void> _markEntityConflict(String entityType, String entityId) async {
    // Pour l'instant : log uniquement — en V2 on exposera un UI de résolution
  }
}
