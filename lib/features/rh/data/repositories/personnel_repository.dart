import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../database/app_database.dart';

final personnelRepositoryProvider = Provider<PersonnelRepository>((ref) {
  return PersonnelRepository(AppDatabase.instance);
});

class PersonnelRepository {
  final AppDatabase _db;
  const PersonnelRepository(this._db);

  Future<List<PersonnelData>> getAll({bool? actif}) =>
      _db.personnelDao.getAll(actif: actif);

  Stream<List<PersonnelData>> watchAll({bool? actif}) =>
      _db.personnelDao.watchAll(actif: actif);

  Future<PersonnelData?> getById(String id) => _db.personnelDao.getById(id);

  Future<void> add({
    required String nom,
    String? prenom,
    String? poste,
    String? departement,
    String typeContrat = 'CDI',
    DateTime? dateEmbauche,
    DateTime? dateFinContrat,
    double? salaireBase,
  }) async {
    final now = DateTime.now();
    await _db.personnelDao.upsert(PersonnelCompanion.insert(
      id: const Uuid().v4(),
      entrepriseId: 'default',
      nom: nom,
      prenom: Value(prenom),
      poste: Value(poste),
      departement: Value(departement),
      typeContrat: Value(typeContrat),
      dateEmbauche: Value(dateEmbauche),
      dateFinContrat: Value(dateFinContrat),
      salaireBase: Value(salaireBase),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<void> update(PersonnelCompanion companion) =>
      _db.personnelDao.upsert(companion);

  Future<void> toggleActif(String id, bool actif) =>
      _db.personnelDao.toggleActif(id, actif);

  // Congés
  Future<List<Conge>> getCongesByPersonnel(String personnelId) =>
      _db.congesDao.getByPersonnel(personnelId);

  Future<void> addConge({
    required String personnelId,
    required DateTime dateDebut,
    required DateTime dateFin,
    String type = 'conge_annuel',
    String? motif,
  }) async {
    final now = DateTime.now();
    await _db.congesDao.upsert(CongesCompanion.insert(
      id: const Uuid().v4(),
      personnelId: personnelId,
      dateDebut: dateDebut,
      dateFin: dateFin,
      type: Value(type),
      motif: Value(motif),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<void> updateStatutConge(String id, String statut, {String? validePar}) =>
      _db.congesDao.updateStatut(id, statut, validePar: validePar);

  Future<void> deleteConge(String id) => _db.congesDao.deleteById(id);
}
