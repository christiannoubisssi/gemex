import 'package:drift/drift.dart';

class Charges extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get dossierId => text().nullable()();
  TextColumn get saisiPar => text().nullable()();

  TextColumn get categorie => text()();
  TextColumn get libelle => text()();
  RealColumn get montant => real()();
  DateTimeColumn get dateCharge => dateTime()();
  IntColumn get mois => integer()();
  IntColumn get annee => integer()();
  TextColumn get justificatifUrl => text().nullable()();
  TextColumn get notes => text().nullable()();

  // 'unique', 'mensuel', 'trimestriel', 'annuel'
  TextColumn get recurrence =>
      text().withDefault(const Constant('unique'))();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
