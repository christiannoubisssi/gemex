// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charges_dao.dart';

// ignore_for_file: type=lint
mixin _$ChargesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChargesTable get charges => attachedDatabase.charges;
  ChargesDaoManager get managers => ChargesDaoManager(this);
}

class ChargesDaoManager {
  final _$ChargesDaoMixin _db;
  ChargesDaoManager(this._db);
  $$ChargesTableTableManager get charges =>
      $$ChargesTableTableManager(_db.attachedDatabase, _db.charges);
}
