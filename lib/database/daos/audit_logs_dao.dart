import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/audit_logs_table.dart';

part 'audit_logs_dao.g.dart';

@DriftAccessor(tables: [AuditLogs])
class AuditLogsDao extends DatabaseAccessor<AppDatabase>
    with _$AuditLogsDaoMixin {
  AuditLogsDao(super.db);

  Future<void> insert(AuditLogsCompanion companion) =>
      into(auditLogs).insert(companion);

  Future<void> upsert(AuditLogsCompanion companion) =>
      into(auditLogs).insertOnConflictUpdate(companion);

  Future<AuditLog?> getById(String id) =>
      (select(auditLogs)..where((l) => l.id.equals(id))).getSingleOrNull();

  /// Tous les logs, du plus récent au plus ancien (limité à [limit] entrées).
  Stream<List<AuditLog>> watchAll({int limit = 500}) {
    return (select(auditLogs)
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)])
          ..limit(limit))
        .watch();
  }

  /// Version Future (pour les calculs ponctuels, ex : stats agents).
  Future<List<AuditLog>> getAll({int limit = 2000}) {
    return (select(auditLogs)
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Logs pour une entité précise (ex : un dossier).
  Stream<List<AuditLog>> watchByEntityId(String entityId) {
    return (select(auditLogs)
          ..where((l) => l.entityId.equals(entityId))
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)]))
        .watch();
  }

  /// Logs d'un utilisateur spécifique.
  Future<List<AuditLog>> getByUser(String userId) {
    return (select(auditLogs)
          ..where((l) => l.userId.equals(userId))
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)]))
        .get();
  }

  /// Logs non encore envoyés à Supabase.
  Future<List<AuditLog>> getPending() {
    return (select(auditLogs)..where((l) => l.syncStatus.equals('pending')))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(auditLogs)..where((l) => l.id.equals(id))).write(
      const AuditLogsCompanion(syncStatus: Value('synced')),
    );
  }

  Future<int> getTotalCount() async {
    final count = countAll();
    final query = selectOnly(auditLogs)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
