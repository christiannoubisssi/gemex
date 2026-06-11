// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_contacts_dao.dart';

// ignore_for_file: type=lint
mixin _$ClientContactsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientContactsTable get clientContacts => attachedDatabase.clientContacts;
  ClientContactsDaoManager get managers => ClientContactsDaoManager(this);
}

class ClientContactsDaoManager {
  final _$ClientContactsDaoMixin _db;
  ClientContactsDaoManager(this._db);
  $$ClientContactsTableTableManager get clientContacts =>
      $$ClientContactsTableTableManager(
          _db.attachedDatabase, _db.clientContacts);
}
