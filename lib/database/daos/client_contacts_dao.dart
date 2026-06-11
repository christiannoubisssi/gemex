import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/client_contacts_table.dart';

part 'client_contacts_dao.g.dart';

@DriftAccessor(tables: [ClientContacts])
class ClientContactsDao extends DatabaseAccessor<AppDatabase>
    with _$ClientContactsDaoMixin {
  ClientContactsDao(super.db);

  Future<List<ClientContact>> getByClient(String clientId) {
    return (select(clientContacts)
          ..where((t) => t.clientId.equals(clientId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> upsert(ClientContactsCompanion companion) =>
      into(clientContacts).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(clientContacts)..where((t) => t.id.equals(id))).go();

  Future<void> markSynced(String id) async {
    await (update(clientContacts)..where((t) => t.id.equals(id))).write(
      const ClientContactsCompanion(syncStatus: Value('synced')),
    );
  }

  Future<List<ClientContact>> getPending() {
    return (select(clientContacts)..where((t) => t.syncStatus.equals('pending'))).get();
  }
}
