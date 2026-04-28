// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factures_dao.dart';

// ignore_for_file: type=lint
mixin _$FacturesDaoMixin on DatabaseAccessor<AppDatabase> {
  $FacturesTable get factures => attachedDatabase.factures;
  $FacturesLignesTable get facturesLignes => attachedDatabase.facturesLignes;
  FacturesDaoManager get managers => FacturesDaoManager(this);
}

class FacturesDaoManager {
  final _$FacturesDaoMixin _db;
  FacturesDaoManager(this._db);
  $$FacturesTableTableManager get factures =>
      $$FacturesTableTableManager(_db.attachedDatabase, _db.factures);
  $$FacturesLignesTableTableManager get facturesLignes =>
      $$FacturesLignesTableTableManager(
          _db.attachedDatabase, _db.facturesLignes);
}
