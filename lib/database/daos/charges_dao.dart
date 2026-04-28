import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/charges_table.dart';

part 'charges_dao.g.dart';

@DriftAccessor(tables: [Charges])
class ChargesDao extends DatabaseAccessor<AppDatabase> with _$ChargesDaoMixin {
  ChargesDao(super.db);

  Future<List<Charge>> getAll({int? mois, int? annee, String? categorie}) {
    final query = select(charges)
      ..orderBy([(c) => OrderingTerm.desc(c.dateCharge)]);
    if (mois != null) query.where((c) => c.mois.equals(mois));
    if (annee != null) query.where((c) => c.annee.equals(annee));
    if (categorie != null) query.where((c) => c.categorie.equals(categorie));
    return query.get();
  }

  Future<void> upsert(ChargesCompanion companion) {
    return into(charges).insertOnConflictUpdate(companion);
  }

  Future<double> getTotalParMois(int mois, int annee) async {
    final all = await getAll(mois: mois, annee: annee);
    return all.fold<double>(0.0, (sum, c) => sum + c.montant);
  }

  Future<Map<String, double>> getTotalParCategorie(int mois, int annee) async {
    final all = await getAll(mois: mois, annee: annee);
    final map = <String, double>{};
    for (final c in all) {
      map[c.categorie] = (map[c.categorie] ?? 0) + c.montant;
    }
    return map;
  }

  Future<void> markSynced(String id) {
    return (update(charges)..where((c) => c.id.equals(id)))
        .write(const ChargesCompanion(syncStatus: Value('synced')));
  }

  Future<List<Charge>> getPending() {
    return (select(charges)..where((c) => c.syncStatus.equals('pending'))).get();
  }
}
