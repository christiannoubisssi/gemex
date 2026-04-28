import 'package:drift/drift.dart';

class Conges extends Table {
  TextColumn get id => text()();
  TextColumn get personnelId => text()();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime()();
  TextColumn get type => text().withDefault(const Constant('conge_annuel'))();
  TextColumn get motif => text().nullable()();
  // statut: demande | approuve | refuse
  TextColumn get statut => text().withDefault(const Constant('demande'))();
  TextColumn get validePar => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
