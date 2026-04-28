import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pieces_jointes_table.dart';

part 'pieces_jointes_dao.g.dart';

@DriftAccessor(tables: [PiecesJointes])
class PiecesJointesDao extends DatabaseAccessor<AppDatabase>
    with _$PiecesJointesDaoMixin {
  PiecesJointesDao(super.db);

  Future<List<PiecesJointe>> getByDossier(String dossierId) {
    return (select(piecesJointes)
          ..where((p) => p.dossierId.equals(dossierId))
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
        .get();
  }

  Stream<List<PiecesJointe>> watchByDossier(String dossierId) {
    return (select(piecesJointes)
          ..where((p) => p.dossierId.equals(dossierId))
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
        .watch();
  }

  Future<PiecesJointe?> getById(String id) {
    return (select(piecesJointes)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsert(PiecesJointesCompanion companion) {
    return into(piecesJointes).insertOnConflictUpdate(companion);
  }

  Future<void> updateUrlStorage(String id, String url) {
    return (update(piecesJointes)..where((p) => p.id.equals(id))).write(
      PiecesJointesCompanion(
        urlStorage: Value(url),
        syncStatus: const Value('synced'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSynced(String id) {
    return (update(piecesJointes)..where((p) => p.id.equals(id))).write(
      const PiecesJointesCompanion(syncStatus: Value('synced')),
    );
  }

  Future<List<PiecesJointe>> getPending() {
    return (select(piecesJointes)
          ..where((p) => p.syncStatus.equals('pending')))
        .get();
  }

  Future<int> deleteById(String id) {
    return (delete(piecesJointes)..where((p) => p.id.equals(id))).go();
  }

  Future<int> countByDossier(String dossierId) async {
    final count = countAll(filter: piecesJointes.dossierId.equals(dossierId));
    final query = selectOnly(piecesJointes)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
