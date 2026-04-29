import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/taxe_repository.dart';

final taxesProvider = FutureProvider.autoDispose<List<Taxe>>(
  (ref) async => ref.read(taxeRepositoryProvider).getAll(),
);

final taxesActivesProvider = FutureProvider.autoDispose<List<Taxe>>(
  (ref) async => ref.read(taxeRepositoryProvider).getAll(actif: true),
);

class TaxeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(taxeRepositoryProvider).create(data);
      state = const AsyncData(null);
      ref.invalidate(taxesProvider);
      ref.invalidate(taxesActivesProvider);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateTaxe(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taxeRepositoryProvider).update(id, data);
      ref.invalidate(taxesProvider);
      ref.invalidate(taxesActivesProvider);
    });
  }

  Future<void> toggleActif(String id, bool actif) async {
    await ref.read(taxeRepositoryProvider).toggleActif(id, actif);
    ref.invalidate(taxesProvider);
    ref.invalidate(taxesActivesProvider);
  }

  Future<void> deleteById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taxeRepositoryProvider).deleteById(id);
      ref.invalidate(taxesProvider);
      ref.invalidate(taxesActivesProvider);
    });
  }
}

final taxeNotifierProvider =
    AsyncNotifierProvider<TaxeNotifier, void>(() => TaxeNotifier());
