import 'package:drift/drift.dart';

class Taxes extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get nom => text()();
  RealColumn get taux => real().withDefault(const Constant(0.0))();
  TextColumn get description => text().nullable()();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
