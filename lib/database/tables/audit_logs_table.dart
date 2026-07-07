import 'package:drift/drift.dart';

/// Journal d'activité — chaque action métier est tracée ici.
/// Append-only : jamais modifié après insertion.
class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get entrepriseId =>
      text().withDefault(const Constant('default'))();
  TextColumn get userId => text()(); // auth.uid()
  TextColumn get userNom => text()(); // nom lisible pour l'UI
  TextColumn get actionType => text()(); // 'dossier.created', etc.
  TextColumn get entityType => text()(); // 'dossier', 'client', etc.
  TextColumn get entityId => text()();
  TextColumn get entityLabel => text().nullable()(); // 'AV-2025-0042'
  TextColumn get description => text()(); // phrase lisible
  TextColumn get ancienneValeur => text().nullable()(); // pour les changements
  TextColumn get nouvelleValeur => text().nullable()(); // pour les changements
  TextColumn get metadataJson => text().nullable()(); // contexte additionnel
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
