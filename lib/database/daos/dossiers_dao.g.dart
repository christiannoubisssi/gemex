// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dossiers_dao.dart';

// ignore_for_file: type=lint
mixin _$DossiersDaoMixin on DatabaseAccessor<AppDatabase> {
  $DossiersTable get dossiers => attachedDatabase.dossiers;
  DossiersDaoManager get managers => DossiersDaoManager(this);
}

class DossiersDaoManager {
  final _$DossiersDaoMixin _db;
  DossiersDaoManager(this._db);
  $$DossiersTableTableManager get dossiers =>
      $$DossiersTableTableManager(_db.attachedDatabase, _db.dossiers);
}
