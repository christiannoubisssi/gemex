// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devis_dao.dart';

// ignore_for_file: type=lint
mixin _$DevisDaoMixin on DatabaseAccessor<AppDatabase> {
  $DevisTable get devis => attachedDatabase.devis;
  $DevisLignesTable get devisLignes => attachedDatabase.devisLignes;
  DevisDaoManager get managers => DevisDaoManager(this);
}

class DevisDaoManager {
  final _$DevisDaoMixin _db;
  DevisDaoManager(this._db);
  $$DevisTableTableManager get devis =>
      $$DevisTableTableManager(_db.attachedDatabase, _db.devis);
  $$DevisLignesTableTableManager get devisLignes =>
      $$DevisLignesTableTableManager(_db.attachedDatabase, _db.devisLignes);
}
