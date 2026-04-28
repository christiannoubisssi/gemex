import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../database/app_database.dart';
import 'package:drift/drift.dart' show Value;

final chargeRepositoryProvider = Provider<ChargeRepository>((ref) {
  return ChargeRepository(AppDatabase.instance);
});

class ChargeRepository {
  final AppDatabase _db;
  const ChargeRepository(this._db);

  Future<List<Charge>> getAll({int? mois, int? annee, String? categorie}) {
    return _db.chargesDao.getAll(mois: mois, annee: annee, categorie: categorie);
  }

  Future<List<Charge>> getByDossier(String dossierId) {
    return _db.chargesDao.getByDossier(dossierId);
  }

  Future<void> add({
    required String entrepriseId,
    required String categorie,
    required String libelle,
    required double montant,
    required DateTime dateCharge,
    String? dossierId,
    String? saisiPar,
    String? notes,
  }) async {
    final now = DateTime.now();
    await _db.chargesDao.upsert(ChargesCompanion.insert(
      id: const Uuid().v4(),
      entrepriseId: entrepriseId,
      categorie: categorie,
      libelle: libelle,
      montant: montant,
      dateCharge: dateCharge,
      mois: dateCharge.month,
      annee: dateCharge.year,
      dossierId: Value(dossierId),
      saisiPar: Value(saisiPar),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<void> update(ChargesCompanion companion) async {
    await _db.chargesDao.upsert(companion);
  }

  Future<void> delete(String id) async {
    await _db.chargesDao.deleteById(id);
  }

  Future<double> getTotalParMois(int mois, int annee) {
    return _db.chargesDao.getTotalParMois(mois, annee);
  }

  Future<Map<String, double>> getTotalParCategorie(int mois, int annee) {
    return _db.chargesDao.getTotalParCategorie(mois, annee);
  }
}
