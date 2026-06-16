import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/devis_repository.dart';

// StreamProvider réactif — liste complète sans rechargement à chaque navigation
// Drift émet automatiquement une nouvelle valeur à chaque INSERT/UPDATE/DELETE
final devisAllProvider = StreamProvider.autoDispose<List<Devi>>(
  (ref) => ref.read(devisRepositoryProvider).watchAll(),
);

final devisListProvider = FutureProvider.autoDispose.family<List<Devi>, Map<String, String?>>(
  (ref, filters) async => ref.read(devisRepositoryProvider).getAll(
    statut: filters['statut'],
    clientId: filters['clientId'],
    dossierId: filters['dossierId'],
  ),
);

final devisDetailProvider = FutureProvider.autoDispose.family<Devi?, String>(
  (ref, id) async => ref.read(devisRepositoryProvider).getById(id),
);

final devisLignesProvider = FutureProvider.autoDispose.family<List<DevisLigne>, String>(
  (ref, devisId) async => ref.read(devisRepositoryProvider).getLignes(devisId),
);

class DevisNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(devisRepositoryProvider).create(data, lignes);
      state = const AsyncData(null);
      ref.invalidate(devisAllProvider);
      ref.invalidate(devisListProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateStatut(String id, String statut) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(devisRepositoryProvider).updateStatut(id, statut);
      ref.invalidate(devisDetailProvider(id));
      ref.invalidate(devisAllProvider);
      ref.invalidate(devisListProvider);
    });
  }
}

final devisNotifierProvider = AsyncNotifierProvider<DevisNotifier, void>(() => DevisNotifier());
