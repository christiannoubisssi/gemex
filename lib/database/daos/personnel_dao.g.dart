// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_dao.dart';

// ignore_for_file: type=lint
mixin _$PersonnelDaoMixin on DatabaseAccessor<AppDatabase> {
  $PersonnelTable get personnel => attachedDatabase.personnel;
  PersonnelDaoManager get managers => PersonnelDaoManager(this);
}

class PersonnelDaoManager {
  final _$PersonnelDaoMixin _db;
  PersonnelDaoManager(this._db);
  $$PersonnelTableTableManager get personnel =>
      $$PersonnelTableTableManager(_db.attachedDatabase, _db.personnel);
}
