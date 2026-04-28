import 'package:drift/drift.dart';

class Factures extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get dossierId => text().nullable()();
  TextColumn get clientId => text()();
  TextColumn get devisId => text().nullable()();
  TextColumn get creePar => text().nullable()();

  TextColumn get numero => text().nullable()();
  IntColumn get annee => integer()();

  TextColumn get statut => text().withDefault(const Constant('brouillon'))();

  DateTimeColumn get dateEmission => dateTime()();
  DateTimeColumn get dateEcheance => dateTime()();
  DateTimeColumn get datePaiement => dateTime().nullable()();

  RealColumn get montantHt => real().withDefault(const Constant(0.0))();
  RealColumn get tauxTva => real().withDefault(const Constant(18.0))();
  RealColumn get montantTva => real().withDefault(const Constant(0.0))();
  RealColumn get tauxTps => real().withDefault(const Constant(0.0))();
  RealColumn get montantTps => real().withDefault(const Constant(0.0))();
  RealColumn get montantTtc => real().withDefault(const Constant(0.0))();
  RealColumn get montantPaye => real().withDefault(const Constant(0.0))();
  RealColumn get montantRestant => real().withDefault(const Constant(0.0))();

  TextColumn get modePaiement => text().nullable()();
  TextColumn get referencePaiement => text().nullable()();

  TextColumn get objet => text().nullable()();
  TextColumn get conditions => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get motifAnnulation => text().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class FacturesLignes extends Table {
  TextColumn get id => text()();
  TextColumn get factureId => text()();
  IntColumn get ordre => integer().withDefault(const Constant(0))();
  TextColumn get designation => text()();
  TextColumn get description => text().nullable()();
  RealColumn get quantite => real().withDefault(const Constant(1.0))();
  TextColumn get unite => text().withDefault(const Constant('forfait'))();
  RealColumn get prixUnit => real().withDefault(const Constant(0.0))();
  RealColumn get montantHt => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
