import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/dossiers_table.dart';

part 'dossiers_dao.g.dart';

@DriftAccessor(tables: [Dossiers])
class DossiersDao extends DatabaseAccessor<AppDatabase> with _$DossiersDaoMixin {
  DossiersDao(super.db);

  Future<List<Dossier>> getAll({
    String? statut,
    String? priorite,
    String? clientId,
    String? search,
  }) {
    final query = select(dossiers)
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);

    if (statut != null) query.where((d) => d.statut.equals(statut));
    if (priorite != null) query.where((d) => d.priorite.equals(priorite));
    if (clientId != null) query.where((d) => d.clientId.equals(clientId));
    if (search != null && search.isNotEmpty) {
      query.where((d) =>
          d.titre.like('%$search%') |
          d.numero.like('%$search%') |
          d.lieuSinistre.like('%$search%'));
    }
    return query.get();
  }

  Stream<List<Dossier>> watchAll({String? statut}) {
    final query = select(dossiers)
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    if (statut != null) query.where((d) => d.statut.equals(statut));
    return query.watch();
  }

  Future<Dossier?> getById(String id) {
    return (select(dossiers)..where((d) => d.id.equals(id))).getSingleOrNull();
  }

  Future<List<Dossier>> getUrgents() {
    return (select(dossiers)
          ..where((d) =>
              d.priorite.isIn(['haute', 'urgente']) &
              d.statut.isNotIn(['clos', 'annule']))
          ..orderBy([(d) => OrderingTerm.desc(d.createdAt)])
          ..limit(5))
        .get();
  }

  Future<void> upsert(DossiersCompanion companion) {
    return into(dossiers).insertOnConflictUpdate(companion);
  }

  Future<void> updateStatut(String id, String statut,
      {DateTime? dateExpertise, DateTime? dateRapport, DateTime? dateCloture, String? motifAnnulation}) {
    return (update(dossiers)..where((d) => d.id.equals(id))).write(DossiersCompanion(
      statut: Value(statut),
      dateExpertise: dateExpertise != null ? Value(dateExpertise) : const Value.absent(),
      dateRapport: dateRapport != null ? Value(dateRapport) : const Value.absent(),
      dateCloture: dateCloture != null ? Value(dateCloture) : const Value.absent(),
      motifAnnulation: motifAnnulation != null ? Value(motifAnnulation) : const Value.absent(),
      syncStatus: const Value('pending'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateNumero(String id, String numero) {
    return (update(dossiers)..where((d) => d.id.equals(id))).write(DossiersCompanion(
      numero: Value(numero),
      syncStatus: const Value('synced'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> markSynced(String id) {
    return (update(dossiers)..where((d) => d.id.equals(id)))
        .write(const DossiersCompanion(syncStatus: Value('synced')));
  }

  Future<List<Dossier>> getPending() {
    return (select(dossiers)..where((d) => d.syncStatus.equals('pending'))).get();
  }

  Future<Map<String, int>> getStatsCounts() async {
    final all = await select(dossiers).get();
    final counts = <String, int>{};
    for (final d in all) {
      counts[d.statut] = (counts[d.statut] ?? 0) + 1;
    }
    return counts;
  }
}
