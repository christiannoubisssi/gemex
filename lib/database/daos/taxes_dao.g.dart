// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxes_dao.dart';

// ignore_for_file: type=lint
mixin _$TaxesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TaxesTable get taxes => attachedDatabase.taxes;
  TaxesDaoManager get managers => TaxesDaoManager(this);
}

class TaxesDaoManager {
  final _$TaxesDaoMixin _db;
  TaxesDaoManager(this._db);
  $$TaxesTableTableManager get taxes =>
      $$TaxesTableTableManager(_db.attachedDatabase, _db.taxes);
}
