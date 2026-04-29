import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/charges_modeles_table.dart';

part 'charges_modeles_dao.g.dart';

@DriftAccessor(tables: [ChargesModeles, ChargesModeleLines])
class ChargesModelesDao extends DatabaseAccessor<AppDatabase>
    with _$ChargesModelesDaoMixin {
  ChargesModelesDao(super.db);

  Future<List<ChargesModele>> getAll({String? statut}) {
    final q = select(chargesModeles)
      ..orderBy([(t) => OrderingTerm.desc(t.annee), (t) => OrderingTerm.desc(t.mois)]);
    if (statut != null) {
      q.where((t) => t.statut.equals(statut));
    }
    return q.get();
  }

  Future<ChargesModele?> getById(String id) =>
      (select(chargesModeles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ChargesModeleLine>> getLignes(String modeleId) =>
      (select(chargesModeleLines)
            ..where((t) => t.modeleId.equals(modeleId))
            ..orderBy([(t) => OrderingTerm.asc(t.ordre)]))
          .get();

  Future<void> upsert(ChargesModelesCompanion companion) =>
      into(chargesModeles).insertOnConflictUpdate(companion);

  Future<void> upsertLigne(ChargesModeleLinesCompanion companion) =>
      into(chargesModeleLines).insertOnConflictUpdate(companion);

  Future<void> deleteLigne(String id) =>
      (delete(chargesModeleLines)..where((t) => t.id.equals(id))).go();

  Future<void> deleteLignes(String modeleId) =>
      (delete(chargesModeleLines)..where((t) => t.modeleId.equals(modeleId))).go();

  Future<void> updateStatut(
    String id,
    String statut, {
    String? motifRefus,
    DateTime? dateValidation,
    String? valideParId,
    String? valideParNom,
    DateTime? dateSubmission,
  }) async {
    await (update(chargesModeles)..where((t) => t.id.equals(id))).write(
      ChargesModelesCompanion(
        statut: Value(statut),
        motifRefus: motifRefus != null ? Value(motifRefus) : const Value.absent(),
        dateValidation: dateValidation != null ? Value(dateValidation) : const Value.absent(),
        valideParId: valideParId != null ? Value(valideParId) : const Value.absent(),
        valideParNom: valideParNom != null ? Value(valideParNom) : const Value.absent(),
        dateSubmission: dateSubmission != null ? Value(dateSubmission) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateLigneStatut(String id, String statut, {String? motifRefus}) async {
    await (update(chargesModeleLines)..where((t) => t.id.equals(id))).write(
      ChargesModeleLinesCompanion(
        statut: Value(statut),
        motifRefus: motifRefus != null ? Value(motifRefus) : const Value.absent(),
      ),
    );
  }

  Future<void> markSynced(String id) async {
    await (update(chargesModeles)..where((t) => t.id.equals(id))).write(
      const ChargesModelesCompanion(statut: Value.absent()),
    );
  }
}
