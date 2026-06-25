import 'package:drift/drift.dart';

import 'connection/connection.dart';

import 'tables/clients_table.dart';
import 'tables/client_contacts_table.dart';
import 'tables/dossiers_table.dart';
import 'tables/devis_table.dart';
import 'tables/factures_table.dart';
import 'tables/charges_table.dart';
import 'tables/charges_modeles_table.dart';
import 'tables/taxes_table.dart';
import 'tables/personnel_table.dart';
import 'tables/conges_table.dart';
import 'tables/pieces_jointes_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/documents_rapport_table.dart';
import 'tables/produits_table.dart';
import 'tables/stock_mouvements_table.dart';
import 'tables/referentiels_table.dart';
import 'daos/clients_dao.dart';
import 'daos/client_contacts_dao.dart';
import 'daos/dossiers_dao.dart';
import 'daos/devis_dao.dart';
import 'daos/factures_dao.dart';
import 'daos/charges_dao.dart';
import 'daos/charges_modeles_dao.dart';
import 'daos/taxes_dao.dart';
import 'daos/personnel_dao.dart';
import 'daos/salaires_dao.dart';
import 'daos/conges_dao.dart';
import 'daos/pieces_jointes_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'daos/documents_rapport_dao.dart';
import 'daos/produits_dao.dart';
import 'daos/stock_mouvements_dao.dart';
import 'daos/referentiels_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clients,
    ClientContacts,
    Dossiers,
    Devis,
    DevisLignes,
    Factures,
    FacturesLignes,
    Charges,
    ChargesModeles,
    ChargesModeleLines,
    Taxes,
    Personnel,
    Salaires,
    Conges,
    PiecesJointes,
    SyncQueue,
    DocumentsRapport,
    Produits,
    StockMouvements,
    Referentiels,
  ],
  daos: [
    ClientsDao,
    ClientContactsDao,
    DossiersDao,
    DevisDao,
    FacturesDao,
    ChargesDao,
    ChargesModelesDao,
    TaxesDao,
    PersonnelDao,
    SalairesDao,
    CongesDao,
    PiecesJointesDao,
    SyncQueueDao,
    DocumentsRapportDao,
    ProduitsDao,
    StockMouvementsDao,
    ReferentielsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(piecesJointes);
      if (from < 3) await m.createTable(conges);
      if (from < 4) {
        await m.createTable(chargesModeles);
        await m.createTable(chargesModeleLines);
        await m.createTable(taxes);
        await m.addColumn(devisLignes, devisLignes.taxesJson);
        await m.addColumn(facturesLignes, facturesLignes.taxesJson);
      }
      if (from < 5) {
        await m.addColumn(clients, clients.numeroTva);
        await m.addColumn(clients, clients.rccm);
        await m.addColumn(clients, clients.nif);
        await m.createTable(clientContacts);
      }
      // v6 : documents professionnels des dossiers (saisie de contenu)
      if (from < 6) await m.createTable(documentsRapport);
      // v7 : catalogue produits + mouvements de stock
      if (from < 7) {
        await m.createTable(produits);
        await m.createTable(stockMouvements);
      }
      // v8 : référentiels (postes, départements)
      if (from < 8) {
        await m.createTable(referentiels);
      }
      // v9 : récurrence sur les charges
      if (from < 9) {
        await m.addColumn(charges, charges.recurrence);
      }
    },
  );

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }

  static QueryExecutor _openConnection() => openAppDatabase();
}
