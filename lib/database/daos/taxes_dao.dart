import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/taxes_table.dart';

part 'taxes_dao.g.dart';

@DriftAccessor(tables: [Taxes])
class TaxesDao extends DatabaseAccessor<AppDatabase> with _$TaxesDaoMixin {
  TaxesDao(super.db);

  Future<List<Taxe>> getAll({bool? actif}) {
    final q = select(taxes)..orderBy([(t) => OrderingTerm.asc(t.nom)]);
    if (actif != null) q.where((t) => t.actif.equals(actif));
    return q.get();
  }

  Future<Taxe?> getById(String id) =>
      (select(taxes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(TaxesCompanion companion) =>
      into(taxes).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(taxes)..where((t) => t.id.equals(id))).go();

  Future<void> toggleActif(String id, bool actif) async {
    await (update(taxes)..where((t) => t.id.equals(id))).write(
      TaxesCompanion(actif: Value(actif), updatedAt: Value(DateTime.now())),
    );
  }
}
