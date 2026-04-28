import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../database/app_database.dart';

final salaireRepositoryProvider = Provider<SalaireRepository>((ref) {
  return SalaireRepository(AppDatabase.instance);
});

class SalaireRepository {
  final AppDatabase _db;
  const SalaireRepository(this._db);

  Future<List<Salaire>> getByMoisAnnee(int mois, int annee) =>
      _db.salairesDao.getByMoisAnnee(mois, annee);

  Future<List<Salaire>> getByPersonnel(String personnelId) =>
      _db.salairesDao.getByPersonnel(personnelId);

  /// Crée une fiche de paie vierge pour chaque actif qui n'en a pas encore ce mois.
  Future<void> initierMois(int mois, int annee) async {
    final actifs = await _db.personnelDao.getAll(actif: true);
    for (final p in actifs) {
      final existing = await _db.salairesDao.getByPersonnelMois(p.id, mois, annee);
      if (existing != null) continue;
      final base = p.salaireBase ?? 0.0;
      final now = DateTime.now();
      await _db.salairesDao.upsert(SalairesCompanion.insert(
        id: const Uuid().v4(),
        entrepriseId: p.entrepriseId,
        personnelId: p.id,
        mois: mois,
        annee: annee,
        salaireBrut: Value(base),
        salaireNet: base,
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    }
  }

  Future<void> updateSalaire(SalairesCompanion companion) =>
      _db.salairesDao.upsert(companion);

  Future<void> valider(String id) =>
      _db.salairesDao.updateStatut(id, 'valide');

  /// Marque payé et crée une charge "Salaires" correspondante.
  Future<void> marquerPaye(String id) async {
    final salaire = await _db.salairesDao.getById(id);
    await _db.salairesDao.updateStatut(id, 'paye');

    if (salaire != null && !salaire.comptabilise) {
      final chargeId = const Uuid().v4();
      final now = DateTime.now();
      await _db.chargesDao.upsert(ChargesCompanion.insert(
        id: chargeId,
        entrepriseId: salaire.entrepriseId,
        categorie: 'Salaires',
        libelle: 'Salaire ${salaire.mois}/${salaire.annee}',
        montant: salaire.salaireNet,
        dateCharge: now,
        mois: salaire.mois,
        annee: salaire.annee,
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
      await _db.salairesDao.marquerComptabilise(id, chargeId);
    }
  }

  Future<double> getMasseSalariale(int mois, int annee) =>
      _db.salairesDao.getMasseSalariale(mois, annee);
}
