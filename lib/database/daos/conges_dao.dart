import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/conges_table.dart';

part 'conges_dao.g.dart';

@DriftAccessor(tables: [Conges])
class CongesDao extends DatabaseAccessor<AppDatabase> with _$CongesDaoMixin {
  CongesDao(super.db);

  Future<List<Conge>> getByPersonnel(String personnelId) {
    return (select(conges)
          ..where((c) => c.personnelId.equals(personnelId))
          ..orderBy([(c) => OrderingTerm.desc(c.dateDebut)]))
        .get();
  }

  Future<List<Conge>> getByMois(int mois, int annee) {
    final debut = DateTime(annee, mois);
    final fin = DateTime(annee, mois + 1);
    return (select(conges)
          ..where((c) => c.dateDebut.isBiggerOrEqualValue(debut) & c.dateDebut.isSmallerThanValue(fin)))
        .get();
  }

  Future<void> upsert(CongesCompanion companion) {
    return into(conges).insertOnConflictUpdate(companion);
  }

  Future<void> updateStatut(String id, String statut, {String? validePar}) {
    return (update(conges)..where((c) => c.id.equals(id))).write(
      CongesCompanion(
        statut: Value(statut),
        validePar: validePar != null ? Value(validePar) : const Value.absent(),
      ),
    );
  }

  Future<void> deleteById(String id) {
    return (delete(conges)..where((c) => c.id.equals(id))).go();
  }

  Future<void> markSynced(String id) {
    return (update(conges)..where((c) => c.id.equals(id)))
        .write(const CongesCompanion(syncStatus: Value('synced')));
  }

  Future<List<Conge>> getPending() {
    return (select(conges)..where((c) => c.syncStatus.equals('pending'))).get();
  }
}
