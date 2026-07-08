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

/// Liste des clients qui ont une référence définie.
/// Utilisée dans les dropdowns de référence sur les dossiers.
/// Format : ({clientId, nom, reference})
final clientsAvecReferenceProvider = FutureProvider.autoDispose<
    List<({String clientId, String nom, String reference})>>(
  (ref) async {
    final clients = await ref.read(clientRepositoryProvider).getAll();
    return clients
        .where((c) => c.reference != null && c.reference!.isNotEmpty)
        .map((c) => (
              clientId: c.id,
              nom: c.nom,
              reference: c.reference!,
            ))
        .toList();
  },
);

// ── Contacts client ──────────────────────────────────────────────────────────

final clientContactsProvider = FutureProvider.autoDispose.family<List<ClientContact>, String>(
  (ref, clientId) async => ref.read(clientRepositoryProvider).getContacts(clientId),
);

class ClientContactNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(String clientId, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).addContact(
            clientId: clientId,
            nom: data['nom'] as String,
            fonction: data['fonction'] as String?,
            telephone: data['telephone'] as String?,
            email: data['email'] as String?,
          );
      ref.invalidate(clientContactsProvider(clientId));
    });
  }

  Future<void> updateContact(String clientId, String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).updateContact(id, data);
      ref.invalidate(clientContactsProvider(clientId));
    });
  }

  Future<void> delete(String clientId, String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).deleteContact(id);
      ref.invalidate(clientContactsProvider(clientId));
    });
  }
}

final clientContactNotifierProvider =
    AsyncNotifierProvider<ClientContactNotifier, void>(() => ClientContactNotifier());
