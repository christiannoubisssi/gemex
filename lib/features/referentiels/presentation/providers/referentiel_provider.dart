import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/referentiel_repository.dart';

/// Postes actifs (stream réactif)
final postesProvider = StreamProvider.autoDispose<List<Referentiel>>(
  (ref) => ref.read(referentielRepositoryProvider).watchAll(type: 'poste'),
);

/// Départements actifs (stream réactif)
final departementsProvider = StreamProvider.autoDispose<List<Referentiel>>(
  (ref) =>
      ref.read(referentielRepositoryProvider).watchAll(type: 'departement'),
);

class ReferentielNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> add({
    required String type,
    required String nom,
  }) async {
    state = const AsyncLoading();
    try {
      final id = await ref
          .read(referentielRepositoryProvider)
          .add(type: type, nom: nom);
      state = const AsyncData(null);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateNom(String id, String nom) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(referentielRepositoryProvider).updateNom(id, nom),
    );
  }

  Future<void> deleteById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(referentielRepositoryProvider).deleteById(id),
    );
  }
}

final referentielNotifierProvider =
    AsyncNotifierProvider<ReferentielNotifier, void>(
        () => ReferentielNotifier());
