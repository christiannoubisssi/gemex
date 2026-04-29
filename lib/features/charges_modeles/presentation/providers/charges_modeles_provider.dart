import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/charges_modeles_repository.dart';

final chargesModelesProvider = FutureProvider.autoDispose.family<List<ChargesModele>, String?>(
  (ref, statut) async => ref.read(chargesModelesRepositoryProvider).getAll(statut: statut),
);

final chargesModeleDetailProvider = FutureProvider.autoDispose.family<ChargesModele?, String>(
  (ref, id) async => ref.read(chargesModelesRepositoryProvider).getById(id),
);

final chargesModeleLignesProvider = FutureProvider.autoDispose.family<List<ChargesModeleLine>, String>(
  (ref, modeleId) async => ref.read(chargesModelesRepositoryProvider).getLignes(modeleId),
);

class ChargesModeleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(chargesModelesRepositoryProvider).create(data, lignes);
      state = const AsyncData(null);
      ref.invalidate(chargesModelesProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateLignes(String modeleId, List<Map<String, dynamic>> lignes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chargesModelesRepositoryProvider).updateLignes(modeleId, lignes);
      ref.invalidate(chargesModeleLignesProvider(modeleId));
    });
  }

  Future<void> soumettre(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chargesModelesRepositoryProvider).soumettre(id);
      ref.invalidate(chargesModeleDetailProvider(id));
      ref.invalidate(chargesModelesProvider);
    });
  }

  Future<void> valider(String id, String userId, String userNom) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chargesModelesRepositoryProvider).valider(id, userId, userNom);
      ref.invalidate(chargesModeleDetailProvider(id));
      ref.invalidate(chargesModelesProvider);
    });
  }

  Future<void> refuser(String id, String motif, String userId, String userNom) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chargesModelesRepositoryProvider).refuser(id, motif, userId, userNom);
      ref.invalidate(chargesModeleDetailProvider(id));
      ref.invalidate(chargesModelesProvider);
    });
  }

  Future<void> reporter(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(chargesModelesRepositoryProvider).reporter(id);
      ref.invalidate(chargesModeleDetailProvider(id));
      ref.invalidate(chargesModelesProvider);
    });
  }

  Future<void> updateLigneStatut(String ligneId, String statut, {String? motif, String? modeleId}) async {
    await ref.read(chargesModelesRepositoryProvider).updateLigneStatut(ligneId, statut, motif: motif);
    if (modeleId != null) ref.invalidate(chargesModeleLignesProvider(modeleId));
  }
}

final chargesModeleNotifierProvider =
    AsyncNotifierProvider<ChargesModeleNotifier, void>(() => ChargesModeleNotifier());
