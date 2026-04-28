// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salaires_dao.dart';

// ignore_for_file: type=lint
mixin _$SalairesDaoMixin on DatabaseAccessor<AppDatabase> {
  $SalairesTable get salaires => attachedDatabase.salaires;
  SalairesDaoManager get managers => SalairesDaoManager(this);
}

class SalairesDaoManager {
  final _$SalairesDaoMixin _db;
  SalairesDaoManager(this._db);
  $$SalairesTableTableManager get salaires =>
      $$SalairesTableTableManager(_db.attachedDatabase, _db.salaires);
}
