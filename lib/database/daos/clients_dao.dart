import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/clients_table.dart';

part 'clients_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  Future<List<Client>> getAll({String? search, String? typeClient}) {
    final query = select(clients)
      ..orderBy([(c) => OrderingTerm.asc(c.nom)]);

    if (search != null && search.isNotEmpty) {
      query.where((c) =>
          c.nom.like('%$search%') |
          c.email.like('%$search%') |
          c.telephone.like('%$search%'));
    }
    if (typeClient != null) {
      query.where((c) => c.typeClient.equals(typeClient));
    }
    return query.get();
  }

  Stream<List<Client>> watchAll() {
    return (select(clients)..orderBy([(c) => OrderingTerm.asc(c.nom)])).watch();
  }

  Future<Client?> getById(String id) {
    return (select(clients)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(ClientsCompanion companion) {
    return into(clients).insertOnConflictUpdate(companion);
  }

  Future<void> markSynced(String id) {
    return (update(clients)..where((c) => c.id.equals(id)))
        .write(const ClientsCompanion(syncStatus: Value('synced')));
  }

  Future<List<Client>> getPending() {
    return (select(clients)..where((c) => c.syncStatus.equals('pending'))).get();
  }

  Future<void> updateSolde(String id, double totalFacture, double totalPaye) {
    return (update(clients)..where((c) => c.id.equals(id))).write(ClientsCompanion(
      totalFacture: Value(totalFacture),
      totalPaye: Value(totalPaye),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
