import 'package:drift/drift.dart';

class Personnel extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get utilisateurId => text().nullable()();
  TextColumn get nom => text()();
  TextColumn get prenom => text().nullable()();
  TextColumn get poste => text().nullable()();
  TextColumn get departement => text().nullable()();
  TextColumn get typeContrat => text().withDefault(const Constant('CDI'))();
  DateTimeColumn get dateEmbauche => dateTime().nullable()();
  DateTimeColumn get dateFinContrat => dateTime().nullable()();
  RealColumn get salaireBase => real().nullable()();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Salaires extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get personnelId => text()();

  IntColumn get mois => integer()();
  IntColumn get annee => integer()();

  RealColumn get salaireBrut => real().withDefault(const Constant(0.0))();
  RealColumn get cnps => real().withDefault(const Constant(0.0))();
  RealColumn get irpp => real().withDefault(const Constant(0.0))();
  RealColumn get autresRetenues => real().withDefault(const Constant(0.0))();
  RealColumn get salaireNet => real()();

  TextColumn get statut => text().withDefault(const Constant('en_attente'))();
  DateTimeColumn get dateValidation => dateTime().nullable()();
  TextColumn get validePar => text().nullable()();
  DateTimeColumn get datePaiement => dateTime().nullable()();
  TextColumn get modePaiement => text().nullable()();

  BoolColumn get comptabilise => boolean().withDefault(const Constant(false))();
  TextColumn get chargeId => text().nullable()();
  TextColumn get notes => text().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
