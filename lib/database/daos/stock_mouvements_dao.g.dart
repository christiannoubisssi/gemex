// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mouvements_dao.dart';

// ignore_for_file: type=lint
mixin _$StockMouvementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $StockMouvementsTable get stockMouvements => attachedDatabase.stockMouvements;
  StockMouvementsDaoManager get managers => StockMouvementsDaoManager(this);
}

class StockMouvementsDaoManager {
  final _$StockMouvementsDaoMixin _db;
  StockMouvementsDaoManager(this._db);
  $$StockMouvementsTableTableManager get stockMouvements =>
      $$StockMouvementsTableTableManager(
          _db.attachedDatabase, _db.stockMouvements);
}
