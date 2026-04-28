import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../data/repositories/personnel_repository.dart';

final personnelListProvider =
    StreamProvider.autoDispose<List<PersonnelData>>((ref) {
  return ref.read(personnelRepositoryProvider).watchAll(actif: true);
});

final allPersonnelProvider =
    StreamProvider.autoDispose<List<PersonnelData>>((ref) {
  return ref.read(personnelRepositoryProvider).watchAll();
});

final personnelDetailProvider =
    FutureProvider.autoDispose.family<PersonnelData?, String>((ref, id) {
  return ref.read(personnelRepositoryProvider).getById(id);
});

final congesPersonnelProvider =
    FutureProvider.autoDispose.family<List<Conge>, String>((ref, personnelId) {
  return ref.read(personnelRepositoryProvider).getCongesByPersonnel(personnelId);
});

class PersonnelNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addPersonnel({
    required String nom,
    String? prenom,
    String? poste,
    String? departement,
    String typeContrat = 'CDI',
    DateTime? dateEmbauche,
    DateTime? dateFinContrat,
    double? salaireBase,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(personnelRepositoryProvider).add(
              nom: nom,
              prenom: prenom,
              poste: poste,
              departement: departement,
              typeContrat: typeContrat,
              dateEmbauche: dateEmbauche,
              dateFinContrat: dateFinContrat,
              salaireBase: salaireBase,
            ));
  }

  Future<void> updatePersonnel(PersonnelCompanion companion) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(personnelRepositoryProvider).update(companion));
  }

  Future<void> toggleActif(String id, bool actif) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(personnelRepositoryProvider).toggleActif(id, actif));
  }

  Future<void> addConge({
    required String personnelId,
    required DateTime dateDebut,
    required DateTime dateFin,
    String type = 'conge_annuel',
    String? motif,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(personnelRepositoryProvider).addConge(
              personnelId: personnelId,
              dateDebut: dateDebut,
              dateFin: dateFin,
              type: type,
              motif: motif,
            ));
  }

  Future<void> approuverConge(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(personnelRepositoryProvider).updateStatutConge(id, 'approuve'));
  }

  Future<void> refuserConge(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(personnelRepositoryProvider).updateStatutConge(id, 'refuse'));
  }

  Future<void> deleteConge(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(personnelRepositoryProvider).deleteConge(id));
  }
}

final personnelNotifierProvider =
    AsyncNotifierProvider<PersonnelNotifier, void>(PersonnelNotifier.new);
