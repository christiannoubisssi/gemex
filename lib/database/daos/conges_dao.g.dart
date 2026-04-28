// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conges_dao.dart';

// ignore_for_file: type=lint
mixin _$CongesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CongesTable get conges => attachedDatabase.conges;
  CongesDaoManager get managers => CongesDaoManager(this);
}

class CongesDaoManager {
  final _$CongesDaoMixin _db;
  CongesDaoManager(this._db);
  $$CongesTableTableManager get conges =>
      $$CongesTableTableManager(_db.attachedDatabase, _db.conges);
}
