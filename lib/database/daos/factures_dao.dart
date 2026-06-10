import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/factures_table.dart';

part 'factures_dao.g.dart';

@DriftAccessor(tables: [Factures, FacturesLignes])
class FacturesDao extends DatabaseAccessor<AppDatabase> with _$FacturesDaoMixin {
  FacturesDao(super.db);

  Future<List<Facture>> getAll({String? statut, String? clientId, String? dossierId}) {
    final query = select(factures)
      ..orderBy([(f) => OrderingTerm.desc(f.createdAt)]);
    if (statut != null) query.where((f) => f.statut.equals(statut));
    if (clientId != null) query.where((f) => f.clientId.equals(clientId));
    if (dossierId != null) query.where((f) => f.dossierId.equals(dossierId));
    return query.get();
  }

  Stream<List<Facture>> watchAll() {
    return (select(factures)..orderBy([(f) => OrderingTerm.desc(f.createdAt)])).watch();
  }

  Future<Facture?> getById(String id) {
    return (select(factures)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  Future<List<FacturesLigne>> getLignes(String factureId) {
    return (select(facturesLignes)
          ..where((l) => l.factureId.equals(factureId))
          ..orderBy([(l) => OrderingTerm.asc(l.ordre)]))
        .get();
  }

  Future<void> upsertFacture(FacturesCompanion companion) {
    return into(factures).insertOnConflictUpdate(companion);
  }

  Future<void> upsertLigne(FacturesLignesCompanion companion) {
    return into(facturesLignes).insertOnConflictUpdate(companion);
  }

  Future<void> deleteLignes(String factureId) {
    return (delete(facturesLignes)..where((l) => l.factureId.equals(factureId))).go();
  }

  Future<void> enregistrerPaiement(
      String id, double montantPaye, String? modePaiement, String? reference) async {
    final facture = await getById(id);
    if (facture == null) return;

    final newMontantPaye = facture.montantPaye + montantPaye;
    final newMontantRestant = facture.montantTtc - newMontantPaye;
    String newStatut = facture.statut;
    if (newMontantRestant <= 0) {
      newStatut = 'payee';
    } else if (newMontantPaye > 0) {
      newStatut = 'partiellement_payee';
    }

    await (update(factures)..where((f) => f.id.equals(id))).write(FacturesCompanion(
      montantPaye: Value(newMontantPaye),
      montantRestant: Value(newMontantRestant.clamp(0.0, double.infinity)),
      statut: Value(newStatut),
      modePaiement: Value(modePaiement),
      referencePaiement: Value(reference),
      datePaiement: newStatut == 'payee' ? Value(DateTime.now()) : const Value.absent(),
      syncStatus: const Value('pending'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<double> getCaParMois(int mois, int annee) async {
    final all = await (select(factures)
          ..where((f) =>
              f.statut.isIn(['emise', 'partiellement_payee', 'payee']) &
              f.annee.equals(annee)))
        .get();
    return all
        .where((f) => f.dateEmission.month == mois)
        .fold<double>(0.0, (sum, f) => sum + f.montantHt);
  }

  Future<double> getTotalCreances() async {
    final all = await (select(factures)
          ..where((f) => f.montantRestant.isBiggerThanValue(0)))
        .get();
    return all.fold<double>(0.0, (sum, f) => sum + f.montantRestant);
  }

  Future<List<Facture>> getEnRetard() {
    final now = DateTime.now();
    return (select(factures)
          ..where((f) =>
              f.statut.isIn(['emise', 'partiellement_payee']) &
              f.dateEcheance.isSmallerThan(Variable(now))))
        .get();
  }

  Future<double> getTauxRecouvrement() async {
    final all = await (select(factures)
          ..where((f) => f.statut.isNotIn(['annulee'])))
        .get();
    if (all.isEmpty) return 0.0;
    final totalEmis = all.fold<double>(0.0, (s, f) => s + f.montantTtc);
    final totalRecouvre = all.fold<double>(0.0, (s, f) => s + f.montantPaye);
    if (totalEmis == 0) return 0.0;
    return (totalRecouvre / totalEmis) * 100;
  }

  Future<void> updateNumero(String id, String numero) {
    return (update(factures)..where((f) => f.id.equals(id))).write(FacturesCompanion(
      numero: Value(numero),
      syncStatus: const Value('synced'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> markSynced(String id) {
    return (update(factures)..where((f) => f.id.equals(id)))
        .write(const FacturesCompanion(syncStatus: Value('synced')));
  }

  Future<List<Facture>> getPending() {
    return (select(factures)..where((f) => f.syncStatus.equals('pending'))).get();
  }
}
