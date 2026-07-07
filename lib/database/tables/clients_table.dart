import 'package:drift/drift.dart';

class Clients extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId => text()();
  TextColumn get typeClient => text()(); // entreprise|particulier|assurance|armateur
  TextColumn get nom => text()();
  TextColumn get contactNom => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get telephone => text().nullable()();
  TextColumn get adresse => text().nullable()();
  TextColumn get ville => text().nullable()();
  TextColumn get pays => text().withDefault(const Constant('Gabon'))();
  TextColumn get numeroTva => text().nullable()();
  TextColumn get rccm => text().nullable()();
  TextColumn get nif => text().nullable()();
  TextColumn get notes => text().nullable()();

  // Référence interne (tous clients)
  TextColumn get reference => text().nullable()();

  // Références spécifiques client OLEA
  TextColumn get refOleaUnique => text().nullable()();
  TextColumn get refAgl => text().nullable()();
  TextColumn get refDs => text().nullable()();
  TextColumn get cabinetBce => text().nullable()();

  RealColumn get totalFacture => real().withDefault(const Constant(0.0))();
  RealColumn get totalPaye => real().withDefault(const Constant(0.0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
