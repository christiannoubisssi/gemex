import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/dossier_repository.dart';

final dossiersProvider = FutureProvider.autoDispose.family<List<Dossier>, String?>(
  (ref, statut) async {
    return ref.read(dossierRepositoryProvider).getAll(statut: statut);
  },
);

final dossierSearchProvider = FutureProvider.autoDispose.family<List<Dossier>, String>(
  (ref, search) async {
    return ref.read(dossierRepositoryProvider).getAll(search: search);
  },
);

final dossierDetailProvider = FutureProvider.autoDispose.family<Dossier?, String>(
  (ref, id) async {
    return ref.read(dossierRepositoryProvider).getById(id);
  },
);

final dossiersUrgentsProvider = FutureProvider.autoDispose<List<Dossier>>(
  (ref) async {
    return ref.read(dossierRepositoryProvider).getUrgents();
  },
);

final dossiersByClientProvider = FutureProvider.autoDispose.family<List<Dossier>, String>(
  (ref, clientId) async =>
      ref.read(dossierRepositoryProvider).getAll(clientId: clientId),
);

final dossierStatsProvider = FutureProvider.autoDispose<Map<String, int>>(
  (ref) async {
    return ref.read(dossierRepositoryProvider).getStatsCounts();
  },
);

class DossierNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      // Sanitiser dès le notifier : convertit DateTime → ISO string
      final safeData = toJsonSafe(data);
      AppLogger.i('DossierNotifier', 'Création dossier…');
      final id = await ref.read(dossierRepositoryProvider).create(safeData);
      state = const AsyncData(null);
      ref.invalidate(dossiersProvider);
      ref.invalidate(dossierStatsProvider);
      AppLogger.i('DossierNotifier', 'Dossier créé : $id');
      return id;
    } catch (e, s) {
      AppLogger.e('DossierNotifier', 'Erreur création dossier', error: e, stack: s);
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateDossier(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(dossierRepositoryProvider).update(id, toJsonSafe(data));
      ref.invalidate(dossierDetailProvider(id));
      ref.invalidate(dossiersProvider);
    });
  }

  Future<void> changerStatut(String id, String statut, {String? motif}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(dossierRepositoryProvider).changerStatut(id, statut, motif: motif);
      ref.invalidate(dossierDetailProvider(id));
      ref.invalidate(dossiersProvider);
      ref.invalidate(dossierStatsProvider);
    });
  }
}

final dossierNotifierProvider = AsyncNotifierProvider<DossierNotifier, void>(() {
  return DossierNotifier();
});
