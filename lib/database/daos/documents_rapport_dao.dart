import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/documents_rapport_table.dart';

part 'documents_rapport_dao.g.dart';

@DriftAccessor(tables: [DocumentsRapport])
class DocumentsRapportDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentsRapportDaoMixin {
  DocumentsRapportDao(super.db);

  /// Document d'un type donné pour un dossier (null = jamais renseigné)
  Future<DocumentsRapportData?> getByDossierAndType(
      String dossierId, String type) {
    return (select(documentsRapport)
          ..where((d) =>
              d.dossierId.equals(dossierId) & d.type.equals(type)))
        .getSingleOrNull();
  }

  /// Stream de tous les documents d'un dossier (pour affichage en temps réel)
  Stream<List<DocumentsRapportData>> watchByDossier(String dossierId) {
    return (select(documentsRapport)
          ..where((d) => d.dossierId.equals(dossierId))
          ..orderBy([(d) => OrderingTerm.asc(d.type)]))
        .watch();
  }

  /// Crée ou met à jour (upsert sur id)
  Future<void> upsert(DocumentsRapportCompanion companion) {
    return into(documentsRapport).insertOnConflictUpdate(companion);
  }

  Future<void> markSynced(String id) {
    return (update(documentsRapport)..where((d) => d.id.equals(id)))
        .write(const DocumentsRapportCompanion(syncStatus: Value('synced')));
  }

  Future<List<DocumentsRapportData>> getPending() {
    return (select(documentsRapport)
          ..where((d) => d.syncStatus.equals('pending')))
        .get();
  }
}
