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

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class StockRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  StockRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<StockMouvement>> getAll({String? produitId, String? type}) =>
      _db.stockMouvementsDao.getAll(produitId: produitId, type: type);

  Stream<List<StockMouvement>> watchAll({String? produitId}) =>
      _db.stockMouvementsDao.watchAll(produitId: produitId);

  Future<double> getStockProduit(String produitId) =>
      _db.stockMouvementsDao.getStockProduit(produitId);

  Future<Map<String, double>> getStockAll() =>
      _db.stockMouvementsDao.getStockAll();

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    await _db.stockMouvementsDao.upsert(StockMouvementsCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? 'default',
      produitId: data['produit_id'] as String,
      type: data['type'] as String, // 'entree' | 'sortie'
      quantite: (data['quantite'] as num).toDouble(),
      dateMouvement: data['date_mouvement'] as DateTime? ?? now,
      prixUnitaire: drift.Value((data['prix_unitaire'] as num?)?.toDouble() ?? 0),
      reference: drift.Value(data['reference'] as String?),
      dossierId: drift.Value(data['dossier_id'] as String?),
      effectuePar: drift.Value(data['effectue_par'] as String?),
      notes: drift.Value(data['notes'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    ));

    final syncData = {...data, 'id': id};
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('stock_mouvements').insert(toJsonSafe(syncData));
        await _db.stockMouvementsDao.markSynced(id);
      } catch (e) {
        AppLogger.w('StockRepository', 'Échec sync mouvement $id', error: e);
        await _db.syncQueueDao.enqueue(
          entityType: 'stock_mouvement',
          entityId: id,
          operation: 'create',
          payload: jsonEncode(toJsonSafe(syncData)),
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'stock_mouvement',
        entityId: id,
        operation: 'create',
        payload: jsonEncode(toJsonSafe(syncData)),
      );
    }
    return id;
  }

  Future<void> deleteById(String id) async {
    await _db.stockMouvementsDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('stock_mouvements').delete().eq('id', id);
      } catch (_) {}
    }
  }
}
