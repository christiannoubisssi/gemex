import 'package:drift/drift.dart';

/// Stocke le contenu saisi pour chaque document professionnel d'un dossier.
/// `contenu_json` est un Map<String,String> (sections → texte libre) sérialisé.
class DocumentsRapport extends Table {
  TextColumn get id           => text()();
  TextColumn get dossierId    => text()();
  TextColumn get type         => text()(); // TypeDocumentMetier.name (ex: 'ordreMission')
  TextColumn get contenuJson  => text().withDefault(const Constant('{}'))();
  TextColumn get statut       => text().withDefault(const Constant('brouillon'))(); // brouillon | finalise
  TextColumn get entrepriseId => text().withDefault(const Constant('default'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus   => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
