import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/client_repository.dart';

final clientsProvider = FutureProvider.autoDispose.family<List<Client>, String?>(
  (ref, typeClient) async => ref.read(clientRepositoryProvider).getAll(typeClient: typeClient),
);

final clientSearchProvider = FutureProvider.autoDispose.family<List<Client>, String>(
  (ref, search) async => ref.read(clientRepositoryProvider).getAll(search: search),
);

final clientDetailProvider = FutureProvider.autoDispose.family<Client?, String>(
  (ref, id) async => ref.read(clientRepositoryProvider).getById(id),
);

class ClientNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(clientRepositoryProvider).create(data);
      state = const AsyncData(null);
      ref.invalidate(clientsProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateClient(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).update(id, data);
      ref.invalidate(clientDetailProvider(id));
      ref.invalidate(clientsProvider);
    });
  }
}

final clientNotifierProvider = AsyncNotifierProvider<ClientNotifier, void>(() => ClientNotifier());

// Map clientId → nom pour affichage dans les listes (devis, factures, dossiers)
final clientsMapProvider = FutureProvider.autoDispose<Map<String, String>>((ref) async {
  final clients = await ref.read(clientRepositoryProvider).getAll();
  return {for (final c in clients) c.id: c.nom};
});
