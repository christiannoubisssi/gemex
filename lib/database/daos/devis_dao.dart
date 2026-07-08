import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/devis_table.dart';

part 'devis_dao.g.dart';

@DriftAccessor(tables: [Devis, DevisLignes])
class DevisDao extends DatabaseAccessor<AppDatabase> with _$DevisDaoMixin {
  DevisDao(super.db);

  Future<List<Devi>> getAll({String? statut, String? clientId, String? dossierId}) {
    final query = select(devis)
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    if (statut != null) query.where((d) => d.statut.equals(statut));
    if (clientId != null) query.where((d) => d.clientId.equals(clientId));
    if (dossierId != null) query.where((d) => d.dossierId.equals(dossierId));
    return query.get();
  }

  Stream<List<Devi>> watchAll() {
    return (select(devis)..orderBy([(d) => OrderingTerm.desc(d.createdAt)])).watch();
  }

  Future<Devi?> getById(String id) {
    return (select(devis)..where((d) => d.id.equals(id))).getSingleOrNull();
  }

  Future<List<DevisLigne>> getLignes(String devisId) {
    return (select(devisLignes)
          ..where((l) => l.devisId.equals(devisId))
          ..orderBy([(l) => OrderingTerm.asc(l.ordre)]))
        .get();
  }

  Future<void> upsertDevis(DevisCompanion companion) {
    return into(devis).insertOnConflictUpdate(companion);
  }

  Future<void> upsertLigne(DevisLignesCompanion companion) {
    return into(devisLignes).insertOnConflictUpdate(companion);
  }

  Future<void> deleteLignes(String devisId) {
    return (delete(devisLignes)..where((l) => l.devisId.equals(devisId))).go();
  }

  Future<void> updateStatut(String id, String statut) {
    return (update(devis)..where((d) => d.id.equals(id))).write(DevisCompanion(
      statut: Value(statut),
      syncStatus: const Value('pending'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateNumero(String id, String numero) {
    return (update(devis)..where((d) => d.id.equals(id))).write(DevisCompanion(
      numero: Value(numero),
      syncStatus: const Value('synced'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> markSynced(String id) {
    return (update(devis)..where((d) => d.id.equals(id)))
        .write(const DevisCompanion(syncStatus: Value('synced')));
  }

  Future<List<Devi>> getPending() {
    return (select(devis)..where((d) => d.syncStatus.equals('pending'))).get();
  }

  /// Suppression physique d'un devis + ses lignes (admin only).
  Future<void> deleteDevis(String id) async {
    await (delete(devisLignes)..where((l) => l.devisId.equals(id))).go();
    await (delete(devis)..where((d) => d.id.equals(id))).go();
  }

  /// Supprime tous les devis liés à un dossier (cascade lors de suppression dossier).
  Future<void> deleteByDossierId(String dossierId) async {
    final liste = await (select(devis)
          ..where((d) => d.dossierId.equals(dossierId)))
        .get();
    for (final d in liste) {
      await deleteDevis(d.id);
    }
  }
}
