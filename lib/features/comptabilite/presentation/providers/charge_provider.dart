import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../data/repositories/charge_repository.dart';

// Paramètre pour filtrer par mois/année
typedef MoisAnnee = ({int mois, int annee});

final chargesProvider =
    FutureProvider.autoDispose.family<List<Charge>, MoisAnnee>((ref, period) {
  final repo = ref.read(chargeRepositoryProvider);
  return repo.getAll(mois: period.mois, annee: period.annee);
});

final totalChargesProvider =
    FutureProvider.autoDispose.family<double, MoisAnnee>((ref, period) {
  final repo = ref.read(chargeRepositoryProvider);
  return repo.getTotalParMois(period.mois, period.annee);
});

final chargesParCategorieProvider =
    FutureProvider.autoDispose.family<Map<String, double>, MoisAnnee>((ref, period) {
  final repo = ref.read(chargeRepositoryProvider);
  return repo.getTotalParCategorie(period.mois, period.annee);
});

class ChargeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCharge({
    required String entrepriseId,
    required String categorie,
    required String libelle,
    required double montant,
    required DateTime dateCharge,
    String? dossierId,
    String? saisiPar,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(chargeRepositoryProvider).add(
          entrepriseId: entrepriseId,
          categorie: categorie,
          libelle: libelle,
          montant: montant,
          dateCharge: dateCharge,
          dossierId: dossierId,
          saisiPar: saisiPar,
          notes: notes,
        ));
  }

  Future<void> updateCharge(ChargesCompanion companion) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(chargeRepositoryProvider).update(companion));
  }

  Future<void> deleteCharge(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(chargeRepositoryProvider).delete(id));
  }
}

final chargeNotifierProvider =
    AsyncNotifierProvider<ChargeNotifier, void>(ChargeNotifier.new);
