import 'package:drift/drift.dart';

/// Contacts secondaires d'un client (entreprise, assurance...).
/// Chaque client peut avoir plusieurs contacts, chacun avec sa fonction,
/// son téléphone et son email.
class ClientContacts extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text()();
  TextColumn get nom => text()();
  TextColumn get fonction => text().nullable()();
  TextColumn get telephone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
