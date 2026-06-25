import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/produit_repository.dart';

/// Stream réactif — auto-update via Drift
final produitsProvider = StreamProvider.autoDispose<List<Produit>>(
  (ref) => ref.read(produitRepositoryProvider).watchAll(actif: true),
);

/// Produits "Vente" pour les devis/factures
final produitsVenteProvider = StreamProvider.autoDispose<List<Produit>>(
  (ref) => ref.read(produitRepositoryProvider).watchAll(actif: true, estVente: true),
);

/// Produits "Achat" pour les charges
final produitsAchatProvider = StreamProvider.autoDispose<List<Produit>>(
  (ref) => ref.read(produitRepositoryProvider).watchAll(actif: true, estAchat: true),
);

/// Tous les produits (actifs + archivés) pour la gestion
final produitsTousProvider = StreamProvider.autoDispose<List<Produit>>(
  (ref) => ref.read(produitRepositoryProvider).watchAll(),
);

/// Prochain code auto-généré
final produitNextCodeProvider = FutureProvider.autoDispose<String>(
  (ref) => ref.read(produitRepositoryProvider).nextCode(),
);

class ProduitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(produitRepositoryProvider).create(data);
      state = const AsyncData(null);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateProduit(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(produitRepositoryProvider).update(id, data);
    });
  }

  Future<void> toggleActif(String id, bool actif) async {
    await ref.read(produitRepositoryProvider).toggleActif(id, actif);
  }

  Future<void> deleteById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(produitRepositoryProvider).deleteById(id);
    });
  }
}

final produitNotifierProvider =
    AsyncNotifierProvider<ProduitNotifier, void>(() => ProduitNotifier());
