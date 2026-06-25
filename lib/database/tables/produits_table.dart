import 'package:drift/drift.dart';

class Produits extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get code => text()(); // PRD-001
  TextColumn get nom => text()();
  TextColumn get description => text().nullable()();
  TextColumn get unite => text().withDefault(const Constant('unité'))();
  RealColumn get prixVente => real().withDefault(const Constant(0.0))();
  RealColumn get prixAchat => real().withDefault(const Constant(0.0))();
  BoolColumn get estVente => boolean().withDefault(const Constant(true))();
  BoolColumn get estAchat => boolean().withDefault(const Constant(false))();
  TextColumn get categorie => text().nullable()();
  RealColumn get stockMin => real().withDefault(const Constant(0.0))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
