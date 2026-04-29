// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charges_modeles_dao.dart';

// ignore_for_file: type=lint
mixin _$ChargesModelesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChargesModelesTable get chargesModeles => attachedDatabase.chargesModeles;
  $ChargesModeleLinesTable get chargesModeleLines =>
      attachedDatabase.chargesModeleLines;
  ChargesModelesDaoManager get managers => ChargesModelesDaoManager(this);
}

class ChargesModelesDaoManager {
  final _$ChargesModelesDaoMixin _db;
  ChargesModelesDaoManager(this._db);
  $$ChargesModelesTableTableManager get chargesModeles =>
      $$ChargesModelesTableTableManager(
          _db.attachedDatabase, _db.chargesModeles);
  $$ChargesModeleLinesTableTableManager get chargesModeleLines =>
      $$ChargesModeleLinesTableTableManager(
          _db.attachedDatabase, _db.chargesModeleLines);
}
