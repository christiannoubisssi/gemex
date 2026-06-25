import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/produits_table.dart';

part 'produits_dao.g.dart';

@DriftAccessor(tables: [Produits])
class ProduitsDao extends DatabaseAccessor<AppDatabase> with _$ProduitsDaoMixin {
  ProduitsDao(super.db);

  /// Tous les produits actifs, triés par nom
  Future<List<Produit>> getAll({bool? actif, bool? estVente, bool? estAchat}) {
    final q = select(produits)..orderBy([(p) => OrderingTerm.asc(p.nom)]);
    if (actif != null) q.where((p) => p.actif.equals(actif));
    if (estVente != null) q.where((p) => p.estVente.equals(estVente));
    if (estAchat != null) q.where((p) => p.estAchat.equals(estAchat));
    return q.get();
  }

  /// Stream réactif (auto-update UI)
  Stream<List<Produit>> watchAll({bool? actif, bool? estVente, bool? estAchat}) {
    final q = select(produits)..orderBy([(p) => OrderingTerm.asc(p.nom)]);
    if (actif != null) q.where((p) => p.actif.equals(actif));
    if (estVente != null) q.where((p) => p.estVente.equals(estVente));
    if (estAchat != null) q.where((p) => p.estAchat.equals(estAchat));
    return q.watch();
  }

  Future<Produit?> getById(String id) =>
      (select(produits)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<Produit?> getByCode(String code) =>
      (select(produits)..where((p) => p.code.equals(code))).getSingleOrNull();

  Future<void> upsert(ProduitsCompanion companion) =>
      into(produits).insertOnConflictUpdate(companion);

  Future<void> toggleActif(String id, bool actif) async {
    await (update(produits)..where((p) => p.id.equals(id))).write(
      ProduitsCompanion(actif: Value(actif), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteById(String id) =>
      (delete(produits)..where((p) => p.id.equals(id))).go();

  Future<void> markSynced(String id) =>
      (update(produits)..where((p) => p.id.equals(id)))
          .write(const ProduitsCompanion(syncStatus: Value('synced')));

  /// Prochain code auto : PRD-NNN
  Future<String> nextCode() async {
    final all = await (select(produits)
          ..orderBy([(p) => OrderingTerm.desc(p.code)]))
        .get();
    int max = 0;
    for (final p in all) {
      final match = RegExp(r'PRD-(\d+)').firstMatch(p.code);
      if (match != null) {
        final n = int.tryParse(match.group(1)!) ?? 0;
        if (n > max) max = n;
      }
    }
    return 'PRD-${(max + 1).toString().padLeft(3, '0')}';
  }
}
