import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/stock_mouvements_table.dart';

part 'stock_mouvements_dao.g.dart';

@DriftAccessor(tables: [StockMouvements])
class StockMouvementsDao extends DatabaseAccessor<AppDatabase>
    with _$StockMouvementsDaoMixin {
  StockMouvementsDao(super.db);

  Future<List<StockMouvement>> getAll({String? produitId, String? type}) {
    final q = select(stockMouvements)
      ..orderBy([(m) => OrderingTerm.desc(m.dateMouvement)]);
    if (produitId != null) q.where((m) => m.produitId.equals(produitId));
    if (type != null) q.where((m) => m.type.equals(type));
    return q.get();
  }

  Stream<List<StockMouvement>> watchAll({String? produitId}) {
    final q = select(stockMouvements)
      ..orderBy([(m) => OrderingTerm.desc(m.dateMouvement)]);
    if (produitId != null) q.where((m) => m.produitId.equals(produitId));
    return q.watch();
  }

  Future<StockMouvement?> getById(String id) =>
      (select(stockMouvements)..where((m) => m.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(StockMouvementsCompanion companion) =>
      into(stockMouvements).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(stockMouvements)..where((m) => m.id.equals(id))).go();

  Future<void> markSynced(String id) =>
      (update(stockMouvements)..where((m) => m.id.equals(id)))
          .write(const StockMouvementsCompanion(syncStatus: Value('synced')));

  /// Quantité en stock pour un produit = Σ entrées − Σ sorties
  Future<double> getStockProduit(String produitId) async {
    final mouvements = await getAll(produitId: produitId);
    double stock = 0;
    for (final m in mouvements) {
      stock += m.type == 'entree' ? m.quantite : -m.quantite;
    }
    return stock;
  }

  /// Stock de tous les produits : {produitId: quantité}
  Future<Map<String, double>> getStockAll() async {
    final all = await (select(stockMouvements)).get();
    final map = <String, double>{};
    for (final m in all) {
      map[m.produitId] =
          (map[m.produitId] ?? 0) + (m.type == 'entree' ? m.quantite : -m.quantite);
    }
    return map;
  }
}
