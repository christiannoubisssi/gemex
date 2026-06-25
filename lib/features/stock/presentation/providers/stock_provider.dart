import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/stock_repository.dart';

/// Stream réactif : tous les mouvements
final stockMouvementsProvider = StreamProvider.autoDispose<List<StockMouvement>>(
  (ref) => ref.read(stockRepositoryProvider).watchAll(),
);

/// Mouvements filtrés par produit
final stockMouvementsProduitProvider =
    StreamProvider.autoDispose.family<List<StockMouvement>, String>(
  (ref, produitId) => ref.read(stockRepositoryProvider).watchAll(produitId: produitId),
);

/// Quantités en stock pour tous les produits
final stockQuantitesProvider = FutureProvider.autoDispose<Map<String, double>>(
  (ref) => ref.read(stockRepositoryProvider).getStockAll(),
);

class StockNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(stockRepositoryProvider).create(data);
      state = const AsyncData(null);
      ref.invalidate(stockQuantitesProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> deleteById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(stockRepositoryProvider).deleteById(id);
      ref.invalidate(stockQuantitesProvider);
    });
  }
}

final stockNotifierProvider =
    AsyncNotifierProvider<StockNotifier, void>(() => StockNotifier());
