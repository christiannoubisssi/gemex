import 'package:drift/drift.dart';

class StockMouvements extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get produitId => text()();
  TextColumn get type => text()(); // 'entree' | 'sortie'
  RealColumn get quantite => real()();
  RealColumn get prixUnitaire => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dateMouvement => dateTime()();
  TextColumn get reference => text().nullable()(); // n° facture, bon…
  TextColumn get dossierId => text().nullable()();
  TextColumn get effectuePar => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
