import 'package:drift/drift.dart';

/// File d'attente des opérations offline à synchroniser avec Supabase.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // dossier | client | facture | devis | charge
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // create | update | delete
  TextColumn get payload => text()(); // JSON de la donnée
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttempt => dateTime().nullable()();
}
