import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../database/app_database.dart';

final taxeRepositoryProvider = Provider<TaxeRepository>((ref) {
  return TaxeRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class TaxeRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  TaxeRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<Taxe>> getAll({bool? actif}) => _db.taxesDao.getAll(actif: actif);

  Future<Taxe?> getById(String id) => _db.taxesDao.getById(id);

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final entrepriseId = data['entreprise_id'] as String? ?? '';

    await _db.taxesDao.upsert(TaxesCompanion.insert(
      id: id,
      entrepriseId: entrepriseId,
      nom: data['nom'] as String,
      taux: drift.Value((data['taux'] as num).toDouble()),
      description: drift.Value(data['description'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    ));

    AppLogger.i('TaxeRepository', 'Taxe créée localement : $id (${data['nom']})');

    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('taxes').insert({...data, 'id': id});
        await _db.taxesDao.upsert(TaxesCompanion(
          id: drift.Value(id),
          syncStatus: const drift.Value(AppConstants.syncSynced),
        ));
        AppLogger.i('TaxeRepository', 'Taxe synchronisée : $id');
      } catch (e) {
        AppLogger.w('TaxeRepository', 'Échec sync taxe $id', error: e);
      }
    }

    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.taxesDao.upsert(TaxesCompanion(
      id: drift.Value(id),
      nom: data.containsKey('nom') ? drift.Value(data['nom'] as String) : const drift.Value.absent(),
      taux: data.containsKey('taux')
          ? drift.Value((data['taux'] as num).toDouble())
          : const drift.Value.absent(),
      description: data.containsKey('description')
          ? drift.Value(data['description'] as String?)
          : const drift.Value.absent(),
      actif: data.containsKey('actif')
          ? drift.Value(data['actif'] as bool)
          : const drift.Value.absent(),
      updatedAt: drift.Value(DateTime.now()),
      syncStatus: const drift.Value(AppConstants.syncPending),
    ));

    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('taxes').update(data).eq('id', id);
        await _db.taxesDao.upsert(TaxesCompanion(
          id: drift.Value(id),
          syncStatus: const drift.Value(AppConstants.syncSynced),
        ));
        AppLogger.i('TaxeRepository', 'Taxe mise à jour et synchronisée : $id');
      } catch (e) {
        AppLogger.w('TaxeRepository', 'Échec sync update taxe $id', error: e);
      }
    }
  }

  Future<void> toggleActif(String id, bool actif) =>
      _db.taxesDao.toggleActif(id, actif);

  Future<void> deleteById(String id) => _db.taxesDao.deleteById(id);
}
