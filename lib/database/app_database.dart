import 'package:drift/drift.dart';

import 'connection/connection.dart';

import 'tables/clients_table.dart';
import 'tables/dossiers_table.dart';
import 'tables/devis_table.dart';
import 'tables/factures_table.dart';
import 'tables/charges_table.dart';
import 'tables/personnel_table.dart';
import 'tables/conges_table.dart';
import 'tables/pieces_jointes_table.dart';
import 'tables/sync_queue_table.dart';
import 'daos/clients_dao.dart';
import 'daos/dossiers_dao.dart';
import 'daos/devis_dao.dart';
import 'daos/factures_dao.dart';
import 'daos/charges_dao.dart';
import 'daos/personnel_dao.dart';
import 'daos/salaires_dao.dart';
import 'daos/conges_dao.dart';
import 'daos/pieces_jointes_dao.dart';
import 'daos/sync_queue_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clients,
    Dossiers,
    Devis,
    DevisLignes,
    Factures,
    FacturesLignes,
    Charges,
    Personnel,
    Salaires,
    Conges,
    PiecesJointes,
    SyncQueue,
  ],
  daos: [
    ClientsDao,
    DossiersDao,
    DevisDao,
    FacturesDao,
    ChargesDao,
    PersonnelDao,
    SalairesDao,
    CongesDao,
    PiecesJointesDao,
    SyncQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(piecesJointes);
      if (from < 3) await m.createTable(conges);
    },
  );

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }

  static QueryExecutor _openConnection() => openAppDatabase();
}

