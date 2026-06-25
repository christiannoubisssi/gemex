// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produits_dao.dart';

// ignore_for_file: type=lint
mixin _$ProduitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProduitsTable get produits => attachedDatabase.produits;
  ProduitsDaoManager get managers => ProduitsDaoManager(this);
}

class ProduitsDaoManager {
  final _$ProduitsDaoMixin _db;
  ProduitsDaoManager(this._db);
  $$ProduitsTableTableManager get produits =>
      $$ProduitsTableTableManager(_db.attachedDatabase, _db.produits);
}
