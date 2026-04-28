import 'package:drift/drift.dart';

class PiecesJointes extends Table {
  TextColumn get id => text()();
  TextColumn get dossierId => text()();
  TextColumn get nom => text()();
  TextColumn get typeFichier => text()(); // 'image', 'pdf', 'document'
  TextColumn get cheminLocal => text()();
  TextColumn get urlStorage => text().nullable()();
  IntColumn get taille => integer().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
