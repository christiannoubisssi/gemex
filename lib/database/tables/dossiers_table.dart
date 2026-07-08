import 'package:drift/drift.dart';

class Dossiers extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get clientId => text().nullable()();
  TextColumn get expertId => text().nullable()();
  TextColumn get typeMissionId => text().nullable()();

  TextColumn get numero => text().nullable()();
  IntColumn get annee => integer()();

  TextColumn get titre => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dateSinistre => dateTime().nullable()();
  TextColumn get lieuSinistre => text().nullable()();
  TextColumn get natureSinistre => text().nullable()();
  RealColumn get montantSinistre => real().nullable()();

  TextColumn get statut => text().withDefault(const Constant('brouillon'))();
  TextColumn get priorite => text().withDefault(const Constant('normale'))();

  DateTimeColumn get dateOuverture => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateExpertise => dateTime().nullable()();
  DateTimeColumn get dateRapport => dateTime().nullable()();
  DateTimeColumn get dateCloture => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();

  TextColumn get compagnieAssurance => text().nullable()();
  TextColumn get numeroPolice => text().nullable()();
  TextColumn get courtier => text().nullable()();

  /// Créateur du dossier (dénormalisé pour affichage et stats rapides)
  TextColumn get createdByNom => text().nullable()();
  TextColumn get createdById  => text().nullable()();

  /// Références client (jusqu'à 3 parties impliquées dans le sinistre)
  TextColumn get refClient1 => text().nullable()();
  TextColumn get refClient2 => text().nullable()();
  TextColumn get refClient3 => text().nullable()();

  TextColumn get notesInternes => text().nullable()();
  TextColumn get observations => text().nullable()();
  TextColumn get motifAnnulation => text().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
