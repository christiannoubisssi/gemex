import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/personnel_table.dart';

part 'personnel_dao.g.dart';

@DriftAccessor(tables: [Personnel])
class PersonnelDao extends DatabaseAccessor<AppDatabase> with _$PersonnelDaoMixin {
  PersonnelDao(super.db);

  Future<List<PersonnelData>> getAll({bool? actif}) {
    final query = select(personnel)
      ..orderBy([(p) => OrderingTerm.asc(p.nom)]);
    if (actif != null) query.where((p) => p.actif.equals(actif));
    return query.get();
  }

  Future<PersonnelData?> getById(String id) {
    return (select(personnel)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(PersonnelCompanion companion) {
    return into(personnel).insertOnConflictUpdate(companion);
  }

  Future<void> toggleActif(String id, bool value) {
    return (update(personnel)..where((p) => p.id.equals(id)))
        .write(PersonnelCompanion(actif: Value(value)));
  }

  Future<void> markSynced(String id) {
    return (update(personnel)..where((p) => p.id.equals(id)))
        .write(const PersonnelCompanion(syncStatus: Value('synced')));
  }

  Future<List<PersonnelData>> getPending() {
    return (select(personnel)..where((p) => p.syncStatus.equals('pending'))).get();
  }

  Stream<List<PersonnelData>> watchAll({bool? actif}) {
    final query = select(personnel)
      ..orderBy([(p) => OrderingTerm.asc(p.nom)]);
    if (actif != null) query.where((p) => p.actif.equals(actif));
    return query.watch();
  }
}
