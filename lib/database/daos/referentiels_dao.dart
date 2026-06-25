import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/referentiels_table.dart';

part 'referentiels_dao.g.dart';

@DriftAccessor(tables: [Referentiels])
class ReferentielsDao extends DatabaseAccessor<AppDatabase>
    with _$ReferentielsDaoMixin {
  ReferentielsDao(super.db);

  Future<List<Referentiel>> getAll({required String type, bool? actif}) {
    final query = select(referentiels)
      ..where((r) => r.type.equals(type))
      ..orderBy([(r) => OrderingTerm.asc(r.nom)]);
    if (actif != null) query.where((r) => r.actif.equals(actif));
    return query.get();
  }

  Stream<List<Referentiel>> watchAll({required String type}) {
    return (select(referentiels)
          ..where((r) => r.type.equals(type) & r.actif.equals(true))
          ..orderBy([(r) => OrderingTerm.asc(r.nom)]))
        .watch();
  }

  Future<void> upsert(ReferentielsCompanion companion) {
    return into(referentiels).insertOnConflictUpdate(companion);
  }

  Future<void> deleteById(String id) {
    return (delete(referentiels)..where((r) => r.id.equals(id))).go();
  }

  Future<void> markSynced(String id) {
    return (update(referentiels)..where((r) => r.id.equals(id)))
        .write(const ReferentielsCompanion(syncStatus: Value('synced')));
  }

  Future<List<Referentiel>> getPending() {
    return (select(referentiels)
          ..where((r) => r.syncStatus.equals('pending')))
        .get();
  }
}
