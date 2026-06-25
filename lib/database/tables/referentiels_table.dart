import 'package:drift/drift.dart';

class Referentiels extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId =>
      text().withDefault(const Constant('default'))();
  TextColumn get type => text()(); // 'poste' | 'departement'
  TextColumn get nom => text()();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
