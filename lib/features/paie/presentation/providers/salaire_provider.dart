import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../database/app_database.dart';
import '../../data/repositories/salaire_repository.dart';

typedef MoisAnnee = ({int mois, int annee});

final salairesProvider =
    FutureProvider.autoDispose.family<List<Salaire>, MoisAnnee>((ref, period) {
  return ref.read(salaireRepositoryProvider).getByMoisAnnee(period.mois, period.annee);
});

final masseSalarialeProvider =
    FutureProvider.autoDispose.family<double, MoisAnnee>((ref, period) {
  return ref.read(salaireRepositoryProvider).getMasseSalariale(period.mois, period.annee);
});

class PaieNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> initierMois(int mois, int annee) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(salaireRepositoryProvider).initierMois(mois, annee));
  }

  Future<void> updateSalaire({
    required String id,
    required double salaireBrut,
    required double cnps,
    required double irpp,
    required double autresRetenues,
  }) async {
    final net = salaireBrut - cnps - irpp - autresRetenues;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(salaireRepositoryProvider).updateSalaire(SalairesCompanion(
              id: Value(id),
              salaireBrut: Value(salaireBrut),
              cnps: Value(cnps),
              irpp: Value(irpp),
              autresRetenues: Value(autresRetenues),
              salaireNet: Value(net < 0 ? 0 : net),
              syncStatus: const Value('pending'),
              updatedAt: Value(DateTime.now()),
            )));
  }

  Future<void> valider(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(salaireRepositoryProvider).valider(id));
  }

  Future<void> marquerPaye(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(salaireRepositoryProvider).marquerPaye(id));
  }
}

final paieNotifierProvider =
    AsyncNotifierProvider<PaieNotifier, void>(PaieNotifier.new);
