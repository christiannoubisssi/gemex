import 'package:drift/drift.dart';

class ChargesModeles extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  IntColumn get mois => integer()();
  IntColumn get annee => integer()();
  TextColumn get titre => text()();
  TextColumn get soumisParId => text().nullable()();
  TextColumn get soumisParNom => text().nullable()();
  // brouillon | soumis | valide | refuse | reporte
  TextColumn get statut => text().withDefault(const Constant('brouillon'))();
  TextColumn get motifRefus => text().nullable()();
  DateTimeColumn get dateSubmission => dateTime().nullable()();
  DateTimeColumn get dateValidation => dateTime().nullable()();
  TextColumn get valideParId => text().nullable()();
  TextColumn get valideParNom => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ChargesModeleLines extends Table {
  TextColumn get id => text()();
  TextColumn get modeleId => text()();
  IntColumn get ordre => integer().withDefault(const Constant(0))();
  TextColumn get designation => text()();
  RealColumn get montant => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dateEcheance => dateTime().nullable()();
  // basse | normale | haute | urgente
  TextColumn get priorite => text().withDefault(const Constant('normale'))();
  // pending | valide | refuse | reporte
  TextColumn get statut => text().withDefault(const Constant('pending'))();
  TextColumn get motifRefus => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
