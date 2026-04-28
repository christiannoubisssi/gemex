import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final id = await ref.read(dossierRepositoryProvider).create(data);
      state = const AsyncData(null);
      ref.invalidate(dossiersProvider);
      ref.invalidate(dossierStatsProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateDossier(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(dossierRepositoryProvider).update(id, data);
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
