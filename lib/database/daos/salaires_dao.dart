import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/personnel_table.dart';

part 'salaires_dao.g.dart';

@DriftAccessor(tables: [Salaires])
class SalairesDao extends DatabaseAccessor<AppDatabase> with _$SalairesDaoMixin {
  SalairesDao(super.db);

  Future<Salaire?> getById(String id) {
    return (select(salaires)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  Future<List<Salaire>> getByMoisAnnee(int mois, int annee) {
    return (select(salaires)
          ..where((s) => s.mois.equals(mois) & s.annee.equals(annee))
          ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
        .get();
  }

  Future<List<Salaire>> getByPersonnel(String personnelId) {
    return (select(salaires)
          ..where((s) => s.personnelId.equals(personnelId))
          ..orderBy([
            (s) => OrderingTerm.desc(s.annee),
            (s) => OrderingTerm.desc(s.mois),
          ]))
        .get();
  }

  Future<Salaire?> getByPersonnelMois(String personnelId, int mois, int annee) {
    return (select(salaires)
          ..where((s) =>
              s.personnelId.equals(personnelId) &
              s.mois.equals(mois) &
              s.annee.equals(annee)))
        .getSingleOrNull();
  }

  Future<void> upsert(SalairesCompanion companion) {
    return into(salaires).insertOnConflictUpdate(companion);
  }

  Future<void> updateStatut(String id, String statut, {DateTime? date}) {
    return (update(salaires)..where((s) => s.id.equals(id))).write(
      SalairesCompanion(
        statut: Value(statut),
        dateValidation: statut == 'valide' ? Value(date ?? DateTime.now()) : const Value.absent(),
        datePaiement: statut == 'paye' ? Value(date ?? DateTime.now()) : const Value.absent(),
      ),
    );
  }

  Future<void> marquerComptabilise(String id, String chargeId) {
    return (update(salaires)..where((s) => s.id.equals(id))).write(
      SalairesCompanion(
        comptabilise: const Value(true),
        chargeId: Value(chargeId),
      ),
    );
  }

  Future<void> markSynced(String id) {
    return (update(salaires)..where((s) => s.id.equals(id)))
        .write(const SalairesCompanion(syncStatus: Value('synced')));
  }

  Future<List<Salaire>> getPending() {
    return (select(salaires)..where((s) => s.syncStatus.equals('pending'))).get();
  }

  Future<double> getMasseSalariale(int mois, int annee) async {
    final all = await getByMoisAnnee(mois, annee);
    return all.fold<double>(0.0, (sum, s) => sum + s.salaireNet);
  }
}
