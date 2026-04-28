import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
  }) {
    // Remplacer l'ancienne opération pour la même entité si elle existe
    return transaction(() async {
      await (delete(syncQueue)
            ..where((q) =>
                q.entityId.equals(entityId) & q.entityType.equals(entityType)))
          .go();
      await into(syncQueue).insert(SyncQueueCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payload: payload,
      ));
    });
  }

  Future<List<SyncQueueData>> getPending({int maxAttempts = 5}) {
    return (select(syncQueue)
          ..where((q) => q.attempts.isSmallerThanValue(maxAttempts))
          ..orderBy([(q) => OrderingTerm.asc(q.createdAt)]))
        .get();
  }

  Future<void> incrementAttempts(int id) async {
    final item = await (select(syncQueue)..where((q) => q.id.equals(id)))
        .getSingleOrNull();
    if (item == null) return;
    await (update(syncQueue)..where((q) => q.id.equals(id)))
        .write(SyncQueueCompanion(
      attempts: Value(item.attempts + 1),
      lastAttempt: Value(DateTime.now()),
    ));
  }

  Future<void> deleteItem(int id) {
    return (delete(syncQueue)..where((q) => q.id.equals(id))).go();
  }

  Future<int> getPendingCount() async {
    final items = await getPending();
    return items.length;
  }
}
