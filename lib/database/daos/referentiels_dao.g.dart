// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referentiels_dao.dart';

// ignore_for_file: type=lint
mixin _$ReferentielsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReferentielsTable get referentiels => attachedDatabase.referentiels;
  ReferentielsDaoManager get managers => ReferentielsDaoManager(this);
}

class ReferentielsDaoManager {
  final _$ReferentielsDaoMixin _db;
  ReferentielsDaoManager(this._db);
  $$ReferentielsTableTableManager get referentiels =>
      $$ReferentielsTableTableManager(_db.attachedDatabase, _db.referentiels);
}
