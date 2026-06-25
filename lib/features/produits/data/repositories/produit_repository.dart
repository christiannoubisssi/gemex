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

final produitRepositoryProvider = Provider<ProduitRepository>((ref) {
  return ProduitRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class ProduitRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  ProduitRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<Produit>> getAll({bool? actif, bool? estVente, bool? estAchat}) =>
      _db.produitsDao.getAll(actif: actif, estVente: estVente, estAchat: estAchat);

  Stream<List<Produit>> watchAll({bool? actif, bool? estVente, bool? estAchat}) =>
      _db.produitsDao.watchAll(actif: actif, estVente: estVente, estAchat: estAchat);

  Future<Produit?> getById(String id) => _db.produitsDao.getById(id);

  Future<String> nextCode() => _db.produitsDao.nextCode();

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final code = data['code'] as String? ?? await nextCode();

    await _db.produitsDao.upsert(ProduitsCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? 'default',
      code: code,
      nom: data['nom'] as String,
      description: drift.Value(data['description'] as String?),
      unite: drift.Value(data['unite'] as String? ?? 'unité'),
      prixVente: drift.Value((data['prix_vente'] as num?)?.toDouble() ?? 0),
      prixAchat: drift.Value((data['prix_achat'] as num?)?.toDouble() ?? 0),
      estVente: drift.Value(data['est_vente'] as bool? ?? true),
      estAchat: drift.Value(data['est_achat'] as bool? ?? false),
      categorie: drift.Value(data['categorie'] as String?),
      stockMin: drift.Value((data['stock_min'] as num?)?.toDouble() ?? 0),
      syncStatus: const drift.Value(AppConstants.syncPending),
    ));

    final syncData = {...data, 'id': id, 'code': code};
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('produits').insert(toJsonSafe(syncData));
        await _db.produitsDao.markSynced(id);
        AppLogger.i('ProduitRepository', 'Produit $id synchronisé');
      } catch (e) {
        AppLogger.w('ProduitRepository', 'Échec sync produit $id', error: e);
        await _db.syncQueueDao.enqueue(
          entityType: 'produit',
          entityId: id,
          operation: 'create',
          payload: jsonEncode(toJsonSafe(syncData)),
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'produit',
        entityId: id,
        operation: 'create',
        payload: jsonEncode(toJsonSafe(syncData)),
      );
    }
    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.produitsDao.upsert(ProduitsCompanion(
      id: drift.Value(id),
      code: data.containsKey('code')
          ? drift.Value(data['code'] as String)
          : const drift.Value.absent(),
      nom: data.containsKey('nom')
          ? drift.Value(data['nom'] as String)
          : const drift.Value.absent(),
      description: data.containsKey('description')
          ? drift.Value(data['description'] as String?)
          : const drift.Value.absent(),
      unite: data.containsKey('unite')
          ? drift.Value(data['unite'] as String)
          : const drift.Value.absent(),
      prixVente: data.containsKey('prix_vente')
          ? drift.Value((data['prix_vente'] as num).toDouble())
          : const drift.Value.absent(),
      prixAchat: data.containsKey('prix_achat')
          ? drift.Value((data['prix_achat'] as num).toDouble())
          : const drift.Value.absent(),
      estVente: data.containsKey('est_vente')
          ? drift.Value(data['est_vente'] as bool)
          : const drift.Value.absent(),
      estAchat: data.containsKey('est_achat')
          ? drift.Value(data['est_achat'] as bool)
          : const drift.Value.absent(),
      categorie: data.containsKey('categorie')
          ? drift.Value(data['categorie'] as String?)
          : const drift.Value.absent(),
      stockMin: data.containsKey('stock_min')
          ? drift.Value((data['stock_min'] as num).toDouble())
          : const drift.Value.absent(),
      updatedAt: drift.Value(DateTime.now()),
      syncStatus: const drift.Value(AppConstants.syncPending),
    ));

    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('produits').update(toJsonSafe(data)).eq('id', id);
        await _db.produitsDao.markSynced(id);
      } catch (e) {
        AppLogger.w('ProduitRepository', 'Échec sync update produit $id', error: e);
      }
    }
  }

  Future<void> toggleActif(String id, bool actif) async {
    await _db.produitsDao.toggleActif(id, actif);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('produits').update({'actif': actif}).eq('id', id);
        await _db.produitsDao.markSynced(id);
      } catch (_) {}
    }
  }

  Future<void> deleteById(String id) async {
    await _db.produitsDao.deleteById(id);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('produits').delete().eq('id', id);
      } catch (_) {}
    }
  }
}
