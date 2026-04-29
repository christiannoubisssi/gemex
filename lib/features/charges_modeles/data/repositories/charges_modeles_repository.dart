import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../database/app_database.dart';

final chargesModelesRepositoryProvider = Provider<ChargesModelesRepository>((ref) {
  return ChargesModelesRepository(db: AppDatabase.instance);
});

class ChargesModelesRepository {
  final AppDatabase _db;

  ChargesModelesRepository({required AppDatabase db}) : _db = db;

  Future<List<ChargesModele>> getAll({String? statut}) =>
      _db.chargesModelesDao.getAll(statut: statut);

  Future<ChargesModele?> getById(String id) =>
      _db.chargesModelesDao.getById(id);

  Future<List<ChargesModeleLine>> getLignes(String modeleId) =>
      _db.chargesModelesDao.getLignes(modeleId);

  Future<String> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    final id = const Uuid().v4();

    await _db.chargesModelesDao.upsert(ChargesModelesCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? '',
      mois: data['mois'] as int,
      annee: data['annee'] as int,
      titre: data['titre'] as String,
      soumisParId: drift.Value(data['soumis_par_id'] as String?),
      soumisParNom: drift.Value(data['soumis_par_nom'] as String?),
    ));

    for (var i = 0; i < lignes.length; i++) {
      final l = lignes[i];
      await _db.chargesModelesDao.upsertLigne(ChargesModeleLinesCompanion.insert(
        id: const Uuid().v4(),
        modeleId: id,
        ordre: drift.Value(i),
        designation: l['designation'] as String,
        montant: drift.Value((l['montant'] as num? ?? 0).toDouble()),
        dateEcheance: drift.Value(l['date_echeance'] as DateTime?),
        priorite: drift.Value(l['priorite'] as String? ?? 'normale'),
        notes: drift.Value(l['notes'] as String?),
      ));
    }

    return id;
  }

  Future<void> updateLignes(String modeleId, List<Map<String, dynamic>> lignes) async {
    await _db.chargesModelesDao.deleteLignes(modeleId);
    for (var i = 0; i < lignes.length; i++) {
      final l = lignes[i];
      await _db.chargesModelesDao.upsertLigne(ChargesModeleLinesCompanion.insert(
        id: l['id'] as String? ?? const Uuid().v4(),
        modeleId: modeleId,
        ordre: drift.Value(i),
        designation: l['designation'] as String,
        montant: drift.Value((l['montant'] as num? ?? 0).toDouble()),
        dateEcheance: drift.Value(l['date_echeance'] as DateTime?),
        priorite: drift.Value(l['priorite'] as String? ?? 'normale'),
        notes: drift.Value(l['notes'] as String?),
      ));
    }
  }

  Future<void> soumettre(String id) async {
    await _db.chargesModelesDao.updateStatut(
      id, 'soumis',
      dateSubmission: DateTime.now(),
    );
  }

  Future<void> valider(String id, String userId, String userNom) async {
    await _db.chargesModelesDao.updateStatut(
      id, 'valide',
      dateValidation: DateTime.now(),
      valideParId: userId,
      valideParNom: userNom,
    );
  }

  Future<void> refuser(String id, String motif, String userId, String userNom) async {
    await _db.chargesModelesDao.updateStatut(
      id, 'refuse',
      motifRefus: motif,
      dateValidation: DateTime.now(),
      valideParId: userId,
      valideParNom: userNom,
    );
  }

  Future<void> reporter(String id) async {
    await _db.chargesModelesDao.updateStatut(id, 'reporte');
  }

  Future<void> updateLigneStatut(String ligneId, String statut, {String? motif}) =>
      _db.chargesModelesDao.updateLigneStatut(ligneId, statut, motifRefus: motif);
}
