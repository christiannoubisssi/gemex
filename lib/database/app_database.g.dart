// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeClientMeta =
      const VerificationMeta('typeClient');
  @override
  late final GeneratedColumn<String> typeClient = GeneratedColumn<String>(
      'type_client', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contactNomMeta =
      const VerificationMeta('contactNom');
  @override
  late final GeneratedColumn<String> contactNom = GeneratedColumn<String>(
      'contact_nom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adresseMeta =
      const VerificationMeta('adresse');
  @override
  late final GeneratedColumn<String> adresse = GeneratedColumn<String>(
      'adresse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _villeMeta = const VerificationMeta('ville');
  @override
  late final GeneratedColumn<String> ville = GeneratedColumn<String>(
      'ville', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paysMeta = const VerificationMeta('pays');
  @override
  late final GeneratedColumn<String> pays = GeneratedColumn<String>(
      'pays', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Gabon'));
  static const VerificationMeta _numeroTvaMeta =
      const VerificationMeta('numeroTva');
  @override
  late final GeneratedColumn<String> numeroTva = GeneratedColumn<String>(
      'numero_tva', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rccmMeta = const VerificationMeta('rccm');
  @override
  late final GeneratedColumn<String> rccm = GeneratedColumn<String>(
      'rccm', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nifMeta = const VerificationMeta('nif');
  @override
  late final GeneratedColumn<String> nif = GeneratedColumn<String>(
      'nif', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalFactureMeta =
      const VerificationMeta('totalFacture');
  @override
  late final GeneratedColumn<double> totalFacture = GeneratedColumn<double>(
      'total_facture', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalPayeMeta =
      const VerificationMeta('totalPaye');
  @override
  late final GeneratedColumn<double> totalPaye = GeneratedColumn<double>(
      'total_paye', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        typeClient,
        nom,
        contactNom,
        email,
        telephone,
        adresse,
        ville,
        pays,
        numeroTva,
        rccm,
        nif,
        notes,
        totalFacture,
        totalPaye,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<Client> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('type_client')) {
      context.handle(
          _typeClientMeta,
          typeClient.isAcceptableOrUnknown(
              data['type_client']!, _typeClientMeta));
    } else if (isInserting) {
      context.missing(_typeClientMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('contact_nom')) {
      context.handle(
          _contactNomMeta,
          contactNom.isAcceptableOrUnknown(
              data['contact_nom']!, _contactNomMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('adresse')) {
      context.handle(_adresseMeta,
          adresse.isAcceptableOrUnknown(data['adresse']!, _adresseMeta));
    }
    if (data.containsKey('ville')) {
      context.handle(
          _villeMeta, ville.isAcceptableOrUnknown(data['ville']!, _villeMeta));
    }
    if (data.containsKey('pays')) {
      context.handle(
          _paysMeta, pays.isAcceptableOrUnknown(data['pays']!, _paysMeta));
    }
    if (data.containsKey('numero_tva')) {
      context.handle(_numeroTvaMeta,
          numeroTva.isAcceptableOrUnknown(data['numero_tva']!, _numeroTvaMeta));
    }
    if (data.containsKey('rccm')) {
      context.handle(
          _rccmMeta, rccm.isAcceptableOrUnknown(data['rccm']!, _rccmMeta));
    }
    if (data.containsKey('nif')) {
      context.handle(
          _nifMeta, nif.isAcceptableOrUnknown(data['nif']!, _nifMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('total_facture')) {
      context.handle(
          _totalFactureMeta,
          totalFacture.isAcceptableOrUnknown(
              data['total_facture']!, _totalFactureMeta));
    }
    if (data.containsKey('total_paye')) {
      context.handle(_totalPayeMeta,
          totalPaye.isAcceptableOrUnknown(data['total_paye']!, _totalPayeMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      typeClient: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_client'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      contactNom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_nom']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone']),
      adresse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adresse']),
      ville: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ville']),
      pays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pays'])!,
      numeroTva: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_tva']),
      rccm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rccm']),
      nif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nif']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      totalFacture: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_facture'])!,
      totalPaye: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_paye'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final String id;
  final String entrepriseId;
  final String typeClient;
  final String nom;
  final String? contactNom;
  final String? email;
  final String? telephone;
  final String? adresse;
  final String? ville;
  final String pays;
  final String? numeroTva;
  final String? rccm;
  final String? nif;
  final String? notes;
  final double totalFacture;
  final double totalPaye;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Client(
      {required this.id,
      required this.entrepriseId,
      required this.typeClient,
      required this.nom,
      this.contactNom,
      this.email,
      this.telephone,
      this.adresse,
      this.ville,
      required this.pays,
      this.numeroTva,
      this.rccm,
      this.nif,
      this.notes,
      required this.totalFacture,
      required this.totalPaye,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    map['type_client'] = Variable<String>(typeClient);
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || contactNom != null) {
      map['contact_nom'] = Variable<String>(contactNom);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || adresse != null) {
      map['adresse'] = Variable<String>(adresse);
    }
    if (!nullToAbsent || ville != null) {
      map['ville'] = Variable<String>(ville);
    }
    map['pays'] = Variable<String>(pays);
    if (!nullToAbsent || numeroTva != null) {
      map['numero_tva'] = Variable<String>(numeroTva);
    }
    if (!nullToAbsent || rccm != null) {
      map['rccm'] = Variable<String>(rccm);
    }
    if (!nullToAbsent || nif != null) {
      map['nif'] = Variable<String>(nif);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['total_facture'] = Variable<double>(totalFacture);
    map['total_paye'] = Variable<double>(totalPaye);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      typeClient: Value(typeClient),
      nom: Value(nom),
      contactNom: contactNom == null && nullToAbsent
          ? const Value.absent()
          : Value(contactNom),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      adresse: adresse == null && nullToAbsent
          ? const Value.absent()
          : Value(adresse),
      ville:
          ville == null && nullToAbsent ? const Value.absent() : Value(ville),
      pays: Value(pays),
      numeroTva: numeroTva == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroTva),
      rccm: rccm == null && nullToAbsent ? const Value.absent() : Value(rccm),
      nif: nif == null && nullToAbsent ? const Value.absent() : Value(nif),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      totalFacture: Value(totalFacture),
      totalPaye: Value(totalPaye),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      typeClient: serializer.fromJson<String>(json['typeClient']),
      nom: serializer.fromJson<String>(json['nom']),
      contactNom: serializer.fromJson<String?>(json['contactNom']),
      email: serializer.fromJson<String?>(json['email']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      adresse: serializer.fromJson<String?>(json['adresse']),
      ville: serializer.fromJson<String?>(json['ville']),
      pays: serializer.fromJson<String>(json['pays']),
      numeroTva: serializer.fromJson<String?>(json['numeroTva']),
      rccm: serializer.fromJson<String?>(json['rccm']),
      nif: serializer.fromJson<String?>(json['nif']),
      notes: serializer.fromJson<String?>(json['notes']),
      totalFacture: serializer.fromJson<double>(json['totalFacture']),
      totalPaye: serializer.fromJson<double>(json['totalPaye']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'typeClient': serializer.toJson<String>(typeClient),
      'nom': serializer.toJson<String>(nom),
      'contactNom': serializer.toJson<String?>(contactNom),
      'email': serializer.toJson<String?>(email),
      'telephone': serializer.toJson<String?>(telephone),
      'adresse': serializer.toJson<String?>(adresse),
      'ville': serializer.toJson<String?>(ville),
      'pays': serializer.toJson<String>(pays),
      'numeroTva': serializer.toJson<String?>(numeroTva),
      'rccm': serializer.toJson<String?>(rccm),
      'nif': serializer.toJson<String?>(nif),
      'notes': serializer.toJson<String?>(notes),
      'totalFacture': serializer.toJson<double>(totalFacture),
      'totalPaye': serializer.toJson<double>(totalPaye),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Client copyWith(
          {String? id,
          String? entrepriseId,
          String? typeClient,
          String? nom,
          Value<String?> contactNom = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> telephone = const Value.absent(),
          Value<String?> adresse = const Value.absent(),
          Value<String?> ville = const Value.absent(),
          String? pays,
          Value<String?> numeroTva = const Value.absent(),
          Value<String?> rccm = const Value.absent(),
          Value<String?> nif = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          double? totalFacture,
          double? totalPaye,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Client(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        typeClient: typeClient ?? this.typeClient,
        nom: nom ?? this.nom,
        contactNom: contactNom.present ? contactNom.value : this.contactNom,
        email: email.present ? email.value : this.email,
        telephone: telephone.present ? telephone.value : this.telephone,
        adresse: adresse.present ? adresse.value : this.adresse,
        ville: ville.present ? ville.value : this.ville,
        pays: pays ?? this.pays,
        numeroTva: numeroTva.present ? numeroTva.value : this.numeroTva,
        rccm: rccm.present ? rccm.value : this.rccm,
        nif: nif.present ? nif.value : this.nif,
        notes: notes.present ? notes.value : this.notes,
        totalFacture: totalFacture ?? this.totalFacture,
        totalPaye: totalPaye ?? this.totalPaye,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      typeClient:
          data.typeClient.present ? data.typeClient.value : this.typeClient,
      nom: data.nom.present ? data.nom.value : this.nom,
      contactNom:
          data.contactNom.present ? data.contactNom.value : this.contactNom,
      email: data.email.present ? data.email.value : this.email,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      adresse: data.adresse.present ? data.adresse.value : this.adresse,
      ville: data.ville.present ? data.ville.value : this.ville,
      pays: data.pays.present ? data.pays.value : this.pays,
      numeroTva: data.numeroTva.present ? data.numeroTva.value : this.numeroTva,
      rccm: data.rccm.present ? data.rccm.value : this.rccm,
      nif: data.nif.present ? data.nif.value : this.nif,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalFacture: data.totalFacture.present
          ? data.totalFacture.value
          : this.totalFacture,
      totalPaye: data.totalPaye.present ? data.totalPaye.value : this.totalPaye,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('typeClient: $typeClient, ')
          ..write('nom: $nom, ')
          ..write('contactNom: $contactNom, ')
          ..write('email: $email, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('ville: $ville, ')
          ..write('pays: $pays, ')
          ..write('numeroTva: $numeroTva, ')
          ..write('rccm: $rccm, ')
          ..write('nif: $nif, ')
          ..write('notes: $notes, ')
          ..write('totalFacture: $totalFacture, ')
          ..write('totalPaye: $totalPaye, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entrepriseId,
      typeClient,
      nom,
      contactNom,
      email,
      telephone,
      adresse,
      ville,
      pays,
      numeroTva,
      rccm,
      nif,
      notes,
      totalFacture,
      totalPaye,
      syncStatus,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.typeClient == this.typeClient &&
          other.nom == this.nom &&
          other.contactNom == this.contactNom &&
          other.email == this.email &&
          other.telephone == this.telephone &&
          other.adresse == this.adresse &&
          other.ville == this.ville &&
          other.pays == this.pays &&
          other.numeroTva == this.numeroTva &&
          other.rccm == this.rccm &&
          other.nif == this.nif &&
          other.notes == this.notes &&
          other.totalFacture == this.totalFacture &&
          other.totalPaye == this.totalPaye &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String> typeClient;
  final Value<String> nom;
  final Value<String?> contactNom;
  final Value<String?> email;
  final Value<String?> telephone;
  final Value<String?> adresse;
  final Value<String?> ville;
  final Value<String> pays;
  final Value<String?> numeroTva;
  final Value<String?> rccm;
  final Value<String?> nif;
  final Value<String?> notes;
  final Value<double> totalFacture;
  final Value<double> totalPaye;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.typeClient = const Value.absent(),
    this.nom = const Value.absent(),
    this.contactNom = const Value.absent(),
    this.email = const Value.absent(),
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.ville = const Value.absent(),
    this.pays = const Value.absent(),
    this.numeroTva = const Value.absent(),
    this.rccm = const Value.absent(),
    this.nif = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalFacture = const Value.absent(),
    this.totalPaye = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String entrepriseId,
    required String typeClient,
    required String nom,
    this.contactNom = const Value.absent(),
    this.email = const Value.absent(),
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.ville = const Value.absent(),
    this.pays = const Value.absent(),
    this.numeroTva = const Value.absent(),
    this.rccm = const Value.absent(),
    this.nif = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalFacture = const Value.absent(),
    this.totalPaye = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        typeClient = Value(typeClient),
        nom = Value(nom);
  static Insertable<Client> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? typeClient,
    Expression<String>? nom,
    Expression<String>? contactNom,
    Expression<String>? email,
    Expression<String>? telephone,
    Expression<String>? adresse,
    Expression<String>? ville,
    Expression<String>? pays,
    Expression<String>? numeroTva,
    Expression<String>? rccm,
    Expression<String>? nif,
    Expression<String>? notes,
    Expression<double>? totalFacture,
    Expression<double>? totalPaye,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (typeClient != null) 'type_client': typeClient,
      if (nom != null) 'nom': nom,
      if (contactNom != null) 'contact_nom': contactNom,
      if (email != null) 'email': email,
      if (telephone != null) 'telephone': telephone,
      if (adresse != null) 'adresse': adresse,
      if (ville != null) 'ville': ville,
      if (pays != null) 'pays': pays,
      if (numeroTva != null) 'numero_tva': numeroTva,
      if (rccm != null) 'rccm': rccm,
      if (nif != null) 'nif': nif,
      if (notes != null) 'notes': notes,
      if (totalFacture != null) 'total_facture': totalFacture,
      if (totalPaye != null) 'total_paye': totalPaye,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String>? typeClient,
      Value<String>? nom,
      Value<String?>? contactNom,
      Value<String?>? email,
      Value<String?>? telephone,
      Value<String?>? adresse,
      Value<String?>? ville,
      Value<String>? pays,
      Value<String?>? numeroTva,
      Value<String?>? rccm,
      Value<String?>? nif,
      Value<String?>? notes,
      Value<double>? totalFacture,
      Value<double>? totalPaye,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ClientsCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      typeClient: typeClient ?? this.typeClient,
      nom: nom ?? this.nom,
      contactNom: contactNom ?? this.contactNom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      numeroTva: numeroTva ?? this.numeroTva,
      rccm: rccm ?? this.rccm,
      nif: nif ?? this.nif,
      notes: notes ?? this.notes,
      totalFacture: totalFacture ?? this.totalFacture,
      totalPaye: totalPaye ?? this.totalPaye,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (typeClient.present) {
      map['type_client'] = Variable<String>(typeClient.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (contactNom.present) {
      map['contact_nom'] = Variable<String>(contactNom.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (adresse.present) {
      map['adresse'] = Variable<String>(adresse.value);
    }
    if (ville.present) {
      map['ville'] = Variable<String>(ville.value);
    }
    if (pays.present) {
      map['pays'] = Variable<String>(pays.value);
    }
    if (numeroTva.present) {
      map['numero_tva'] = Variable<String>(numeroTva.value);
    }
    if (rccm.present) {
      map['rccm'] = Variable<String>(rccm.value);
    }
    if (nif.present) {
      map['nif'] = Variable<String>(nif.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalFacture.present) {
      map['total_facture'] = Variable<double>(totalFacture.value);
    }
    if (totalPaye.present) {
      map['total_paye'] = Variable<double>(totalPaye.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('typeClient: $typeClient, ')
          ..write('nom: $nom, ')
          ..write('contactNom: $contactNom, ')
          ..write('email: $email, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('ville: $ville, ')
          ..write('pays: $pays, ')
          ..write('numeroTva: $numeroTva, ')
          ..write('rccm: $rccm, ')
          ..write('nif: $nif, ')
          ..write('notes: $notes, ')
          ..write('totalFacture: $totalFacture, ')
          ..write('totalPaye: $totalPaye, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientContactsTable extends ClientContacts
    with TableInfo<$ClientContactsTable, ClientContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fonctionMeta =
      const VerificationMeta('fonction');
  @override
  late final GeneratedColumn<String> fonction = GeneratedColumn<String>(
      'fonction', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clientId,
        nom,
        fonction,
        telephone,
        email,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_contacts';
  @override
  VerificationContext validateIntegrity(Insertable<ClientContact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('fonction')) {
      context.handle(_fonctionMeta,
          fonction.isAcceptableOrUnknown(data['fonction']!, _fonctionMeta));
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientContact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      fonction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fonction']),
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ClientContactsTable createAlias(String alias) {
    return $ClientContactsTable(attachedDatabase, alias);
  }
}

class ClientContact extends DataClass implements Insertable<ClientContact> {
  final String id;
  final String clientId;
  final String nom;
  final String? fonction;
  final String? telephone;
  final String? email;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ClientContact(
      {required this.id,
      required this.clientId,
      required this.nom,
      this.fonction,
      this.telephone,
      this.email,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || fonction != null) {
      map['fonction'] = Variable<String>(fonction);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientContactsCompanion toCompanion(bool nullToAbsent) {
    return ClientContactsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      nom: Value(nom),
      fonction: fonction == null && nullToAbsent
          ? const Value.absent()
          : Value(fonction),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClientContact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientContact(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      nom: serializer.fromJson<String>(json['nom']),
      fonction: serializer.fromJson<String?>(json['fonction']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      email: serializer.fromJson<String?>(json['email']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'nom': serializer.toJson<String>(nom),
      'fonction': serializer.toJson<String?>(fonction),
      'telephone': serializer.toJson<String?>(telephone),
      'email': serializer.toJson<String?>(email),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClientContact copyWith(
          {String? id,
          String? clientId,
          String? nom,
          Value<String?> fonction = const Value.absent(),
          Value<String?> telephone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ClientContact(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        nom: nom ?? this.nom,
        fonction: fonction.present ? fonction.value : this.fonction,
        telephone: telephone.present ? telephone.value : this.telephone,
        email: email.present ? email.value : this.email,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ClientContact copyWithCompanion(ClientContactsCompanion data) {
    return ClientContact(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      nom: data.nom.present ? data.nom.value : this.nom,
      fonction: data.fonction.present ? data.fonction.value : this.fonction,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      email: data.email.present ? data.email.value : this.email,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientContact(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('nom: $nom, ')
          ..write('fonction: $fonction, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, nom, fonction, telephone, email,
      syncStatus, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientContact &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.nom == this.nom &&
          other.fonction == this.fonction &&
          other.telephone == this.telephone &&
          other.email == this.email &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClientContactsCompanion extends UpdateCompanion<ClientContact> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> nom;
  final Value<String?> fonction;
  final Value<String?> telephone;
  final Value<String?> email;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClientContactsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.nom = const Value.absent(),
    this.fonction = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientContactsCompanion.insert({
    required String id,
    required String clientId,
    required String nom,
    this.fonction = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        clientId = Value(clientId),
        nom = Value(nom);
  static Insertable<ClientContact> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? nom,
    Expression<String>? fonction,
    Expression<String>? telephone,
    Expression<String>? email,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (nom != null) 'nom': nom,
      if (fonction != null) 'fonction': fonction,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientContactsCompanion copyWith(
      {Value<String>? id,
      Value<String>? clientId,
      Value<String>? nom,
      Value<String?>? fonction,
      Value<String?>? telephone,
      Value<String?>? email,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ClientContactsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      nom: nom ?? this.nom,
      fonction: fonction ?? this.fonction,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (fonction.present) {
      map['fonction'] = Variable<String>(fonction.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientContactsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('nom: $nom, ')
          ..write('fonction: $fonction, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DossiersTable extends Dossiers with TableInfo<$DossiersTable, Dossier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DossiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expertIdMeta =
      const VerificationMeta('expertId');
  @override
  late final GeneratedColumn<String> expertId = GeneratedColumn<String>(
      'expert_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMissionIdMeta =
      const VerificationMeta('typeMissionId');
  @override
  late final GeneratedColumn<String> typeMissionId = GeneratedColumn<String>(
      'type_mission_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
      'titre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateSinistreMeta =
      const VerificationMeta('dateSinistre');
  @override
  late final GeneratedColumn<DateTime> dateSinistre = GeneratedColumn<DateTime>(
      'date_sinistre', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lieuSinistreMeta =
      const VerificationMeta('lieuSinistre');
  @override
  late final GeneratedColumn<String> lieuSinistre = GeneratedColumn<String>(
      'lieu_sinistre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _natureSinistreMeta =
      const VerificationMeta('natureSinistre');
  @override
  late final GeneratedColumn<String> natureSinistre = GeneratedColumn<String>(
      'nature_sinistre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _montantSinistreMeta =
      const VerificationMeta('montantSinistre');
  @override
  late final GeneratedColumn<double> montantSinistre = GeneratedColumn<double>(
      'montant_sinistre', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('nouveau'));
  static const VerificationMeta _prioriteMeta =
      const VerificationMeta('priorite');
  @override
  late final GeneratedColumn<String> priorite = GeneratedColumn<String>(
      'priorite', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normale'));
  static const VerificationMeta _dateOuvertureMeta =
      const VerificationMeta('dateOuverture');
  @override
  late final GeneratedColumn<DateTime> dateOuverture =
      GeneratedColumn<DateTime>('date_ouverture', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _dateExpertiseMeta =
      const VerificationMeta('dateExpertise');
  @override
  late final GeneratedColumn<DateTime> dateExpertise =
      GeneratedColumn<DateTime>('date_expertise', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateRapportMeta =
      const VerificationMeta('dateRapport');
  @override
  late final GeneratedColumn<DateTime> dateRapport = GeneratedColumn<DateTime>(
      'date_rapport', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateClotureMeta =
      const VerificationMeta('dateCloture');
  @override
  late final GeneratedColumn<DateTime> dateCloture = GeneratedColumn<DateTime>(
      'date_cloture', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _compagnieAssuranceMeta =
      const VerificationMeta('compagnieAssurance');
  @override
  late final GeneratedColumn<String> compagnieAssurance =
      GeneratedColumn<String>('compagnie_assurance', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroPoliceMeta =
      const VerificationMeta('numeroPolice');
  @override
  late final GeneratedColumn<String> numeroPolice = GeneratedColumn<String>(
      'numero_police', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _courtierMeta =
      const VerificationMeta('courtier');
  @override
  late final GeneratedColumn<String> courtier = GeneratedColumn<String>(
      'courtier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesInternesMeta =
      const VerificationMeta('notesInternes');
  @override
  late final GeneratedColumn<String> notesInternes = GeneratedColumn<String>(
      'notes_internes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observationsMeta =
      const VerificationMeta('observations');
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
      'observations', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motifAnnulationMeta =
      const VerificationMeta('motifAnnulation');
  @override
  late final GeneratedColumn<String> motifAnnulation = GeneratedColumn<String>(
      'motif_annulation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        clientId,
        expertId,
        typeMissionId,
        numero,
        annee,
        titre,
        description,
        dateSinistre,
        lieuSinistre,
        natureSinistre,
        montantSinistre,
        statut,
        priorite,
        dateOuverture,
        dateExpertise,
        dateRapport,
        dateCloture,
        deadline,
        compagnieAssurance,
        numeroPolice,
        courtier,
        notesInternes,
        observations,
        motifAnnulation,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dossiers';
  @override
  VerificationContext validateIntegrity(Insertable<Dossier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    }
    if (data.containsKey('expert_id')) {
      context.handle(_expertIdMeta,
          expertId.isAcceptableOrUnknown(data['expert_id']!, _expertIdMeta));
    }
    if (data.containsKey('type_mission_id')) {
      context.handle(
          _typeMissionIdMeta,
          typeMissionId.isAcceptableOrUnknown(
              data['type_mission_id']!, _typeMissionIdMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('titre')) {
      context.handle(
          _titreMeta, titre.isAcceptableOrUnknown(data['titre']!, _titreMeta));
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date_sinistre')) {
      context.handle(
          _dateSinistreMeta,
          dateSinistre.isAcceptableOrUnknown(
              data['date_sinistre']!, _dateSinistreMeta));
    }
    if (data.containsKey('lieu_sinistre')) {
      context.handle(
          _lieuSinistreMeta,
          lieuSinistre.isAcceptableOrUnknown(
              data['lieu_sinistre']!, _lieuSinistreMeta));
    }
    if (data.containsKey('nature_sinistre')) {
      context.handle(
          _natureSinistreMeta,
          natureSinistre.isAcceptableOrUnknown(
              data['nature_sinistre']!, _natureSinistreMeta));
    }
    if (data.containsKey('montant_sinistre')) {
      context.handle(
          _montantSinistreMeta,
          montantSinistre.isAcceptableOrUnknown(
              data['montant_sinistre']!, _montantSinistreMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('priorite')) {
      context.handle(_prioriteMeta,
          priorite.isAcceptableOrUnknown(data['priorite']!, _prioriteMeta));
    }
    if (data.containsKey('date_ouverture')) {
      context.handle(
          _dateOuvertureMeta,
          dateOuverture.isAcceptableOrUnknown(
              data['date_ouverture']!, _dateOuvertureMeta));
    }
    if (data.containsKey('date_expertise')) {
      context.handle(
          _dateExpertiseMeta,
          dateExpertise.isAcceptableOrUnknown(
              data['date_expertise']!, _dateExpertiseMeta));
    }
    if (data.containsKey('date_rapport')) {
      context.handle(
          _dateRapportMeta,
          dateRapport.isAcceptableOrUnknown(
              data['date_rapport']!, _dateRapportMeta));
    }
    if (data.containsKey('date_cloture')) {
      context.handle(
          _dateClotureMeta,
          dateCloture.isAcceptableOrUnknown(
              data['date_cloture']!, _dateClotureMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('compagnie_assurance')) {
      context.handle(
          _compagnieAssuranceMeta,
          compagnieAssurance.isAcceptableOrUnknown(
              data['compagnie_assurance']!, _compagnieAssuranceMeta));
    }
    if (data.containsKey('numero_police')) {
      context.handle(
          _numeroPoliceMeta,
          numeroPolice.isAcceptableOrUnknown(
              data['numero_police']!, _numeroPoliceMeta));
    }
    if (data.containsKey('courtier')) {
      context.handle(_courtierMeta,
          courtier.isAcceptableOrUnknown(data['courtier']!, _courtierMeta));
    }
    if (data.containsKey('notes_internes')) {
      context.handle(
          _notesInternesMeta,
          notesInternes.isAcceptableOrUnknown(
              data['notes_internes']!, _notesInternesMeta));
    }
    if (data.containsKey('observations')) {
      context.handle(
          _observationsMeta,
          observations.isAcceptableOrUnknown(
              data['observations']!, _observationsMeta));
    }
    if (data.containsKey('motif_annulation')) {
      context.handle(
          _motifAnnulationMeta,
          motifAnnulation.isAcceptableOrUnknown(
              data['motif_annulation']!, _motifAnnulationMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dossier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dossier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id']),
      expertId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expert_id']),
      typeMissionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_mission_id']),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero']),
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      titre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titre'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dateSinistre: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_sinistre']),
      lieuSinistre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lieu_sinistre']),
      natureSinistre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nature_sinistre']),
      montantSinistre: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}montant_sinistre']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      priorite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priorite'])!,
      dateOuverture: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_ouverture'])!,
      dateExpertise: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_expertise']),
      dateRapport: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_rapport']),
      dateCloture: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_cloture']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      compagnieAssurance: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}compagnie_assurance']),
      numeroPolice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_police']),
      courtier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}courtier']),
      notesInternes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes_internes']),
      observations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observations']),
      motifAnnulation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}motif_annulation']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DossiersTable createAlias(String alias) {
    return $DossiersTable(attachedDatabase, alias);
  }
}

class Dossier extends DataClass implements Insertable<Dossier> {
  final String id;
  final String entrepriseId;
  final String? clientId;
  final String? expertId;
  final String? typeMissionId;
  final String? numero;
  final int annee;
  final String titre;
  final String? description;
  final DateTime? dateSinistre;
  final String? lieuSinistre;
  final String? natureSinistre;
  final double? montantSinistre;
  final String statut;
  final String priorite;
  final DateTime dateOuverture;
  final DateTime? dateExpertise;
  final DateTime? dateRapport;
  final DateTime? dateCloture;
  final DateTime? deadline;
  final String? compagnieAssurance;
  final String? numeroPolice;
  final String? courtier;
  final String? notesInternes;
  final String? observations;
  final String? motifAnnulation;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Dossier(
      {required this.id,
      required this.entrepriseId,
      this.clientId,
      this.expertId,
      this.typeMissionId,
      this.numero,
      required this.annee,
      required this.titre,
      this.description,
      this.dateSinistre,
      this.lieuSinistre,
      this.natureSinistre,
      this.montantSinistre,
      required this.statut,
      required this.priorite,
      required this.dateOuverture,
      this.dateExpertise,
      this.dateRapport,
      this.dateCloture,
      this.deadline,
      this.compagnieAssurance,
      this.numeroPolice,
      this.courtier,
      this.notesInternes,
      this.observations,
      this.motifAnnulation,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || expertId != null) {
      map['expert_id'] = Variable<String>(expertId);
    }
    if (!nullToAbsent || typeMissionId != null) {
      map['type_mission_id'] = Variable<String>(typeMissionId);
    }
    if (!nullToAbsent || numero != null) {
      map['numero'] = Variable<String>(numero);
    }
    map['annee'] = Variable<int>(annee);
    map['titre'] = Variable<String>(titre);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dateSinistre != null) {
      map['date_sinistre'] = Variable<DateTime>(dateSinistre);
    }
    if (!nullToAbsent || lieuSinistre != null) {
      map['lieu_sinistre'] = Variable<String>(lieuSinistre);
    }
    if (!nullToAbsent || natureSinistre != null) {
      map['nature_sinistre'] = Variable<String>(natureSinistre);
    }
    if (!nullToAbsent || montantSinistre != null) {
      map['montant_sinistre'] = Variable<double>(montantSinistre);
    }
    map['statut'] = Variable<String>(statut);
    map['priorite'] = Variable<String>(priorite);
    map['date_ouverture'] = Variable<DateTime>(dateOuverture);
    if (!nullToAbsent || dateExpertise != null) {
      map['date_expertise'] = Variable<DateTime>(dateExpertise);
    }
    if (!nullToAbsent || dateRapport != null) {
      map['date_rapport'] = Variable<DateTime>(dateRapport);
    }
    if (!nullToAbsent || dateCloture != null) {
      map['date_cloture'] = Variable<DateTime>(dateCloture);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    if (!nullToAbsent || compagnieAssurance != null) {
      map['compagnie_assurance'] = Variable<String>(compagnieAssurance);
    }
    if (!nullToAbsent || numeroPolice != null) {
      map['numero_police'] = Variable<String>(numeroPolice);
    }
    if (!nullToAbsent || courtier != null) {
      map['courtier'] = Variable<String>(courtier);
    }
    if (!nullToAbsent || notesInternes != null) {
      map['notes_internes'] = Variable<String>(notesInternes);
    }
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    if (!nullToAbsent || motifAnnulation != null) {
      map['motif_annulation'] = Variable<String>(motifAnnulation);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DossiersCompanion toCompanion(bool nullToAbsent) {
    return DossiersCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      expertId: expertId == null && nullToAbsent
          ? const Value.absent()
          : Value(expertId),
      typeMissionId: typeMissionId == null && nullToAbsent
          ? const Value.absent()
          : Value(typeMissionId),
      numero:
          numero == null && nullToAbsent ? const Value.absent() : Value(numero),
      annee: Value(annee),
      titre: Value(titre),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dateSinistre: dateSinistre == null && nullToAbsent
          ? const Value.absent()
          : Value(dateSinistre),
      lieuSinistre: lieuSinistre == null && nullToAbsent
          ? const Value.absent()
          : Value(lieuSinistre),
      natureSinistre: natureSinistre == null && nullToAbsent
          ? const Value.absent()
          : Value(natureSinistre),
      montantSinistre: montantSinistre == null && nullToAbsent
          ? const Value.absent()
          : Value(montantSinistre),
      statut: Value(statut),
      priorite: Value(priorite),
      dateOuverture: Value(dateOuverture),
      dateExpertise: dateExpertise == null && nullToAbsent
          ? const Value.absent()
          : Value(dateExpertise),
      dateRapport: dateRapport == null && nullToAbsent
          ? const Value.absent()
          : Value(dateRapport),
      dateCloture: dateCloture == null && nullToAbsent
          ? const Value.absent()
          : Value(dateCloture),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      compagnieAssurance: compagnieAssurance == null && nullToAbsent
          ? const Value.absent()
          : Value(compagnieAssurance),
      numeroPolice: numeroPolice == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroPolice),
      courtier: courtier == null && nullToAbsent
          ? const Value.absent()
          : Value(courtier),
      notesInternes: notesInternes == null && nullToAbsent
          ? const Value.absent()
          : Value(notesInternes),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      motifAnnulation: motifAnnulation == null && nullToAbsent
          ? const Value.absent()
          : Value(motifAnnulation),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Dossier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dossier(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      expertId: serializer.fromJson<String?>(json['expertId']),
      typeMissionId: serializer.fromJson<String?>(json['typeMissionId']),
      numero: serializer.fromJson<String?>(json['numero']),
      annee: serializer.fromJson<int>(json['annee']),
      titre: serializer.fromJson<String>(json['titre']),
      description: serializer.fromJson<String?>(json['description']),
      dateSinistre: serializer.fromJson<DateTime?>(json['dateSinistre']),
      lieuSinistre: serializer.fromJson<String?>(json['lieuSinistre']),
      natureSinistre: serializer.fromJson<String?>(json['natureSinistre']),
      montantSinistre: serializer.fromJson<double?>(json['montantSinistre']),
      statut: serializer.fromJson<String>(json['statut']),
      priorite: serializer.fromJson<String>(json['priorite']),
      dateOuverture: serializer.fromJson<DateTime>(json['dateOuverture']),
      dateExpertise: serializer.fromJson<DateTime?>(json['dateExpertise']),
      dateRapport: serializer.fromJson<DateTime?>(json['dateRapport']),
      dateCloture: serializer.fromJson<DateTime?>(json['dateCloture']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      compagnieAssurance:
          serializer.fromJson<String?>(json['compagnieAssurance']),
      numeroPolice: serializer.fromJson<String?>(json['numeroPolice']),
      courtier: serializer.fromJson<String?>(json['courtier']),
      notesInternes: serializer.fromJson<String?>(json['notesInternes']),
      observations: serializer.fromJson<String?>(json['observations']),
      motifAnnulation: serializer.fromJson<String?>(json['motifAnnulation']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'clientId': serializer.toJson<String?>(clientId),
      'expertId': serializer.toJson<String?>(expertId),
      'typeMissionId': serializer.toJson<String?>(typeMissionId),
      'numero': serializer.toJson<String?>(numero),
      'annee': serializer.toJson<int>(annee),
      'titre': serializer.toJson<String>(titre),
      'description': serializer.toJson<String?>(description),
      'dateSinistre': serializer.toJson<DateTime?>(dateSinistre),
      'lieuSinistre': serializer.toJson<String?>(lieuSinistre),
      'natureSinistre': serializer.toJson<String?>(natureSinistre),
      'montantSinistre': serializer.toJson<double?>(montantSinistre),
      'statut': serializer.toJson<String>(statut),
      'priorite': serializer.toJson<String>(priorite),
      'dateOuverture': serializer.toJson<DateTime>(dateOuverture),
      'dateExpertise': serializer.toJson<DateTime?>(dateExpertise),
      'dateRapport': serializer.toJson<DateTime?>(dateRapport),
      'dateCloture': serializer.toJson<DateTime?>(dateCloture),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'compagnieAssurance': serializer.toJson<String?>(compagnieAssurance),
      'numeroPolice': serializer.toJson<String?>(numeroPolice),
      'courtier': serializer.toJson<String?>(courtier),
      'notesInternes': serializer.toJson<String?>(notesInternes),
      'observations': serializer.toJson<String?>(observations),
      'motifAnnulation': serializer.toJson<String?>(motifAnnulation),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Dossier copyWith(
          {String? id,
          String? entrepriseId,
          Value<String?> clientId = const Value.absent(),
          Value<String?> expertId = const Value.absent(),
          Value<String?> typeMissionId = const Value.absent(),
          Value<String?> numero = const Value.absent(),
          int? annee,
          String? titre,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> dateSinistre = const Value.absent(),
          Value<String?> lieuSinistre = const Value.absent(),
          Value<String?> natureSinistre = const Value.absent(),
          Value<double?> montantSinistre = const Value.absent(),
          String? statut,
          String? priorite,
          DateTime? dateOuverture,
          Value<DateTime?> dateExpertise = const Value.absent(),
          Value<DateTime?> dateRapport = const Value.absent(),
          Value<DateTime?> dateCloture = const Value.absent(),
          Value<DateTime?> deadline = const Value.absent(),
          Value<String?> compagnieAssurance = const Value.absent(),
          Value<String?> numeroPolice = const Value.absent(),
          Value<String?> courtier = const Value.absent(),
          Value<String?> notesInternes = const Value.absent(),
          Value<String?> observations = const Value.absent(),
          Value<String?> motifAnnulation = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Dossier(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        clientId: clientId.present ? clientId.value : this.clientId,
        expertId: expertId.present ? expertId.value : this.expertId,
        typeMissionId:
            typeMissionId.present ? typeMissionId.value : this.typeMissionId,
        numero: numero.present ? numero.value : this.numero,
        annee: annee ?? this.annee,
        titre: titre ?? this.titre,
        description: description.present ? description.value : this.description,
        dateSinistre:
            dateSinistre.present ? dateSinistre.value : this.dateSinistre,
        lieuSinistre:
            lieuSinistre.present ? lieuSinistre.value : this.lieuSinistre,
        natureSinistre:
            natureSinistre.present ? natureSinistre.value : this.natureSinistre,
        montantSinistre: montantSinistre.present
            ? montantSinistre.value
            : this.montantSinistre,
        statut: statut ?? this.statut,
        priorite: priorite ?? this.priorite,
        dateOuverture: dateOuverture ?? this.dateOuverture,
        dateExpertise:
            dateExpertise.present ? dateExpertise.value : this.dateExpertise,
        dateRapport: dateRapport.present ? dateRapport.value : this.dateRapport,
        dateCloture: dateCloture.present ? dateCloture.value : this.dateCloture,
        deadline: deadline.present ? deadline.value : this.deadline,
        compagnieAssurance: compagnieAssurance.present
            ? compagnieAssurance.value
            : this.compagnieAssurance,
        numeroPolice:
            numeroPolice.present ? numeroPolice.value : this.numeroPolice,
        courtier: courtier.present ? courtier.value : this.courtier,
        notesInternes:
            notesInternes.present ? notesInternes.value : this.notesInternes,
        observations:
            observations.present ? observations.value : this.observations,
        motifAnnulation: motifAnnulation.present
            ? motifAnnulation.value
            : this.motifAnnulation,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Dossier copyWithCompanion(DossiersCompanion data) {
    return Dossier(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      expertId: data.expertId.present ? data.expertId.value : this.expertId,
      typeMissionId: data.typeMissionId.present
          ? data.typeMissionId.value
          : this.typeMissionId,
      numero: data.numero.present ? data.numero.value : this.numero,
      annee: data.annee.present ? data.annee.value : this.annee,
      titre: data.titre.present ? data.titre.value : this.titre,
      description:
          data.description.present ? data.description.value : this.description,
      dateSinistre: data.dateSinistre.present
          ? data.dateSinistre.value
          : this.dateSinistre,
      lieuSinistre: data.lieuSinistre.present
          ? data.lieuSinistre.value
          : this.lieuSinistre,
      natureSinistre: data.natureSinistre.present
          ? data.natureSinistre.value
          : this.natureSinistre,
      montantSinistre: data.montantSinistre.present
          ? data.montantSinistre.value
          : this.montantSinistre,
      statut: data.statut.present ? data.statut.value : this.statut,
      priorite: data.priorite.present ? data.priorite.value : this.priorite,
      dateOuverture: data.dateOuverture.present
          ? data.dateOuverture.value
          : this.dateOuverture,
      dateExpertise: data.dateExpertise.present
          ? data.dateExpertise.value
          : this.dateExpertise,
      dateRapport:
          data.dateRapport.present ? data.dateRapport.value : this.dateRapport,
      dateCloture:
          data.dateCloture.present ? data.dateCloture.value : this.dateCloture,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      compagnieAssurance: data.compagnieAssurance.present
          ? data.compagnieAssurance.value
          : this.compagnieAssurance,
      numeroPolice: data.numeroPolice.present
          ? data.numeroPolice.value
          : this.numeroPolice,
      courtier: data.courtier.present ? data.courtier.value : this.courtier,
      notesInternes: data.notesInternes.present
          ? data.notesInternes.value
          : this.notesInternes,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      motifAnnulation: data.motifAnnulation.present
          ? data.motifAnnulation.value
          : this.motifAnnulation,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dossier(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('clientId: $clientId, ')
          ..write('expertId: $expertId, ')
          ..write('typeMissionId: $typeMissionId, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('titre: $titre, ')
          ..write('description: $description, ')
          ..write('dateSinistre: $dateSinistre, ')
          ..write('lieuSinistre: $lieuSinistre, ')
          ..write('natureSinistre: $natureSinistre, ')
          ..write('montantSinistre: $montantSinistre, ')
          ..write('statut: $statut, ')
          ..write('priorite: $priorite, ')
          ..write('dateOuverture: $dateOuverture, ')
          ..write('dateExpertise: $dateExpertise, ')
          ..write('dateRapport: $dateRapport, ')
          ..write('dateCloture: $dateCloture, ')
          ..write('deadline: $deadline, ')
          ..write('compagnieAssurance: $compagnieAssurance, ')
          ..write('numeroPolice: $numeroPolice, ')
          ..write('courtier: $courtier, ')
          ..write('notesInternes: $notesInternes, ')
          ..write('observations: $observations, ')
          ..write('motifAnnulation: $motifAnnulation, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        entrepriseId,
        clientId,
        expertId,
        typeMissionId,
        numero,
        annee,
        titre,
        description,
        dateSinistre,
        lieuSinistre,
        natureSinistre,
        montantSinistre,
        statut,
        priorite,
        dateOuverture,
        dateExpertise,
        dateRapport,
        dateCloture,
        deadline,
        compagnieAssurance,
        numeroPolice,
        courtier,
        notesInternes,
        observations,
        motifAnnulation,
        syncStatus,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dossier &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.clientId == this.clientId &&
          other.expertId == this.expertId &&
          other.typeMissionId == this.typeMissionId &&
          other.numero == this.numero &&
          other.annee == this.annee &&
          other.titre == this.titre &&
          other.description == this.description &&
          other.dateSinistre == this.dateSinistre &&
          other.lieuSinistre == this.lieuSinistre &&
          other.natureSinistre == this.natureSinistre &&
          other.montantSinistre == this.montantSinistre &&
          other.statut == this.statut &&
          other.priorite == this.priorite &&
          other.dateOuverture == this.dateOuverture &&
          other.dateExpertise == this.dateExpertise &&
          other.dateRapport == this.dateRapport &&
          other.dateCloture == this.dateCloture &&
          other.deadline == this.deadline &&
          other.compagnieAssurance == this.compagnieAssurance &&
          other.numeroPolice == this.numeroPolice &&
          other.courtier == this.courtier &&
          other.notesInternes == this.notesInternes &&
          other.observations == this.observations &&
          other.motifAnnulation == this.motifAnnulation &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DossiersCompanion extends UpdateCompanion<Dossier> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String?> clientId;
  final Value<String?> expertId;
  final Value<String?> typeMissionId;
  final Value<String?> numero;
  final Value<int> annee;
  final Value<String> titre;
  final Value<String?> description;
  final Value<DateTime?> dateSinistre;
  final Value<String?> lieuSinistre;
  final Value<String?> natureSinistre;
  final Value<double?> montantSinistre;
  final Value<String> statut;
  final Value<String> priorite;
  final Value<DateTime> dateOuverture;
  final Value<DateTime?> dateExpertise;
  final Value<DateTime?> dateRapport;
  final Value<DateTime?> dateCloture;
  final Value<DateTime?> deadline;
  final Value<String?> compagnieAssurance;
  final Value<String?> numeroPolice;
  final Value<String?> courtier;
  final Value<String?> notesInternes;
  final Value<String?> observations;
  final Value<String?> motifAnnulation;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DossiersCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.expertId = const Value.absent(),
    this.typeMissionId = const Value.absent(),
    this.numero = const Value.absent(),
    this.annee = const Value.absent(),
    this.titre = const Value.absent(),
    this.description = const Value.absent(),
    this.dateSinistre = const Value.absent(),
    this.lieuSinistre = const Value.absent(),
    this.natureSinistre = const Value.absent(),
    this.montantSinistre = const Value.absent(),
    this.statut = const Value.absent(),
    this.priorite = const Value.absent(),
    this.dateOuverture = const Value.absent(),
    this.dateExpertise = const Value.absent(),
    this.dateRapport = const Value.absent(),
    this.dateCloture = const Value.absent(),
    this.deadline = const Value.absent(),
    this.compagnieAssurance = const Value.absent(),
    this.numeroPolice = const Value.absent(),
    this.courtier = const Value.absent(),
    this.notesInternes = const Value.absent(),
    this.observations = const Value.absent(),
    this.motifAnnulation = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DossiersCompanion.insert({
    required String id,
    required String entrepriseId,
    this.clientId = const Value.absent(),
    this.expertId = const Value.absent(),
    this.typeMissionId = const Value.absent(),
    this.numero = const Value.absent(),
    required int annee,
    required String titre,
    this.description = const Value.absent(),
    this.dateSinistre = const Value.absent(),
    this.lieuSinistre = const Value.absent(),
    this.natureSinistre = const Value.absent(),
    this.montantSinistre = const Value.absent(),
    this.statut = const Value.absent(),
    this.priorite = const Value.absent(),
    this.dateOuverture = const Value.absent(),
    this.dateExpertise = const Value.absent(),
    this.dateRapport = const Value.absent(),
    this.dateCloture = const Value.absent(),
    this.deadline = const Value.absent(),
    this.compagnieAssurance = const Value.absent(),
    this.numeroPolice = const Value.absent(),
    this.courtier = const Value.absent(),
    this.notesInternes = const Value.absent(),
    this.observations = const Value.absent(),
    this.motifAnnulation = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        annee = Value(annee),
        titre = Value(titre);
  static Insertable<Dossier> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? clientId,
    Expression<String>? expertId,
    Expression<String>? typeMissionId,
    Expression<String>? numero,
    Expression<int>? annee,
    Expression<String>? titre,
    Expression<String>? description,
    Expression<DateTime>? dateSinistre,
    Expression<String>? lieuSinistre,
    Expression<String>? natureSinistre,
    Expression<double>? montantSinistre,
    Expression<String>? statut,
    Expression<String>? priorite,
    Expression<DateTime>? dateOuverture,
    Expression<DateTime>? dateExpertise,
    Expression<DateTime>? dateRapport,
    Expression<DateTime>? dateCloture,
    Expression<DateTime>? deadline,
    Expression<String>? compagnieAssurance,
    Expression<String>? numeroPolice,
    Expression<String>? courtier,
    Expression<String>? notesInternes,
    Expression<String>? observations,
    Expression<String>? motifAnnulation,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (clientId != null) 'client_id': clientId,
      if (expertId != null) 'expert_id': expertId,
      if (typeMissionId != null) 'type_mission_id': typeMissionId,
      if (numero != null) 'numero': numero,
      if (annee != null) 'annee': annee,
      if (titre != null) 'titre': titre,
      if (description != null) 'description': description,
      if (dateSinistre != null) 'date_sinistre': dateSinistre,
      if (lieuSinistre != null) 'lieu_sinistre': lieuSinistre,
      if (natureSinistre != null) 'nature_sinistre': natureSinistre,
      if (montantSinistre != null) 'montant_sinistre': montantSinistre,
      if (statut != null) 'statut': statut,
      if (priorite != null) 'priorite': priorite,
      if (dateOuverture != null) 'date_ouverture': dateOuverture,
      if (dateExpertise != null) 'date_expertise': dateExpertise,
      if (dateRapport != null) 'date_rapport': dateRapport,
      if (dateCloture != null) 'date_cloture': dateCloture,
      if (deadline != null) 'deadline': deadline,
      if (compagnieAssurance != null) 'compagnie_assurance': compagnieAssurance,
      if (numeroPolice != null) 'numero_police': numeroPolice,
      if (courtier != null) 'courtier': courtier,
      if (notesInternes != null) 'notes_internes': notesInternes,
      if (observations != null) 'observations': observations,
      if (motifAnnulation != null) 'motif_annulation': motifAnnulation,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DossiersCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String?>? clientId,
      Value<String?>? expertId,
      Value<String?>? typeMissionId,
      Value<String?>? numero,
      Value<int>? annee,
      Value<String>? titre,
      Value<String?>? description,
      Value<DateTime?>? dateSinistre,
      Value<String?>? lieuSinistre,
      Value<String?>? natureSinistre,
      Value<double?>? montantSinistre,
      Value<String>? statut,
      Value<String>? priorite,
      Value<DateTime>? dateOuverture,
      Value<DateTime?>? dateExpertise,
      Value<DateTime?>? dateRapport,
      Value<DateTime?>? dateCloture,
      Value<DateTime?>? deadline,
      Value<String?>? compagnieAssurance,
      Value<String?>? numeroPolice,
      Value<String?>? courtier,
      Value<String?>? notesInternes,
      Value<String?>? observations,
      Value<String?>? motifAnnulation,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DossiersCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      clientId: clientId ?? this.clientId,
      expertId: expertId ?? this.expertId,
      typeMissionId: typeMissionId ?? this.typeMissionId,
      numero: numero ?? this.numero,
      annee: annee ?? this.annee,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      dateSinistre: dateSinistre ?? this.dateSinistre,
      lieuSinistre: lieuSinistre ?? this.lieuSinistre,
      natureSinistre: natureSinistre ?? this.natureSinistre,
      montantSinistre: montantSinistre ?? this.montantSinistre,
      statut: statut ?? this.statut,
      priorite: priorite ?? this.priorite,
      dateOuverture: dateOuverture ?? this.dateOuverture,
      dateExpertise: dateExpertise ?? this.dateExpertise,
      dateRapport: dateRapport ?? this.dateRapport,
      dateCloture: dateCloture ?? this.dateCloture,
      deadline: deadline ?? this.deadline,
      compagnieAssurance: compagnieAssurance ?? this.compagnieAssurance,
      numeroPolice: numeroPolice ?? this.numeroPolice,
      courtier: courtier ?? this.courtier,
      notesInternes: notesInternes ?? this.notesInternes,
      observations: observations ?? this.observations,
      motifAnnulation: motifAnnulation ?? this.motifAnnulation,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (expertId.present) {
      map['expert_id'] = Variable<String>(expertId.value);
    }
    if (typeMissionId.present) {
      map['type_mission_id'] = Variable<String>(typeMissionId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dateSinistre.present) {
      map['date_sinistre'] = Variable<DateTime>(dateSinistre.value);
    }
    if (lieuSinistre.present) {
      map['lieu_sinistre'] = Variable<String>(lieuSinistre.value);
    }
    if (natureSinistre.present) {
      map['nature_sinistre'] = Variable<String>(natureSinistre.value);
    }
    if (montantSinistre.present) {
      map['montant_sinistre'] = Variable<double>(montantSinistre.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (priorite.present) {
      map['priorite'] = Variable<String>(priorite.value);
    }
    if (dateOuverture.present) {
      map['date_ouverture'] = Variable<DateTime>(dateOuverture.value);
    }
    if (dateExpertise.present) {
      map['date_expertise'] = Variable<DateTime>(dateExpertise.value);
    }
    if (dateRapport.present) {
      map['date_rapport'] = Variable<DateTime>(dateRapport.value);
    }
    if (dateCloture.present) {
      map['date_cloture'] = Variable<DateTime>(dateCloture.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (compagnieAssurance.present) {
      map['compagnie_assurance'] = Variable<String>(compagnieAssurance.value);
    }
    if (numeroPolice.present) {
      map['numero_police'] = Variable<String>(numeroPolice.value);
    }
    if (courtier.present) {
      map['courtier'] = Variable<String>(courtier.value);
    }
    if (notesInternes.present) {
      map['notes_internes'] = Variable<String>(notesInternes.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (motifAnnulation.present) {
      map['motif_annulation'] = Variable<String>(motifAnnulation.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DossiersCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('clientId: $clientId, ')
          ..write('expertId: $expertId, ')
          ..write('typeMissionId: $typeMissionId, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('titre: $titre, ')
          ..write('description: $description, ')
          ..write('dateSinistre: $dateSinistre, ')
          ..write('lieuSinistre: $lieuSinistre, ')
          ..write('natureSinistre: $natureSinistre, ')
          ..write('montantSinistre: $montantSinistre, ')
          ..write('statut: $statut, ')
          ..write('priorite: $priorite, ')
          ..write('dateOuverture: $dateOuverture, ')
          ..write('dateExpertise: $dateExpertise, ')
          ..write('dateRapport: $dateRapport, ')
          ..write('dateCloture: $dateCloture, ')
          ..write('deadline: $deadline, ')
          ..write('compagnieAssurance: $compagnieAssurance, ')
          ..write('numeroPolice: $numeroPolice, ')
          ..write('courtier: $courtier, ')
          ..write('notesInternes: $notesInternes, ')
          ..write('observations: $observations, ')
          ..write('motifAnnulation: $motifAnnulation, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevisTable extends Devis with TableInfo<$DevisTable, Devi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dossierIdMeta =
      const VerificationMeta('dossierId');
  @override
  late final GeneratedColumn<String> dossierId = GeneratedColumn<String>(
      'dossier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creeParMeta =
      const VerificationMeta('creePar');
  @override
  late final GeneratedColumn<String> creePar = GeneratedColumn<String>(
      'cree_par', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('brouillon'));
  static const VerificationMeta _dateEmissionMeta =
      const VerificationMeta('dateEmission');
  @override
  late final GeneratedColumn<DateTime> dateEmission = GeneratedColumn<DateTime>(
      'date_emission', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateValiditeMeta =
      const VerificationMeta('dateValidite');
  @override
  late final GeneratedColumn<DateTime> dateValidite = GeneratedColumn<DateTime>(
      'date_validite', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _montantHtMeta =
      const VerificationMeta('montantHt');
  @override
  late final GeneratedColumn<double> montantHt = GeneratedColumn<double>(
      'montant_ht', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tauxTvaMeta =
      const VerificationMeta('tauxTva');
  @override
  late final GeneratedColumn<double> tauxTva = GeneratedColumn<double>(
      'taux_tva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(18.0));
  static const VerificationMeta _montantTvaMeta =
      const VerificationMeta('montantTva');
  @override
  late final GeneratedColumn<double> montantTva = GeneratedColumn<double>(
      'montant_tva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tauxTpsMeta =
      const VerificationMeta('tauxTps');
  @override
  late final GeneratedColumn<double> tauxTps = GeneratedColumn<double>(
      'taux_tps', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantTpsMeta =
      const VerificationMeta('montantTps');
  @override
  late final GeneratedColumn<double> montantTps = GeneratedColumn<double>(
      'montant_tps', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantTtcMeta =
      const VerificationMeta('montantTtc');
  @override
  late final GeneratedColumn<double> montantTtc = GeneratedColumn<double>(
      'montant_ttc', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _objetMeta = const VerificationMeta('objet');
  @override
  late final GeneratedColumn<String> objet = GeneratedColumn<String>(
      'objet', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conditionsMeta =
      const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
      'conditions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        dossierId,
        clientId,
        creePar,
        numero,
        annee,
        statut,
        dateEmission,
        dateValidite,
        montantHt,
        tauxTva,
        montantTva,
        tauxTps,
        montantTps,
        montantTtc,
        objet,
        conditions,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devis';
  @override
  VerificationContext validateIntegrity(Insertable<Devi> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('dossier_id')) {
      context.handle(_dossierIdMeta,
          dossierId.isAcceptableOrUnknown(data['dossier_id']!, _dossierIdMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('cree_par')) {
      context.handle(_creeParMeta,
          creePar.isAcceptableOrUnknown(data['cree_par']!, _creeParMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('date_emission')) {
      context.handle(
          _dateEmissionMeta,
          dateEmission.isAcceptableOrUnknown(
              data['date_emission']!, _dateEmissionMeta));
    } else if (isInserting) {
      context.missing(_dateEmissionMeta);
    }
    if (data.containsKey('date_validite')) {
      context.handle(
          _dateValiditeMeta,
          dateValidite.isAcceptableOrUnknown(
              data['date_validite']!, _dateValiditeMeta));
    } else if (isInserting) {
      context.missing(_dateValiditeMeta);
    }
    if (data.containsKey('montant_ht')) {
      context.handle(_montantHtMeta,
          montantHt.isAcceptableOrUnknown(data['montant_ht']!, _montantHtMeta));
    }
    if (data.containsKey('taux_tva')) {
      context.handle(_tauxTvaMeta,
          tauxTva.isAcceptableOrUnknown(data['taux_tva']!, _tauxTvaMeta));
    }
    if (data.containsKey('montant_tva')) {
      context.handle(
          _montantTvaMeta,
          montantTva.isAcceptableOrUnknown(
              data['montant_tva']!, _montantTvaMeta));
    }
    if (data.containsKey('taux_tps')) {
      context.handle(_tauxTpsMeta,
          tauxTps.isAcceptableOrUnknown(data['taux_tps']!, _tauxTpsMeta));
    }
    if (data.containsKey('montant_tps')) {
      context.handle(
          _montantTpsMeta,
          montantTps.isAcceptableOrUnknown(
              data['montant_tps']!, _montantTpsMeta));
    }
    if (data.containsKey('montant_ttc')) {
      context.handle(
          _montantTtcMeta,
          montantTtc.isAcceptableOrUnknown(
              data['montant_ttc']!, _montantTtcMeta));
    }
    if (data.containsKey('objet')) {
      context.handle(
          _objetMeta, objet.isAcceptableOrUnknown(data['objet']!, _objetMeta));
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Devi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Devi(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      dossierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dossier_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      creePar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cree_par']),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero']),
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      dateEmission: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_emission'])!,
      dateValidite: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_validite'])!,
      montantHt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ht'])!,
      tauxTva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_tva'])!,
      montantTva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_tva'])!,
      tauxTps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_tps'])!,
      montantTps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_tps'])!,
      montantTtc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ttc'])!,
      objet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}objet']),
      conditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DevisTable createAlias(String alias) {
    return $DevisTable(attachedDatabase, alias);
  }
}

class Devi extends DataClass implements Insertable<Devi> {
  final String id;
  final String entrepriseId;
  final String? dossierId;
  final String clientId;
  final String? creePar;
  final String? numero;
  final int annee;
  final String statut;
  final DateTime dateEmission;
  final DateTime dateValidite;
  final double montantHt;
  final double tauxTva;
  final double montantTva;
  final double tauxTps;
  final double montantTps;
  final double montantTtc;
  final String? objet;
  final String? conditions;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Devi(
      {required this.id,
      required this.entrepriseId,
      this.dossierId,
      required this.clientId,
      this.creePar,
      this.numero,
      required this.annee,
      required this.statut,
      required this.dateEmission,
      required this.dateValidite,
      required this.montantHt,
      required this.tauxTva,
      required this.montantTva,
      required this.tauxTps,
      required this.montantTps,
      required this.montantTtc,
      this.objet,
      this.conditions,
      this.notes,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    if (!nullToAbsent || dossierId != null) {
      map['dossier_id'] = Variable<String>(dossierId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || creePar != null) {
      map['cree_par'] = Variable<String>(creePar);
    }
    if (!nullToAbsent || numero != null) {
      map['numero'] = Variable<String>(numero);
    }
    map['annee'] = Variable<int>(annee);
    map['statut'] = Variable<String>(statut);
    map['date_emission'] = Variable<DateTime>(dateEmission);
    map['date_validite'] = Variable<DateTime>(dateValidite);
    map['montant_ht'] = Variable<double>(montantHt);
    map['taux_tva'] = Variable<double>(tauxTva);
    map['montant_tva'] = Variable<double>(montantTva);
    map['taux_tps'] = Variable<double>(tauxTps);
    map['montant_tps'] = Variable<double>(montantTps);
    map['montant_ttc'] = Variable<double>(montantTtc);
    if (!nullToAbsent || objet != null) {
      map['objet'] = Variable<String>(objet);
    }
    if (!nullToAbsent || conditions != null) {
      map['conditions'] = Variable<String>(conditions);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DevisCompanion toCompanion(bool nullToAbsent) {
    return DevisCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      dossierId: dossierId == null && nullToAbsent
          ? const Value.absent()
          : Value(dossierId),
      clientId: Value(clientId),
      creePar: creePar == null && nullToAbsent
          ? const Value.absent()
          : Value(creePar),
      numero:
          numero == null && nullToAbsent ? const Value.absent() : Value(numero),
      annee: Value(annee),
      statut: Value(statut),
      dateEmission: Value(dateEmission),
      dateValidite: Value(dateValidite),
      montantHt: Value(montantHt),
      tauxTva: Value(tauxTva),
      montantTva: Value(montantTva),
      tauxTps: Value(tauxTps),
      montantTps: Value(montantTps),
      montantTtc: Value(montantTtc),
      objet:
          objet == null && nullToAbsent ? const Value.absent() : Value(objet),
      conditions: conditions == null && nullToAbsent
          ? const Value.absent()
          : Value(conditions),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Devi.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Devi(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      dossierId: serializer.fromJson<String?>(json['dossierId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      creePar: serializer.fromJson<String?>(json['creePar']),
      numero: serializer.fromJson<String?>(json['numero']),
      annee: serializer.fromJson<int>(json['annee']),
      statut: serializer.fromJson<String>(json['statut']),
      dateEmission: serializer.fromJson<DateTime>(json['dateEmission']),
      dateValidite: serializer.fromJson<DateTime>(json['dateValidite']),
      montantHt: serializer.fromJson<double>(json['montantHt']),
      tauxTva: serializer.fromJson<double>(json['tauxTva']),
      montantTva: serializer.fromJson<double>(json['montantTva']),
      tauxTps: serializer.fromJson<double>(json['tauxTps']),
      montantTps: serializer.fromJson<double>(json['montantTps']),
      montantTtc: serializer.fromJson<double>(json['montantTtc']),
      objet: serializer.fromJson<String?>(json['objet']),
      conditions: serializer.fromJson<String?>(json['conditions']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'dossierId': serializer.toJson<String?>(dossierId),
      'clientId': serializer.toJson<String>(clientId),
      'creePar': serializer.toJson<String?>(creePar),
      'numero': serializer.toJson<String?>(numero),
      'annee': serializer.toJson<int>(annee),
      'statut': serializer.toJson<String>(statut),
      'dateEmission': serializer.toJson<DateTime>(dateEmission),
      'dateValidite': serializer.toJson<DateTime>(dateValidite),
      'montantHt': serializer.toJson<double>(montantHt),
      'tauxTva': serializer.toJson<double>(tauxTva),
      'montantTva': serializer.toJson<double>(montantTva),
      'tauxTps': serializer.toJson<double>(tauxTps),
      'montantTps': serializer.toJson<double>(montantTps),
      'montantTtc': serializer.toJson<double>(montantTtc),
      'objet': serializer.toJson<String?>(objet),
      'conditions': serializer.toJson<String?>(conditions),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Devi copyWith(
          {String? id,
          String? entrepriseId,
          Value<String?> dossierId = const Value.absent(),
          String? clientId,
          Value<String?> creePar = const Value.absent(),
          Value<String?> numero = const Value.absent(),
          int? annee,
          String? statut,
          DateTime? dateEmission,
          DateTime? dateValidite,
          double? montantHt,
          double? tauxTva,
          double? montantTva,
          double? tauxTps,
          double? montantTps,
          double? montantTtc,
          Value<String?> objet = const Value.absent(),
          Value<String?> conditions = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Devi(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        dossierId: dossierId.present ? dossierId.value : this.dossierId,
        clientId: clientId ?? this.clientId,
        creePar: creePar.present ? creePar.value : this.creePar,
        numero: numero.present ? numero.value : this.numero,
        annee: annee ?? this.annee,
        statut: statut ?? this.statut,
        dateEmission: dateEmission ?? this.dateEmission,
        dateValidite: dateValidite ?? this.dateValidite,
        montantHt: montantHt ?? this.montantHt,
        tauxTva: tauxTva ?? this.tauxTva,
        montantTva: montantTva ?? this.montantTva,
        tauxTps: tauxTps ?? this.tauxTps,
        montantTps: montantTps ?? this.montantTps,
        montantTtc: montantTtc ?? this.montantTtc,
        objet: objet.present ? objet.value : this.objet,
        conditions: conditions.present ? conditions.value : this.conditions,
        notes: notes.present ? notes.value : this.notes,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Devi copyWithCompanion(DevisCompanion data) {
    return Devi(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      dossierId: data.dossierId.present ? data.dossierId.value : this.dossierId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      creePar: data.creePar.present ? data.creePar.value : this.creePar,
      numero: data.numero.present ? data.numero.value : this.numero,
      annee: data.annee.present ? data.annee.value : this.annee,
      statut: data.statut.present ? data.statut.value : this.statut,
      dateEmission: data.dateEmission.present
          ? data.dateEmission.value
          : this.dateEmission,
      dateValidite: data.dateValidite.present
          ? data.dateValidite.value
          : this.dateValidite,
      montantHt: data.montantHt.present ? data.montantHt.value : this.montantHt,
      tauxTva: data.tauxTva.present ? data.tauxTva.value : this.tauxTva,
      montantTva:
          data.montantTva.present ? data.montantTva.value : this.montantTva,
      tauxTps: data.tauxTps.present ? data.tauxTps.value : this.tauxTps,
      montantTps:
          data.montantTps.present ? data.montantTps.value : this.montantTps,
      montantTtc:
          data.montantTtc.present ? data.montantTtc.value : this.montantTtc,
      objet: data.objet.present ? data.objet.value : this.objet,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Devi(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('clientId: $clientId, ')
          ..write('creePar: $creePar, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('statut: $statut, ')
          ..write('dateEmission: $dateEmission, ')
          ..write('dateValidite: $dateValidite, ')
          ..write('montantHt: $montantHt, ')
          ..write('tauxTva: $tauxTva, ')
          ..write('montantTva: $montantTva, ')
          ..write('tauxTps: $tauxTps, ')
          ..write('montantTps: $montantTps, ')
          ..write('montantTtc: $montantTtc, ')
          ..write('objet: $objet, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        entrepriseId,
        dossierId,
        clientId,
        creePar,
        numero,
        annee,
        statut,
        dateEmission,
        dateValidite,
        montantHt,
        tauxTva,
        montantTva,
        tauxTps,
        montantTps,
        montantTtc,
        objet,
        conditions,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Devi &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.dossierId == this.dossierId &&
          other.clientId == this.clientId &&
          other.creePar == this.creePar &&
          other.numero == this.numero &&
          other.annee == this.annee &&
          other.statut == this.statut &&
          other.dateEmission == this.dateEmission &&
          other.dateValidite == this.dateValidite &&
          other.montantHt == this.montantHt &&
          other.tauxTva == this.tauxTva &&
          other.montantTva == this.montantTva &&
          other.tauxTps == this.tauxTps &&
          other.montantTps == this.montantTps &&
          other.montantTtc == this.montantTtc &&
          other.objet == this.objet &&
          other.conditions == this.conditions &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DevisCompanion extends UpdateCompanion<Devi> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String?> dossierId;
  final Value<String> clientId;
  final Value<String?> creePar;
  final Value<String?> numero;
  final Value<int> annee;
  final Value<String> statut;
  final Value<DateTime> dateEmission;
  final Value<DateTime> dateValidite;
  final Value<double> montantHt;
  final Value<double> tauxTva;
  final Value<double> montantTva;
  final Value<double> tauxTps;
  final Value<double> montantTps;
  final Value<double> montantTtc;
  final Value<String?> objet;
  final Value<String?> conditions;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DevisCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.dossierId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.creePar = const Value.absent(),
    this.numero = const Value.absent(),
    this.annee = const Value.absent(),
    this.statut = const Value.absent(),
    this.dateEmission = const Value.absent(),
    this.dateValidite = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.tauxTva = const Value.absent(),
    this.montantTva = const Value.absent(),
    this.tauxTps = const Value.absent(),
    this.montantTps = const Value.absent(),
    this.montantTtc = const Value.absent(),
    this.objet = const Value.absent(),
    this.conditions = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevisCompanion.insert({
    required String id,
    required String entrepriseId,
    this.dossierId = const Value.absent(),
    required String clientId,
    this.creePar = const Value.absent(),
    this.numero = const Value.absent(),
    required int annee,
    this.statut = const Value.absent(),
    required DateTime dateEmission,
    required DateTime dateValidite,
    this.montantHt = const Value.absent(),
    this.tauxTva = const Value.absent(),
    this.montantTva = const Value.absent(),
    this.tauxTps = const Value.absent(),
    this.montantTps = const Value.absent(),
    this.montantTtc = const Value.absent(),
    this.objet = const Value.absent(),
    this.conditions = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        clientId = Value(clientId),
        annee = Value(annee),
        dateEmission = Value(dateEmission),
        dateValidite = Value(dateValidite);
  static Insertable<Devi> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? dossierId,
    Expression<String>? clientId,
    Expression<String>? creePar,
    Expression<String>? numero,
    Expression<int>? annee,
    Expression<String>? statut,
    Expression<DateTime>? dateEmission,
    Expression<DateTime>? dateValidite,
    Expression<double>? montantHt,
    Expression<double>? tauxTva,
    Expression<double>? montantTva,
    Expression<double>? tauxTps,
    Expression<double>? montantTps,
    Expression<double>? montantTtc,
    Expression<String>? objet,
    Expression<String>? conditions,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (dossierId != null) 'dossier_id': dossierId,
      if (clientId != null) 'client_id': clientId,
      if (creePar != null) 'cree_par': creePar,
      if (numero != null) 'numero': numero,
      if (annee != null) 'annee': annee,
      if (statut != null) 'statut': statut,
      if (dateEmission != null) 'date_emission': dateEmission,
      if (dateValidite != null) 'date_validite': dateValidite,
      if (montantHt != null) 'montant_ht': montantHt,
      if (tauxTva != null) 'taux_tva': tauxTva,
      if (montantTva != null) 'montant_tva': montantTva,
      if (tauxTps != null) 'taux_tps': tauxTps,
      if (montantTps != null) 'montant_tps': montantTps,
      if (montantTtc != null) 'montant_ttc': montantTtc,
      if (objet != null) 'objet': objet,
      if (conditions != null) 'conditions': conditions,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevisCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String?>? dossierId,
      Value<String>? clientId,
      Value<String?>? creePar,
      Value<String?>? numero,
      Value<int>? annee,
      Value<String>? statut,
      Value<DateTime>? dateEmission,
      Value<DateTime>? dateValidite,
      Value<double>? montantHt,
      Value<double>? tauxTva,
      Value<double>? montantTva,
      Value<double>? tauxTps,
      Value<double>? montantTps,
      Value<double>? montantTtc,
      Value<String?>? objet,
      Value<String?>? conditions,
      Value<String?>? notes,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DevisCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      dossierId: dossierId ?? this.dossierId,
      clientId: clientId ?? this.clientId,
      creePar: creePar ?? this.creePar,
      numero: numero ?? this.numero,
      annee: annee ?? this.annee,
      statut: statut ?? this.statut,
      dateEmission: dateEmission ?? this.dateEmission,
      dateValidite: dateValidite ?? this.dateValidite,
      montantHt: montantHt ?? this.montantHt,
      tauxTva: tauxTva ?? this.tauxTva,
      montantTva: montantTva ?? this.montantTva,
      tauxTps: tauxTps ?? this.tauxTps,
      montantTps: montantTps ?? this.montantTps,
      montantTtc: montantTtc ?? this.montantTtc,
      objet: objet ?? this.objet,
      conditions: conditions ?? this.conditions,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (dossierId.present) {
      map['dossier_id'] = Variable<String>(dossierId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (creePar.present) {
      map['cree_par'] = Variable<String>(creePar.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (dateEmission.present) {
      map['date_emission'] = Variable<DateTime>(dateEmission.value);
    }
    if (dateValidite.present) {
      map['date_validite'] = Variable<DateTime>(dateValidite.value);
    }
    if (montantHt.present) {
      map['montant_ht'] = Variable<double>(montantHt.value);
    }
    if (tauxTva.present) {
      map['taux_tva'] = Variable<double>(tauxTva.value);
    }
    if (montantTva.present) {
      map['montant_tva'] = Variable<double>(montantTva.value);
    }
    if (tauxTps.present) {
      map['taux_tps'] = Variable<double>(tauxTps.value);
    }
    if (montantTps.present) {
      map['montant_tps'] = Variable<double>(montantTps.value);
    }
    if (montantTtc.present) {
      map['montant_ttc'] = Variable<double>(montantTtc.value);
    }
    if (objet.present) {
      map['objet'] = Variable<String>(objet.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevisCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('clientId: $clientId, ')
          ..write('creePar: $creePar, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('statut: $statut, ')
          ..write('dateEmission: $dateEmission, ')
          ..write('dateValidite: $dateValidite, ')
          ..write('montantHt: $montantHt, ')
          ..write('tauxTva: $tauxTva, ')
          ..write('montantTva: $montantTva, ')
          ..write('tauxTps: $tauxTps, ')
          ..write('montantTps: $montantTps, ')
          ..write('montantTtc: $montantTtc, ')
          ..write('objet: $objet, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevisLignesTable extends DevisLignes
    with TableInfo<$DevisLignesTable, DevisLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevisLignesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _devisIdMeta =
      const VerificationMeta('devisId');
  @override
  late final GeneratedColumn<String> devisId = GeneratedColumn<String>(
      'devis_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
      'ordre', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _designationMeta =
      const VerificationMeta('designation');
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
      'designation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantiteMeta =
      const VerificationMeta('quantite');
  @override
  late final GeneratedColumn<double> quantite = GeneratedColumn<double>(
      'quantite', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _uniteMeta = const VerificationMeta('unite');
  @override
  late final GeneratedColumn<String> unite = GeneratedColumn<String>(
      'unite', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('forfait'));
  static const VerificationMeta _prixUnitMeta =
      const VerificationMeta('prixUnit');
  @override
  late final GeneratedColumn<double> prixUnit = GeneratedColumn<double>(
      'prix_unit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantHtMeta =
      const VerificationMeta('montantHt');
  @override
  late final GeneratedColumn<double> montantHt = GeneratedColumn<double>(
      'montant_ht', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxesJsonMeta =
      const VerificationMeta('taxesJson');
  @override
  late final GeneratedColumn<String> taxesJson = GeneratedColumn<String>(
      'taxes_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        devisId,
        ordre,
        designation,
        description,
        quantite,
        unite,
        prixUnit,
        montantHt,
        taxesJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devis_lignes';
  @override
  VerificationContext validateIntegrity(Insertable<DevisLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('devis_id')) {
      context.handle(_devisIdMeta,
          devisId.isAcceptableOrUnknown(data['devis_id']!, _devisIdMeta));
    } else if (isInserting) {
      context.missing(_devisIdMeta);
    }
    if (data.containsKey('ordre')) {
      context.handle(
          _ordreMeta, ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta));
    }
    if (data.containsKey('designation')) {
      context.handle(
          _designationMeta,
          designation.isAcceptableOrUnknown(
              data['designation']!, _designationMeta));
    } else if (isInserting) {
      context.missing(_designationMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('quantite')) {
      context.handle(_quantiteMeta,
          quantite.isAcceptableOrUnknown(data['quantite']!, _quantiteMeta));
    }
    if (data.containsKey('unite')) {
      context.handle(
          _uniteMeta, unite.isAcceptableOrUnknown(data['unite']!, _uniteMeta));
    }
    if (data.containsKey('prix_unit')) {
      context.handle(_prixUnitMeta,
          prixUnit.isAcceptableOrUnknown(data['prix_unit']!, _prixUnitMeta));
    }
    if (data.containsKey('montant_ht')) {
      context.handle(_montantHtMeta,
          montantHt.isAcceptableOrUnknown(data['montant_ht']!, _montantHtMeta));
    }
    if (data.containsKey('taxes_json')) {
      context.handle(_taxesJsonMeta,
          taxesJson.isAcceptableOrUnknown(data['taxes_json']!, _taxesJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DevisLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DevisLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      devisId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}devis_id'])!,
      ordre: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordre'])!,
      designation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      quantite: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantite'])!,
      unite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unite'])!,
      prixUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}prix_unit'])!,
      montantHt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ht'])!,
      taxesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}taxes_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DevisLignesTable createAlias(String alias) {
    return $DevisLignesTable(attachedDatabase, alias);
  }
}

class DevisLigne extends DataClass implements Insertable<DevisLigne> {
  final String id;
  final String devisId;
  final int ordre;
  final String designation;
  final String? description;
  final double quantite;
  final String unite;
  final double prixUnit;
  final double montantHt;
  final String? taxesJson;
  final DateTime createdAt;
  const DevisLigne(
      {required this.id,
      required this.devisId,
      required this.ordre,
      required this.designation,
      this.description,
      required this.quantite,
      required this.unite,
      required this.prixUnit,
      required this.montantHt,
      this.taxesJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['devis_id'] = Variable<String>(devisId);
    map['ordre'] = Variable<int>(ordre);
    map['designation'] = Variable<String>(designation);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['quantite'] = Variable<double>(quantite);
    map['unite'] = Variable<String>(unite);
    map['prix_unit'] = Variable<double>(prixUnit);
    map['montant_ht'] = Variable<double>(montantHt);
    if (!nullToAbsent || taxesJson != null) {
      map['taxes_json'] = Variable<String>(taxesJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DevisLignesCompanion toCompanion(bool nullToAbsent) {
    return DevisLignesCompanion(
      id: Value(id),
      devisId: Value(devisId),
      ordre: Value(ordre),
      designation: Value(designation),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      quantite: Value(quantite),
      unite: Value(unite),
      prixUnit: Value(prixUnit),
      montantHt: Value(montantHt),
      taxesJson: taxesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(taxesJson),
      createdAt: Value(createdAt),
    );
  }

  factory DevisLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DevisLigne(
      id: serializer.fromJson<String>(json['id']),
      devisId: serializer.fromJson<String>(json['devisId']),
      ordre: serializer.fromJson<int>(json['ordre']),
      designation: serializer.fromJson<String>(json['designation']),
      description: serializer.fromJson<String?>(json['description']),
      quantite: serializer.fromJson<double>(json['quantite']),
      unite: serializer.fromJson<String>(json['unite']),
      prixUnit: serializer.fromJson<double>(json['prixUnit']),
      montantHt: serializer.fromJson<double>(json['montantHt']),
      taxesJson: serializer.fromJson<String?>(json['taxesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'devisId': serializer.toJson<String>(devisId),
      'ordre': serializer.toJson<int>(ordre),
      'designation': serializer.toJson<String>(designation),
      'description': serializer.toJson<String?>(description),
      'quantite': serializer.toJson<double>(quantite),
      'unite': serializer.toJson<String>(unite),
      'prixUnit': serializer.toJson<double>(prixUnit),
      'montantHt': serializer.toJson<double>(montantHt),
      'taxesJson': serializer.toJson<String?>(taxesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DevisLigne copyWith(
          {String? id,
          String? devisId,
          int? ordre,
          String? designation,
          Value<String?> description = const Value.absent(),
          double? quantite,
          String? unite,
          double? prixUnit,
          double? montantHt,
          Value<String?> taxesJson = const Value.absent(),
          DateTime? createdAt}) =>
      DevisLigne(
        id: id ?? this.id,
        devisId: devisId ?? this.devisId,
        ordre: ordre ?? this.ordre,
        designation: designation ?? this.designation,
        description: description.present ? description.value : this.description,
        quantite: quantite ?? this.quantite,
        unite: unite ?? this.unite,
        prixUnit: prixUnit ?? this.prixUnit,
        montantHt: montantHt ?? this.montantHt,
        taxesJson: taxesJson.present ? taxesJson.value : this.taxesJson,
        createdAt: createdAt ?? this.createdAt,
      );
  DevisLigne copyWithCompanion(DevisLignesCompanion data) {
    return DevisLigne(
      id: data.id.present ? data.id.value : this.id,
      devisId: data.devisId.present ? data.devisId.value : this.devisId,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
      designation:
          data.designation.present ? data.designation.value : this.designation,
      description:
          data.description.present ? data.description.value : this.description,
      quantite: data.quantite.present ? data.quantite.value : this.quantite,
      unite: data.unite.present ? data.unite.value : this.unite,
      prixUnit: data.prixUnit.present ? data.prixUnit.value : this.prixUnit,
      montantHt: data.montantHt.present ? data.montantHt.value : this.montantHt,
      taxesJson: data.taxesJson.present ? data.taxesJson.value : this.taxesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DevisLigne(')
          ..write('id: $id, ')
          ..write('devisId: $devisId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('description: $description, ')
          ..write('quantite: $quantite, ')
          ..write('unite: $unite, ')
          ..write('prixUnit: $prixUnit, ')
          ..write('montantHt: $montantHt, ')
          ..write('taxesJson: $taxesJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, devisId, ordre, designation, description,
      quantite, unite, prixUnit, montantHt, taxesJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DevisLigne &&
          other.id == this.id &&
          other.devisId == this.devisId &&
          other.ordre == this.ordre &&
          other.designation == this.designation &&
          other.description == this.description &&
          other.quantite == this.quantite &&
          other.unite == this.unite &&
          other.prixUnit == this.prixUnit &&
          other.montantHt == this.montantHt &&
          other.taxesJson == this.taxesJson &&
          other.createdAt == this.createdAt);
}

class DevisLignesCompanion extends UpdateCompanion<DevisLigne> {
  final Value<String> id;
  final Value<String> devisId;
  final Value<int> ordre;
  final Value<String> designation;
  final Value<String?> description;
  final Value<double> quantite;
  final Value<String> unite;
  final Value<double> prixUnit;
  final Value<double> montantHt;
  final Value<String?> taxesJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DevisLignesCompanion({
    this.id = const Value.absent(),
    this.devisId = const Value.absent(),
    this.ordre = const Value.absent(),
    this.designation = const Value.absent(),
    this.description = const Value.absent(),
    this.quantite = const Value.absent(),
    this.unite = const Value.absent(),
    this.prixUnit = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.taxesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevisLignesCompanion.insert({
    required String id,
    required String devisId,
    this.ordre = const Value.absent(),
    required String designation,
    this.description = const Value.absent(),
    this.quantite = const Value.absent(),
    this.unite = const Value.absent(),
    this.prixUnit = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.taxesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        devisId = Value(devisId),
        designation = Value(designation);
  static Insertable<DevisLigne> custom({
    Expression<String>? id,
    Expression<String>? devisId,
    Expression<int>? ordre,
    Expression<String>? designation,
    Expression<String>? description,
    Expression<double>? quantite,
    Expression<String>? unite,
    Expression<double>? prixUnit,
    Expression<double>? montantHt,
    Expression<String>? taxesJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (devisId != null) 'devis_id': devisId,
      if (ordre != null) 'ordre': ordre,
      if (designation != null) 'designation': designation,
      if (description != null) 'description': description,
      if (quantite != null) 'quantite': quantite,
      if (unite != null) 'unite': unite,
      if (prixUnit != null) 'prix_unit': prixUnit,
      if (montantHt != null) 'montant_ht': montantHt,
      if (taxesJson != null) 'taxes_json': taxesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevisLignesCompanion copyWith(
      {Value<String>? id,
      Value<String>? devisId,
      Value<int>? ordre,
      Value<String>? designation,
      Value<String?>? description,
      Value<double>? quantite,
      Value<String>? unite,
      Value<double>? prixUnit,
      Value<double>? montantHt,
      Value<String?>? taxesJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DevisLignesCompanion(
      id: id ?? this.id,
      devisId: devisId ?? this.devisId,
      ordre: ordre ?? this.ordre,
      designation: designation ?? this.designation,
      description: description ?? this.description,
      quantite: quantite ?? this.quantite,
      unite: unite ?? this.unite,
      prixUnit: prixUnit ?? this.prixUnit,
      montantHt: montantHt ?? this.montantHt,
      taxesJson: taxesJson ?? this.taxesJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (devisId.present) {
      map['devis_id'] = Variable<String>(devisId.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quantite.present) {
      map['quantite'] = Variable<double>(quantite.value);
    }
    if (unite.present) {
      map['unite'] = Variable<String>(unite.value);
    }
    if (prixUnit.present) {
      map['prix_unit'] = Variable<double>(prixUnit.value);
    }
    if (montantHt.present) {
      map['montant_ht'] = Variable<double>(montantHt.value);
    }
    if (taxesJson.present) {
      map['taxes_json'] = Variable<String>(taxesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevisLignesCompanion(')
          ..write('id: $id, ')
          ..write('devisId: $devisId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('description: $description, ')
          ..write('quantite: $quantite, ')
          ..write('unite: $unite, ')
          ..write('prixUnit: $prixUnit, ')
          ..write('montantHt: $montantHt, ')
          ..write('taxesJson: $taxesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FacturesTable extends Factures with TableInfo<$FacturesTable, Facture> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dossierIdMeta =
      const VerificationMeta('dossierId');
  @override
  late final GeneratedColumn<String> dossierId = GeneratedColumn<String>(
      'dossier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _devisIdMeta =
      const VerificationMeta('devisId');
  @override
  late final GeneratedColumn<String> devisId = GeneratedColumn<String>(
      'devis_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creeParMeta =
      const VerificationMeta('creePar');
  @override
  late final GeneratedColumn<String> creePar = GeneratedColumn<String>(
      'cree_par', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('brouillon'));
  static const VerificationMeta _dateEmissionMeta =
      const VerificationMeta('dateEmission');
  @override
  late final GeneratedColumn<DateTime> dateEmission = GeneratedColumn<DateTime>(
      'date_emission', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateEcheanceMeta =
      const VerificationMeta('dateEcheance');
  @override
  late final GeneratedColumn<DateTime> dateEcheance = GeneratedColumn<DateTime>(
      'date_echeance', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _datePaiementMeta =
      const VerificationMeta('datePaiement');
  @override
  late final GeneratedColumn<DateTime> datePaiement = GeneratedColumn<DateTime>(
      'date_paiement', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _montantHtMeta =
      const VerificationMeta('montantHt');
  @override
  late final GeneratedColumn<double> montantHt = GeneratedColumn<double>(
      'montant_ht', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tauxTvaMeta =
      const VerificationMeta('tauxTva');
  @override
  late final GeneratedColumn<double> tauxTva = GeneratedColumn<double>(
      'taux_tva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(18.0));
  static const VerificationMeta _montantTvaMeta =
      const VerificationMeta('montantTva');
  @override
  late final GeneratedColumn<double> montantTva = GeneratedColumn<double>(
      'montant_tva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tauxTpsMeta =
      const VerificationMeta('tauxTps');
  @override
  late final GeneratedColumn<double> tauxTps = GeneratedColumn<double>(
      'taux_tps', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantTpsMeta =
      const VerificationMeta('montantTps');
  @override
  late final GeneratedColumn<double> montantTps = GeneratedColumn<double>(
      'montant_tps', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantTtcMeta =
      const VerificationMeta('montantTtc');
  @override
  late final GeneratedColumn<double> montantTtc = GeneratedColumn<double>(
      'montant_ttc', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantPayeMeta =
      const VerificationMeta('montantPaye');
  @override
  late final GeneratedColumn<double> montantPaye = GeneratedColumn<double>(
      'montant_paye', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantRestantMeta =
      const VerificationMeta('montantRestant');
  @override
  late final GeneratedColumn<double> montantRestant = GeneratedColumn<double>(
      'montant_restant', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _modePaiementMeta =
      const VerificationMeta('modePaiement');
  @override
  late final GeneratedColumn<String> modePaiement = GeneratedColumn<String>(
      'mode_paiement', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referencePaiementMeta =
      const VerificationMeta('referencePaiement');
  @override
  late final GeneratedColumn<String> referencePaiement =
      GeneratedColumn<String>('reference_paiement', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _objetMeta = const VerificationMeta('objet');
  @override
  late final GeneratedColumn<String> objet = GeneratedColumn<String>(
      'objet', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conditionsMeta =
      const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
      'conditions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _motifAnnulationMeta =
      const VerificationMeta('motifAnnulation');
  @override
  late final GeneratedColumn<String> motifAnnulation = GeneratedColumn<String>(
      'motif_annulation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        dossierId,
        clientId,
        devisId,
        creePar,
        numero,
        annee,
        statut,
        dateEmission,
        dateEcheance,
        datePaiement,
        montantHt,
        tauxTva,
        montantTva,
        tauxTps,
        montantTps,
        montantTtc,
        montantPaye,
        montantRestant,
        modePaiement,
        referencePaiement,
        objet,
        conditions,
        notes,
        motifAnnulation,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factures';
  @override
  VerificationContext validateIntegrity(Insertable<Facture> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('dossier_id')) {
      context.handle(_dossierIdMeta,
          dossierId.isAcceptableOrUnknown(data['dossier_id']!, _dossierIdMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('devis_id')) {
      context.handle(_devisIdMeta,
          devisId.isAcceptableOrUnknown(data['devis_id']!, _devisIdMeta));
    }
    if (data.containsKey('cree_par')) {
      context.handle(_creeParMeta,
          creePar.isAcceptableOrUnknown(data['cree_par']!, _creeParMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('date_emission')) {
      context.handle(
          _dateEmissionMeta,
          dateEmission.isAcceptableOrUnknown(
              data['date_emission']!, _dateEmissionMeta));
    } else if (isInserting) {
      context.missing(_dateEmissionMeta);
    }
    if (data.containsKey('date_echeance')) {
      context.handle(
          _dateEcheanceMeta,
          dateEcheance.isAcceptableOrUnknown(
              data['date_echeance']!, _dateEcheanceMeta));
    } else if (isInserting) {
      context.missing(_dateEcheanceMeta);
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
          _datePaiementMeta,
          datePaiement.isAcceptableOrUnknown(
              data['date_paiement']!, _datePaiementMeta));
    }
    if (data.containsKey('montant_ht')) {
      context.handle(_montantHtMeta,
          montantHt.isAcceptableOrUnknown(data['montant_ht']!, _montantHtMeta));
    }
    if (data.containsKey('taux_tva')) {
      context.handle(_tauxTvaMeta,
          tauxTva.isAcceptableOrUnknown(data['taux_tva']!, _tauxTvaMeta));
    }
    if (data.containsKey('montant_tva')) {
      context.handle(
          _montantTvaMeta,
          montantTva.isAcceptableOrUnknown(
              data['montant_tva']!, _montantTvaMeta));
    }
    if (data.containsKey('taux_tps')) {
      context.handle(_tauxTpsMeta,
          tauxTps.isAcceptableOrUnknown(data['taux_tps']!, _tauxTpsMeta));
    }
    if (data.containsKey('montant_tps')) {
      context.handle(
          _montantTpsMeta,
          montantTps.isAcceptableOrUnknown(
              data['montant_tps']!, _montantTpsMeta));
    }
    if (data.containsKey('montant_ttc')) {
      context.handle(
          _montantTtcMeta,
          montantTtc.isAcceptableOrUnknown(
              data['montant_ttc']!, _montantTtcMeta));
    }
    if (data.containsKey('montant_paye')) {
      context.handle(
          _montantPayeMeta,
          montantPaye.isAcceptableOrUnknown(
              data['montant_paye']!, _montantPayeMeta));
    }
    if (data.containsKey('montant_restant')) {
      context.handle(
          _montantRestantMeta,
          montantRestant.isAcceptableOrUnknown(
              data['montant_restant']!, _montantRestantMeta));
    }
    if (data.containsKey('mode_paiement')) {
      context.handle(
          _modePaiementMeta,
          modePaiement.isAcceptableOrUnknown(
              data['mode_paiement']!, _modePaiementMeta));
    }
    if (data.containsKey('reference_paiement')) {
      context.handle(
          _referencePaiementMeta,
          referencePaiement.isAcceptableOrUnknown(
              data['reference_paiement']!, _referencePaiementMeta));
    }
    if (data.containsKey('objet')) {
      context.handle(
          _objetMeta, objet.isAcceptableOrUnknown(data['objet']!, _objetMeta));
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('motif_annulation')) {
      context.handle(
          _motifAnnulationMeta,
          motifAnnulation.isAcceptableOrUnknown(
              data['motif_annulation']!, _motifAnnulationMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Facture map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Facture(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      dossierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dossier_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      devisId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}devis_id']),
      creePar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cree_par']),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero']),
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      dateEmission: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_emission'])!,
      dateEcheance: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_echeance'])!,
      datePaiement: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_paiement']),
      montantHt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ht'])!,
      tauxTva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_tva'])!,
      montantTva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_tva'])!,
      tauxTps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_tps'])!,
      montantTps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_tps'])!,
      montantTtc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ttc'])!,
      montantPaye: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_paye'])!,
      montantRestant: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}montant_restant'])!,
      modePaiement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode_paiement']),
      referencePaiement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_paiement']),
      objet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}objet']),
      conditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      motifAnnulation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}motif_annulation']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FacturesTable createAlias(String alias) {
    return $FacturesTable(attachedDatabase, alias);
  }
}

class Facture extends DataClass implements Insertable<Facture> {
  final String id;
  final String entrepriseId;
  final String? dossierId;
  final String clientId;
  final String? devisId;
  final String? creePar;
  final String? numero;
  final int annee;
  final String statut;
  final DateTime dateEmission;
  final DateTime dateEcheance;
  final DateTime? datePaiement;
  final double montantHt;
  final double tauxTva;
  final double montantTva;
  final double tauxTps;
  final double montantTps;
  final double montantTtc;
  final double montantPaye;
  final double montantRestant;
  final String? modePaiement;
  final String? referencePaiement;
  final String? objet;
  final String? conditions;
  final String? notes;
  final String? motifAnnulation;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Facture(
      {required this.id,
      required this.entrepriseId,
      this.dossierId,
      required this.clientId,
      this.devisId,
      this.creePar,
      this.numero,
      required this.annee,
      required this.statut,
      required this.dateEmission,
      required this.dateEcheance,
      this.datePaiement,
      required this.montantHt,
      required this.tauxTva,
      required this.montantTva,
      required this.tauxTps,
      required this.montantTps,
      required this.montantTtc,
      required this.montantPaye,
      required this.montantRestant,
      this.modePaiement,
      this.referencePaiement,
      this.objet,
      this.conditions,
      this.notes,
      this.motifAnnulation,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    if (!nullToAbsent || dossierId != null) {
      map['dossier_id'] = Variable<String>(dossierId);
    }
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || devisId != null) {
      map['devis_id'] = Variable<String>(devisId);
    }
    if (!nullToAbsent || creePar != null) {
      map['cree_par'] = Variable<String>(creePar);
    }
    if (!nullToAbsent || numero != null) {
      map['numero'] = Variable<String>(numero);
    }
    map['annee'] = Variable<int>(annee);
    map['statut'] = Variable<String>(statut);
    map['date_emission'] = Variable<DateTime>(dateEmission);
    map['date_echeance'] = Variable<DateTime>(dateEcheance);
    if (!nullToAbsent || datePaiement != null) {
      map['date_paiement'] = Variable<DateTime>(datePaiement);
    }
    map['montant_ht'] = Variable<double>(montantHt);
    map['taux_tva'] = Variable<double>(tauxTva);
    map['montant_tva'] = Variable<double>(montantTva);
    map['taux_tps'] = Variable<double>(tauxTps);
    map['montant_tps'] = Variable<double>(montantTps);
    map['montant_ttc'] = Variable<double>(montantTtc);
    map['montant_paye'] = Variable<double>(montantPaye);
    map['montant_restant'] = Variable<double>(montantRestant);
    if (!nullToAbsent || modePaiement != null) {
      map['mode_paiement'] = Variable<String>(modePaiement);
    }
    if (!nullToAbsent || referencePaiement != null) {
      map['reference_paiement'] = Variable<String>(referencePaiement);
    }
    if (!nullToAbsent || objet != null) {
      map['objet'] = Variable<String>(objet);
    }
    if (!nullToAbsent || conditions != null) {
      map['conditions'] = Variable<String>(conditions);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || motifAnnulation != null) {
      map['motif_annulation'] = Variable<String>(motifAnnulation);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FacturesCompanion toCompanion(bool nullToAbsent) {
    return FacturesCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      dossierId: dossierId == null && nullToAbsent
          ? const Value.absent()
          : Value(dossierId),
      clientId: Value(clientId),
      devisId: devisId == null && nullToAbsent
          ? const Value.absent()
          : Value(devisId),
      creePar: creePar == null && nullToAbsent
          ? const Value.absent()
          : Value(creePar),
      numero:
          numero == null && nullToAbsent ? const Value.absent() : Value(numero),
      annee: Value(annee),
      statut: Value(statut),
      dateEmission: Value(dateEmission),
      dateEcheance: Value(dateEcheance),
      datePaiement: datePaiement == null && nullToAbsent
          ? const Value.absent()
          : Value(datePaiement),
      montantHt: Value(montantHt),
      tauxTva: Value(tauxTva),
      montantTva: Value(montantTva),
      tauxTps: Value(tauxTps),
      montantTps: Value(montantTps),
      montantTtc: Value(montantTtc),
      montantPaye: Value(montantPaye),
      montantRestant: Value(montantRestant),
      modePaiement: modePaiement == null && nullToAbsent
          ? const Value.absent()
          : Value(modePaiement),
      referencePaiement: referencePaiement == null && nullToAbsent
          ? const Value.absent()
          : Value(referencePaiement),
      objet:
          objet == null && nullToAbsent ? const Value.absent() : Value(objet),
      conditions: conditions == null && nullToAbsent
          ? const Value.absent()
          : Value(conditions),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      motifAnnulation: motifAnnulation == null && nullToAbsent
          ? const Value.absent()
          : Value(motifAnnulation),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Facture.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Facture(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      dossierId: serializer.fromJson<String?>(json['dossierId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      devisId: serializer.fromJson<String?>(json['devisId']),
      creePar: serializer.fromJson<String?>(json['creePar']),
      numero: serializer.fromJson<String?>(json['numero']),
      annee: serializer.fromJson<int>(json['annee']),
      statut: serializer.fromJson<String>(json['statut']),
      dateEmission: serializer.fromJson<DateTime>(json['dateEmission']),
      dateEcheance: serializer.fromJson<DateTime>(json['dateEcheance']),
      datePaiement: serializer.fromJson<DateTime?>(json['datePaiement']),
      montantHt: serializer.fromJson<double>(json['montantHt']),
      tauxTva: serializer.fromJson<double>(json['tauxTva']),
      montantTva: serializer.fromJson<double>(json['montantTva']),
      tauxTps: serializer.fromJson<double>(json['tauxTps']),
      montantTps: serializer.fromJson<double>(json['montantTps']),
      montantTtc: serializer.fromJson<double>(json['montantTtc']),
      montantPaye: serializer.fromJson<double>(json['montantPaye']),
      montantRestant: serializer.fromJson<double>(json['montantRestant']),
      modePaiement: serializer.fromJson<String?>(json['modePaiement']),
      referencePaiement:
          serializer.fromJson<String?>(json['referencePaiement']),
      objet: serializer.fromJson<String?>(json['objet']),
      conditions: serializer.fromJson<String?>(json['conditions']),
      notes: serializer.fromJson<String?>(json['notes']),
      motifAnnulation: serializer.fromJson<String?>(json['motifAnnulation']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'dossierId': serializer.toJson<String?>(dossierId),
      'clientId': serializer.toJson<String>(clientId),
      'devisId': serializer.toJson<String?>(devisId),
      'creePar': serializer.toJson<String?>(creePar),
      'numero': serializer.toJson<String?>(numero),
      'annee': serializer.toJson<int>(annee),
      'statut': serializer.toJson<String>(statut),
      'dateEmission': serializer.toJson<DateTime>(dateEmission),
      'dateEcheance': serializer.toJson<DateTime>(dateEcheance),
      'datePaiement': serializer.toJson<DateTime?>(datePaiement),
      'montantHt': serializer.toJson<double>(montantHt),
      'tauxTva': serializer.toJson<double>(tauxTva),
      'montantTva': serializer.toJson<double>(montantTva),
      'tauxTps': serializer.toJson<double>(tauxTps),
      'montantTps': serializer.toJson<double>(montantTps),
      'montantTtc': serializer.toJson<double>(montantTtc),
      'montantPaye': serializer.toJson<double>(montantPaye),
      'montantRestant': serializer.toJson<double>(montantRestant),
      'modePaiement': serializer.toJson<String?>(modePaiement),
      'referencePaiement': serializer.toJson<String?>(referencePaiement),
      'objet': serializer.toJson<String?>(objet),
      'conditions': serializer.toJson<String?>(conditions),
      'notes': serializer.toJson<String?>(notes),
      'motifAnnulation': serializer.toJson<String?>(motifAnnulation),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Facture copyWith(
          {String? id,
          String? entrepriseId,
          Value<String?> dossierId = const Value.absent(),
          String? clientId,
          Value<String?> devisId = const Value.absent(),
          Value<String?> creePar = const Value.absent(),
          Value<String?> numero = const Value.absent(),
          int? annee,
          String? statut,
          DateTime? dateEmission,
          DateTime? dateEcheance,
          Value<DateTime?> datePaiement = const Value.absent(),
          double? montantHt,
          double? tauxTva,
          double? montantTva,
          double? tauxTps,
          double? montantTps,
          double? montantTtc,
          double? montantPaye,
          double? montantRestant,
          Value<String?> modePaiement = const Value.absent(),
          Value<String?> referencePaiement = const Value.absent(),
          Value<String?> objet = const Value.absent(),
          Value<String?> conditions = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> motifAnnulation = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Facture(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        dossierId: dossierId.present ? dossierId.value : this.dossierId,
        clientId: clientId ?? this.clientId,
        devisId: devisId.present ? devisId.value : this.devisId,
        creePar: creePar.present ? creePar.value : this.creePar,
        numero: numero.present ? numero.value : this.numero,
        annee: annee ?? this.annee,
        statut: statut ?? this.statut,
        dateEmission: dateEmission ?? this.dateEmission,
        dateEcheance: dateEcheance ?? this.dateEcheance,
        datePaiement:
            datePaiement.present ? datePaiement.value : this.datePaiement,
        montantHt: montantHt ?? this.montantHt,
        tauxTva: tauxTva ?? this.tauxTva,
        montantTva: montantTva ?? this.montantTva,
        tauxTps: tauxTps ?? this.tauxTps,
        montantTps: montantTps ?? this.montantTps,
        montantTtc: montantTtc ?? this.montantTtc,
        montantPaye: montantPaye ?? this.montantPaye,
        montantRestant: montantRestant ?? this.montantRestant,
        modePaiement:
            modePaiement.present ? modePaiement.value : this.modePaiement,
        referencePaiement: referencePaiement.present
            ? referencePaiement.value
            : this.referencePaiement,
        objet: objet.present ? objet.value : this.objet,
        conditions: conditions.present ? conditions.value : this.conditions,
        notes: notes.present ? notes.value : this.notes,
        motifAnnulation: motifAnnulation.present
            ? motifAnnulation.value
            : this.motifAnnulation,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Facture copyWithCompanion(FacturesCompanion data) {
    return Facture(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      dossierId: data.dossierId.present ? data.dossierId.value : this.dossierId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      devisId: data.devisId.present ? data.devisId.value : this.devisId,
      creePar: data.creePar.present ? data.creePar.value : this.creePar,
      numero: data.numero.present ? data.numero.value : this.numero,
      annee: data.annee.present ? data.annee.value : this.annee,
      statut: data.statut.present ? data.statut.value : this.statut,
      dateEmission: data.dateEmission.present
          ? data.dateEmission.value
          : this.dateEmission,
      dateEcheance: data.dateEcheance.present
          ? data.dateEcheance.value
          : this.dateEcheance,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      montantHt: data.montantHt.present ? data.montantHt.value : this.montantHt,
      tauxTva: data.tauxTva.present ? data.tauxTva.value : this.tauxTva,
      montantTva:
          data.montantTva.present ? data.montantTva.value : this.montantTva,
      tauxTps: data.tauxTps.present ? data.tauxTps.value : this.tauxTps,
      montantTps:
          data.montantTps.present ? data.montantTps.value : this.montantTps,
      montantTtc:
          data.montantTtc.present ? data.montantTtc.value : this.montantTtc,
      montantPaye:
          data.montantPaye.present ? data.montantPaye.value : this.montantPaye,
      montantRestant: data.montantRestant.present
          ? data.montantRestant.value
          : this.montantRestant,
      modePaiement: data.modePaiement.present
          ? data.modePaiement.value
          : this.modePaiement,
      referencePaiement: data.referencePaiement.present
          ? data.referencePaiement.value
          : this.referencePaiement,
      objet: data.objet.present ? data.objet.value : this.objet,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
      notes: data.notes.present ? data.notes.value : this.notes,
      motifAnnulation: data.motifAnnulation.present
          ? data.motifAnnulation.value
          : this.motifAnnulation,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Facture(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('clientId: $clientId, ')
          ..write('devisId: $devisId, ')
          ..write('creePar: $creePar, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('statut: $statut, ')
          ..write('dateEmission: $dateEmission, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('montantHt: $montantHt, ')
          ..write('tauxTva: $tauxTva, ')
          ..write('montantTva: $montantTva, ')
          ..write('tauxTps: $tauxTps, ')
          ..write('montantTps: $montantTps, ')
          ..write('montantTtc: $montantTtc, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('montantRestant: $montantRestant, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('referencePaiement: $referencePaiement, ')
          ..write('objet: $objet, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('motifAnnulation: $motifAnnulation, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        entrepriseId,
        dossierId,
        clientId,
        devisId,
        creePar,
        numero,
        annee,
        statut,
        dateEmission,
        dateEcheance,
        datePaiement,
        montantHt,
        tauxTva,
        montantTva,
        tauxTps,
        montantTps,
        montantTtc,
        montantPaye,
        montantRestant,
        modePaiement,
        referencePaiement,
        objet,
        conditions,
        notes,
        motifAnnulation,
        syncStatus,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Facture &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.dossierId == this.dossierId &&
          other.clientId == this.clientId &&
          other.devisId == this.devisId &&
          other.creePar == this.creePar &&
          other.numero == this.numero &&
          other.annee == this.annee &&
          other.statut == this.statut &&
          other.dateEmission == this.dateEmission &&
          other.dateEcheance == this.dateEcheance &&
          other.datePaiement == this.datePaiement &&
          other.montantHt == this.montantHt &&
          other.tauxTva == this.tauxTva &&
          other.montantTva == this.montantTva &&
          other.tauxTps == this.tauxTps &&
          other.montantTps == this.montantTps &&
          other.montantTtc == this.montantTtc &&
          other.montantPaye == this.montantPaye &&
          other.montantRestant == this.montantRestant &&
          other.modePaiement == this.modePaiement &&
          other.referencePaiement == this.referencePaiement &&
          other.objet == this.objet &&
          other.conditions == this.conditions &&
          other.notes == this.notes &&
          other.motifAnnulation == this.motifAnnulation &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FacturesCompanion extends UpdateCompanion<Facture> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String?> dossierId;
  final Value<String> clientId;
  final Value<String?> devisId;
  final Value<String?> creePar;
  final Value<String?> numero;
  final Value<int> annee;
  final Value<String> statut;
  final Value<DateTime> dateEmission;
  final Value<DateTime> dateEcheance;
  final Value<DateTime?> datePaiement;
  final Value<double> montantHt;
  final Value<double> tauxTva;
  final Value<double> montantTva;
  final Value<double> tauxTps;
  final Value<double> montantTps;
  final Value<double> montantTtc;
  final Value<double> montantPaye;
  final Value<double> montantRestant;
  final Value<String?> modePaiement;
  final Value<String?> referencePaiement;
  final Value<String?> objet;
  final Value<String?> conditions;
  final Value<String?> notes;
  final Value<String?> motifAnnulation;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FacturesCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.dossierId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.devisId = const Value.absent(),
    this.creePar = const Value.absent(),
    this.numero = const Value.absent(),
    this.annee = const Value.absent(),
    this.statut = const Value.absent(),
    this.dateEmission = const Value.absent(),
    this.dateEcheance = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.tauxTva = const Value.absent(),
    this.montantTva = const Value.absent(),
    this.tauxTps = const Value.absent(),
    this.montantTps = const Value.absent(),
    this.montantTtc = const Value.absent(),
    this.montantPaye = const Value.absent(),
    this.montantRestant = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.referencePaiement = const Value.absent(),
    this.objet = const Value.absent(),
    this.conditions = const Value.absent(),
    this.notes = const Value.absent(),
    this.motifAnnulation = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FacturesCompanion.insert({
    required String id,
    required String entrepriseId,
    this.dossierId = const Value.absent(),
    required String clientId,
    this.devisId = const Value.absent(),
    this.creePar = const Value.absent(),
    this.numero = const Value.absent(),
    required int annee,
    this.statut = const Value.absent(),
    required DateTime dateEmission,
    required DateTime dateEcheance,
    this.datePaiement = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.tauxTva = const Value.absent(),
    this.montantTva = const Value.absent(),
    this.tauxTps = const Value.absent(),
    this.montantTps = const Value.absent(),
    this.montantTtc = const Value.absent(),
    this.montantPaye = const Value.absent(),
    this.montantRestant = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.referencePaiement = const Value.absent(),
    this.objet = const Value.absent(),
    this.conditions = const Value.absent(),
    this.notes = const Value.absent(),
    this.motifAnnulation = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        clientId = Value(clientId),
        annee = Value(annee),
        dateEmission = Value(dateEmission),
        dateEcheance = Value(dateEcheance);
  static Insertable<Facture> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? dossierId,
    Expression<String>? clientId,
    Expression<String>? devisId,
    Expression<String>? creePar,
    Expression<String>? numero,
    Expression<int>? annee,
    Expression<String>? statut,
    Expression<DateTime>? dateEmission,
    Expression<DateTime>? dateEcheance,
    Expression<DateTime>? datePaiement,
    Expression<double>? montantHt,
    Expression<double>? tauxTva,
    Expression<double>? montantTva,
    Expression<double>? tauxTps,
    Expression<double>? montantTps,
    Expression<double>? montantTtc,
    Expression<double>? montantPaye,
    Expression<double>? montantRestant,
    Expression<String>? modePaiement,
    Expression<String>? referencePaiement,
    Expression<String>? objet,
    Expression<String>? conditions,
    Expression<String>? notes,
    Expression<String>? motifAnnulation,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (dossierId != null) 'dossier_id': dossierId,
      if (clientId != null) 'client_id': clientId,
      if (devisId != null) 'devis_id': devisId,
      if (creePar != null) 'cree_par': creePar,
      if (numero != null) 'numero': numero,
      if (annee != null) 'annee': annee,
      if (statut != null) 'statut': statut,
      if (dateEmission != null) 'date_emission': dateEmission,
      if (dateEcheance != null) 'date_echeance': dateEcheance,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (montantHt != null) 'montant_ht': montantHt,
      if (tauxTva != null) 'taux_tva': tauxTva,
      if (montantTva != null) 'montant_tva': montantTva,
      if (tauxTps != null) 'taux_tps': tauxTps,
      if (montantTps != null) 'montant_tps': montantTps,
      if (montantTtc != null) 'montant_ttc': montantTtc,
      if (montantPaye != null) 'montant_paye': montantPaye,
      if (montantRestant != null) 'montant_restant': montantRestant,
      if (modePaiement != null) 'mode_paiement': modePaiement,
      if (referencePaiement != null) 'reference_paiement': referencePaiement,
      if (objet != null) 'objet': objet,
      if (conditions != null) 'conditions': conditions,
      if (notes != null) 'notes': notes,
      if (motifAnnulation != null) 'motif_annulation': motifAnnulation,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FacturesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String?>? dossierId,
      Value<String>? clientId,
      Value<String?>? devisId,
      Value<String?>? creePar,
      Value<String?>? numero,
      Value<int>? annee,
      Value<String>? statut,
      Value<DateTime>? dateEmission,
      Value<DateTime>? dateEcheance,
      Value<DateTime?>? datePaiement,
      Value<double>? montantHt,
      Value<double>? tauxTva,
      Value<double>? montantTva,
      Value<double>? tauxTps,
      Value<double>? montantTps,
      Value<double>? montantTtc,
      Value<double>? montantPaye,
      Value<double>? montantRestant,
      Value<String?>? modePaiement,
      Value<String?>? referencePaiement,
      Value<String?>? objet,
      Value<String?>? conditions,
      Value<String?>? notes,
      Value<String?>? motifAnnulation,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FacturesCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      dossierId: dossierId ?? this.dossierId,
      clientId: clientId ?? this.clientId,
      devisId: devisId ?? this.devisId,
      creePar: creePar ?? this.creePar,
      numero: numero ?? this.numero,
      annee: annee ?? this.annee,
      statut: statut ?? this.statut,
      dateEmission: dateEmission ?? this.dateEmission,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      datePaiement: datePaiement ?? this.datePaiement,
      montantHt: montantHt ?? this.montantHt,
      tauxTva: tauxTva ?? this.tauxTva,
      montantTva: montantTva ?? this.montantTva,
      tauxTps: tauxTps ?? this.tauxTps,
      montantTps: montantTps ?? this.montantTps,
      montantTtc: montantTtc ?? this.montantTtc,
      montantPaye: montantPaye ?? this.montantPaye,
      montantRestant: montantRestant ?? this.montantRestant,
      modePaiement: modePaiement ?? this.modePaiement,
      referencePaiement: referencePaiement ?? this.referencePaiement,
      objet: objet ?? this.objet,
      conditions: conditions ?? this.conditions,
      notes: notes ?? this.notes,
      motifAnnulation: motifAnnulation ?? this.motifAnnulation,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (dossierId.present) {
      map['dossier_id'] = Variable<String>(dossierId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (devisId.present) {
      map['devis_id'] = Variable<String>(devisId.value);
    }
    if (creePar.present) {
      map['cree_par'] = Variable<String>(creePar.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (dateEmission.present) {
      map['date_emission'] = Variable<DateTime>(dateEmission.value);
    }
    if (dateEcheance.present) {
      map['date_echeance'] = Variable<DateTime>(dateEcheance.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<DateTime>(datePaiement.value);
    }
    if (montantHt.present) {
      map['montant_ht'] = Variable<double>(montantHt.value);
    }
    if (tauxTva.present) {
      map['taux_tva'] = Variable<double>(tauxTva.value);
    }
    if (montantTva.present) {
      map['montant_tva'] = Variable<double>(montantTva.value);
    }
    if (tauxTps.present) {
      map['taux_tps'] = Variable<double>(tauxTps.value);
    }
    if (montantTps.present) {
      map['montant_tps'] = Variable<double>(montantTps.value);
    }
    if (montantTtc.present) {
      map['montant_ttc'] = Variable<double>(montantTtc.value);
    }
    if (montantPaye.present) {
      map['montant_paye'] = Variable<double>(montantPaye.value);
    }
    if (montantRestant.present) {
      map['montant_restant'] = Variable<double>(montantRestant.value);
    }
    if (modePaiement.present) {
      map['mode_paiement'] = Variable<String>(modePaiement.value);
    }
    if (referencePaiement.present) {
      map['reference_paiement'] = Variable<String>(referencePaiement.value);
    }
    if (objet.present) {
      map['objet'] = Variable<String>(objet.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (motifAnnulation.present) {
      map['motif_annulation'] = Variable<String>(motifAnnulation.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturesCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('clientId: $clientId, ')
          ..write('devisId: $devisId, ')
          ..write('creePar: $creePar, ')
          ..write('numero: $numero, ')
          ..write('annee: $annee, ')
          ..write('statut: $statut, ')
          ..write('dateEmission: $dateEmission, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('montantHt: $montantHt, ')
          ..write('tauxTva: $tauxTva, ')
          ..write('montantTva: $montantTva, ')
          ..write('tauxTps: $tauxTps, ')
          ..write('montantTps: $montantTps, ')
          ..write('montantTtc: $montantTtc, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('montantRestant: $montantRestant, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('referencePaiement: $referencePaiement, ')
          ..write('objet: $objet, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('motifAnnulation: $motifAnnulation, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FacturesLignesTable extends FacturesLignes
    with TableInfo<$FacturesLignesTable, FacturesLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturesLignesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factureIdMeta =
      const VerificationMeta('factureId');
  @override
  late final GeneratedColumn<String> factureId = GeneratedColumn<String>(
      'facture_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
      'ordre', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _designationMeta =
      const VerificationMeta('designation');
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
      'designation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantiteMeta =
      const VerificationMeta('quantite');
  @override
  late final GeneratedColumn<double> quantite = GeneratedColumn<double>(
      'quantite', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _uniteMeta = const VerificationMeta('unite');
  @override
  late final GeneratedColumn<String> unite = GeneratedColumn<String>(
      'unite', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('forfait'));
  static const VerificationMeta _prixUnitMeta =
      const VerificationMeta('prixUnit');
  @override
  late final GeneratedColumn<double> prixUnit = GeneratedColumn<double>(
      'prix_unit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantHtMeta =
      const VerificationMeta('montantHt');
  @override
  late final GeneratedColumn<double> montantHt = GeneratedColumn<double>(
      'montant_ht', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxesJsonMeta =
      const VerificationMeta('taxesJson');
  @override
  late final GeneratedColumn<String> taxesJson = GeneratedColumn<String>(
      'taxes_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        factureId,
        ordre,
        designation,
        description,
        quantite,
        unite,
        prixUnit,
        montantHt,
        taxesJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factures_lignes';
  @override
  VerificationContext validateIntegrity(Insertable<FacturesLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('facture_id')) {
      context.handle(_factureIdMeta,
          factureId.isAcceptableOrUnknown(data['facture_id']!, _factureIdMeta));
    } else if (isInserting) {
      context.missing(_factureIdMeta);
    }
    if (data.containsKey('ordre')) {
      context.handle(
          _ordreMeta, ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta));
    }
    if (data.containsKey('designation')) {
      context.handle(
          _designationMeta,
          designation.isAcceptableOrUnknown(
              data['designation']!, _designationMeta));
    } else if (isInserting) {
      context.missing(_designationMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('quantite')) {
      context.handle(_quantiteMeta,
          quantite.isAcceptableOrUnknown(data['quantite']!, _quantiteMeta));
    }
    if (data.containsKey('unite')) {
      context.handle(
          _uniteMeta, unite.isAcceptableOrUnknown(data['unite']!, _uniteMeta));
    }
    if (data.containsKey('prix_unit')) {
      context.handle(_prixUnitMeta,
          prixUnit.isAcceptableOrUnknown(data['prix_unit']!, _prixUnitMeta));
    }
    if (data.containsKey('montant_ht')) {
      context.handle(_montantHtMeta,
          montantHt.isAcceptableOrUnknown(data['montant_ht']!, _montantHtMeta));
    }
    if (data.containsKey('taxes_json')) {
      context.handle(_taxesJsonMeta,
          taxesJson.isAcceptableOrUnknown(data['taxes_json']!, _taxesJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FacturesLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FacturesLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      factureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}facture_id'])!,
      ordre: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordre'])!,
      designation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      quantite: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantite'])!,
      unite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unite'])!,
      prixUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}prix_unit'])!,
      montantHt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_ht'])!,
      taxesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}taxes_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FacturesLignesTable createAlias(String alias) {
    return $FacturesLignesTable(attachedDatabase, alias);
  }
}

class FacturesLigne extends DataClass implements Insertable<FacturesLigne> {
  final String id;
  final String factureId;
  final int ordre;
  final String designation;
  final String? description;
  final double quantite;
  final String unite;
  final double prixUnit;
  final double montantHt;
  final String? taxesJson;
  final DateTime createdAt;
  const FacturesLigne(
      {required this.id,
      required this.factureId,
      required this.ordre,
      required this.designation,
      this.description,
      required this.quantite,
      required this.unite,
      required this.prixUnit,
      required this.montantHt,
      this.taxesJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['facture_id'] = Variable<String>(factureId);
    map['ordre'] = Variable<int>(ordre);
    map['designation'] = Variable<String>(designation);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['quantite'] = Variable<double>(quantite);
    map['unite'] = Variable<String>(unite);
    map['prix_unit'] = Variable<double>(prixUnit);
    map['montant_ht'] = Variable<double>(montantHt);
    if (!nullToAbsent || taxesJson != null) {
      map['taxes_json'] = Variable<String>(taxesJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FacturesLignesCompanion toCompanion(bool nullToAbsent) {
    return FacturesLignesCompanion(
      id: Value(id),
      factureId: Value(factureId),
      ordre: Value(ordre),
      designation: Value(designation),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      quantite: Value(quantite),
      unite: Value(unite),
      prixUnit: Value(prixUnit),
      montantHt: Value(montantHt),
      taxesJson: taxesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(taxesJson),
      createdAt: Value(createdAt),
    );
  }

  factory FacturesLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FacturesLigne(
      id: serializer.fromJson<String>(json['id']),
      factureId: serializer.fromJson<String>(json['factureId']),
      ordre: serializer.fromJson<int>(json['ordre']),
      designation: serializer.fromJson<String>(json['designation']),
      description: serializer.fromJson<String?>(json['description']),
      quantite: serializer.fromJson<double>(json['quantite']),
      unite: serializer.fromJson<String>(json['unite']),
      prixUnit: serializer.fromJson<double>(json['prixUnit']),
      montantHt: serializer.fromJson<double>(json['montantHt']),
      taxesJson: serializer.fromJson<String?>(json['taxesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'factureId': serializer.toJson<String>(factureId),
      'ordre': serializer.toJson<int>(ordre),
      'designation': serializer.toJson<String>(designation),
      'description': serializer.toJson<String?>(description),
      'quantite': serializer.toJson<double>(quantite),
      'unite': serializer.toJson<String>(unite),
      'prixUnit': serializer.toJson<double>(prixUnit),
      'montantHt': serializer.toJson<double>(montantHt),
      'taxesJson': serializer.toJson<String?>(taxesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FacturesLigne copyWith(
          {String? id,
          String? factureId,
          int? ordre,
          String? designation,
          Value<String?> description = const Value.absent(),
          double? quantite,
          String? unite,
          double? prixUnit,
          double? montantHt,
          Value<String?> taxesJson = const Value.absent(),
          DateTime? createdAt}) =>
      FacturesLigne(
        id: id ?? this.id,
        factureId: factureId ?? this.factureId,
        ordre: ordre ?? this.ordre,
        designation: designation ?? this.designation,
        description: description.present ? description.value : this.description,
        quantite: quantite ?? this.quantite,
        unite: unite ?? this.unite,
        prixUnit: prixUnit ?? this.prixUnit,
        montantHt: montantHt ?? this.montantHt,
        taxesJson: taxesJson.present ? taxesJson.value : this.taxesJson,
        createdAt: createdAt ?? this.createdAt,
      );
  FacturesLigne copyWithCompanion(FacturesLignesCompanion data) {
    return FacturesLigne(
      id: data.id.present ? data.id.value : this.id,
      factureId: data.factureId.present ? data.factureId.value : this.factureId,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
      designation:
          data.designation.present ? data.designation.value : this.designation,
      description:
          data.description.present ? data.description.value : this.description,
      quantite: data.quantite.present ? data.quantite.value : this.quantite,
      unite: data.unite.present ? data.unite.value : this.unite,
      prixUnit: data.prixUnit.present ? data.prixUnit.value : this.prixUnit,
      montantHt: data.montantHt.present ? data.montantHt.value : this.montantHt,
      taxesJson: data.taxesJson.present ? data.taxesJson.value : this.taxesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FacturesLigne(')
          ..write('id: $id, ')
          ..write('factureId: $factureId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('description: $description, ')
          ..write('quantite: $quantite, ')
          ..write('unite: $unite, ')
          ..write('prixUnit: $prixUnit, ')
          ..write('montantHt: $montantHt, ')
          ..write('taxesJson: $taxesJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, factureId, ordre, designation,
      description, quantite, unite, prixUnit, montantHt, taxesJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FacturesLigne &&
          other.id == this.id &&
          other.factureId == this.factureId &&
          other.ordre == this.ordre &&
          other.designation == this.designation &&
          other.description == this.description &&
          other.quantite == this.quantite &&
          other.unite == this.unite &&
          other.prixUnit == this.prixUnit &&
          other.montantHt == this.montantHt &&
          other.taxesJson == this.taxesJson &&
          other.createdAt == this.createdAt);
}

class FacturesLignesCompanion extends UpdateCompanion<FacturesLigne> {
  final Value<String> id;
  final Value<String> factureId;
  final Value<int> ordre;
  final Value<String> designation;
  final Value<String?> description;
  final Value<double> quantite;
  final Value<String> unite;
  final Value<double> prixUnit;
  final Value<double> montantHt;
  final Value<String?> taxesJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FacturesLignesCompanion({
    this.id = const Value.absent(),
    this.factureId = const Value.absent(),
    this.ordre = const Value.absent(),
    this.designation = const Value.absent(),
    this.description = const Value.absent(),
    this.quantite = const Value.absent(),
    this.unite = const Value.absent(),
    this.prixUnit = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.taxesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FacturesLignesCompanion.insert({
    required String id,
    required String factureId,
    this.ordre = const Value.absent(),
    required String designation,
    this.description = const Value.absent(),
    this.quantite = const Value.absent(),
    this.unite = const Value.absent(),
    this.prixUnit = const Value.absent(),
    this.montantHt = const Value.absent(),
    this.taxesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        factureId = Value(factureId),
        designation = Value(designation);
  static Insertable<FacturesLigne> custom({
    Expression<String>? id,
    Expression<String>? factureId,
    Expression<int>? ordre,
    Expression<String>? designation,
    Expression<String>? description,
    Expression<double>? quantite,
    Expression<String>? unite,
    Expression<double>? prixUnit,
    Expression<double>? montantHt,
    Expression<String>? taxesJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (factureId != null) 'facture_id': factureId,
      if (ordre != null) 'ordre': ordre,
      if (designation != null) 'designation': designation,
      if (description != null) 'description': description,
      if (quantite != null) 'quantite': quantite,
      if (unite != null) 'unite': unite,
      if (prixUnit != null) 'prix_unit': prixUnit,
      if (montantHt != null) 'montant_ht': montantHt,
      if (taxesJson != null) 'taxes_json': taxesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FacturesLignesCompanion copyWith(
      {Value<String>? id,
      Value<String>? factureId,
      Value<int>? ordre,
      Value<String>? designation,
      Value<String?>? description,
      Value<double>? quantite,
      Value<String>? unite,
      Value<double>? prixUnit,
      Value<double>? montantHt,
      Value<String?>? taxesJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FacturesLignesCompanion(
      id: id ?? this.id,
      factureId: factureId ?? this.factureId,
      ordre: ordre ?? this.ordre,
      designation: designation ?? this.designation,
      description: description ?? this.description,
      quantite: quantite ?? this.quantite,
      unite: unite ?? this.unite,
      prixUnit: prixUnit ?? this.prixUnit,
      montantHt: montantHt ?? this.montantHt,
      taxesJson: taxesJson ?? this.taxesJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (factureId.present) {
      map['facture_id'] = Variable<String>(factureId.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quantite.present) {
      map['quantite'] = Variable<double>(quantite.value);
    }
    if (unite.present) {
      map['unite'] = Variable<String>(unite.value);
    }
    if (prixUnit.present) {
      map['prix_unit'] = Variable<double>(prixUnit.value);
    }
    if (montantHt.present) {
      map['montant_ht'] = Variable<double>(montantHt.value);
    }
    if (taxesJson.present) {
      map['taxes_json'] = Variable<String>(taxesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturesLignesCompanion(')
          ..write('id: $id, ')
          ..write('factureId: $factureId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('description: $description, ')
          ..write('quantite: $quantite, ')
          ..write('unite: $unite, ')
          ..write('prixUnit: $prixUnit, ')
          ..write('montantHt: $montantHt, ')
          ..write('taxesJson: $taxesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChargesTable extends Charges with TableInfo<$ChargesTable, Charge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dossierIdMeta =
      const VerificationMeta('dossierId');
  @override
  late final GeneratedColumn<String> dossierId = GeneratedColumn<String>(
      'dossier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saisiParMeta =
      const VerificationMeta('saisiPar');
  @override
  late final GeneratedColumn<String> saisiPar = GeneratedColumn<String>(
      'saisi_par', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categorieMeta =
      const VerificationMeta('categorie');
  @override
  late final GeneratedColumn<String> categorie = GeneratedColumn<String>(
      'categorie', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _libelleMeta =
      const VerificationMeta('libelle');
  @override
  late final GeneratedColumn<String> libelle = GeneratedColumn<String>(
      'libelle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montantMeta =
      const VerificationMeta('montant');
  @override
  late final GeneratedColumn<double> montant = GeneratedColumn<double>(
      'montant', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateChargeMeta =
      const VerificationMeta('dateCharge');
  @override
  late final GeneratedColumn<DateTime> dateCharge = GeneratedColumn<DateTime>(
      'date_charge', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _moisMeta = const VerificationMeta('mois');
  @override
  late final GeneratedColumn<int> mois = GeneratedColumn<int>(
      'mois', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _justificatifUrlMeta =
      const VerificationMeta('justificatifUrl');
  @override
  late final GeneratedColumn<String> justificatifUrl = GeneratedColumn<String>(
      'justificatif_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        dossierId,
        saisiPar,
        categorie,
        libelle,
        montant,
        dateCharge,
        mois,
        annee,
        justificatifUrl,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charges';
  @override
  VerificationContext validateIntegrity(Insertable<Charge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('dossier_id')) {
      context.handle(_dossierIdMeta,
          dossierId.isAcceptableOrUnknown(data['dossier_id']!, _dossierIdMeta));
    }
    if (data.containsKey('saisi_par')) {
      context.handle(_saisiParMeta,
          saisiPar.isAcceptableOrUnknown(data['saisi_par']!, _saisiParMeta));
    }
    if (data.containsKey('categorie')) {
      context.handle(_categorieMeta,
          categorie.isAcceptableOrUnknown(data['categorie']!, _categorieMeta));
    } else if (isInserting) {
      context.missing(_categorieMeta);
    }
    if (data.containsKey('libelle')) {
      context.handle(_libelleMeta,
          libelle.isAcceptableOrUnknown(data['libelle']!, _libelleMeta));
    } else if (isInserting) {
      context.missing(_libelleMeta);
    }
    if (data.containsKey('montant')) {
      context.handle(_montantMeta,
          montant.isAcceptableOrUnknown(data['montant']!, _montantMeta));
    } else if (isInserting) {
      context.missing(_montantMeta);
    }
    if (data.containsKey('date_charge')) {
      context.handle(
          _dateChargeMeta,
          dateCharge.isAcceptableOrUnknown(
              data['date_charge']!, _dateChargeMeta));
    } else if (isInserting) {
      context.missing(_dateChargeMeta);
    }
    if (data.containsKey('mois')) {
      context.handle(
          _moisMeta, mois.isAcceptableOrUnknown(data['mois']!, _moisMeta));
    } else if (isInserting) {
      context.missing(_moisMeta);
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('justificatif_url')) {
      context.handle(
          _justificatifUrlMeta,
          justificatifUrl.isAcceptableOrUnknown(
              data['justificatif_url']!, _justificatifUrlMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Charge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Charge(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      dossierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dossier_id']),
      saisiPar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}saisi_par']),
      categorie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categorie'])!,
      libelle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}libelle'])!,
      montant: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant'])!,
      dateCharge: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_charge'])!,
      mois: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mois'])!,
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      justificatifUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}justificatif_url']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChargesTable createAlias(String alias) {
    return $ChargesTable(attachedDatabase, alias);
  }
}

class Charge extends DataClass implements Insertable<Charge> {
  final String id;
  final String entrepriseId;
  final String? dossierId;
  final String? saisiPar;
  final String categorie;
  final String libelle;
  final double montant;
  final DateTime dateCharge;
  final int mois;
  final int annee;
  final String? justificatifUrl;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Charge(
      {required this.id,
      required this.entrepriseId,
      this.dossierId,
      this.saisiPar,
      required this.categorie,
      required this.libelle,
      required this.montant,
      required this.dateCharge,
      required this.mois,
      required this.annee,
      this.justificatifUrl,
      this.notes,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    if (!nullToAbsent || dossierId != null) {
      map['dossier_id'] = Variable<String>(dossierId);
    }
    if (!nullToAbsent || saisiPar != null) {
      map['saisi_par'] = Variable<String>(saisiPar);
    }
    map['categorie'] = Variable<String>(categorie);
    map['libelle'] = Variable<String>(libelle);
    map['montant'] = Variable<double>(montant);
    map['date_charge'] = Variable<DateTime>(dateCharge);
    map['mois'] = Variable<int>(mois);
    map['annee'] = Variable<int>(annee);
    if (!nullToAbsent || justificatifUrl != null) {
      map['justificatif_url'] = Variable<String>(justificatifUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChargesCompanion toCompanion(bool nullToAbsent) {
    return ChargesCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      dossierId: dossierId == null && nullToAbsent
          ? const Value.absent()
          : Value(dossierId),
      saisiPar: saisiPar == null && nullToAbsent
          ? const Value.absent()
          : Value(saisiPar),
      categorie: Value(categorie),
      libelle: Value(libelle),
      montant: Value(montant),
      dateCharge: Value(dateCharge),
      mois: Value(mois),
      annee: Value(annee),
      justificatifUrl: justificatifUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(justificatifUrl),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Charge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Charge(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      dossierId: serializer.fromJson<String?>(json['dossierId']),
      saisiPar: serializer.fromJson<String?>(json['saisiPar']),
      categorie: serializer.fromJson<String>(json['categorie']),
      libelle: serializer.fromJson<String>(json['libelle']),
      montant: serializer.fromJson<double>(json['montant']),
      dateCharge: serializer.fromJson<DateTime>(json['dateCharge']),
      mois: serializer.fromJson<int>(json['mois']),
      annee: serializer.fromJson<int>(json['annee']),
      justificatifUrl: serializer.fromJson<String?>(json['justificatifUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'dossierId': serializer.toJson<String?>(dossierId),
      'saisiPar': serializer.toJson<String?>(saisiPar),
      'categorie': serializer.toJson<String>(categorie),
      'libelle': serializer.toJson<String>(libelle),
      'montant': serializer.toJson<double>(montant),
      'dateCharge': serializer.toJson<DateTime>(dateCharge),
      'mois': serializer.toJson<int>(mois),
      'annee': serializer.toJson<int>(annee),
      'justificatifUrl': serializer.toJson<String?>(justificatifUrl),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Charge copyWith(
          {String? id,
          String? entrepriseId,
          Value<String?> dossierId = const Value.absent(),
          Value<String?> saisiPar = const Value.absent(),
          String? categorie,
          String? libelle,
          double? montant,
          DateTime? dateCharge,
          int? mois,
          int? annee,
          Value<String?> justificatifUrl = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Charge(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        dossierId: dossierId.present ? dossierId.value : this.dossierId,
        saisiPar: saisiPar.present ? saisiPar.value : this.saisiPar,
        categorie: categorie ?? this.categorie,
        libelle: libelle ?? this.libelle,
        montant: montant ?? this.montant,
        dateCharge: dateCharge ?? this.dateCharge,
        mois: mois ?? this.mois,
        annee: annee ?? this.annee,
        justificatifUrl: justificatifUrl.present
            ? justificatifUrl.value
            : this.justificatifUrl,
        notes: notes.present ? notes.value : this.notes,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Charge copyWithCompanion(ChargesCompanion data) {
    return Charge(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      dossierId: data.dossierId.present ? data.dossierId.value : this.dossierId,
      saisiPar: data.saisiPar.present ? data.saisiPar.value : this.saisiPar,
      categorie: data.categorie.present ? data.categorie.value : this.categorie,
      libelle: data.libelle.present ? data.libelle.value : this.libelle,
      montant: data.montant.present ? data.montant.value : this.montant,
      dateCharge:
          data.dateCharge.present ? data.dateCharge.value : this.dateCharge,
      mois: data.mois.present ? data.mois.value : this.mois,
      annee: data.annee.present ? data.annee.value : this.annee,
      justificatifUrl: data.justificatifUrl.present
          ? data.justificatifUrl.value
          : this.justificatifUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Charge(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('saisiPar: $saisiPar, ')
          ..write('categorie: $categorie, ')
          ..write('libelle: $libelle, ')
          ..write('montant: $montant, ')
          ..write('dateCharge: $dateCharge, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('justificatifUrl: $justificatifUrl, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entrepriseId,
      dossierId,
      saisiPar,
      categorie,
      libelle,
      montant,
      dateCharge,
      mois,
      annee,
      justificatifUrl,
      notes,
      syncStatus,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Charge &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.dossierId == this.dossierId &&
          other.saisiPar == this.saisiPar &&
          other.categorie == this.categorie &&
          other.libelle == this.libelle &&
          other.montant == this.montant &&
          other.dateCharge == this.dateCharge &&
          other.mois == this.mois &&
          other.annee == this.annee &&
          other.justificatifUrl == this.justificatifUrl &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChargesCompanion extends UpdateCompanion<Charge> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String?> dossierId;
  final Value<String?> saisiPar;
  final Value<String> categorie;
  final Value<String> libelle;
  final Value<double> montant;
  final Value<DateTime> dateCharge;
  final Value<int> mois;
  final Value<int> annee;
  final Value<String?> justificatifUrl;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChargesCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.dossierId = const Value.absent(),
    this.saisiPar = const Value.absent(),
    this.categorie = const Value.absent(),
    this.libelle = const Value.absent(),
    this.montant = const Value.absent(),
    this.dateCharge = const Value.absent(),
    this.mois = const Value.absent(),
    this.annee = const Value.absent(),
    this.justificatifUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChargesCompanion.insert({
    required String id,
    required String entrepriseId,
    this.dossierId = const Value.absent(),
    this.saisiPar = const Value.absent(),
    required String categorie,
    required String libelle,
    required double montant,
    required DateTime dateCharge,
    required int mois,
    required int annee,
    this.justificatifUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        categorie = Value(categorie),
        libelle = Value(libelle),
        montant = Value(montant),
        dateCharge = Value(dateCharge),
        mois = Value(mois),
        annee = Value(annee);
  static Insertable<Charge> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? dossierId,
    Expression<String>? saisiPar,
    Expression<String>? categorie,
    Expression<String>? libelle,
    Expression<double>? montant,
    Expression<DateTime>? dateCharge,
    Expression<int>? mois,
    Expression<int>? annee,
    Expression<String>? justificatifUrl,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (dossierId != null) 'dossier_id': dossierId,
      if (saisiPar != null) 'saisi_par': saisiPar,
      if (categorie != null) 'categorie': categorie,
      if (libelle != null) 'libelle': libelle,
      if (montant != null) 'montant': montant,
      if (dateCharge != null) 'date_charge': dateCharge,
      if (mois != null) 'mois': mois,
      if (annee != null) 'annee': annee,
      if (justificatifUrl != null) 'justificatif_url': justificatifUrl,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChargesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String?>? dossierId,
      Value<String?>? saisiPar,
      Value<String>? categorie,
      Value<String>? libelle,
      Value<double>? montant,
      Value<DateTime>? dateCharge,
      Value<int>? mois,
      Value<int>? annee,
      Value<String?>? justificatifUrl,
      Value<String?>? notes,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChargesCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      dossierId: dossierId ?? this.dossierId,
      saisiPar: saisiPar ?? this.saisiPar,
      categorie: categorie ?? this.categorie,
      libelle: libelle ?? this.libelle,
      montant: montant ?? this.montant,
      dateCharge: dateCharge ?? this.dateCharge,
      mois: mois ?? this.mois,
      annee: annee ?? this.annee,
      justificatifUrl: justificatifUrl ?? this.justificatifUrl,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (dossierId.present) {
      map['dossier_id'] = Variable<String>(dossierId.value);
    }
    if (saisiPar.present) {
      map['saisi_par'] = Variable<String>(saisiPar.value);
    }
    if (categorie.present) {
      map['categorie'] = Variable<String>(categorie.value);
    }
    if (libelle.present) {
      map['libelle'] = Variable<String>(libelle.value);
    }
    if (montant.present) {
      map['montant'] = Variable<double>(montant.value);
    }
    if (dateCharge.present) {
      map['date_charge'] = Variable<DateTime>(dateCharge.value);
    }
    if (mois.present) {
      map['mois'] = Variable<int>(mois.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (justificatifUrl.present) {
      map['justificatif_url'] = Variable<String>(justificatifUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargesCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('dossierId: $dossierId, ')
          ..write('saisiPar: $saisiPar, ')
          ..write('categorie: $categorie, ')
          ..write('libelle: $libelle, ')
          ..write('montant: $montant, ')
          ..write('dateCharge: $dateCharge, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('justificatifUrl: $justificatifUrl, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChargesModelesTable extends ChargesModeles
    with TableInfo<$ChargesModelesTable, ChargesModele> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargesModelesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moisMeta = const VerificationMeta('mois');
  @override
  late final GeneratedColumn<int> mois = GeneratedColumn<int>(
      'mois', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
      'titre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _soumisParIdMeta =
      const VerificationMeta('soumisParId');
  @override
  late final GeneratedColumn<String> soumisParId = GeneratedColumn<String>(
      'soumis_par_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _soumisParNomMeta =
      const VerificationMeta('soumisParNom');
  @override
  late final GeneratedColumn<String> soumisParNom = GeneratedColumn<String>(
      'soumis_par_nom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('brouillon'));
  static const VerificationMeta _motifRefusMeta =
      const VerificationMeta('motifRefus');
  @override
  late final GeneratedColumn<String> motifRefus = GeneratedColumn<String>(
      'motif_refus', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateSubmissionMeta =
      const VerificationMeta('dateSubmission');
  @override
  late final GeneratedColumn<DateTime> dateSubmission =
      GeneratedColumn<DateTime>('date_submission', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateValidationMeta =
      const VerificationMeta('dateValidation');
  @override
  late final GeneratedColumn<DateTime> dateValidation =
      GeneratedColumn<DateTime>('date_validation', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _valideParIdMeta =
      const VerificationMeta('valideParId');
  @override
  late final GeneratedColumn<String> valideParId = GeneratedColumn<String>(
      'valide_par_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _valideParNomMeta =
      const VerificationMeta('valideParNom');
  @override
  late final GeneratedColumn<String> valideParNom = GeneratedColumn<String>(
      'valide_par_nom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        mois,
        annee,
        titre,
        soumisParId,
        soumisParNom,
        statut,
        motifRefus,
        dateSubmission,
        dateValidation,
        valideParId,
        valideParNom,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charges_modeles';
  @override
  VerificationContext validateIntegrity(Insertable<ChargesModele> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('mois')) {
      context.handle(
          _moisMeta, mois.isAcceptableOrUnknown(data['mois']!, _moisMeta));
    } else if (isInserting) {
      context.missing(_moisMeta);
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('titre')) {
      context.handle(
          _titreMeta, titre.isAcceptableOrUnknown(data['titre']!, _titreMeta));
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('soumis_par_id')) {
      context.handle(
          _soumisParIdMeta,
          soumisParId.isAcceptableOrUnknown(
              data['soumis_par_id']!, _soumisParIdMeta));
    }
    if (data.containsKey('soumis_par_nom')) {
      context.handle(
          _soumisParNomMeta,
          soumisParNom.isAcceptableOrUnknown(
              data['soumis_par_nom']!, _soumisParNomMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('motif_refus')) {
      context.handle(
          _motifRefusMeta,
          motifRefus.isAcceptableOrUnknown(
              data['motif_refus']!, _motifRefusMeta));
    }
    if (data.containsKey('date_submission')) {
      context.handle(
          _dateSubmissionMeta,
          dateSubmission.isAcceptableOrUnknown(
              data['date_submission']!, _dateSubmissionMeta));
    }
    if (data.containsKey('date_validation')) {
      context.handle(
          _dateValidationMeta,
          dateValidation.isAcceptableOrUnknown(
              data['date_validation']!, _dateValidationMeta));
    }
    if (data.containsKey('valide_par_id')) {
      context.handle(
          _valideParIdMeta,
          valideParId.isAcceptableOrUnknown(
              data['valide_par_id']!, _valideParIdMeta));
    }
    if (data.containsKey('valide_par_nom')) {
      context.handle(
          _valideParNomMeta,
          valideParNom.isAcceptableOrUnknown(
              data['valide_par_nom']!, _valideParNomMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChargesModele map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargesModele(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      mois: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mois'])!,
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      titre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titre'])!,
      soumisParId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}soumis_par_id']),
      soumisParNom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}soumis_par_nom']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      motifRefus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motif_refus']),
      dateSubmission: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_submission']),
      dateValidation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_validation']),
      valideParId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valide_par_id']),
      valideParNom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valide_par_nom']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChargesModelesTable createAlias(String alias) {
    return $ChargesModelesTable(attachedDatabase, alias);
  }
}

class ChargesModele extends DataClass implements Insertable<ChargesModele> {
  final String id;
  final String entrepriseId;
  final int mois;
  final int annee;
  final String titre;
  final String? soumisParId;
  final String? soumisParNom;
  final String statut;
  final String? motifRefus;
  final DateTime? dateSubmission;
  final DateTime? dateValidation;
  final String? valideParId;
  final String? valideParNom;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChargesModele(
      {required this.id,
      required this.entrepriseId,
      required this.mois,
      required this.annee,
      required this.titre,
      this.soumisParId,
      this.soumisParNom,
      required this.statut,
      this.motifRefus,
      this.dateSubmission,
      this.dateValidation,
      this.valideParId,
      this.valideParNom,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    map['mois'] = Variable<int>(mois);
    map['annee'] = Variable<int>(annee);
    map['titre'] = Variable<String>(titre);
    if (!nullToAbsent || soumisParId != null) {
      map['soumis_par_id'] = Variable<String>(soumisParId);
    }
    if (!nullToAbsent || soumisParNom != null) {
      map['soumis_par_nom'] = Variable<String>(soumisParNom);
    }
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || motifRefus != null) {
      map['motif_refus'] = Variable<String>(motifRefus);
    }
    if (!nullToAbsent || dateSubmission != null) {
      map['date_submission'] = Variable<DateTime>(dateSubmission);
    }
    if (!nullToAbsent || dateValidation != null) {
      map['date_validation'] = Variable<DateTime>(dateValidation);
    }
    if (!nullToAbsent || valideParId != null) {
      map['valide_par_id'] = Variable<String>(valideParId);
    }
    if (!nullToAbsent || valideParNom != null) {
      map['valide_par_nom'] = Variable<String>(valideParNom);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChargesModelesCompanion toCompanion(bool nullToAbsent) {
    return ChargesModelesCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      mois: Value(mois),
      annee: Value(annee),
      titre: Value(titre),
      soumisParId: soumisParId == null && nullToAbsent
          ? const Value.absent()
          : Value(soumisParId),
      soumisParNom: soumisParNom == null && nullToAbsent
          ? const Value.absent()
          : Value(soumisParNom),
      statut: Value(statut),
      motifRefus: motifRefus == null && nullToAbsent
          ? const Value.absent()
          : Value(motifRefus),
      dateSubmission: dateSubmission == null && nullToAbsent
          ? const Value.absent()
          : Value(dateSubmission),
      dateValidation: dateValidation == null && nullToAbsent
          ? const Value.absent()
          : Value(dateValidation),
      valideParId: valideParId == null && nullToAbsent
          ? const Value.absent()
          : Value(valideParId),
      valideParNom: valideParNom == null && nullToAbsent
          ? const Value.absent()
          : Value(valideParNom),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChargesModele.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargesModele(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      mois: serializer.fromJson<int>(json['mois']),
      annee: serializer.fromJson<int>(json['annee']),
      titre: serializer.fromJson<String>(json['titre']),
      soumisParId: serializer.fromJson<String?>(json['soumisParId']),
      soumisParNom: serializer.fromJson<String?>(json['soumisParNom']),
      statut: serializer.fromJson<String>(json['statut']),
      motifRefus: serializer.fromJson<String?>(json['motifRefus']),
      dateSubmission: serializer.fromJson<DateTime?>(json['dateSubmission']),
      dateValidation: serializer.fromJson<DateTime?>(json['dateValidation']),
      valideParId: serializer.fromJson<String?>(json['valideParId']),
      valideParNom: serializer.fromJson<String?>(json['valideParNom']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'mois': serializer.toJson<int>(mois),
      'annee': serializer.toJson<int>(annee),
      'titre': serializer.toJson<String>(titre),
      'soumisParId': serializer.toJson<String?>(soumisParId),
      'soumisParNom': serializer.toJson<String?>(soumisParNom),
      'statut': serializer.toJson<String>(statut),
      'motifRefus': serializer.toJson<String?>(motifRefus),
      'dateSubmission': serializer.toJson<DateTime?>(dateSubmission),
      'dateValidation': serializer.toJson<DateTime?>(dateValidation),
      'valideParId': serializer.toJson<String?>(valideParId),
      'valideParNom': serializer.toJson<String?>(valideParNom),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChargesModele copyWith(
          {String? id,
          String? entrepriseId,
          int? mois,
          int? annee,
          String? titre,
          Value<String?> soumisParId = const Value.absent(),
          Value<String?> soumisParNom = const Value.absent(),
          String? statut,
          Value<String?> motifRefus = const Value.absent(),
          Value<DateTime?> dateSubmission = const Value.absent(),
          Value<DateTime?> dateValidation = const Value.absent(),
          Value<String?> valideParId = const Value.absent(),
          Value<String?> valideParNom = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ChargesModele(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        mois: mois ?? this.mois,
        annee: annee ?? this.annee,
        titre: titre ?? this.titre,
        soumisParId: soumisParId.present ? soumisParId.value : this.soumisParId,
        soumisParNom:
            soumisParNom.present ? soumisParNom.value : this.soumisParNom,
        statut: statut ?? this.statut,
        motifRefus: motifRefus.present ? motifRefus.value : this.motifRefus,
        dateSubmission:
            dateSubmission.present ? dateSubmission.value : this.dateSubmission,
        dateValidation:
            dateValidation.present ? dateValidation.value : this.dateValidation,
        valideParId: valideParId.present ? valideParId.value : this.valideParId,
        valideParNom:
            valideParNom.present ? valideParNom.value : this.valideParNom,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ChargesModele copyWithCompanion(ChargesModelesCompanion data) {
    return ChargesModele(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      mois: data.mois.present ? data.mois.value : this.mois,
      annee: data.annee.present ? data.annee.value : this.annee,
      titre: data.titre.present ? data.titre.value : this.titre,
      soumisParId:
          data.soumisParId.present ? data.soumisParId.value : this.soumisParId,
      soumisParNom: data.soumisParNom.present
          ? data.soumisParNom.value
          : this.soumisParNom,
      statut: data.statut.present ? data.statut.value : this.statut,
      motifRefus:
          data.motifRefus.present ? data.motifRefus.value : this.motifRefus,
      dateSubmission: data.dateSubmission.present
          ? data.dateSubmission.value
          : this.dateSubmission,
      dateValidation: data.dateValidation.present
          ? data.dateValidation.value
          : this.dateValidation,
      valideParId:
          data.valideParId.present ? data.valideParId.value : this.valideParId,
      valideParNom: data.valideParNom.present
          ? data.valideParNom.value
          : this.valideParNom,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChargesModele(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('titre: $titre, ')
          ..write('soumisParId: $soumisParId, ')
          ..write('soumisParNom: $soumisParNom, ')
          ..write('statut: $statut, ')
          ..write('motifRefus: $motifRefus, ')
          ..write('dateSubmission: $dateSubmission, ')
          ..write('dateValidation: $dateValidation, ')
          ..write('valideParId: $valideParId, ')
          ..write('valideParNom: $valideParNom, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entrepriseId,
      mois,
      annee,
      titre,
      soumisParId,
      soumisParNom,
      statut,
      motifRefus,
      dateSubmission,
      dateValidation,
      valideParId,
      valideParNom,
      syncStatus,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargesModele &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.mois == this.mois &&
          other.annee == this.annee &&
          other.titre == this.titre &&
          other.soumisParId == this.soumisParId &&
          other.soumisParNom == this.soumisParNom &&
          other.statut == this.statut &&
          other.motifRefus == this.motifRefus &&
          other.dateSubmission == this.dateSubmission &&
          other.dateValidation == this.dateValidation &&
          other.valideParId == this.valideParId &&
          other.valideParNom == this.valideParNom &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChargesModelesCompanion extends UpdateCompanion<ChargesModele> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<int> mois;
  final Value<int> annee;
  final Value<String> titre;
  final Value<String?> soumisParId;
  final Value<String?> soumisParNom;
  final Value<String> statut;
  final Value<String?> motifRefus;
  final Value<DateTime?> dateSubmission;
  final Value<DateTime?> dateValidation;
  final Value<String?> valideParId;
  final Value<String?> valideParNom;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChargesModelesCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.mois = const Value.absent(),
    this.annee = const Value.absent(),
    this.titre = const Value.absent(),
    this.soumisParId = const Value.absent(),
    this.soumisParNom = const Value.absent(),
    this.statut = const Value.absent(),
    this.motifRefus = const Value.absent(),
    this.dateSubmission = const Value.absent(),
    this.dateValidation = const Value.absent(),
    this.valideParId = const Value.absent(),
    this.valideParNom = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChargesModelesCompanion.insert({
    required String id,
    required String entrepriseId,
    required int mois,
    required int annee,
    required String titre,
    this.soumisParId = const Value.absent(),
    this.soumisParNom = const Value.absent(),
    this.statut = const Value.absent(),
    this.motifRefus = const Value.absent(),
    this.dateSubmission = const Value.absent(),
    this.dateValidation = const Value.absent(),
    this.valideParId = const Value.absent(),
    this.valideParNom = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        mois = Value(mois),
        annee = Value(annee),
        titre = Value(titre);
  static Insertable<ChargesModele> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<int>? mois,
    Expression<int>? annee,
    Expression<String>? titre,
    Expression<String>? soumisParId,
    Expression<String>? soumisParNom,
    Expression<String>? statut,
    Expression<String>? motifRefus,
    Expression<DateTime>? dateSubmission,
    Expression<DateTime>? dateValidation,
    Expression<String>? valideParId,
    Expression<String>? valideParNom,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (mois != null) 'mois': mois,
      if (annee != null) 'annee': annee,
      if (titre != null) 'titre': titre,
      if (soumisParId != null) 'soumis_par_id': soumisParId,
      if (soumisParNom != null) 'soumis_par_nom': soumisParNom,
      if (statut != null) 'statut': statut,
      if (motifRefus != null) 'motif_refus': motifRefus,
      if (dateSubmission != null) 'date_submission': dateSubmission,
      if (dateValidation != null) 'date_validation': dateValidation,
      if (valideParId != null) 'valide_par_id': valideParId,
      if (valideParNom != null) 'valide_par_nom': valideParNom,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChargesModelesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<int>? mois,
      Value<int>? annee,
      Value<String>? titre,
      Value<String?>? soumisParId,
      Value<String?>? soumisParNom,
      Value<String>? statut,
      Value<String?>? motifRefus,
      Value<DateTime?>? dateSubmission,
      Value<DateTime?>? dateValidation,
      Value<String?>? valideParId,
      Value<String?>? valideParNom,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChargesModelesCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      mois: mois ?? this.mois,
      annee: annee ?? this.annee,
      titre: titre ?? this.titre,
      soumisParId: soumisParId ?? this.soumisParId,
      soumisParNom: soumisParNom ?? this.soumisParNom,
      statut: statut ?? this.statut,
      motifRefus: motifRefus ?? this.motifRefus,
      dateSubmission: dateSubmission ?? this.dateSubmission,
      dateValidation: dateValidation ?? this.dateValidation,
      valideParId: valideParId ?? this.valideParId,
      valideParNom: valideParNom ?? this.valideParNom,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (mois.present) {
      map['mois'] = Variable<int>(mois.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (soumisParId.present) {
      map['soumis_par_id'] = Variable<String>(soumisParId.value);
    }
    if (soumisParNom.present) {
      map['soumis_par_nom'] = Variable<String>(soumisParNom.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (motifRefus.present) {
      map['motif_refus'] = Variable<String>(motifRefus.value);
    }
    if (dateSubmission.present) {
      map['date_submission'] = Variable<DateTime>(dateSubmission.value);
    }
    if (dateValidation.present) {
      map['date_validation'] = Variable<DateTime>(dateValidation.value);
    }
    if (valideParId.present) {
      map['valide_par_id'] = Variable<String>(valideParId.value);
    }
    if (valideParNom.present) {
      map['valide_par_nom'] = Variable<String>(valideParNom.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargesModelesCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('titre: $titre, ')
          ..write('soumisParId: $soumisParId, ')
          ..write('soumisParNom: $soumisParNom, ')
          ..write('statut: $statut, ')
          ..write('motifRefus: $motifRefus, ')
          ..write('dateSubmission: $dateSubmission, ')
          ..write('dateValidation: $dateValidation, ')
          ..write('valideParId: $valideParId, ')
          ..write('valideParNom: $valideParNom, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChargesModeleLinesTable extends ChargesModeleLines
    with TableInfo<$ChargesModeleLinesTable, ChargesModeleLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargesModeleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeleIdMeta =
      const VerificationMeta('modeleId');
  @override
  late final GeneratedColumn<String> modeleId = GeneratedColumn<String>(
      'modele_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
      'ordre', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _designationMeta =
      const VerificationMeta('designation');
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
      'designation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montantMeta =
      const VerificationMeta('montant');
  @override
  late final GeneratedColumn<double> montant = GeneratedColumn<double>(
      'montant', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateEcheanceMeta =
      const VerificationMeta('dateEcheance');
  @override
  late final GeneratedColumn<DateTime> dateEcheance = GeneratedColumn<DateTime>(
      'date_echeance', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _prioriteMeta =
      const VerificationMeta('priorite');
  @override
  late final GeneratedColumn<String> priorite = GeneratedColumn<String>(
      'priorite', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normale'));
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _motifRefusMeta =
      const VerificationMeta('motifRefus');
  @override
  late final GeneratedColumn<String> motifRefus = GeneratedColumn<String>(
      'motif_refus', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        modeleId,
        ordre,
        designation,
        montant,
        dateEcheance,
        priorite,
        statut,
        motifRefus,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charges_modele_lines';
  @override
  VerificationContext validateIntegrity(Insertable<ChargesModeleLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('modele_id')) {
      context.handle(_modeleIdMeta,
          modeleId.isAcceptableOrUnknown(data['modele_id']!, _modeleIdMeta));
    } else if (isInserting) {
      context.missing(_modeleIdMeta);
    }
    if (data.containsKey('ordre')) {
      context.handle(
          _ordreMeta, ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta));
    }
    if (data.containsKey('designation')) {
      context.handle(
          _designationMeta,
          designation.isAcceptableOrUnknown(
              data['designation']!, _designationMeta));
    } else if (isInserting) {
      context.missing(_designationMeta);
    }
    if (data.containsKey('montant')) {
      context.handle(_montantMeta,
          montant.isAcceptableOrUnknown(data['montant']!, _montantMeta));
    }
    if (data.containsKey('date_echeance')) {
      context.handle(
          _dateEcheanceMeta,
          dateEcheance.isAcceptableOrUnknown(
              data['date_echeance']!, _dateEcheanceMeta));
    }
    if (data.containsKey('priorite')) {
      context.handle(_prioriteMeta,
          priorite.isAcceptableOrUnknown(data['priorite']!, _prioriteMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('motif_refus')) {
      context.handle(
          _motifRefusMeta,
          motifRefus.isAcceptableOrUnknown(
              data['motif_refus']!, _motifRefusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChargesModeleLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargesModeleLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      modeleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modele_id'])!,
      ordre: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordre'])!,
      designation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation'])!,
      montant: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant'])!,
      dateEcheance: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_echeance']),
      priorite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priorite'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      motifRefus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motif_refus']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChargesModeleLinesTable createAlias(String alias) {
    return $ChargesModeleLinesTable(attachedDatabase, alias);
  }
}

class ChargesModeleLine extends DataClass
    implements Insertable<ChargesModeleLine> {
  final String id;
  final String modeleId;
  final int ordre;
  final String designation;
  final double montant;
  final DateTime? dateEcheance;
  final String priorite;
  final String statut;
  final String? motifRefus;
  final String? notes;
  final DateTime createdAt;
  const ChargesModeleLine(
      {required this.id,
      required this.modeleId,
      required this.ordre,
      required this.designation,
      required this.montant,
      this.dateEcheance,
      required this.priorite,
      required this.statut,
      this.motifRefus,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['modele_id'] = Variable<String>(modeleId);
    map['ordre'] = Variable<int>(ordre);
    map['designation'] = Variable<String>(designation);
    map['montant'] = Variable<double>(montant);
    if (!nullToAbsent || dateEcheance != null) {
      map['date_echeance'] = Variable<DateTime>(dateEcheance);
    }
    map['priorite'] = Variable<String>(priorite);
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || motifRefus != null) {
      map['motif_refus'] = Variable<String>(motifRefus);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChargesModeleLinesCompanion toCompanion(bool nullToAbsent) {
    return ChargesModeleLinesCompanion(
      id: Value(id),
      modeleId: Value(modeleId),
      ordre: Value(ordre),
      designation: Value(designation),
      montant: Value(montant),
      dateEcheance: dateEcheance == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEcheance),
      priorite: Value(priorite),
      statut: Value(statut),
      motifRefus: motifRefus == null && nullToAbsent
          ? const Value.absent()
          : Value(motifRefus),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory ChargesModeleLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargesModeleLine(
      id: serializer.fromJson<String>(json['id']),
      modeleId: serializer.fromJson<String>(json['modeleId']),
      ordre: serializer.fromJson<int>(json['ordre']),
      designation: serializer.fromJson<String>(json['designation']),
      montant: serializer.fromJson<double>(json['montant']),
      dateEcheance: serializer.fromJson<DateTime?>(json['dateEcheance']),
      priorite: serializer.fromJson<String>(json['priorite']),
      statut: serializer.fromJson<String>(json['statut']),
      motifRefus: serializer.fromJson<String?>(json['motifRefus']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modeleId': serializer.toJson<String>(modeleId),
      'ordre': serializer.toJson<int>(ordre),
      'designation': serializer.toJson<String>(designation),
      'montant': serializer.toJson<double>(montant),
      'dateEcheance': serializer.toJson<DateTime?>(dateEcheance),
      'priorite': serializer.toJson<String>(priorite),
      'statut': serializer.toJson<String>(statut),
      'motifRefus': serializer.toJson<String?>(motifRefus),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChargesModeleLine copyWith(
          {String? id,
          String? modeleId,
          int? ordre,
          String? designation,
          double? montant,
          Value<DateTime?> dateEcheance = const Value.absent(),
          String? priorite,
          String? statut,
          Value<String?> motifRefus = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      ChargesModeleLine(
        id: id ?? this.id,
        modeleId: modeleId ?? this.modeleId,
        ordre: ordre ?? this.ordre,
        designation: designation ?? this.designation,
        montant: montant ?? this.montant,
        dateEcheance:
            dateEcheance.present ? dateEcheance.value : this.dateEcheance,
        priorite: priorite ?? this.priorite,
        statut: statut ?? this.statut,
        motifRefus: motifRefus.present ? motifRefus.value : this.motifRefus,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  ChargesModeleLine copyWithCompanion(ChargesModeleLinesCompanion data) {
    return ChargesModeleLine(
      id: data.id.present ? data.id.value : this.id,
      modeleId: data.modeleId.present ? data.modeleId.value : this.modeleId,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
      designation:
          data.designation.present ? data.designation.value : this.designation,
      montant: data.montant.present ? data.montant.value : this.montant,
      dateEcheance: data.dateEcheance.present
          ? data.dateEcheance.value
          : this.dateEcheance,
      priorite: data.priorite.present ? data.priorite.value : this.priorite,
      statut: data.statut.present ? data.statut.value : this.statut,
      motifRefus:
          data.motifRefus.present ? data.motifRefus.value : this.motifRefus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChargesModeleLine(')
          ..write('id: $id, ')
          ..write('modeleId: $modeleId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('montant: $montant, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('priorite: $priorite, ')
          ..write('statut: $statut, ')
          ..write('motifRefus: $motifRefus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, modeleId, ordre, designation, montant,
      dateEcheance, priorite, statut, motifRefus, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargesModeleLine &&
          other.id == this.id &&
          other.modeleId == this.modeleId &&
          other.ordre == this.ordre &&
          other.designation == this.designation &&
          other.montant == this.montant &&
          other.dateEcheance == this.dateEcheance &&
          other.priorite == this.priorite &&
          other.statut == this.statut &&
          other.motifRefus == this.motifRefus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ChargesModeleLinesCompanion extends UpdateCompanion<ChargesModeleLine> {
  final Value<String> id;
  final Value<String> modeleId;
  final Value<int> ordre;
  final Value<String> designation;
  final Value<double> montant;
  final Value<DateTime?> dateEcheance;
  final Value<String> priorite;
  final Value<String> statut;
  final Value<String?> motifRefus;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChargesModeleLinesCompanion({
    this.id = const Value.absent(),
    this.modeleId = const Value.absent(),
    this.ordre = const Value.absent(),
    this.designation = const Value.absent(),
    this.montant = const Value.absent(),
    this.dateEcheance = const Value.absent(),
    this.priorite = const Value.absent(),
    this.statut = const Value.absent(),
    this.motifRefus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChargesModeleLinesCompanion.insert({
    required String id,
    required String modeleId,
    this.ordre = const Value.absent(),
    required String designation,
    this.montant = const Value.absent(),
    this.dateEcheance = const Value.absent(),
    this.priorite = const Value.absent(),
    this.statut = const Value.absent(),
    this.motifRefus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        modeleId = Value(modeleId),
        designation = Value(designation);
  static Insertable<ChargesModeleLine> custom({
    Expression<String>? id,
    Expression<String>? modeleId,
    Expression<int>? ordre,
    Expression<String>? designation,
    Expression<double>? montant,
    Expression<DateTime>? dateEcheance,
    Expression<String>? priorite,
    Expression<String>? statut,
    Expression<String>? motifRefus,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeleId != null) 'modele_id': modeleId,
      if (ordre != null) 'ordre': ordre,
      if (designation != null) 'designation': designation,
      if (montant != null) 'montant': montant,
      if (dateEcheance != null) 'date_echeance': dateEcheance,
      if (priorite != null) 'priorite': priorite,
      if (statut != null) 'statut': statut,
      if (motifRefus != null) 'motif_refus': motifRefus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChargesModeleLinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? modeleId,
      Value<int>? ordre,
      Value<String>? designation,
      Value<double>? montant,
      Value<DateTime?>? dateEcheance,
      Value<String>? priorite,
      Value<String>? statut,
      Value<String?>? motifRefus,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ChargesModeleLinesCompanion(
      id: id ?? this.id,
      modeleId: modeleId ?? this.modeleId,
      ordre: ordre ?? this.ordre,
      designation: designation ?? this.designation,
      montant: montant ?? this.montant,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      priorite: priorite ?? this.priorite,
      statut: statut ?? this.statut,
      motifRefus: motifRefus ?? this.motifRefus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modeleId.present) {
      map['modele_id'] = Variable<String>(modeleId.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (montant.present) {
      map['montant'] = Variable<double>(montant.value);
    }
    if (dateEcheance.present) {
      map['date_echeance'] = Variable<DateTime>(dateEcheance.value);
    }
    if (priorite.present) {
      map['priorite'] = Variable<String>(priorite.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (motifRefus.present) {
      map['motif_refus'] = Variable<String>(motifRefus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargesModeleLinesCompanion(')
          ..write('id: $id, ')
          ..write('modeleId: $modeleId, ')
          ..write('ordre: $ordre, ')
          ..write('designation: $designation, ')
          ..write('montant: $montant, ')
          ..write('dateEcheance: $dateEcheance, ')
          ..write('priorite: $priorite, ')
          ..write('statut: $statut, ')
          ..write('motifRefus: $motifRefus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaxesTable extends Taxes with TableInfo<$TaxesTable, Taxe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tauxMeta = const VerificationMeta('taux');
  @override
  late final GeneratedColumn<double> taux = GeneratedColumn<double>(
      'taux', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        nom,
        taux,
        description,
        actif,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'taxes';
  @override
  VerificationContext validateIntegrity(Insertable<Taxe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('taux')) {
      context.handle(
          _tauxMeta, taux.isAcceptableOrUnknown(data['taux']!, _tauxMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Taxe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Taxe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      taux: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TaxesTable createAlias(String alias) {
    return $TaxesTable(attachedDatabase, alias);
  }
}

class Taxe extends DataClass implements Insertable<Taxe> {
  final String id;
  final String entrepriseId;
  final String nom;
  final double taux;
  final String? description;
  final bool actif;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Taxe(
      {required this.id,
      required this.entrepriseId,
      required this.nom,
      required this.taux,
      this.description,
      required this.actif,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    map['nom'] = Variable<String>(nom);
    map['taux'] = Variable<double>(taux);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['actif'] = Variable<bool>(actif);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaxesCompanion toCompanion(bool nullToAbsent) {
    return TaxesCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      nom: Value(nom),
      taux: Value(taux),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      actif: Value(actif),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Taxe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Taxe(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      nom: serializer.fromJson<String>(json['nom']),
      taux: serializer.fromJson<double>(json['taux']),
      description: serializer.fromJson<String?>(json['description']),
      actif: serializer.fromJson<bool>(json['actif']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'nom': serializer.toJson<String>(nom),
      'taux': serializer.toJson<double>(taux),
      'description': serializer.toJson<String?>(description),
      'actif': serializer.toJson<bool>(actif),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Taxe copyWith(
          {String? id,
          String? entrepriseId,
          String? nom,
          double? taux,
          Value<String?> description = const Value.absent(),
          bool? actif,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Taxe(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        nom: nom ?? this.nom,
        taux: taux ?? this.taux,
        description: description.present ? description.value : this.description,
        actif: actif ?? this.actif,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Taxe copyWithCompanion(TaxesCompanion data) {
    return Taxe(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      nom: data.nom.present ? data.nom.value : this.nom,
      taux: data.taux.present ? data.taux.value : this.taux,
      description:
          data.description.present ? data.description.value : this.description,
      actif: data.actif.present ? data.actif.value : this.actif,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Taxe(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('nom: $nom, ')
          ..write('taux: $taux, ')
          ..write('description: $description, ')
          ..write('actif: $actif, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entrepriseId, nom, taux, description,
      actif, syncStatus, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Taxe &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.nom == this.nom &&
          other.taux == this.taux &&
          other.description == this.description &&
          other.actif == this.actif &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaxesCompanion extends UpdateCompanion<Taxe> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String> nom;
  final Value<double> taux;
  final Value<String?> description;
  final Value<bool> actif;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaxesCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.nom = const Value.absent(),
    this.taux = const Value.absent(),
    this.description = const Value.absent(),
    this.actif = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaxesCompanion.insert({
    required String id,
    required String entrepriseId,
    required String nom,
    this.taux = const Value.absent(),
    this.description = const Value.absent(),
    this.actif = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        nom = Value(nom);
  static Insertable<Taxe> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? nom,
    Expression<double>? taux,
    Expression<String>? description,
    Expression<bool>? actif,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (nom != null) 'nom': nom,
      if (taux != null) 'taux': taux,
      if (description != null) 'description': description,
      if (actif != null) 'actif': actif,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaxesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String>? nom,
      Value<double>? taux,
      Value<String?>? description,
      Value<bool>? actif,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TaxesCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      nom: nom ?? this.nom,
      taux: taux ?? this.taux,
      description: description ?? this.description,
      actif: actif ?? this.actif,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (taux.present) {
      map['taux'] = Variable<double>(taux.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxesCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('nom: $nom, ')
          ..write('taux: $taux, ')
          ..write('description: $description, ')
          ..write('actif: $actif, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonnelTable extends Personnel
    with TableInfo<$PersonnelTable, PersonnelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonnelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _utilisateurIdMeta =
      const VerificationMeta('utilisateurId');
  @override
  late final GeneratedColumn<String> utilisateurId = GeneratedColumn<String>(
      'utilisateur_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
      'prenom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _posteMeta = const VerificationMeta('poste');
  @override
  late final GeneratedColumn<String> poste = GeneratedColumn<String>(
      'poste', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _departementMeta =
      const VerificationMeta('departement');
  @override
  late final GeneratedColumn<String> departement = GeneratedColumn<String>(
      'departement', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeContratMeta =
      const VerificationMeta('typeContrat');
  @override
  late final GeneratedColumn<String> typeContrat = GeneratedColumn<String>(
      'type_contrat', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CDI'));
  static const VerificationMeta _dateEmbaucheMeta =
      const VerificationMeta('dateEmbauche');
  @override
  late final GeneratedColumn<DateTime> dateEmbauche = GeneratedColumn<DateTime>(
      'date_embauche', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateFinContratMeta =
      const VerificationMeta('dateFinContrat');
  @override
  late final GeneratedColumn<DateTime> dateFinContrat =
      GeneratedColumn<DateTime>('date_fin_contrat', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _salaireBaseMeta =
      const VerificationMeta('salaireBase');
  @override
  late final GeneratedColumn<double> salaireBase = GeneratedColumn<double>(
      'salaire_base', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        utilisateurId,
        nom,
        prenom,
        poste,
        departement,
        typeContrat,
        dateEmbauche,
        dateFinContrat,
        salaireBase,
        actif,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personnel';
  @override
  VerificationContext validateIntegrity(Insertable<PersonnelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('utilisateur_id')) {
      context.handle(
          _utilisateurIdMeta,
          utilisateurId.isAcceptableOrUnknown(
              data['utilisateur_id']!, _utilisateurIdMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(_prenomMeta,
          prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta));
    }
    if (data.containsKey('poste')) {
      context.handle(
          _posteMeta, poste.isAcceptableOrUnknown(data['poste']!, _posteMeta));
    }
    if (data.containsKey('departement')) {
      context.handle(
          _departementMeta,
          departement.isAcceptableOrUnknown(
              data['departement']!, _departementMeta));
    }
    if (data.containsKey('type_contrat')) {
      context.handle(
          _typeContratMeta,
          typeContrat.isAcceptableOrUnknown(
              data['type_contrat']!, _typeContratMeta));
    }
    if (data.containsKey('date_embauche')) {
      context.handle(
          _dateEmbaucheMeta,
          dateEmbauche.isAcceptableOrUnknown(
              data['date_embauche']!, _dateEmbaucheMeta));
    }
    if (data.containsKey('date_fin_contrat')) {
      context.handle(
          _dateFinContratMeta,
          dateFinContrat.isAcceptableOrUnknown(
              data['date_fin_contrat']!, _dateFinContratMeta));
    }
    if (data.containsKey('salaire_base')) {
      context.handle(
          _salaireBaseMeta,
          salaireBase.isAcceptableOrUnknown(
              data['salaire_base']!, _salaireBaseMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonnelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonnelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      utilisateurId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}utilisateur_id']),
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      prenom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prenom']),
      poste: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poste']),
      departement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}departement']),
      typeContrat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_contrat'])!,
      dateEmbauche: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_embauche']),
      dateFinContrat: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_fin_contrat']),
      salaireBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}salaire_base']),
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonnelTable createAlias(String alias) {
    return $PersonnelTable(attachedDatabase, alias);
  }
}

class PersonnelData extends DataClass implements Insertable<PersonnelData> {
  final String id;
  final String entrepriseId;
  final String? utilisateurId;
  final String nom;
  final String? prenom;
  final String? poste;
  final String? departement;
  final String typeContrat;
  final DateTime? dateEmbauche;
  final DateTime? dateFinContrat;
  final double? salaireBase;
  final bool actif;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PersonnelData(
      {required this.id,
      required this.entrepriseId,
      this.utilisateurId,
      required this.nom,
      this.prenom,
      this.poste,
      this.departement,
      required this.typeContrat,
      this.dateEmbauche,
      this.dateFinContrat,
      this.salaireBase,
      required this.actif,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    if (!nullToAbsent || utilisateurId != null) {
      map['utilisateur_id'] = Variable<String>(utilisateurId);
    }
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || prenom != null) {
      map['prenom'] = Variable<String>(prenom);
    }
    if (!nullToAbsent || poste != null) {
      map['poste'] = Variable<String>(poste);
    }
    if (!nullToAbsent || departement != null) {
      map['departement'] = Variable<String>(departement);
    }
    map['type_contrat'] = Variable<String>(typeContrat);
    if (!nullToAbsent || dateEmbauche != null) {
      map['date_embauche'] = Variable<DateTime>(dateEmbauche);
    }
    if (!nullToAbsent || dateFinContrat != null) {
      map['date_fin_contrat'] = Variable<DateTime>(dateFinContrat);
    }
    if (!nullToAbsent || salaireBase != null) {
      map['salaire_base'] = Variable<double>(salaireBase);
    }
    map['actif'] = Variable<bool>(actif);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonnelCompanion toCompanion(bool nullToAbsent) {
    return PersonnelCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      utilisateurId: utilisateurId == null && nullToAbsent
          ? const Value.absent()
          : Value(utilisateurId),
      nom: Value(nom),
      prenom:
          prenom == null && nullToAbsent ? const Value.absent() : Value(prenom),
      poste:
          poste == null && nullToAbsent ? const Value.absent() : Value(poste),
      departement: departement == null && nullToAbsent
          ? const Value.absent()
          : Value(departement),
      typeContrat: Value(typeContrat),
      dateEmbauche: dateEmbauche == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEmbauche),
      dateFinContrat: dateFinContrat == null && nullToAbsent
          ? const Value.absent()
          : Value(dateFinContrat),
      salaireBase: salaireBase == null && nullToAbsent
          ? const Value.absent()
          : Value(salaireBase),
      actif: Value(actif),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonnelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonnelData(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      utilisateurId: serializer.fromJson<String?>(json['utilisateurId']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String?>(json['prenom']),
      poste: serializer.fromJson<String?>(json['poste']),
      departement: serializer.fromJson<String?>(json['departement']),
      typeContrat: serializer.fromJson<String>(json['typeContrat']),
      dateEmbauche: serializer.fromJson<DateTime?>(json['dateEmbauche']),
      dateFinContrat: serializer.fromJson<DateTime?>(json['dateFinContrat']),
      salaireBase: serializer.fromJson<double?>(json['salaireBase']),
      actif: serializer.fromJson<bool>(json['actif']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'utilisateurId': serializer.toJson<String?>(utilisateurId),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String?>(prenom),
      'poste': serializer.toJson<String?>(poste),
      'departement': serializer.toJson<String?>(departement),
      'typeContrat': serializer.toJson<String>(typeContrat),
      'dateEmbauche': serializer.toJson<DateTime?>(dateEmbauche),
      'dateFinContrat': serializer.toJson<DateTime?>(dateFinContrat),
      'salaireBase': serializer.toJson<double?>(salaireBase),
      'actif': serializer.toJson<bool>(actif),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonnelData copyWith(
          {String? id,
          String? entrepriseId,
          Value<String?> utilisateurId = const Value.absent(),
          String? nom,
          Value<String?> prenom = const Value.absent(),
          Value<String?> poste = const Value.absent(),
          Value<String?> departement = const Value.absent(),
          String? typeContrat,
          Value<DateTime?> dateEmbauche = const Value.absent(),
          Value<DateTime?> dateFinContrat = const Value.absent(),
          Value<double?> salaireBase = const Value.absent(),
          bool? actif,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PersonnelData(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        utilisateurId:
            utilisateurId.present ? utilisateurId.value : this.utilisateurId,
        nom: nom ?? this.nom,
        prenom: prenom.present ? prenom.value : this.prenom,
        poste: poste.present ? poste.value : this.poste,
        departement: departement.present ? departement.value : this.departement,
        typeContrat: typeContrat ?? this.typeContrat,
        dateEmbauche:
            dateEmbauche.present ? dateEmbauche.value : this.dateEmbauche,
        dateFinContrat:
            dateFinContrat.present ? dateFinContrat.value : this.dateFinContrat,
        salaireBase: salaireBase.present ? salaireBase.value : this.salaireBase,
        actif: actif ?? this.actif,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PersonnelData copyWithCompanion(PersonnelCompanion data) {
    return PersonnelData(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      utilisateurId: data.utilisateurId.present
          ? data.utilisateurId.value
          : this.utilisateurId,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      poste: data.poste.present ? data.poste.value : this.poste,
      departement:
          data.departement.present ? data.departement.value : this.departement,
      typeContrat:
          data.typeContrat.present ? data.typeContrat.value : this.typeContrat,
      dateEmbauche: data.dateEmbauche.present
          ? data.dateEmbauche.value
          : this.dateEmbauche,
      dateFinContrat: data.dateFinContrat.present
          ? data.dateFinContrat.value
          : this.dateFinContrat,
      salaireBase:
          data.salaireBase.present ? data.salaireBase.value : this.salaireBase,
      actif: data.actif.present ? data.actif.value : this.actif,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelData(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('poste: $poste, ')
          ..write('departement: $departement, ')
          ..write('typeContrat: $typeContrat, ')
          ..write('dateEmbauche: $dateEmbauche, ')
          ..write('dateFinContrat: $dateFinContrat, ')
          ..write('salaireBase: $salaireBase, ')
          ..write('actif: $actif, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entrepriseId,
      utilisateurId,
      nom,
      prenom,
      poste,
      departement,
      typeContrat,
      dateEmbauche,
      dateFinContrat,
      salaireBase,
      actif,
      syncStatus,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonnelData &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.utilisateurId == this.utilisateurId &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.poste == this.poste &&
          other.departement == this.departement &&
          other.typeContrat == this.typeContrat &&
          other.dateEmbauche == this.dateEmbauche &&
          other.dateFinContrat == this.dateFinContrat &&
          other.salaireBase == this.salaireBase &&
          other.actif == this.actif &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonnelCompanion extends UpdateCompanion<PersonnelData> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String?> utilisateurId;
  final Value<String> nom;
  final Value<String?> prenom;
  final Value<String?> poste;
  final Value<String?> departement;
  final Value<String> typeContrat;
  final Value<DateTime?> dateEmbauche;
  final Value<DateTime?> dateFinContrat;
  final Value<double?> salaireBase;
  final Value<bool> actif;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PersonnelCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.utilisateurId = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.poste = const Value.absent(),
    this.departement = const Value.absent(),
    this.typeContrat = const Value.absent(),
    this.dateEmbauche = const Value.absent(),
    this.dateFinContrat = const Value.absent(),
    this.salaireBase = const Value.absent(),
    this.actif = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonnelCompanion.insert({
    required String id,
    required String entrepriseId,
    this.utilisateurId = const Value.absent(),
    required String nom,
    this.prenom = const Value.absent(),
    this.poste = const Value.absent(),
    this.departement = const Value.absent(),
    this.typeContrat = const Value.absent(),
    this.dateEmbauche = const Value.absent(),
    this.dateFinContrat = const Value.absent(),
    this.salaireBase = const Value.absent(),
    this.actif = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        nom = Value(nom);
  static Insertable<PersonnelData> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? utilisateurId,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? poste,
    Expression<String>? departement,
    Expression<String>? typeContrat,
    Expression<DateTime>? dateEmbauche,
    Expression<DateTime>? dateFinContrat,
    Expression<double>? salaireBase,
    Expression<bool>? actif,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (utilisateurId != null) 'utilisateur_id': utilisateurId,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (poste != null) 'poste': poste,
      if (departement != null) 'departement': departement,
      if (typeContrat != null) 'type_contrat': typeContrat,
      if (dateEmbauche != null) 'date_embauche': dateEmbauche,
      if (dateFinContrat != null) 'date_fin_contrat': dateFinContrat,
      if (salaireBase != null) 'salaire_base': salaireBase,
      if (actif != null) 'actif': actif,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonnelCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String?>? utilisateurId,
      Value<String>? nom,
      Value<String?>? prenom,
      Value<String?>? poste,
      Value<String?>? departement,
      Value<String>? typeContrat,
      Value<DateTime?>? dateEmbauche,
      Value<DateTime?>? dateFinContrat,
      Value<double?>? salaireBase,
      Value<bool>? actif,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PersonnelCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      poste: poste ?? this.poste,
      departement: departement ?? this.departement,
      typeContrat: typeContrat ?? this.typeContrat,
      dateEmbauche: dateEmbauche ?? this.dateEmbauche,
      dateFinContrat: dateFinContrat ?? this.dateFinContrat,
      salaireBase: salaireBase ?? this.salaireBase,
      actif: actif ?? this.actif,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (utilisateurId.present) {
      map['utilisateur_id'] = Variable<String>(utilisateurId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (poste.present) {
      map['poste'] = Variable<String>(poste.value);
    }
    if (departement.present) {
      map['departement'] = Variable<String>(departement.value);
    }
    if (typeContrat.present) {
      map['type_contrat'] = Variable<String>(typeContrat.value);
    }
    if (dateEmbauche.present) {
      map['date_embauche'] = Variable<DateTime>(dateEmbauche.value);
    }
    if (dateFinContrat.present) {
      map['date_fin_contrat'] = Variable<DateTime>(dateFinContrat.value);
    }
    if (salaireBase.present) {
      map['salaire_base'] = Variable<double>(salaireBase.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('poste: $poste, ')
          ..write('departement: $departement, ')
          ..write('typeContrat: $typeContrat, ')
          ..write('dateEmbauche: $dateEmbauche, ')
          ..write('dateFinContrat: $dateFinContrat, ')
          ..write('salaireBase: $salaireBase, ')
          ..write('actif: $actif, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalairesTable extends Salaires with TableInfo<$SalairesTable, Salaire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entrepriseIdMeta =
      const VerificationMeta('entrepriseId');
  @override
  late final GeneratedColumn<String> entrepriseId = GeneratedColumn<String>(
      'entreprise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personnelIdMeta =
      const VerificationMeta('personnelId');
  @override
  late final GeneratedColumn<String> personnelId = GeneratedColumn<String>(
      'personnel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moisMeta = const VerificationMeta('mois');
  @override
  late final GeneratedColumn<int> mois = GeneratedColumn<int>(
      'mois', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
      'annee', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _salaireBrutMeta =
      const VerificationMeta('salaireBrut');
  @override
  late final GeneratedColumn<double> salaireBrut = GeneratedColumn<double>(
      'salaire_brut', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cnpsMeta = const VerificationMeta('cnps');
  @override
  late final GeneratedColumn<double> cnps = GeneratedColumn<double>(
      'cnps', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _irppMeta = const VerificationMeta('irpp');
  @override
  late final GeneratedColumn<double> irpp = GeneratedColumn<double>(
      'irpp', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _autresRetenuesMeta =
      const VerificationMeta('autresRetenues');
  @override
  late final GeneratedColumn<double> autresRetenues = GeneratedColumn<double>(
      'autres_retenues', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _salaireNetMeta =
      const VerificationMeta('salaireNet');
  @override
  late final GeneratedColumn<double> salaireNet = GeneratedColumn<double>(
      'salaire_net', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en_attente'));
  static const VerificationMeta _dateValidationMeta =
      const VerificationMeta('dateValidation');
  @override
  late final GeneratedColumn<DateTime> dateValidation =
      GeneratedColumn<DateTime>('date_validation', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _valideParMeta =
      const VerificationMeta('validePar');
  @override
  late final GeneratedColumn<String> validePar = GeneratedColumn<String>(
      'valide_par', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _datePaiementMeta =
      const VerificationMeta('datePaiement');
  @override
  late final GeneratedColumn<DateTime> datePaiement = GeneratedColumn<DateTime>(
      'date_paiement', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _modePaiementMeta =
      const VerificationMeta('modePaiement');
  @override
  late final GeneratedColumn<String> modePaiement = GeneratedColumn<String>(
      'mode_paiement', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _comptabiliseMeta =
      const VerificationMeta('comptabilise');
  @override
  late final GeneratedColumn<bool> comptabilise = GeneratedColumn<bool>(
      'comptabilise', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("comptabilise" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _chargeIdMeta =
      const VerificationMeta('chargeId');
  @override
  late final GeneratedColumn<String> chargeId = GeneratedColumn<String>(
      'charge_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entrepriseId,
        personnelId,
        mois,
        annee,
        salaireBrut,
        cnps,
        irpp,
        autresRetenues,
        salaireNet,
        statut,
        dateValidation,
        validePar,
        datePaiement,
        modePaiement,
        comptabilise,
        chargeId,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salaires';
  @override
  VerificationContext validateIntegrity(Insertable<Salaire> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entreprise_id')) {
      context.handle(
          _entrepriseIdMeta,
          entrepriseId.isAcceptableOrUnknown(
              data['entreprise_id']!, _entrepriseIdMeta));
    } else if (isInserting) {
      context.missing(_entrepriseIdMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
          _personnelIdMeta,
          personnelId.isAcceptableOrUnknown(
              data['personnel_id']!, _personnelIdMeta));
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('mois')) {
      context.handle(
          _moisMeta, mois.isAcceptableOrUnknown(data['mois']!, _moisMeta));
    } else if (isInserting) {
      context.missing(_moisMeta);
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta));
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('salaire_brut')) {
      context.handle(
          _salaireBrutMeta,
          salaireBrut.isAcceptableOrUnknown(
              data['salaire_brut']!, _salaireBrutMeta));
    }
    if (data.containsKey('cnps')) {
      context.handle(
          _cnpsMeta, cnps.isAcceptableOrUnknown(data['cnps']!, _cnpsMeta));
    }
    if (data.containsKey('irpp')) {
      context.handle(
          _irppMeta, irpp.isAcceptableOrUnknown(data['irpp']!, _irppMeta));
    }
    if (data.containsKey('autres_retenues')) {
      context.handle(
          _autresRetenuesMeta,
          autresRetenues.isAcceptableOrUnknown(
              data['autres_retenues']!, _autresRetenuesMeta));
    }
    if (data.containsKey('salaire_net')) {
      context.handle(
          _salaireNetMeta,
          salaireNet.isAcceptableOrUnknown(
              data['salaire_net']!, _salaireNetMeta));
    } else if (isInserting) {
      context.missing(_salaireNetMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('date_validation')) {
      context.handle(
          _dateValidationMeta,
          dateValidation.isAcceptableOrUnknown(
              data['date_validation']!, _dateValidationMeta));
    }
    if (data.containsKey('valide_par')) {
      context.handle(_valideParMeta,
          validePar.isAcceptableOrUnknown(data['valide_par']!, _valideParMeta));
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
          _datePaiementMeta,
          datePaiement.isAcceptableOrUnknown(
              data['date_paiement']!, _datePaiementMeta));
    }
    if (data.containsKey('mode_paiement')) {
      context.handle(
          _modePaiementMeta,
          modePaiement.isAcceptableOrUnknown(
              data['mode_paiement']!, _modePaiementMeta));
    }
    if (data.containsKey('comptabilise')) {
      context.handle(
          _comptabiliseMeta,
          comptabilise.isAcceptableOrUnknown(
              data['comptabilise']!, _comptabiliseMeta));
    }
    if (data.containsKey('charge_id')) {
      context.handle(_chargeIdMeta,
          chargeId.isAcceptableOrUnknown(data['charge_id']!, _chargeIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Salaire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Salaire(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entrepriseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entreprise_id'])!,
      personnelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personnel_id'])!,
      mois: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mois'])!,
      annee: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}annee'])!,
      salaireBrut: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}salaire_brut'])!,
      cnps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cnps'])!,
      irpp: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}irpp'])!,
      autresRetenues: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}autres_retenues'])!,
      salaireNet: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}salaire_net'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      dateValidation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_validation']),
      validePar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valide_par']),
      datePaiement: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_paiement']),
      modePaiement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode_paiement']),
      comptabilise: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}comptabilise'])!,
      chargeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}charge_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SalairesTable createAlias(String alias) {
    return $SalairesTable(attachedDatabase, alias);
  }
}

class Salaire extends DataClass implements Insertable<Salaire> {
  final String id;
  final String entrepriseId;
  final String personnelId;
  final int mois;
  final int annee;
  final double salaireBrut;
  final double cnps;
  final double irpp;
  final double autresRetenues;
  final double salaireNet;
  final String statut;
  final DateTime? dateValidation;
  final String? validePar;
  final DateTime? datePaiement;
  final String? modePaiement;
  final bool comptabilise;
  final String? chargeId;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Salaire(
      {required this.id,
      required this.entrepriseId,
      required this.personnelId,
      required this.mois,
      required this.annee,
      required this.salaireBrut,
      required this.cnps,
      required this.irpp,
      required this.autresRetenues,
      required this.salaireNet,
      required this.statut,
      this.dateValidation,
      this.validePar,
      this.datePaiement,
      this.modePaiement,
      required this.comptabilise,
      this.chargeId,
      this.notes,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entreprise_id'] = Variable<String>(entrepriseId);
    map['personnel_id'] = Variable<String>(personnelId);
    map['mois'] = Variable<int>(mois);
    map['annee'] = Variable<int>(annee);
    map['salaire_brut'] = Variable<double>(salaireBrut);
    map['cnps'] = Variable<double>(cnps);
    map['irpp'] = Variable<double>(irpp);
    map['autres_retenues'] = Variable<double>(autresRetenues);
    map['salaire_net'] = Variable<double>(salaireNet);
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || dateValidation != null) {
      map['date_validation'] = Variable<DateTime>(dateValidation);
    }
    if (!nullToAbsent || validePar != null) {
      map['valide_par'] = Variable<String>(validePar);
    }
    if (!nullToAbsent || datePaiement != null) {
      map['date_paiement'] = Variable<DateTime>(datePaiement);
    }
    if (!nullToAbsent || modePaiement != null) {
      map['mode_paiement'] = Variable<String>(modePaiement);
    }
    map['comptabilise'] = Variable<bool>(comptabilise);
    if (!nullToAbsent || chargeId != null) {
      map['charge_id'] = Variable<String>(chargeId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SalairesCompanion toCompanion(bool nullToAbsent) {
    return SalairesCompanion(
      id: Value(id),
      entrepriseId: Value(entrepriseId),
      personnelId: Value(personnelId),
      mois: Value(mois),
      annee: Value(annee),
      salaireBrut: Value(salaireBrut),
      cnps: Value(cnps),
      irpp: Value(irpp),
      autresRetenues: Value(autresRetenues),
      salaireNet: Value(salaireNet),
      statut: Value(statut),
      dateValidation: dateValidation == null && nullToAbsent
          ? const Value.absent()
          : Value(dateValidation),
      validePar: validePar == null && nullToAbsent
          ? const Value.absent()
          : Value(validePar),
      datePaiement: datePaiement == null && nullToAbsent
          ? const Value.absent()
          : Value(datePaiement),
      modePaiement: modePaiement == null && nullToAbsent
          ? const Value.absent()
          : Value(modePaiement),
      comptabilise: Value(comptabilise),
      chargeId: chargeId == null && nullToAbsent
          ? const Value.absent()
          : Value(chargeId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Salaire.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Salaire(
      id: serializer.fromJson<String>(json['id']),
      entrepriseId: serializer.fromJson<String>(json['entrepriseId']),
      personnelId: serializer.fromJson<String>(json['personnelId']),
      mois: serializer.fromJson<int>(json['mois']),
      annee: serializer.fromJson<int>(json['annee']),
      salaireBrut: serializer.fromJson<double>(json['salaireBrut']),
      cnps: serializer.fromJson<double>(json['cnps']),
      irpp: serializer.fromJson<double>(json['irpp']),
      autresRetenues: serializer.fromJson<double>(json['autresRetenues']),
      salaireNet: serializer.fromJson<double>(json['salaireNet']),
      statut: serializer.fromJson<String>(json['statut']),
      dateValidation: serializer.fromJson<DateTime?>(json['dateValidation']),
      validePar: serializer.fromJson<String?>(json['validePar']),
      datePaiement: serializer.fromJson<DateTime?>(json['datePaiement']),
      modePaiement: serializer.fromJson<String?>(json['modePaiement']),
      comptabilise: serializer.fromJson<bool>(json['comptabilise']),
      chargeId: serializer.fromJson<String?>(json['chargeId']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entrepriseId': serializer.toJson<String>(entrepriseId),
      'personnelId': serializer.toJson<String>(personnelId),
      'mois': serializer.toJson<int>(mois),
      'annee': serializer.toJson<int>(annee),
      'salaireBrut': serializer.toJson<double>(salaireBrut),
      'cnps': serializer.toJson<double>(cnps),
      'irpp': serializer.toJson<double>(irpp),
      'autresRetenues': serializer.toJson<double>(autresRetenues),
      'salaireNet': serializer.toJson<double>(salaireNet),
      'statut': serializer.toJson<String>(statut),
      'dateValidation': serializer.toJson<DateTime?>(dateValidation),
      'validePar': serializer.toJson<String?>(validePar),
      'datePaiement': serializer.toJson<DateTime?>(datePaiement),
      'modePaiement': serializer.toJson<String?>(modePaiement),
      'comptabilise': serializer.toJson<bool>(comptabilise),
      'chargeId': serializer.toJson<String?>(chargeId),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Salaire copyWith(
          {String? id,
          String? entrepriseId,
          String? personnelId,
          int? mois,
          int? annee,
          double? salaireBrut,
          double? cnps,
          double? irpp,
          double? autresRetenues,
          double? salaireNet,
          String? statut,
          Value<DateTime?> dateValidation = const Value.absent(),
          Value<String?> validePar = const Value.absent(),
          Value<DateTime?> datePaiement = const Value.absent(),
          Value<String?> modePaiement = const Value.absent(),
          bool? comptabilise,
          Value<String?> chargeId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Salaire(
        id: id ?? this.id,
        entrepriseId: entrepriseId ?? this.entrepriseId,
        personnelId: personnelId ?? this.personnelId,
        mois: mois ?? this.mois,
        annee: annee ?? this.annee,
        salaireBrut: salaireBrut ?? this.salaireBrut,
        cnps: cnps ?? this.cnps,
        irpp: irpp ?? this.irpp,
        autresRetenues: autresRetenues ?? this.autresRetenues,
        salaireNet: salaireNet ?? this.salaireNet,
        statut: statut ?? this.statut,
        dateValidation:
            dateValidation.present ? dateValidation.value : this.dateValidation,
        validePar: validePar.present ? validePar.value : this.validePar,
        datePaiement:
            datePaiement.present ? datePaiement.value : this.datePaiement,
        modePaiement:
            modePaiement.present ? modePaiement.value : this.modePaiement,
        comptabilise: comptabilise ?? this.comptabilise,
        chargeId: chargeId.present ? chargeId.value : this.chargeId,
        notes: notes.present ? notes.value : this.notes,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Salaire copyWithCompanion(SalairesCompanion data) {
    return Salaire(
      id: data.id.present ? data.id.value : this.id,
      entrepriseId: data.entrepriseId.present
          ? data.entrepriseId.value
          : this.entrepriseId,
      personnelId:
          data.personnelId.present ? data.personnelId.value : this.personnelId,
      mois: data.mois.present ? data.mois.value : this.mois,
      annee: data.annee.present ? data.annee.value : this.annee,
      salaireBrut:
          data.salaireBrut.present ? data.salaireBrut.value : this.salaireBrut,
      cnps: data.cnps.present ? data.cnps.value : this.cnps,
      irpp: data.irpp.present ? data.irpp.value : this.irpp,
      autresRetenues: data.autresRetenues.present
          ? data.autresRetenues.value
          : this.autresRetenues,
      salaireNet:
          data.salaireNet.present ? data.salaireNet.value : this.salaireNet,
      statut: data.statut.present ? data.statut.value : this.statut,
      dateValidation: data.dateValidation.present
          ? data.dateValidation.value
          : this.dateValidation,
      validePar: data.validePar.present ? data.validePar.value : this.validePar,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      modePaiement: data.modePaiement.present
          ? data.modePaiement.value
          : this.modePaiement,
      comptabilise: data.comptabilise.present
          ? data.comptabilise.value
          : this.comptabilise,
      chargeId: data.chargeId.present ? data.chargeId.value : this.chargeId,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Salaire(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('personnelId: $personnelId, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('salaireBrut: $salaireBrut, ')
          ..write('cnps: $cnps, ')
          ..write('irpp: $irpp, ')
          ..write('autresRetenues: $autresRetenues, ')
          ..write('salaireNet: $salaireNet, ')
          ..write('statut: $statut, ')
          ..write('dateValidation: $dateValidation, ')
          ..write('validePar: $validePar, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('comptabilise: $comptabilise, ')
          ..write('chargeId: $chargeId, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        entrepriseId,
        personnelId,
        mois,
        annee,
        salaireBrut,
        cnps,
        irpp,
        autresRetenues,
        salaireNet,
        statut,
        dateValidation,
        validePar,
        datePaiement,
        modePaiement,
        comptabilise,
        chargeId,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Salaire &&
          other.id == this.id &&
          other.entrepriseId == this.entrepriseId &&
          other.personnelId == this.personnelId &&
          other.mois == this.mois &&
          other.annee == this.annee &&
          other.salaireBrut == this.salaireBrut &&
          other.cnps == this.cnps &&
          other.irpp == this.irpp &&
          other.autresRetenues == this.autresRetenues &&
          other.salaireNet == this.salaireNet &&
          other.statut == this.statut &&
          other.dateValidation == this.dateValidation &&
          other.validePar == this.validePar &&
          other.datePaiement == this.datePaiement &&
          other.modePaiement == this.modePaiement &&
          other.comptabilise == this.comptabilise &&
          other.chargeId == this.chargeId &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SalairesCompanion extends UpdateCompanion<Salaire> {
  final Value<String> id;
  final Value<String> entrepriseId;
  final Value<String> personnelId;
  final Value<int> mois;
  final Value<int> annee;
  final Value<double> salaireBrut;
  final Value<double> cnps;
  final Value<double> irpp;
  final Value<double> autresRetenues;
  final Value<double> salaireNet;
  final Value<String> statut;
  final Value<DateTime?> dateValidation;
  final Value<String?> validePar;
  final Value<DateTime?> datePaiement;
  final Value<String?> modePaiement;
  final Value<bool> comptabilise;
  final Value<String?> chargeId;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SalairesCompanion({
    this.id = const Value.absent(),
    this.entrepriseId = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.mois = const Value.absent(),
    this.annee = const Value.absent(),
    this.salaireBrut = const Value.absent(),
    this.cnps = const Value.absent(),
    this.irpp = const Value.absent(),
    this.autresRetenues = const Value.absent(),
    this.salaireNet = const Value.absent(),
    this.statut = const Value.absent(),
    this.dateValidation = const Value.absent(),
    this.validePar = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.comptabilise = const Value.absent(),
    this.chargeId = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalairesCompanion.insert({
    required String id,
    required String entrepriseId,
    required String personnelId,
    required int mois,
    required int annee,
    this.salaireBrut = const Value.absent(),
    this.cnps = const Value.absent(),
    this.irpp = const Value.absent(),
    this.autresRetenues = const Value.absent(),
    required double salaireNet,
    this.statut = const Value.absent(),
    this.dateValidation = const Value.absent(),
    this.validePar = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.comptabilise = const Value.absent(),
    this.chargeId = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entrepriseId = Value(entrepriseId),
        personnelId = Value(personnelId),
        mois = Value(mois),
        annee = Value(annee),
        salaireNet = Value(salaireNet);
  static Insertable<Salaire> custom({
    Expression<String>? id,
    Expression<String>? entrepriseId,
    Expression<String>? personnelId,
    Expression<int>? mois,
    Expression<int>? annee,
    Expression<double>? salaireBrut,
    Expression<double>? cnps,
    Expression<double>? irpp,
    Expression<double>? autresRetenues,
    Expression<double>? salaireNet,
    Expression<String>? statut,
    Expression<DateTime>? dateValidation,
    Expression<String>? validePar,
    Expression<DateTime>? datePaiement,
    Expression<String>? modePaiement,
    Expression<bool>? comptabilise,
    Expression<String>? chargeId,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrepriseId != null) 'entreprise_id': entrepriseId,
      if (personnelId != null) 'personnel_id': personnelId,
      if (mois != null) 'mois': mois,
      if (annee != null) 'annee': annee,
      if (salaireBrut != null) 'salaire_brut': salaireBrut,
      if (cnps != null) 'cnps': cnps,
      if (irpp != null) 'irpp': irpp,
      if (autresRetenues != null) 'autres_retenues': autresRetenues,
      if (salaireNet != null) 'salaire_net': salaireNet,
      if (statut != null) 'statut': statut,
      if (dateValidation != null) 'date_validation': dateValidation,
      if (validePar != null) 'valide_par': validePar,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (modePaiement != null) 'mode_paiement': modePaiement,
      if (comptabilise != null) 'comptabilise': comptabilise,
      if (chargeId != null) 'charge_id': chargeId,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalairesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entrepriseId,
      Value<String>? personnelId,
      Value<int>? mois,
      Value<int>? annee,
      Value<double>? salaireBrut,
      Value<double>? cnps,
      Value<double>? irpp,
      Value<double>? autresRetenues,
      Value<double>? salaireNet,
      Value<String>? statut,
      Value<DateTime?>? dateValidation,
      Value<String?>? validePar,
      Value<DateTime?>? datePaiement,
      Value<String?>? modePaiement,
      Value<bool>? comptabilise,
      Value<String?>? chargeId,
      Value<String?>? notes,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SalairesCompanion(
      id: id ?? this.id,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      personnelId: personnelId ?? this.personnelId,
      mois: mois ?? this.mois,
      annee: annee ?? this.annee,
      salaireBrut: salaireBrut ?? this.salaireBrut,
      cnps: cnps ?? this.cnps,
      irpp: irpp ?? this.irpp,
      autresRetenues: autresRetenues ?? this.autresRetenues,
      salaireNet: salaireNet ?? this.salaireNet,
      statut: statut ?? this.statut,
      dateValidation: dateValidation ?? this.dateValidation,
      validePar: validePar ?? this.validePar,
      datePaiement: datePaiement ?? this.datePaiement,
      modePaiement: modePaiement ?? this.modePaiement,
      comptabilise: comptabilise ?? this.comptabilise,
      chargeId: chargeId ?? this.chargeId,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entrepriseId.present) {
      map['entreprise_id'] = Variable<String>(entrepriseId.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<String>(personnelId.value);
    }
    if (mois.present) {
      map['mois'] = Variable<int>(mois.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (salaireBrut.present) {
      map['salaire_brut'] = Variable<double>(salaireBrut.value);
    }
    if (cnps.present) {
      map['cnps'] = Variable<double>(cnps.value);
    }
    if (irpp.present) {
      map['irpp'] = Variable<double>(irpp.value);
    }
    if (autresRetenues.present) {
      map['autres_retenues'] = Variable<double>(autresRetenues.value);
    }
    if (salaireNet.present) {
      map['salaire_net'] = Variable<double>(salaireNet.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (dateValidation.present) {
      map['date_validation'] = Variable<DateTime>(dateValidation.value);
    }
    if (validePar.present) {
      map['valide_par'] = Variable<String>(validePar.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<DateTime>(datePaiement.value);
    }
    if (modePaiement.present) {
      map['mode_paiement'] = Variable<String>(modePaiement.value);
    }
    if (comptabilise.present) {
      map['comptabilise'] = Variable<bool>(comptabilise.value);
    }
    if (chargeId.present) {
      map['charge_id'] = Variable<String>(chargeId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalairesCompanion(')
          ..write('id: $id, ')
          ..write('entrepriseId: $entrepriseId, ')
          ..write('personnelId: $personnelId, ')
          ..write('mois: $mois, ')
          ..write('annee: $annee, ')
          ..write('salaireBrut: $salaireBrut, ')
          ..write('cnps: $cnps, ')
          ..write('irpp: $irpp, ')
          ..write('autresRetenues: $autresRetenues, ')
          ..write('salaireNet: $salaireNet, ')
          ..write('statut: $statut, ')
          ..write('dateValidation: $dateValidation, ')
          ..write('validePar: $validePar, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('comptabilise: $comptabilise, ')
          ..write('chargeId: $chargeId, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CongesTable extends Conges with TableInfo<$CongesTable, Conge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CongesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personnelIdMeta =
      const VerificationMeta('personnelId');
  @override
  late final GeneratedColumn<String> personnelId = GeneratedColumn<String>(
      'personnel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateDebutMeta =
      const VerificationMeta('dateDebut');
  @override
  late final GeneratedColumn<DateTime> dateDebut = GeneratedColumn<DateTime>(
      'date_debut', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateFinMeta =
      const VerificationMeta('dateFin');
  @override
  late final GeneratedColumn<DateTime> dateFin = GeneratedColumn<DateTime>(
      'date_fin', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('conge_annuel'));
  static const VerificationMeta _motifMeta = const VerificationMeta('motif');
  @override
  late final GeneratedColumn<String> motif = GeneratedColumn<String>(
      'motif', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('demande'));
  static const VerificationMeta _valideParMeta =
      const VerificationMeta('validePar');
  @override
  late final GeneratedColumn<String> validePar = GeneratedColumn<String>(
      'valide_par', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personnelId,
        dateDebut,
        dateFin,
        type,
        motif,
        statut,
        validePar,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conges';
  @override
  VerificationContext validateIntegrity(Insertable<Conge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
          _personnelIdMeta,
          personnelId.isAcceptableOrUnknown(
              data['personnel_id']!, _personnelIdMeta));
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('date_debut')) {
      context.handle(_dateDebutMeta,
          dateDebut.isAcceptableOrUnknown(data['date_debut']!, _dateDebutMeta));
    } else if (isInserting) {
      context.missing(_dateDebutMeta);
    }
    if (data.containsKey('date_fin')) {
      context.handle(_dateFinMeta,
          dateFin.isAcceptableOrUnknown(data['date_fin']!, _dateFinMeta));
    } else if (isInserting) {
      context.missing(_dateFinMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('motif')) {
      context.handle(
          _motifMeta, motif.isAcceptableOrUnknown(data['motif']!, _motifMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('valide_par')) {
      context.handle(_valideParMeta,
          validePar.isAcceptableOrUnknown(data['valide_par']!, _valideParMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Conge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conge(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      personnelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personnel_id'])!,
      dateDebut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_debut'])!,
      dateFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_fin'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      motif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motif']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      validePar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valide_par']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CongesTable createAlias(String alias) {
    return $CongesTable(attachedDatabase, alias);
  }
}

class Conge extends DataClass implements Insertable<Conge> {
  final String id;
  final String personnelId;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String type;
  final String? motif;
  final String statut;
  final String? validePar;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Conge(
      {required this.id,
      required this.personnelId,
      required this.dateDebut,
      required this.dateFin,
      required this.type,
      this.motif,
      required this.statut,
      this.validePar,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['personnel_id'] = Variable<String>(personnelId);
    map['date_debut'] = Variable<DateTime>(dateDebut);
    map['date_fin'] = Variable<DateTime>(dateFin);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || motif != null) {
      map['motif'] = Variable<String>(motif);
    }
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || validePar != null) {
      map['valide_par'] = Variable<String>(validePar);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CongesCompanion toCompanion(bool nullToAbsent) {
    return CongesCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      dateDebut: Value(dateDebut),
      dateFin: Value(dateFin),
      type: Value(type),
      motif:
          motif == null && nullToAbsent ? const Value.absent() : Value(motif),
      statut: Value(statut),
      validePar: validePar == null && nullToAbsent
          ? const Value.absent()
          : Value(validePar),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Conge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conge(
      id: serializer.fromJson<String>(json['id']),
      personnelId: serializer.fromJson<String>(json['personnelId']),
      dateDebut: serializer.fromJson<DateTime>(json['dateDebut']),
      dateFin: serializer.fromJson<DateTime>(json['dateFin']),
      type: serializer.fromJson<String>(json['type']),
      motif: serializer.fromJson<String?>(json['motif']),
      statut: serializer.fromJson<String>(json['statut']),
      validePar: serializer.fromJson<String?>(json['validePar']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personnelId': serializer.toJson<String>(personnelId),
      'dateDebut': serializer.toJson<DateTime>(dateDebut),
      'dateFin': serializer.toJson<DateTime>(dateFin),
      'type': serializer.toJson<String>(type),
      'motif': serializer.toJson<String?>(motif),
      'statut': serializer.toJson<String>(statut),
      'validePar': serializer.toJson<String?>(validePar),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Conge copyWith(
          {String? id,
          String? personnelId,
          DateTime? dateDebut,
          DateTime? dateFin,
          String? type,
          Value<String?> motif = const Value.absent(),
          String? statut,
          Value<String?> validePar = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Conge(
        id: id ?? this.id,
        personnelId: personnelId ?? this.personnelId,
        dateDebut: dateDebut ?? this.dateDebut,
        dateFin: dateFin ?? this.dateFin,
        type: type ?? this.type,
        motif: motif.present ? motif.value : this.motif,
        statut: statut ?? this.statut,
        validePar: validePar.present ? validePar.value : this.validePar,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Conge copyWithCompanion(CongesCompanion data) {
    return Conge(
      id: data.id.present ? data.id.value : this.id,
      personnelId:
          data.personnelId.present ? data.personnelId.value : this.personnelId,
      dateDebut: data.dateDebut.present ? data.dateDebut.value : this.dateDebut,
      dateFin: data.dateFin.present ? data.dateFin.value : this.dateFin,
      type: data.type.present ? data.type.value : this.type,
      motif: data.motif.present ? data.motif.value : this.motif,
      statut: data.statut.present ? data.statut.value : this.statut,
      validePar: data.validePar.present ? data.validePar.value : this.validePar,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conge(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('type: $type, ')
          ..write('motif: $motif, ')
          ..write('statut: $statut, ')
          ..write('validePar: $validePar, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personnelId, dateDebut, dateFin, type,
      motif, statut, validePar, syncStatus, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conge &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.dateDebut == this.dateDebut &&
          other.dateFin == this.dateFin &&
          other.type == this.type &&
          other.motif == this.motif &&
          other.statut == this.statut &&
          other.validePar == this.validePar &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CongesCompanion extends UpdateCompanion<Conge> {
  final Value<String> id;
  final Value<String> personnelId;
  final Value<DateTime> dateDebut;
  final Value<DateTime> dateFin;
  final Value<String> type;
  final Value<String?> motif;
  final Value<String> statut;
  final Value<String?> validePar;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CongesCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.dateDebut = const Value.absent(),
    this.dateFin = const Value.absent(),
    this.type = const Value.absent(),
    this.motif = const Value.absent(),
    this.statut = const Value.absent(),
    this.validePar = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CongesCompanion.insert({
    required String id,
    required String personnelId,
    required DateTime dateDebut,
    required DateTime dateFin,
    this.type = const Value.absent(),
    this.motif = const Value.absent(),
    this.statut = const Value.absent(),
    this.validePar = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        personnelId = Value(personnelId),
        dateDebut = Value(dateDebut),
        dateFin = Value(dateFin);
  static Insertable<Conge> custom({
    Expression<String>? id,
    Expression<String>? personnelId,
    Expression<DateTime>? dateDebut,
    Expression<DateTime>? dateFin,
    Expression<String>? type,
    Expression<String>? motif,
    Expression<String>? statut,
    Expression<String>? validePar,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
      if (type != null) 'type': type,
      if (motif != null) 'motif': motif,
      if (statut != null) 'statut': statut,
      if (validePar != null) 'valide_par': validePar,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CongesCompanion copyWith(
      {Value<String>? id,
      Value<String>? personnelId,
      Value<DateTime>? dateDebut,
      Value<DateTime>? dateFin,
      Value<String>? type,
      Value<String?>? motif,
      Value<String>? statut,
      Value<String?>? validePar,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CongesCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      type: type ?? this.type,
      motif: motif ?? this.motif,
      statut: statut ?? this.statut,
      validePar: validePar ?? this.validePar,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<String>(personnelId.value);
    }
    if (dateDebut.present) {
      map['date_debut'] = Variable<DateTime>(dateDebut.value);
    }
    if (dateFin.present) {
      map['date_fin'] = Variable<DateTime>(dateFin.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (motif.present) {
      map['motif'] = Variable<String>(motif.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (validePar.present) {
      map['valide_par'] = Variable<String>(validePar.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CongesCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('type: $type, ')
          ..write('motif: $motif, ')
          ..write('statut: $statut, ')
          ..write('validePar: $validePar, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PiecesJointesTable extends PiecesJointes
    with TableInfo<$PiecesJointesTable, PiecesJointe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PiecesJointesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dossierIdMeta =
      const VerificationMeta('dossierId');
  @override
  late final GeneratedColumn<String> dossierId = GeneratedColumn<String>(
      'dossier_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeFichierMeta =
      const VerificationMeta('typeFichier');
  @override
  late final GeneratedColumn<String> typeFichier = GeneratedColumn<String>(
      'type_fichier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cheminLocalMeta =
      const VerificationMeta('cheminLocal');
  @override
  late final GeneratedColumn<String> cheminLocal = GeneratedColumn<String>(
      'chemin_local', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlStorageMeta =
      const VerificationMeta('urlStorage');
  @override
  late final GeneratedColumn<String> urlStorage = GeneratedColumn<String>(
      'url_storage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tailleMeta = const VerificationMeta('taille');
  @override
  late final GeneratedColumn<int> taille = GeneratedColumn<int>(
      'taille', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dossierId,
        nom,
        typeFichier,
        cheminLocal,
        urlStorage,
        taille,
        latitude,
        longitude,
        notes,
        syncStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pieces_jointes';
  @override
  VerificationContext validateIntegrity(Insertable<PiecesJointe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dossier_id')) {
      context.handle(_dossierIdMeta,
          dossierId.isAcceptableOrUnknown(data['dossier_id']!, _dossierIdMeta));
    } else if (isInserting) {
      context.missing(_dossierIdMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('type_fichier')) {
      context.handle(
          _typeFichierMeta,
          typeFichier.isAcceptableOrUnknown(
              data['type_fichier']!, _typeFichierMeta));
    } else if (isInserting) {
      context.missing(_typeFichierMeta);
    }
    if (data.containsKey('chemin_local')) {
      context.handle(
          _cheminLocalMeta,
          cheminLocal.isAcceptableOrUnknown(
              data['chemin_local']!, _cheminLocalMeta));
    } else if (isInserting) {
      context.missing(_cheminLocalMeta);
    }
    if (data.containsKey('url_storage')) {
      context.handle(
          _urlStorageMeta,
          urlStorage.isAcceptableOrUnknown(
              data['url_storage']!, _urlStorageMeta));
    }
    if (data.containsKey('taille')) {
      context.handle(_tailleMeta,
          taille.isAcceptableOrUnknown(data['taille']!, _tailleMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PiecesJointe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PiecesJointe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dossierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dossier_id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      typeFichier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_fichier'])!,
      cheminLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chemin_local'])!,
      urlStorage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_storage']),
      taille: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taille']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PiecesJointesTable createAlias(String alias) {
    return $PiecesJointesTable(attachedDatabase, alias);
  }
}

class PiecesJointe extends DataClass implements Insertable<PiecesJointe> {
  final String id;
  final String dossierId;
  final String nom;
  final String typeFichier;
  final String cheminLocal;
  final String? urlStorage;
  final int? taille;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PiecesJointe(
      {required this.id,
      required this.dossierId,
      required this.nom,
      required this.typeFichier,
      required this.cheminLocal,
      this.urlStorage,
      this.taille,
      this.latitude,
      this.longitude,
      this.notes,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dossier_id'] = Variable<String>(dossierId);
    map['nom'] = Variable<String>(nom);
    map['type_fichier'] = Variable<String>(typeFichier);
    map['chemin_local'] = Variable<String>(cheminLocal);
    if (!nullToAbsent || urlStorage != null) {
      map['url_storage'] = Variable<String>(urlStorage);
    }
    if (!nullToAbsent || taille != null) {
      map['taille'] = Variable<int>(taille);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PiecesJointesCompanion toCompanion(bool nullToAbsent) {
    return PiecesJointesCompanion(
      id: Value(id),
      dossierId: Value(dossierId),
      nom: Value(nom),
      typeFichier: Value(typeFichier),
      cheminLocal: Value(cheminLocal),
      urlStorage: urlStorage == null && nullToAbsent
          ? const Value.absent()
          : Value(urlStorage),
      taille:
          taille == null && nullToAbsent ? const Value.absent() : Value(taille),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PiecesJointe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PiecesJointe(
      id: serializer.fromJson<String>(json['id']),
      dossierId: serializer.fromJson<String>(json['dossierId']),
      nom: serializer.fromJson<String>(json['nom']),
      typeFichier: serializer.fromJson<String>(json['typeFichier']),
      cheminLocal: serializer.fromJson<String>(json['cheminLocal']),
      urlStorage: serializer.fromJson<String?>(json['urlStorage']),
      taille: serializer.fromJson<int?>(json['taille']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dossierId': serializer.toJson<String>(dossierId),
      'nom': serializer.toJson<String>(nom),
      'typeFichier': serializer.toJson<String>(typeFichier),
      'cheminLocal': serializer.toJson<String>(cheminLocal),
      'urlStorage': serializer.toJson<String?>(urlStorage),
      'taille': serializer.toJson<int?>(taille),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'notes': serializer.toJson<String?>(notes),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PiecesJointe copyWith(
          {String? id,
          String? dossierId,
          String? nom,
          String? typeFichier,
          String? cheminLocal,
          Value<String?> urlStorage = const Value.absent(),
          Value<int?> taille = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PiecesJointe(
        id: id ?? this.id,
        dossierId: dossierId ?? this.dossierId,
        nom: nom ?? this.nom,
        typeFichier: typeFichier ?? this.typeFichier,
        cheminLocal: cheminLocal ?? this.cheminLocal,
        urlStorage: urlStorage.present ? urlStorage.value : this.urlStorage,
        taille: taille.present ? taille.value : this.taille,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        notes: notes.present ? notes.value : this.notes,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PiecesJointe copyWithCompanion(PiecesJointesCompanion data) {
    return PiecesJointe(
      id: data.id.present ? data.id.value : this.id,
      dossierId: data.dossierId.present ? data.dossierId.value : this.dossierId,
      nom: data.nom.present ? data.nom.value : this.nom,
      typeFichier:
          data.typeFichier.present ? data.typeFichier.value : this.typeFichier,
      cheminLocal:
          data.cheminLocal.present ? data.cheminLocal.value : this.cheminLocal,
      urlStorage:
          data.urlStorage.present ? data.urlStorage.value : this.urlStorage,
      taille: data.taille.present ? data.taille.value : this.taille,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PiecesJointe(')
          ..write('id: $id, ')
          ..write('dossierId: $dossierId, ')
          ..write('nom: $nom, ')
          ..write('typeFichier: $typeFichier, ')
          ..write('cheminLocal: $cheminLocal, ')
          ..write('urlStorage: $urlStorage, ')
          ..write('taille: $taille, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      dossierId,
      nom,
      typeFichier,
      cheminLocal,
      urlStorage,
      taille,
      latitude,
      longitude,
      notes,
      syncStatus,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PiecesJointe &&
          other.id == this.id &&
          other.dossierId == this.dossierId &&
          other.nom == this.nom &&
          other.typeFichier == this.typeFichier &&
          other.cheminLocal == this.cheminLocal &&
          other.urlStorage == this.urlStorage &&
          other.taille == this.taille &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.notes == this.notes &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PiecesJointesCompanion extends UpdateCompanion<PiecesJointe> {
  final Value<String> id;
  final Value<String> dossierId;
  final Value<String> nom;
  final Value<String> typeFichier;
  final Value<String> cheminLocal;
  final Value<String?> urlStorage;
  final Value<int?> taille;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> notes;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PiecesJointesCompanion({
    this.id = const Value.absent(),
    this.dossierId = const Value.absent(),
    this.nom = const Value.absent(),
    this.typeFichier = const Value.absent(),
    this.cheminLocal = const Value.absent(),
    this.urlStorage = const Value.absent(),
    this.taille = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PiecesJointesCompanion.insert({
    required String id,
    required String dossierId,
    required String nom,
    required String typeFichier,
    required String cheminLocal,
    this.urlStorage = const Value.absent(),
    this.taille = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dossierId = Value(dossierId),
        nom = Value(nom),
        typeFichier = Value(typeFichier),
        cheminLocal = Value(cheminLocal);
  static Insertable<PiecesJointe> custom({
    Expression<String>? id,
    Expression<String>? dossierId,
    Expression<String>? nom,
    Expression<String>? typeFichier,
    Expression<String>? cheminLocal,
    Expression<String>? urlStorage,
    Expression<int>? taille,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? notes,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dossierId != null) 'dossier_id': dossierId,
      if (nom != null) 'nom': nom,
      if (typeFichier != null) 'type_fichier': typeFichier,
      if (cheminLocal != null) 'chemin_local': cheminLocal,
      if (urlStorage != null) 'url_storage': urlStorage,
      if (taille != null) 'taille': taille,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (notes != null) 'notes': notes,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PiecesJointesCompanion copyWith(
      {Value<String>? id,
      Value<String>? dossierId,
      Value<String>? nom,
      Value<String>? typeFichier,
      Value<String>? cheminLocal,
      Value<String?>? urlStorage,
      Value<int?>? taille,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String?>? notes,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PiecesJointesCompanion(
      id: id ?? this.id,
      dossierId: dossierId ?? this.dossierId,
      nom: nom ?? this.nom,
      typeFichier: typeFichier ?? this.typeFichier,
      cheminLocal: cheminLocal ?? this.cheminLocal,
      urlStorage: urlStorage ?? this.urlStorage,
      taille: taille ?? this.taille,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dossierId.present) {
      map['dossier_id'] = Variable<String>(dossierId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (typeFichier.present) {
      map['type_fichier'] = Variable<String>(typeFichier.value);
    }
    if (cheminLocal.present) {
      map['chemin_local'] = Variable<String>(cheminLocal.value);
    }
    if (urlStorage.present) {
      map['url_storage'] = Variable<String>(urlStorage.value);
    }
    if (taille.present) {
      map['taille'] = Variable<int>(taille.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PiecesJointesCompanion(')
          ..write('id: $id, ')
          ..write('dossierId: $dossierId, ')
          ..write('nom: $nom, ')
          ..write('typeFichier: $typeFichier, ')
          ..write('cheminLocal: $cheminLocal, ')
          ..write('urlStorage: $urlStorage, ')
          ..write('taille: $taille, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('notes: $notes, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastAttemptMeta =
      const VerificationMeta('lastAttempt');
  @override
  late final GeneratedColumn<DateTime> lastAttempt = GeneratedColumn<DateTime>(
      'last_attempt', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        payload,
        attempts,
        createdAt,
        lastAttempt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_attempt')) {
      context.handle(
          _lastAttemptMeta,
          lastAttempt.isAcceptableOrUnknown(
              data['last_attempt']!, _lastAttemptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastAttempt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_attempt']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final int attempts;
  final DateTime createdAt;
  final DateTime? lastAttempt;
  const SyncQueueData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.attempts,
      required this.createdAt,
      this.lastAttempt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttempt != null) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      lastAttempt: lastAttempt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttempt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttempt: serializer.fromJson<DateTime?>(json['lastAttempt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttempt': serializer.toJson<DateTime?>(lastAttempt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? payload,
          int? attempts,
          DateTime? createdAt,
          Value<DateTime?> lastAttempt = const Value.absent()}) =>
      SyncQueueData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        attempts: attempts ?? this.attempts,
        createdAt: createdAt ?? this.createdAt,
        lastAttempt: lastAttempt.present ? lastAttempt.value : this.lastAttempt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttempt:
          data.lastAttempt.present ? data.lastAttempt.value : this.lastAttempt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttempt: $lastAttempt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operation, payload,
      attempts, createdAt, lastAttempt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.lastAttempt == this.lastAttempt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttempt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttempt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttempt = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttempt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttempt != null) 'last_attempt': lastAttempt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payload,
      Value<int>? attempts,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastAttempt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      lastAttempt: lastAttempt ?? this.lastAttempt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttempt.present) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttempt: $lastAttempt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ClientContactsTable clientContacts = $ClientContactsTable(this);
  late final $DossiersTable dossiers = $DossiersTable(this);
  late final $DevisTable devis = $DevisTable(this);
  late final $DevisLignesTable devisLignes = $DevisLignesTable(this);
  late final $FacturesTable factures = $FacturesTable(this);
  late final $FacturesLignesTable facturesLignes = $FacturesLignesTable(this);
  late final $ChargesTable charges = $ChargesTable(this);
  late final $ChargesModelesTable chargesModeles = $ChargesModelesTable(this);
  late final $ChargesModeleLinesTable chargesModeleLines =
      $ChargesModeleLinesTable(this);
  late final $TaxesTable taxes = $TaxesTable(this);
  late final $PersonnelTable personnel = $PersonnelTable(this);
  late final $SalairesTable salaires = $SalairesTable(this);
  late final $CongesTable conges = $CongesTable(this);
  late final $PiecesJointesTable piecesJointes = $PiecesJointesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final ClientContactsDao clientContactsDao =
      ClientContactsDao(this as AppDatabase);
  late final DossiersDao dossiersDao = DossiersDao(this as AppDatabase);
  late final DevisDao devisDao = DevisDao(this as AppDatabase);
  late final FacturesDao facturesDao = FacturesDao(this as AppDatabase);
  late final ChargesDao chargesDao = ChargesDao(this as AppDatabase);
  late final ChargesModelesDao chargesModelesDao =
      ChargesModelesDao(this as AppDatabase);
  late final TaxesDao taxesDao = TaxesDao(this as AppDatabase);
  late final PersonnelDao personnelDao = PersonnelDao(this as AppDatabase);
  late final SalairesDao salairesDao = SalairesDao(this as AppDatabase);
  late final CongesDao congesDao = CongesDao(this as AppDatabase);
  late final PiecesJointesDao piecesJointesDao =
      PiecesJointesDao(this as AppDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clients,
        clientContacts,
        dossiers,
        devis,
        devisLignes,
        factures,
        facturesLignes,
        charges,
        chargesModeles,
        chargesModeleLines,
        taxes,
        personnel,
        salaires,
        conges,
        piecesJointes,
        syncQueue
      ];
}

typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  required String id,
  required String entrepriseId,
  required String typeClient,
  required String nom,
  Value<String?> contactNom,
  Value<String?> email,
  Value<String?> telephone,
  Value<String?> adresse,
  Value<String?> ville,
  Value<String> pays,
  Value<String?> numeroTva,
  Value<String?> rccm,
  Value<String?> nif,
  Value<String?> notes,
  Value<double> totalFacture,
  Value<double> totalPaye,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String> typeClient,
  Value<String> nom,
  Value<String?> contactNom,
  Value<String?> email,
  Value<String?> telephone,
  Value<String?> adresse,
  Value<String?> ville,
  Value<String> pays,
  Value<String?> numeroTva,
  Value<String?> rccm,
  Value<String?> nif,
  Value<String?> notes,
  Value<double> totalFacture,
  Value<double> totalPaye,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeClient => $composableBuilder(
      column: $table.typeClient, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactNom => $composableBuilder(
      column: $table.contactNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ville => $composableBuilder(
      column: $table.ville, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pays => $composableBuilder(
      column: $table.pays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroTva => $composableBuilder(
      column: $table.numeroTva, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rccm => $composableBuilder(
      column: $table.rccm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nif => $composableBuilder(
      column: $table.nif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalFacture => $composableBuilder(
      column: $table.totalFacture, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPaye => $composableBuilder(
      column: $table.totalPaye, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeClient => $composableBuilder(
      column: $table.typeClient, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactNom => $composableBuilder(
      column: $table.contactNom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ville => $composableBuilder(
      column: $table.ville, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pays => $composableBuilder(
      column: $table.pays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroTva => $composableBuilder(
      column: $table.numeroTva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rccm => $composableBuilder(
      column: $table.rccm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nif => $composableBuilder(
      column: $table.nif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalFacture => $composableBuilder(
      column: $table.totalFacture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPaye => $composableBuilder(
      column: $table.totalPaye, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get typeClient => $composableBuilder(
      column: $table.typeClient, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get contactNom => $composableBuilder(
      column: $table.contactNom, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get adresse =>
      $composableBuilder(column: $table.adresse, builder: (column) => column);

  GeneratedColumn<String> get ville =>
      $composableBuilder(column: $table.ville, builder: (column) => column);

  GeneratedColumn<String> get pays =>
      $composableBuilder(column: $table.pays, builder: (column) => column);

  GeneratedColumn<String> get numeroTva =>
      $composableBuilder(column: $table.numeroTva, builder: (column) => column);

  GeneratedColumn<String> get rccm =>
      $composableBuilder(column: $table.rccm, builder: (column) => column);

  GeneratedColumn<String> get nif =>
      $composableBuilder(column: $table.nif, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get totalFacture => $composableBuilder(
      column: $table.totalFacture, builder: (column) => column);

  GeneratedColumn<double> get totalPaye =>
      $composableBuilder(column: $table.totalPaye, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
    Client,
    PrefetchHooks Function()> {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String> typeClient = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> contactNom = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String?> ville = const Value.absent(),
            Value<String> pays = const Value.absent(),
            Value<String?> numeroTva = const Value.absent(),
            Value<String?> rccm = const Value.absent(),
            Value<String?> nif = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> totalFacture = const Value.absent(),
            Value<double> totalPaye = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion(
            id: id,
            entrepriseId: entrepriseId,
            typeClient: typeClient,
            nom: nom,
            contactNom: contactNom,
            email: email,
            telephone: telephone,
            adresse: adresse,
            ville: ville,
            pays: pays,
            numeroTva: numeroTva,
            rccm: rccm,
            nif: nif,
            notes: notes,
            totalFacture: totalFacture,
            totalPaye: totalPaye,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            required String typeClient,
            required String nom,
            Value<String?> contactNom = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> adresse = const Value.absent(),
            Value<String?> ville = const Value.absent(),
            Value<String> pays = const Value.absent(),
            Value<String?> numeroTva = const Value.absent(),
            Value<String?> rccm = const Value.absent(),
            Value<String?> nif = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> totalFacture = const Value.absent(),
            Value<double> totalPaye = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            typeClient: typeClient,
            nom: nom,
            contactNom: contactNom,
            email: email,
            telephone: telephone,
            adresse: adresse,
            ville: ville,
            pays: pays,
            numeroTva: numeroTva,
            rccm: rccm,
            nif: nif,
            notes: notes,
            totalFacture: totalFacture,
            totalPaye: totalPaye,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
    Client,
    PrefetchHooks Function()>;
typedef $$ClientContactsTableCreateCompanionBuilder = ClientContactsCompanion
    Function({
  required String id,
  required String clientId,
  required String nom,
  Value<String?> fonction,
  Value<String?> telephone,
  Value<String?> email,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ClientContactsTableUpdateCompanionBuilder = ClientContactsCompanion
    Function({
  Value<String> id,
  Value<String> clientId,
  Value<String> nom,
  Value<String?> fonction,
  Value<String?> telephone,
  Value<String?> email,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ClientContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientContactsTable> {
  $$ClientContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fonction => $composableBuilder(
      column: $table.fonction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ClientContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientContactsTable> {
  $$ClientContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fonction => $composableBuilder(
      column: $table.fonction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ClientContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientContactsTable> {
  $$ClientContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get fonction =>
      $composableBuilder(column: $table.fonction, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientContactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientContactsTable,
    ClientContact,
    $$ClientContactsTableFilterComposer,
    $$ClientContactsTableOrderingComposer,
    $$ClientContactsTableAnnotationComposer,
    $$ClientContactsTableCreateCompanionBuilder,
    $$ClientContactsTableUpdateCompanionBuilder,
    (
      ClientContact,
      BaseReferences<_$AppDatabase, $ClientContactsTable, ClientContact>
    ),
    ClientContact,
    PrefetchHooks Function()> {
  $$ClientContactsTableTableManager(
      _$AppDatabase db, $ClientContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> fonction = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientContactsCompanion(
            id: id,
            clientId: clientId,
            nom: nom,
            fonction: fonction,
            telephone: telephone,
            email: email,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clientId,
            required String nom,
            Value<String?> fonction = const Value.absent(),
            Value<String?> telephone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientContactsCompanion.insert(
            id: id,
            clientId: clientId,
            nom: nom,
            fonction: fonction,
            telephone: telephone,
            email: email,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClientContactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientContactsTable,
    ClientContact,
    $$ClientContactsTableFilterComposer,
    $$ClientContactsTableOrderingComposer,
    $$ClientContactsTableAnnotationComposer,
    $$ClientContactsTableCreateCompanionBuilder,
    $$ClientContactsTableUpdateCompanionBuilder,
    (
      ClientContact,
      BaseReferences<_$AppDatabase, $ClientContactsTable, ClientContact>
    ),
    ClientContact,
    PrefetchHooks Function()>;
typedef $$DossiersTableCreateCompanionBuilder = DossiersCompanion Function({
  required String id,
  required String entrepriseId,
  Value<String?> clientId,
  Value<String?> expertId,
  Value<String?> typeMissionId,
  Value<String?> numero,
  required int annee,
  required String titre,
  Value<String?> description,
  Value<DateTime?> dateSinistre,
  Value<String?> lieuSinistre,
  Value<String?> natureSinistre,
  Value<double?> montantSinistre,
  Value<String> statut,
  Value<String> priorite,
  Value<DateTime> dateOuverture,
  Value<DateTime?> dateExpertise,
  Value<DateTime?> dateRapport,
  Value<DateTime?> dateCloture,
  Value<DateTime?> deadline,
  Value<String?> compagnieAssurance,
  Value<String?> numeroPolice,
  Value<String?> courtier,
  Value<String?> notesInternes,
  Value<String?> observations,
  Value<String?> motifAnnulation,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DossiersTableUpdateCompanionBuilder = DossiersCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String?> clientId,
  Value<String?> expertId,
  Value<String?> typeMissionId,
  Value<String?> numero,
  Value<int> annee,
  Value<String> titre,
  Value<String?> description,
  Value<DateTime?> dateSinistre,
  Value<String?> lieuSinistre,
  Value<String?> natureSinistre,
  Value<double?> montantSinistre,
  Value<String> statut,
  Value<String> priorite,
  Value<DateTime> dateOuverture,
  Value<DateTime?> dateExpertise,
  Value<DateTime?> dateRapport,
  Value<DateTime?> dateCloture,
  Value<DateTime?> deadline,
  Value<String?> compagnieAssurance,
  Value<String?> numeroPolice,
  Value<String?> courtier,
  Value<String?> notesInternes,
  Value<String?> observations,
  Value<String?> motifAnnulation,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DossiersTableFilterComposer
    extends Composer<_$AppDatabase, $DossiersTable> {
  $$DossiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expertId => $composableBuilder(
      column: $table.expertId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeMissionId => $composableBuilder(
      column: $table.typeMissionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titre => $composableBuilder(
      column: $table.titre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateSinistre => $composableBuilder(
      column: $table.dateSinistre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lieuSinistre => $composableBuilder(
      column: $table.lieuSinistre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get natureSinistre => $composableBuilder(
      column: $table.natureSinistre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantSinistre => $composableBuilder(
      column: $table.montantSinistre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priorite => $composableBuilder(
      column: $table.priorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOuverture => $composableBuilder(
      column: $table.dateOuverture, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateExpertise => $composableBuilder(
      column: $table.dateExpertise, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateRapport => $composableBuilder(
      column: $table.dateRapport, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCloture => $composableBuilder(
      column: $table.dateCloture, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get compagnieAssurance => $composableBuilder(
      column: $table.compagnieAssurance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroPolice => $composableBuilder(
      column: $table.numeroPolice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get courtier => $composableBuilder(
      column: $table.courtier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notesInternes => $composableBuilder(
      column: $table.notesInternes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DossiersTableOrderingComposer
    extends Composer<_$AppDatabase, $DossiersTable> {
  $$DossiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expertId => $composableBuilder(
      column: $table.expertId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeMissionId => $composableBuilder(
      column: $table.typeMissionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titre => $composableBuilder(
      column: $table.titre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateSinistre => $composableBuilder(
      column: $table.dateSinistre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lieuSinistre => $composableBuilder(
      column: $table.lieuSinistre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get natureSinistre => $composableBuilder(
      column: $table.natureSinistre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantSinistre => $composableBuilder(
      column: $table.montantSinistre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priorite => $composableBuilder(
      column: $table.priorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOuverture => $composableBuilder(
      column: $table.dateOuverture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateExpertise => $composableBuilder(
      column: $table.dateExpertise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateRapport => $composableBuilder(
      column: $table.dateRapport, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCloture => $composableBuilder(
      column: $table.dateCloture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get compagnieAssurance => $composableBuilder(
      column: $table.compagnieAssurance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroPolice => $composableBuilder(
      column: $table.numeroPolice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get courtier => $composableBuilder(
      column: $table.courtier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notesInternes => $composableBuilder(
      column: $table.notesInternes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observations => $composableBuilder(
      column: $table.observations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DossiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DossiersTable> {
  $$DossiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get expertId =>
      $composableBuilder(column: $table.expertId, builder: (column) => column);

  GeneratedColumn<String> get typeMissionId => $composableBuilder(
      column: $table.typeMissionId, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dateSinistre => $composableBuilder(
      column: $table.dateSinistre, builder: (column) => column);

  GeneratedColumn<String> get lieuSinistre => $composableBuilder(
      column: $table.lieuSinistre, builder: (column) => column);

  GeneratedColumn<String> get natureSinistre => $composableBuilder(
      column: $table.natureSinistre, builder: (column) => column);

  GeneratedColumn<double> get montantSinistre => $composableBuilder(
      column: $table.montantSinistre, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get priorite =>
      $composableBuilder(column: $table.priorite, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOuverture => $composableBuilder(
      column: $table.dateOuverture, builder: (column) => column);

  GeneratedColumn<DateTime> get dateExpertise => $composableBuilder(
      column: $table.dateExpertise, builder: (column) => column);

  GeneratedColumn<DateTime> get dateRapport => $composableBuilder(
      column: $table.dateRapport, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCloture => $composableBuilder(
      column: $table.dateCloture, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get compagnieAssurance => $composableBuilder(
      column: $table.compagnieAssurance, builder: (column) => column);

  GeneratedColumn<String> get numeroPolice => $composableBuilder(
      column: $table.numeroPolice, builder: (column) => column);

  GeneratedColumn<String> get courtier =>
      $composableBuilder(column: $table.courtier, builder: (column) => column);

  GeneratedColumn<String> get notesInternes => $composableBuilder(
      column: $table.notesInternes, builder: (column) => column);

  GeneratedColumn<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => column);

  GeneratedColumn<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DossiersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DossiersTable,
    Dossier,
    $$DossiersTableFilterComposer,
    $$DossiersTableOrderingComposer,
    $$DossiersTableAnnotationComposer,
    $$DossiersTableCreateCompanionBuilder,
    $$DossiersTableUpdateCompanionBuilder,
    (Dossier, BaseReferences<_$AppDatabase, $DossiersTable, Dossier>),
    Dossier,
    PrefetchHooks Function()> {
  $$DossiersTableTableManager(_$AppDatabase db, $DossiersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DossiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DossiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DossiersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String?> clientId = const Value.absent(),
            Value<String?> expertId = const Value.absent(),
            Value<String?> typeMissionId = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<String> titre = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> dateSinistre = const Value.absent(),
            Value<String?> lieuSinistre = const Value.absent(),
            Value<String?> natureSinistre = const Value.absent(),
            Value<double?> montantSinistre = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String> priorite = const Value.absent(),
            Value<DateTime> dateOuverture = const Value.absent(),
            Value<DateTime?> dateExpertise = const Value.absent(),
            Value<DateTime?> dateRapport = const Value.absent(),
            Value<DateTime?> dateCloture = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<String?> compagnieAssurance = const Value.absent(),
            Value<String?> numeroPolice = const Value.absent(),
            Value<String?> courtier = const Value.absent(),
            Value<String?> notesInternes = const Value.absent(),
            Value<String?> observations = const Value.absent(),
            Value<String?> motifAnnulation = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DossiersCompanion(
            id: id,
            entrepriseId: entrepriseId,
            clientId: clientId,
            expertId: expertId,
            typeMissionId: typeMissionId,
            numero: numero,
            annee: annee,
            titre: titre,
            description: description,
            dateSinistre: dateSinistre,
            lieuSinistre: lieuSinistre,
            natureSinistre: natureSinistre,
            montantSinistre: montantSinistre,
            statut: statut,
            priorite: priorite,
            dateOuverture: dateOuverture,
            dateExpertise: dateExpertise,
            dateRapport: dateRapport,
            dateCloture: dateCloture,
            deadline: deadline,
            compagnieAssurance: compagnieAssurance,
            numeroPolice: numeroPolice,
            courtier: courtier,
            notesInternes: notesInternes,
            observations: observations,
            motifAnnulation: motifAnnulation,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            Value<String?> clientId = const Value.absent(),
            Value<String?> expertId = const Value.absent(),
            Value<String?> typeMissionId = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            required int annee,
            required String titre,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> dateSinistre = const Value.absent(),
            Value<String?> lieuSinistre = const Value.absent(),
            Value<String?> natureSinistre = const Value.absent(),
            Value<double?> montantSinistre = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String> priorite = const Value.absent(),
            Value<DateTime> dateOuverture = const Value.absent(),
            Value<DateTime?> dateExpertise = const Value.absent(),
            Value<DateTime?> dateRapport = const Value.absent(),
            Value<DateTime?> dateCloture = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<String?> compagnieAssurance = const Value.absent(),
            Value<String?> numeroPolice = const Value.absent(),
            Value<String?> courtier = const Value.absent(),
            Value<String?> notesInternes = const Value.absent(),
            Value<String?> observations = const Value.absent(),
            Value<String?> motifAnnulation = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DossiersCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            clientId: clientId,
            expertId: expertId,
            typeMissionId: typeMissionId,
            numero: numero,
            annee: annee,
            titre: titre,
            description: description,
            dateSinistre: dateSinistre,
            lieuSinistre: lieuSinistre,
            natureSinistre: natureSinistre,
            montantSinistre: montantSinistre,
            statut: statut,
            priorite: priorite,
            dateOuverture: dateOuverture,
            dateExpertise: dateExpertise,
            dateRapport: dateRapport,
            dateCloture: dateCloture,
            deadline: deadline,
            compagnieAssurance: compagnieAssurance,
            numeroPolice: numeroPolice,
            courtier: courtier,
            notesInternes: notesInternes,
            observations: observations,
            motifAnnulation: motifAnnulation,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DossiersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DossiersTable,
    Dossier,
    $$DossiersTableFilterComposer,
    $$DossiersTableOrderingComposer,
    $$DossiersTableAnnotationComposer,
    $$DossiersTableCreateCompanionBuilder,
    $$DossiersTableUpdateCompanionBuilder,
    (Dossier, BaseReferences<_$AppDatabase, $DossiersTable, Dossier>),
    Dossier,
    PrefetchHooks Function()>;
typedef $$DevisTableCreateCompanionBuilder = DevisCompanion Function({
  required String id,
  required String entrepriseId,
  Value<String?> dossierId,
  required String clientId,
  Value<String?> creePar,
  Value<String?> numero,
  required int annee,
  Value<String> statut,
  required DateTime dateEmission,
  required DateTime dateValidite,
  Value<double> montantHt,
  Value<double> tauxTva,
  Value<double> montantTva,
  Value<double> tauxTps,
  Value<double> montantTps,
  Value<double> montantTtc,
  Value<String?> objet,
  Value<String?> conditions,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DevisTableUpdateCompanionBuilder = DevisCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String?> dossierId,
  Value<String> clientId,
  Value<String?> creePar,
  Value<String?> numero,
  Value<int> annee,
  Value<String> statut,
  Value<DateTime> dateEmission,
  Value<DateTime> dateValidite,
  Value<double> montantHt,
  Value<double> tauxTva,
  Value<double> montantTva,
  Value<double> tauxTps,
  Value<double> montantTps,
  Value<double> montantTtc,
  Value<String?> objet,
  Value<String?> conditions,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DevisTableFilterComposer extends Composer<_$AppDatabase, $DevisTable> {
  $$DevisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creePar => $composableBuilder(
      column: $table.creePar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateValidite => $composableBuilder(
      column: $table.dateValidite, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxTva => $composableBuilder(
      column: $table.tauxTva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxTps => $composableBuilder(
      column: $table.tauxTps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get objet => $composableBuilder(
      column: $table.objet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DevisTableOrderingComposer
    extends Composer<_$AppDatabase, $DevisTable> {
  $$DevisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creePar => $composableBuilder(
      column: $table.creePar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateValidite => $composableBuilder(
      column: $table.dateValidite,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxTva => $composableBuilder(
      column: $table.tauxTva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxTps => $composableBuilder(
      column: $table.tauxTps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get objet => $composableBuilder(
      column: $table.objet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DevisTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevisTable> {
  $$DevisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get dossierId =>
      $composableBuilder(column: $table.dossierId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get creePar =>
      $composableBuilder(column: $table.creePar, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission, builder: (column) => column);

  GeneratedColumn<DateTime> get dateValidite => $composableBuilder(
      column: $table.dateValidite, builder: (column) => column);

  GeneratedColumn<double> get montantHt =>
      $composableBuilder(column: $table.montantHt, builder: (column) => column);

  GeneratedColumn<double> get tauxTva =>
      $composableBuilder(column: $table.tauxTva, builder: (column) => column);

  GeneratedColumn<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => column);

  GeneratedColumn<double> get tauxTps =>
      $composableBuilder(column: $table.tauxTps, builder: (column) => column);

  GeneratedColumn<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => column);

  GeneratedColumn<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => column);

  GeneratedColumn<String> get objet =>
      $composableBuilder(column: $table.objet, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DevisTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DevisTable,
    Devi,
    $$DevisTableFilterComposer,
    $$DevisTableOrderingComposer,
    $$DevisTableAnnotationComposer,
    $$DevisTableCreateCompanionBuilder,
    $$DevisTableUpdateCompanionBuilder,
    (Devi, BaseReferences<_$AppDatabase, $DevisTable, Devi>),
    Devi,
    PrefetchHooks Function()> {
  $$DevisTableTableManager(_$AppDatabase db, $DevisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String?> dossierId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> creePar = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<DateTime> dateEmission = const Value.absent(),
            Value<DateTime> dateValidite = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<double> tauxTva = const Value.absent(),
            Value<double> montantTva = const Value.absent(),
            Value<double> tauxTps = const Value.absent(),
            Value<double> montantTps = const Value.absent(),
            Value<double> montantTtc = const Value.absent(),
            Value<String?> objet = const Value.absent(),
            Value<String?> conditions = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevisCompanion(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            clientId: clientId,
            creePar: creePar,
            numero: numero,
            annee: annee,
            statut: statut,
            dateEmission: dateEmission,
            dateValidite: dateValidite,
            montantHt: montantHt,
            tauxTva: tauxTva,
            montantTva: montantTva,
            tauxTps: tauxTps,
            montantTps: montantTps,
            montantTtc: montantTtc,
            objet: objet,
            conditions: conditions,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            Value<String?> dossierId = const Value.absent(),
            required String clientId,
            Value<String?> creePar = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            required int annee,
            Value<String> statut = const Value.absent(),
            required DateTime dateEmission,
            required DateTime dateValidite,
            Value<double> montantHt = const Value.absent(),
            Value<double> tauxTva = const Value.absent(),
            Value<double> montantTva = const Value.absent(),
            Value<double> tauxTps = const Value.absent(),
            Value<double> montantTps = const Value.absent(),
            Value<double> montantTtc = const Value.absent(),
            Value<String?> objet = const Value.absent(),
            Value<String?> conditions = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevisCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            clientId: clientId,
            creePar: creePar,
            numero: numero,
            annee: annee,
            statut: statut,
            dateEmission: dateEmission,
            dateValidite: dateValidite,
            montantHt: montantHt,
            tauxTva: tauxTva,
            montantTva: montantTva,
            tauxTps: tauxTps,
            montantTps: montantTps,
            montantTtc: montantTtc,
            objet: objet,
            conditions: conditions,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DevisTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DevisTable,
    Devi,
    $$DevisTableFilterComposer,
    $$DevisTableOrderingComposer,
    $$DevisTableAnnotationComposer,
    $$DevisTableCreateCompanionBuilder,
    $$DevisTableUpdateCompanionBuilder,
    (Devi, BaseReferences<_$AppDatabase, $DevisTable, Devi>),
    Devi,
    PrefetchHooks Function()>;
typedef $$DevisLignesTableCreateCompanionBuilder = DevisLignesCompanion
    Function({
  required String id,
  required String devisId,
  Value<int> ordre,
  required String designation,
  Value<String?> description,
  Value<double> quantite,
  Value<String> unite,
  Value<double> prixUnit,
  Value<double> montantHt,
  Value<String?> taxesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DevisLignesTableUpdateCompanionBuilder = DevisLignesCompanion
    Function({
  Value<String> id,
  Value<String> devisId,
  Value<int> ordre,
  Value<String> designation,
  Value<String?> description,
  Value<double> quantite,
  Value<String> unite,
  Value<double> prixUnit,
  Value<double> montantHt,
  Value<String?> taxesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DevisLignesTableFilterComposer
    extends Composer<_$AppDatabase, $DevisLignesTable> {
  $$DevisLignesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get devisId => $composableBuilder(
      column: $table.devisId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prixUnit => $composableBuilder(
      column: $table.prixUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxesJson => $composableBuilder(
      column: $table.taxesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DevisLignesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevisLignesTable> {
  $$DevisLignesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get devisId => $composableBuilder(
      column: $table.devisId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prixUnit => $composableBuilder(
      column: $table.prixUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxesJson => $composableBuilder(
      column: $table.taxesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DevisLignesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevisLignesTable> {
  $$DevisLignesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get devisId =>
      $composableBuilder(column: $table.devisId, builder: (column) => column);

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get quantite =>
      $composableBuilder(column: $table.quantite, builder: (column) => column);

  GeneratedColumn<String> get unite =>
      $composableBuilder(column: $table.unite, builder: (column) => column);

  GeneratedColumn<double> get prixUnit =>
      $composableBuilder(column: $table.prixUnit, builder: (column) => column);

  GeneratedColumn<double> get montantHt =>
      $composableBuilder(column: $table.montantHt, builder: (column) => column);

  GeneratedColumn<String> get taxesJson =>
      $composableBuilder(column: $table.taxesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DevisLignesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DevisLignesTable,
    DevisLigne,
    $$DevisLignesTableFilterComposer,
    $$DevisLignesTableOrderingComposer,
    $$DevisLignesTableAnnotationComposer,
    $$DevisLignesTableCreateCompanionBuilder,
    $$DevisLignesTableUpdateCompanionBuilder,
    (DevisLigne, BaseReferences<_$AppDatabase, $DevisLignesTable, DevisLigne>),
    DevisLigne,
    PrefetchHooks Function()> {
  $$DevisLignesTableTableManager(_$AppDatabase db, $DevisLignesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevisLignesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevisLignesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevisLignesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> devisId = const Value.absent(),
            Value<int> ordre = const Value.absent(),
            Value<String> designation = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> quantite = const Value.absent(),
            Value<String> unite = const Value.absent(),
            Value<double> prixUnit = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<String?> taxesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevisLignesCompanion(
            id: id,
            devisId: devisId,
            ordre: ordre,
            designation: designation,
            description: description,
            quantite: quantite,
            unite: unite,
            prixUnit: prixUnit,
            montantHt: montantHt,
            taxesJson: taxesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String devisId,
            Value<int> ordre = const Value.absent(),
            required String designation,
            Value<String?> description = const Value.absent(),
            Value<double> quantite = const Value.absent(),
            Value<String> unite = const Value.absent(),
            Value<double> prixUnit = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<String?> taxesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevisLignesCompanion.insert(
            id: id,
            devisId: devisId,
            ordre: ordre,
            designation: designation,
            description: description,
            quantite: quantite,
            unite: unite,
            prixUnit: prixUnit,
            montantHt: montantHt,
            taxesJson: taxesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DevisLignesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DevisLignesTable,
    DevisLigne,
    $$DevisLignesTableFilterComposer,
    $$DevisLignesTableOrderingComposer,
    $$DevisLignesTableAnnotationComposer,
    $$DevisLignesTableCreateCompanionBuilder,
    $$DevisLignesTableUpdateCompanionBuilder,
    (DevisLigne, BaseReferences<_$AppDatabase, $DevisLignesTable, DevisLigne>),
    DevisLigne,
    PrefetchHooks Function()>;
typedef $$FacturesTableCreateCompanionBuilder = FacturesCompanion Function({
  required String id,
  required String entrepriseId,
  Value<String?> dossierId,
  required String clientId,
  Value<String?> devisId,
  Value<String?> creePar,
  Value<String?> numero,
  required int annee,
  Value<String> statut,
  required DateTime dateEmission,
  required DateTime dateEcheance,
  Value<DateTime?> datePaiement,
  Value<double> montantHt,
  Value<double> tauxTva,
  Value<double> montantTva,
  Value<double> tauxTps,
  Value<double> montantTps,
  Value<double> montantTtc,
  Value<double> montantPaye,
  Value<double> montantRestant,
  Value<String?> modePaiement,
  Value<String?> referencePaiement,
  Value<String?> objet,
  Value<String?> conditions,
  Value<String?> notes,
  Value<String?> motifAnnulation,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$FacturesTableUpdateCompanionBuilder = FacturesCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String?> dossierId,
  Value<String> clientId,
  Value<String?> devisId,
  Value<String?> creePar,
  Value<String?> numero,
  Value<int> annee,
  Value<String> statut,
  Value<DateTime> dateEmission,
  Value<DateTime> dateEcheance,
  Value<DateTime?> datePaiement,
  Value<double> montantHt,
  Value<double> tauxTva,
  Value<double> montantTva,
  Value<double> tauxTps,
  Value<double> montantTps,
  Value<double> montantTtc,
  Value<double> montantPaye,
  Value<double> montantRestant,
  Value<String?> modePaiement,
  Value<String?> referencePaiement,
  Value<String?> objet,
  Value<String?> conditions,
  Value<String?> notes,
  Value<String?> motifAnnulation,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FacturesTableFilterComposer
    extends Composer<_$AppDatabase, $FacturesTable> {
  $$FacturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get devisId => $composableBuilder(
      column: $table.devisId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creePar => $composableBuilder(
      column: $table.creePar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxTva => $composableBuilder(
      column: $table.tauxTva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxTps => $composableBuilder(
      column: $table.tauxTps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get objet => $composableBuilder(
      column: $table.objet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FacturesTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturesTable> {
  $$FacturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get devisId => $composableBuilder(
      column: $table.devisId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creePar => $composableBuilder(
      column: $table.creePar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxTva => $composableBuilder(
      column: $table.tauxTva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxTps => $composableBuilder(
      column: $table.tauxTps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get objet => $composableBuilder(
      column: $table.objet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FacturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturesTable> {
  $$FacturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get dossierId =>
      $composableBuilder(column: $table.dossierId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get devisId =>
      $composableBuilder(column: $table.devisId, builder: (column) => column);

  GeneratedColumn<String> get creePar =>
      $composableBuilder(column: $table.creePar, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEmission => $composableBuilder(
      column: $table.dateEmission, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => column);

  GeneratedColumn<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => column);

  GeneratedColumn<double> get montantHt =>
      $composableBuilder(column: $table.montantHt, builder: (column) => column);

  GeneratedColumn<double> get tauxTva =>
      $composableBuilder(column: $table.tauxTva, builder: (column) => column);

  GeneratedColumn<double> get montantTva => $composableBuilder(
      column: $table.montantTva, builder: (column) => column);

  GeneratedColumn<double> get tauxTps =>
      $composableBuilder(column: $table.tauxTps, builder: (column) => column);

  GeneratedColumn<double> get montantTps => $composableBuilder(
      column: $table.montantTps, builder: (column) => column);

  GeneratedColumn<double> get montantTtc => $composableBuilder(
      column: $table.montantTtc, builder: (column) => column);

  GeneratedColumn<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => column);

  GeneratedColumn<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant, builder: (column) => column);

  GeneratedColumn<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => column);

  GeneratedColumn<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement, builder: (column) => column);

  GeneratedColumn<String> get objet =>
      $composableBuilder(column: $table.objet, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get motifAnnulation => $composableBuilder(
      column: $table.motifAnnulation, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FacturesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FacturesTable,
    Facture,
    $$FacturesTableFilterComposer,
    $$FacturesTableOrderingComposer,
    $$FacturesTableAnnotationComposer,
    $$FacturesTableCreateCompanionBuilder,
    $$FacturesTableUpdateCompanionBuilder,
    (Facture, BaseReferences<_$AppDatabase, $FacturesTable, Facture>),
    Facture,
    PrefetchHooks Function()> {
  $$FacturesTableTableManager(_$AppDatabase db, $FacturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String?> dossierId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String?> devisId = const Value.absent(),
            Value<String?> creePar = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<DateTime> dateEmission = const Value.absent(),
            Value<DateTime> dateEcheance = const Value.absent(),
            Value<DateTime?> datePaiement = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<double> tauxTva = const Value.absent(),
            Value<double> montantTva = const Value.absent(),
            Value<double> tauxTps = const Value.absent(),
            Value<double> montantTps = const Value.absent(),
            Value<double> montantTtc = const Value.absent(),
            Value<double> montantPaye = const Value.absent(),
            Value<double> montantRestant = const Value.absent(),
            Value<String?> modePaiement = const Value.absent(),
            Value<String?> referencePaiement = const Value.absent(),
            Value<String?> objet = const Value.absent(),
            Value<String?> conditions = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> motifAnnulation = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FacturesCompanion(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            clientId: clientId,
            devisId: devisId,
            creePar: creePar,
            numero: numero,
            annee: annee,
            statut: statut,
            dateEmission: dateEmission,
            dateEcheance: dateEcheance,
            datePaiement: datePaiement,
            montantHt: montantHt,
            tauxTva: tauxTva,
            montantTva: montantTva,
            tauxTps: tauxTps,
            montantTps: montantTps,
            montantTtc: montantTtc,
            montantPaye: montantPaye,
            montantRestant: montantRestant,
            modePaiement: modePaiement,
            referencePaiement: referencePaiement,
            objet: objet,
            conditions: conditions,
            notes: notes,
            motifAnnulation: motifAnnulation,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            Value<String?> dossierId = const Value.absent(),
            required String clientId,
            Value<String?> devisId = const Value.absent(),
            Value<String?> creePar = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            required int annee,
            Value<String> statut = const Value.absent(),
            required DateTime dateEmission,
            required DateTime dateEcheance,
            Value<DateTime?> datePaiement = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<double> tauxTva = const Value.absent(),
            Value<double> montantTva = const Value.absent(),
            Value<double> tauxTps = const Value.absent(),
            Value<double> montantTps = const Value.absent(),
            Value<double> montantTtc = const Value.absent(),
            Value<double> montantPaye = const Value.absent(),
            Value<double> montantRestant = const Value.absent(),
            Value<String?> modePaiement = const Value.absent(),
            Value<String?> referencePaiement = const Value.absent(),
            Value<String?> objet = const Value.absent(),
            Value<String?> conditions = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> motifAnnulation = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FacturesCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            clientId: clientId,
            devisId: devisId,
            creePar: creePar,
            numero: numero,
            annee: annee,
            statut: statut,
            dateEmission: dateEmission,
            dateEcheance: dateEcheance,
            datePaiement: datePaiement,
            montantHt: montantHt,
            tauxTva: tauxTva,
            montantTva: montantTva,
            tauxTps: tauxTps,
            montantTps: montantTps,
            montantTtc: montantTtc,
            montantPaye: montantPaye,
            montantRestant: montantRestant,
            modePaiement: modePaiement,
            referencePaiement: referencePaiement,
            objet: objet,
            conditions: conditions,
            notes: notes,
            motifAnnulation: motifAnnulation,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FacturesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FacturesTable,
    Facture,
    $$FacturesTableFilterComposer,
    $$FacturesTableOrderingComposer,
    $$FacturesTableAnnotationComposer,
    $$FacturesTableCreateCompanionBuilder,
    $$FacturesTableUpdateCompanionBuilder,
    (Facture, BaseReferences<_$AppDatabase, $FacturesTable, Facture>),
    Facture,
    PrefetchHooks Function()>;
typedef $$FacturesLignesTableCreateCompanionBuilder = FacturesLignesCompanion
    Function({
  required String id,
  required String factureId,
  Value<int> ordre,
  required String designation,
  Value<String?> description,
  Value<double> quantite,
  Value<String> unite,
  Value<double> prixUnit,
  Value<double> montantHt,
  Value<String?> taxesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$FacturesLignesTableUpdateCompanionBuilder = FacturesLignesCompanion
    Function({
  Value<String> id,
  Value<String> factureId,
  Value<int> ordre,
  Value<String> designation,
  Value<String?> description,
  Value<double> quantite,
  Value<String> unite,
  Value<double> prixUnit,
  Value<double> montantHt,
  Value<String?> taxesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FacturesLignesTableFilterComposer
    extends Composer<_$AppDatabase, $FacturesLignesTable> {
  $$FacturesLignesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get factureId => $composableBuilder(
      column: $table.factureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prixUnit => $composableBuilder(
      column: $table.prixUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxesJson => $composableBuilder(
      column: $table.taxesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FacturesLignesTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturesLignesTable> {
  $$FacturesLignesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get factureId => $composableBuilder(
      column: $table.factureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unite => $composableBuilder(
      column: $table.unite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prixUnit => $composableBuilder(
      column: $table.prixUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantHt => $composableBuilder(
      column: $table.montantHt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxesJson => $composableBuilder(
      column: $table.taxesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FacturesLignesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturesLignesTable> {
  $$FacturesLignesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get factureId =>
      $composableBuilder(column: $table.factureId, builder: (column) => column);

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get quantite =>
      $composableBuilder(column: $table.quantite, builder: (column) => column);

  GeneratedColumn<String> get unite =>
      $composableBuilder(column: $table.unite, builder: (column) => column);

  GeneratedColumn<double> get prixUnit =>
      $composableBuilder(column: $table.prixUnit, builder: (column) => column);

  GeneratedColumn<double> get montantHt =>
      $composableBuilder(column: $table.montantHt, builder: (column) => column);

  GeneratedColumn<String> get taxesJson =>
      $composableBuilder(column: $table.taxesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FacturesLignesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FacturesLignesTable,
    FacturesLigne,
    $$FacturesLignesTableFilterComposer,
    $$FacturesLignesTableOrderingComposer,
    $$FacturesLignesTableAnnotationComposer,
    $$FacturesLignesTableCreateCompanionBuilder,
    $$FacturesLignesTableUpdateCompanionBuilder,
    (
      FacturesLigne,
      BaseReferences<_$AppDatabase, $FacturesLignesTable, FacturesLigne>
    ),
    FacturesLigne,
    PrefetchHooks Function()> {
  $$FacturesLignesTableTableManager(
      _$AppDatabase db, $FacturesLignesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturesLignesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturesLignesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturesLignesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> factureId = const Value.absent(),
            Value<int> ordre = const Value.absent(),
            Value<String> designation = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> quantite = const Value.absent(),
            Value<String> unite = const Value.absent(),
            Value<double> prixUnit = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<String?> taxesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FacturesLignesCompanion(
            id: id,
            factureId: factureId,
            ordre: ordre,
            designation: designation,
            description: description,
            quantite: quantite,
            unite: unite,
            prixUnit: prixUnit,
            montantHt: montantHt,
            taxesJson: taxesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String factureId,
            Value<int> ordre = const Value.absent(),
            required String designation,
            Value<String?> description = const Value.absent(),
            Value<double> quantite = const Value.absent(),
            Value<String> unite = const Value.absent(),
            Value<double> prixUnit = const Value.absent(),
            Value<double> montantHt = const Value.absent(),
            Value<String?> taxesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FacturesLignesCompanion.insert(
            id: id,
            factureId: factureId,
            ordre: ordre,
            designation: designation,
            description: description,
            quantite: quantite,
            unite: unite,
            prixUnit: prixUnit,
            montantHt: montantHt,
            taxesJson: taxesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FacturesLignesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FacturesLignesTable,
    FacturesLigne,
    $$FacturesLignesTableFilterComposer,
    $$FacturesLignesTableOrderingComposer,
    $$FacturesLignesTableAnnotationComposer,
    $$FacturesLignesTableCreateCompanionBuilder,
    $$FacturesLignesTableUpdateCompanionBuilder,
    (
      FacturesLigne,
      BaseReferences<_$AppDatabase, $FacturesLignesTable, FacturesLigne>
    ),
    FacturesLigne,
    PrefetchHooks Function()>;
typedef $$ChargesTableCreateCompanionBuilder = ChargesCompanion Function({
  required String id,
  required String entrepriseId,
  Value<String?> dossierId,
  Value<String?> saisiPar,
  required String categorie,
  required String libelle,
  required double montant,
  required DateTime dateCharge,
  required int mois,
  required int annee,
  Value<String?> justificatifUrl,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ChargesTableUpdateCompanionBuilder = ChargesCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String?> dossierId,
  Value<String?> saisiPar,
  Value<String> categorie,
  Value<String> libelle,
  Value<double> montant,
  Value<DateTime> dateCharge,
  Value<int> mois,
  Value<int> annee,
  Value<String?> justificatifUrl,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ChargesTableFilterComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saisiPar => $composableBuilder(
      column: $table.saisiPar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categorie => $composableBuilder(
      column: $table.categorie, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCharge => $composableBuilder(
      column: $table.dateCharge, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get justificatifUrl => $composableBuilder(
      column: $table.justificatifUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ChargesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saisiPar => $composableBuilder(
      column: $table.saisiPar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categorie => $composableBuilder(
      column: $table.categorie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCharge => $composableBuilder(
      column: $table.dateCharge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get justificatifUrl => $composableBuilder(
      column: $table.justificatifUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargesTable> {
  $$ChargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get dossierId =>
      $composableBuilder(column: $table.dossierId, builder: (column) => column);

  GeneratedColumn<String> get saisiPar =>
      $composableBuilder(column: $table.saisiPar, builder: (column) => column);

  GeneratedColumn<String> get categorie =>
      $composableBuilder(column: $table.categorie, builder: (column) => column);

  GeneratedColumn<String> get libelle =>
      $composableBuilder(column: $table.libelle, builder: (column) => column);

  GeneratedColumn<double> get montant =>
      $composableBuilder(column: $table.montant, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCharge => $composableBuilder(
      column: $table.dateCharge, builder: (column) => column);

  GeneratedColumn<int> get mois =>
      $composableBuilder(column: $table.mois, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<String> get justificatifUrl => $composableBuilder(
      column: $table.justificatifUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChargesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargesTable,
    Charge,
    $$ChargesTableFilterComposer,
    $$ChargesTableOrderingComposer,
    $$ChargesTableAnnotationComposer,
    $$ChargesTableCreateCompanionBuilder,
    $$ChargesTableUpdateCompanionBuilder,
    (Charge, BaseReferences<_$AppDatabase, $ChargesTable, Charge>),
    Charge,
    PrefetchHooks Function()> {
  $$ChargesTableTableManager(_$AppDatabase db, $ChargesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String?> dossierId = const Value.absent(),
            Value<String?> saisiPar = const Value.absent(),
            Value<String> categorie = const Value.absent(),
            Value<String> libelle = const Value.absent(),
            Value<double> montant = const Value.absent(),
            Value<DateTime> dateCharge = const Value.absent(),
            Value<int> mois = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<String?> justificatifUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesCompanion(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            saisiPar: saisiPar,
            categorie: categorie,
            libelle: libelle,
            montant: montant,
            dateCharge: dateCharge,
            mois: mois,
            annee: annee,
            justificatifUrl: justificatifUrl,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            Value<String?> dossierId = const Value.absent(),
            Value<String?> saisiPar = const Value.absent(),
            required String categorie,
            required String libelle,
            required double montant,
            required DateTime dateCharge,
            required int mois,
            required int annee,
            Value<String?> justificatifUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            dossierId: dossierId,
            saisiPar: saisiPar,
            categorie: categorie,
            libelle: libelle,
            montant: montant,
            dateCharge: dateCharge,
            mois: mois,
            annee: annee,
            justificatifUrl: justificatifUrl,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChargesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChargesTable,
    Charge,
    $$ChargesTableFilterComposer,
    $$ChargesTableOrderingComposer,
    $$ChargesTableAnnotationComposer,
    $$ChargesTableCreateCompanionBuilder,
    $$ChargesTableUpdateCompanionBuilder,
    (Charge, BaseReferences<_$AppDatabase, $ChargesTable, Charge>),
    Charge,
    PrefetchHooks Function()>;
typedef $$ChargesModelesTableCreateCompanionBuilder = ChargesModelesCompanion
    Function({
  required String id,
  required String entrepriseId,
  required int mois,
  required int annee,
  required String titre,
  Value<String?> soumisParId,
  Value<String?> soumisParNom,
  Value<String> statut,
  Value<String?> motifRefus,
  Value<DateTime?> dateSubmission,
  Value<DateTime?> dateValidation,
  Value<String?> valideParId,
  Value<String?> valideParNom,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ChargesModelesTableUpdateCompanionBuilder = ChargesModelesCompanion
    Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<int> mois,
  Value<int> annee,
  Value<String> titre,
  Value<String?> soumisParId,
  Value<String?> soumisParNom,
  Value<String> statut,
  Value<String?> motifRefus,
  Value<DateTime?> dateSubmission,
  Value<DateTime?> dateValidation,
  Value<String?> valideParId,
  Value<String?> valideParNom,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ChargesModelesTableFilterComposer
    extends Composer<_$AppDatabase, $ChargesModelesTable> {
  $$ChargesModelesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titre => $composableBuilder(
      column: $table.titre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soumisParId => $composableBuilder(
      column: $table.soumisParId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soumisParNom => $composableBuilder(
      column: $table.soumisParNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateSubmission => $composableBuilder(
      column: $table.dateSubmission,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valideParId => $composableBuilder(
      column: $table.valideParId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valideParNom => $composableBuilder(
      column: $table.valideParNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ChargesModelesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargesModelesTable> {
  $$ChargesModelesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titre => $composableBuilder(
      column: $table.titre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soumisParId => $composableBuilder(
      column: $table.soumisParId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soumisParNom => $composableBuilder(
      column: $table.soumisParNom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateSubmission => $composableBuilder(
      column: $table.dateSubmission,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valideParId => $composableBuilder(
      column: $table.valideParId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valideParNom => $composableBuilder(
      column: $table.valideParNom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChargesModelesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargesModelesTable> {
  $$ChargesModelesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<int> get mois =>
      $composableBuilder(column: $table.mois, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<String> get soumisParId => $composableBuilder(
      column: $table.soumisParId, builder: (column) => column);

  GeneratedColumn<String> get soumisParNom => $composableBuilder(
      column: $table.soumisParNom, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => column);

  GeneratedColumn<DateTime> get dateSubmission => $composableBuilder(
      column: $table.dateSubmission, builder: (column) => column);

  GeneratedColumn<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation, builder: (column) => column);

  GeneratedColumn<String> get valideParId => $composableBuilder(
      column: $table.valideParId, builder: (column) => column);

  GeneratedColumn<String> get valideParNom => $composableBuilder(
      column: $table.valideParNom, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChargesModelesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargesModelesTable,
    ChargesModele,
    $$ChargesModelesTableFilterComposer,
    $$ChargesModelesTableOrderingComposer,
    $$ChargesModelesTableAnnotationComposer,
    $$ChargesModelesTableCreateCompanionBuilder,
    $$ChargesModelesTableUpdateCompanionBuilder,
    (
      ChargesModele,
      BaseReferences<_$AppDatabase, $ChargesModelesTable, ChargesModele>
    ),
    ChargesModele,
    PrefetchHooks Function()> {
  $$ChargesModelesTableTableManager(
      _$AppDatabase db, $ChargesModelesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargesModelesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargesModelesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargesModelesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<int> mois = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<String> titre = const Value.absent(),
            Value<String?> soumisParId = const Value.absent(),
            Value<String?> soumisParNom = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> motifRefus = const Value.absent(),
            Value<DateTime?> dateSubmission = const Value.absent(),
            Value<DateTime?> dateValidation = const Value.absent(),
            Value<String?> valideParId = const Value.absent(),
            Value<String?> valideParNom = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesModelesCompanion(
            id: id,
            entrepriseId: entrepriseId,
            mois: mois,
            annee: annee,
            titre: titre,
            soumisParId: soumisParId,
            soumisParNom: soumisParNom,
            statut: statut,
            motifRefus: motifRefus,
            dateSubmission: dateSubmission,
            dateValidation: dateValidation,
            valideParId: valideParId,
            valideParNom: valideParNom,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            required int mois,
            required int annee,
            required String titre,
            Value<String?> soumisParId = const Value.absent(),
            Value<String?> soumisParNom = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> motifRefus = const Value.absent(),
            Value<DateTime?> dateSubmission = const Value.absent(),
            Value<DateTime?> dateValidation = const Value.absent(),
            Value<String?> valideParId = const Value.absent(),
            Value<String?> valideParNom = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesModelesCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            mois: mois,
            annee: annee,
            titre: titre,
            soumisParId: soumisParId,
            soumisParNom: soumisParNom,
            statut: statut,
            motifRefus: motifRefus,
            dateSubmission: dateSubmission,
            dateValidation: dateValidation,
            valideParId: valideParId,
            valideParNom: valideParNom,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChargesModelesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChargesModelesTable,
    ChargesModele,
    $$ChargesModelesTableFilterComposer,
    $$ChargesModelesTableOrderingComposer,
    $$ChargesModelesTableAnnotationComposer,
    $$ChargesModelesTableCreateCompanionBuilder,
    $$ChargesModelesTableUpdateCompanionBuilder,
    (
      ChargesModele,
      BaseReferences<_$AppDatabase, $ChargesModelesTable, ChargesModele>
    ),
    ChargesModele,
    PrefetchHooks Function()>;
typedef $$ChargesModeleLinesTableCreateCompanionBuilder
    = ChargesModeleLinesCompanion Function({
  required String id,
  required String modeleId,
  Value<int> ordre,
  required String designation,
  Value<double> montant,
  Value<DateTime?> dateEcheance,
  Value<String> priorite,
  Value<String> statut,
  Value<String?> motifRefus,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ChargesModeleLinesTableUpdateCompanionBuilder
    = ChargesModeleLinesCompanion Function({
  Value<String> id,
  Value<String> modeleId,
  Value<int> ordre,
  Value<String> designation,
  Value<double> montant,
  Value<DateTime?> dateEcheance,
  Value<String> priorite,
  Value<String> statut,
  Value<String?> motifRefus,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ChargesModeleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $ChargesModeleLinesTable> {
  $$ChargesModeleLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modeleId => $composableBuilder(
      column: $table.modeleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priorite => $composableBuilder(
      column: $table.priorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ChargesModeleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargesModeleLinesTable> {
  $$ChargesModeleLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modeleId => $composableBuilder(
      column: $table.modeleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montant => $composableBuilder(
      column: $table.montant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priorite => $composableBuilder(
      column: $table.priorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChargesModeleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargesModeleLinesTable> {
  $$ChargesModeleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modeleId =>
      $composableBuilder(column: $table.modeleId, builder: (column) => column);

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => column);

  GeneratedColumn<double> get montant =>
      $composableBuilder(column: $table.montant, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEcheance => $composableBuilder(
      column: $table.dateEcheance, builder: (column) => column);

  GeneratedColumn<String> get priorite =>
      $composableBuilder(column: $table.priorite, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get motifRefus => $composableBuilder(
      column: $table.motifRefus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChargesModeleLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargesModeleLinesTable,
    ChargesModeleLine,
    $$ChargesModeleLinesTableFilterComposer,
    $$ChargesModeleLinesTableOrderingComposer,
    $$ChargesModeleLinesTableAnnotationComposer,
    $$ChargesModeleLinesTableCreateCompanionBuilder,
    $$ChargesModeleLinesTableUpdateCompanionBuilder,
    (
      ChargesModeleLine,
      BaseReferences<_$AppDatabase, $ChargesModeleLinesTable, ChargesModeleLine>
    ),
    ChargesModeleLine,
    PrefetchHooks Function()> {
  $$ChargesModeleLinesTableTableManager(
      _$AppDatabase db, $ChargesModeleLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargesModeleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargesModeleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargesModeleLinesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> modeleId = const Value.absent(),
            Value<int> ordre = const Value.absent(),
            Value<String> designation = const Value.absent(),
            Value<double> montant = const Value.absent(),
            Value<DateTime?> dateEcheance = const Value.absent(),
            Value<String> priorite = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> motifRefus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesModeleLinesCompanion(
            id: id,
            modeleId: modeleId,
            ordre: ordre,
            designation: designation,
            montant: montant,
            dateEcheance: dateEcheance,
            priorite: priorite,
            statut: statut,
            motifRefus: motifRefus,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String modeleId,
            Value<int> ordre = const Value.absent(),
            required String designation,
            Value<double> montant = const Value.absent(),
            Value<DateTime?> dateEcheance = const Value.absent(),
            Value<String> priorite = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> motifRefus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChargesModeleLinesCompanion.insert(
            id: id,
            modeleId: modeleId,
            ordre: ordre,
            designation: designation,
            montant: montant,
            dateEcheance: dateEcheance,
            priorite: priorite,
            statut: statut,
            motifRefus: motifRefus,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChargesModeleLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChargesModeleLinesTable,
    ChargesModeleLine,
    $$ChargesModeleLinesTableFilterComposer,
    $$ChargesModeleLinesTableOrderingComposer,
    $$ChargesModeleLinesTableAnnotationComposer,
    $$ChargesModeleLinesTableCreateCompanionBuilder,
    $$ChargesModeleLinesTableUpdateCompanionBuilder,
    (
      ChargesModeleLine,
      BaseReferences<_$AppDatabase, $ChargesModeleLinesTable, ChargesModeleLine>
    ),
    ChargesModeleLine,
    PrefetchHooks Function()>;
typedef $$TaxesTableCreateCompanionBuilder = TaxesCompanion Function({
  required String id,
  required String entrepriseId,
  required String nom,
  Value<double> taux,
  Value<String?> description,
  Value<bool> actif,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$TaxesTableUpdateCompanionBuilder = TaxesCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String> nom,
  Value<double> taux,
  Value<String?> description,
  Value<bool> actif,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TaxesTableFilterComposer extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taux => $composableBuilder(
      column: $table.taux, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TaxesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taux => $composableBuilder(
      column: $table.taux, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TaxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<double> get taux =>
      $composableBuilder(column: $table.taux, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaxesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaxesTable,
    Taxe,
    $$TaxesTableFilterComposer,
    $$TaxesTableOrderingComposer,
    $$TaxesTableAnnotationComposer,
    $$TaxesTableCreateCompanionBuilder,
    $$TaxesTableUpdateCompanionBuilder,
    (Taxe, BaseReferences<_$AppDatabase, $TaxesTable, Taxe>),
    Taxe,
    PrefetchHooks Function()> {
  $$TaxesTableTableManager(_$AppDatabase db, $TaxesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<double> taux = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaxesCompanion(
            id: id,
            entrepriseId: entrepriseId,
            nom: nom,
            taux: taux,
            description: description,
            actif: actif,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            required String nom,
            Value<double> taux = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaxesCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            nom: nom,
            taux: taux,
            description: description,
            actif: actif,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaxesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaxesTable,
    Taxe,
    $$TaxesTableFilterComposer,
    $$TaxesTableOrderingComposer,
    $$TaxesTableAnnotationComposer,
    $$TaxesTableCreateCompanionBuilder,
    $$TaxesTableUpdateCompanionBuilder,
    (Taxe, BaseReferences<_$AppDatabase, $TaxesTable, Taxe>),
    Taxe,
    PrefetchHooks Function()>;
typedef $$PersonnelTableCreateCompanionBuilder = PersonnelCompanion Function({
  required String id,
  required String entrepriseId,
  Value<String?> utilisateurId,
  required String nom,
  Value<String?> prenom,
  Value<String?> poste,
  Value<String?> departement,
  Value<String> typeContrat,
  Value<DateTime?> dateEmbauche,
  Value<DateTime?> dateFinContrat,
  Value<double?> salaireBase,
  Value<bool> actif,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PersonnelTableUpdateCompanionBuilder = PersonnelCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String?> utilisateurId,
  Value<String> nom,
  Value<String?> prenom,
  Value<String?> poste,
  Value<String?> departement,
  Value<String> typeContrat,
  Value<DateTime?> dateEmbauche,
  Value<DateTime?> dateFinContrat,
  Value<double?> salaireBase,
  Value<bool> actif,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PersonnelTableFilterComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get utilisateurId => $composableBuilder(
      column: $table.utilisateurId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prenom => $composableBuilder(
      column: $table.prenom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get poste => $composableBuilder(
      column: $table.poste, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get departement => $composableBuilder(
      column: $table.departement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeContrat => $composableBuilder(
      column: $table.typeContrat, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateEmbauche => $composableBuilder(
      column: $table.dateEmbauche, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateFinContrat => $composableBuilder(
      column: $table.dateFinContrat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salaireBase => $composableBuilder(
      column: $table.salaireBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonnelTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get utilisateurId => $composableBuilder(
      column: $table.utilisateurId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prenom => $composableBuilder(
      column: $table.prenom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get poste => $composableBuilder(
      column: $table.poste, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get departement => $composableBuilder(
      column: $table.departement, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeContrat => $composableBuilder(
      column: $table.typeContrat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateEmbauche => $composableBuilder(
      column: $table.dateEmbauche,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateFinContrat => $composableBuilder(
      column: $table.dateFinContrat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salaireBase => $composableBuilder(
      column: $table.salaireBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonnelTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get utilisateurId => $composableBuilder(
      column: $table.utilisateurId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get poste =>
      $composableBuilder(column: $table.poste, builder: (column) => column);

  GeneratedColumn<String> get departement => $composableBuilder(
      column: $table.departement, builder: (column) => column);

  GeneratedColumn<String> get typeContrat => $composableBuilder(
      column: $table.typeContrat, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEmbauche => $composableBuilder(
      column: $table.dateEmbauche, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFinContrat => $composableBuilder(
      column: $table.dateFinContrat, builder: (column) => column);

  GeneratedColumn<double> get salaireBase => $composableBuilder(
      column: $table.salaireBase, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonnelTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonnelTable,
    PersonnelData,
    $$PersonnelTableFilterComposer,
    $$PersonnelTableOrderingComposer,
    $$PersonnelTableAnnotationComposer,
    $$PersonnelTableCreateCompanionBuilder,
    $$PersonnelTableUpdateCompanionBuilder,
    (
      PersonnelData,
      BaseReferences<_$AppDatabase, $PersonnelTable, PersonnelData>
    ),
    PersonnelData,
    PrefetchHooks Function()> {
  $$PersonnelTableTableManager(_$AppDatabase db, $PersonnelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonnelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonnelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonnelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String?> utilisateurId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String?> prenom = const Value.absent(),
            Value<String?> poste = const Value.absent(),
            Value<String?> departement = const Value.absent(),
            Value<String> typeContrat = const Value.absent(),
            Value<DateTime?> dateEmbauche = const Value.absent(),
            Value<DateTime?> dateFinContrat = const Value.absent(),
            Value<double?> salaireBase = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonnelCompanion(
            id: id,
            entrepriseId: entrepriseId,
            utilisateurId: utilisateurId,
            nom: nom,
            prenom: prenom,
            poste: poste,
            departement: departement,
            typeContrat: typeContrat,
            dateEmbauche: dateEmbauche,
            dateFinContrat: dateFinContrat,
            salaireBase: salaireBase,
            actif: actif,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            Value<String?> utilisateurId = const Value.absent(),
            required String nom,
            Value<String?> prenom = const Value.absent(),
            Value<String?> poste = const Value.absent(),
            Value<String?> departement = const Value.absent(),
            Value<String> typeContrat = const Value.absent(),
            Value<DateTime?> dateEmbauche = const Value.absent(),
            Value<DateTime?> dateFinContrat = const Value.absent(),
            Value<double?> salaireBase = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonnelCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            utilisateurId: utilisateurId,
            nom: nom,
            prenom: prenom,
            poste: poste,
            departement: departement,
            typeContrat: typeContrat,
            dateEmbauche: dateEmbauche,
            dateFinContrat: dateFinContrat,
            salaireBase: salaireBase,
            actif: actif,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonnelTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonnelTable,
    PersonnelData,
    $$PersonnelTableFilterComposer,
    $$PersonnelTableOrderingComposer,
    $$PersonnelTableAnnotationComposer,
    $$PersonnelTableCreateCompanionBuilder,
    $$PersonnelTableUpdateCompanionBuilder,
    (
      PersonnelData,
      BaseReferences<_$AppDatabase, $PersonnelTable, PersonnelData>
    ),
    PersonnelData,
    PrefetchHooks Function()>;
typedef $$SalairesTableCreateCompanionBuilder = SalairesCompanion Function({
  required String id,
  required String entrepriseId,
  required String personnelId,
  required int mois,
  required int annee,
  Value<double> salaireBrut,
  Value<double> cnps,
  Value<double> irpp,
  Value<double> autresRetenues,
  required double salaireNet,
  Value<String> statut,
  Value<DateTime?> dateValidation,
  Value<String?> validePar,
  Value<DateTime?> datePaiement,
  Value<String?> modePaiement,
  Value<bool> comptabilise,
  Value<String?> chargeId,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SalairesTableUpdateCompanionBuilder = SalairesCompanion Function({
  Value<String> id,
  Value<String> entrepriseId,
  Value<String> personnelId,
  Value<int> mois,
  Value<int> annee,
  Value<double> salaireBrut,
  Value<double> cnps,
  Value<double> irpp,
  Value<double> autresRetenues,
  Value<double> salaireNet,
  Value<String> statut,
  Value<DateTime?> dateValidation,
  Value<String?> validePar,
  Value<DateTime?> datePaiement,
  Value<String?> modePaiement,
  Value<bool> comptabilise,
  Value<String?> chargeId,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SalairesTableFilterComposer
    extends Composer<_$AppDatabase, $SalairesTable> {
  $$SalairesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salaireBrut => $composableBuilder(
      column: $table.salaireBrut, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cnps => $composableBuilder(
      column: $table.cnps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get irpp => $composableBuilder(
      column: $table.irpp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get autresRetenues => $composableBuilder(
      column: $table.autresRetenues,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salaireNet => $composableBuilder(
      column: $table.salaireNet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validePar => $composableBuilder(
      column: $table.validePar, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get comptabilise => $composableBuilder(
      column: $table.comptabilise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chargeId => $composableBuilder(
      column: $table.chargeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SalairesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalairesTable> {
  $$SalairesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mois => $composableBuilder(
      column: $table.mois, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get annee => $composableBuilder(
      column: $table.annee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salaireBrut => $composableBuilder(
      column: $table.salaireBrut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cnps => $composableBuilder(
      column: $table.cnps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get irpp => $composableBuilder(
      column: $table.irpp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get autresRetenues => $composableBuilder(
      column: $table.autresRetenues,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salaireNet => $composableBuilder(
      column: $table.salaireNet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validePar => $composableBuilder(
      column: $table.validePar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get comptabilise => $composableBuilder(
      column: $table.comptabilise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chargeId => $composableBuilder(
      column: $table.chargeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SalairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalairesTable> {
  $$SalairesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entrepriseId => $composableBuilder(
      column: $table.entrepriseId, builder: (column) => column);

  GeneratedColumn<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => column);

  GeneratedColumn<int> get mois =>
      $composableBuilder(column: $table.mois, builder: (column) => column);

  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<double> get salaireBrut => $composableBuilder(
      column: $table.salaireBrut, builder: (column) => column);

  GeneratedColumn<double> get cnps =>
      $composableBuilder(column: $table.cnps, builder: (column) => column);

  GeneratedColumn<double> get irpp =>
      $composableBuilder(column: $table.irpp, builder: (column) => column);

  GeneratedColumn<double> get autresRetenues => $composableBuilder(
      column: $table.autresRetenues, builder: (column) => column);

  GeneratedColumn<double> get salaireNet => $composableBuilder(
      column: $table.salaireNet, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateValidation => $composableBuilder(
      column: $table.dateValidation, builder: (column) => column);

  GeneratedColumn<String> get validePar =>
      $composableBuilder(column: $table.validePar, builder: (column) => column);

  GeneratedColumn<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => column);

  GeneratedColumn<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => column);

  GeneratedColumn<bool> get comptabilise => $composableBuilder(
      column: $table.comptabilise, builder: (column) => column);

  GeneratedColumn<String> get chargeId =>
      $composableBuilder(column: $table.chargeId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SalairesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalairesTable,
    Salaire,
    $$SalairesTableFilterComposer,
    $$SalairesTableOrderingComposer,
    $$SalairesTableAnnotationComposer,
    $$SalairesTableCreateCompanionBuilder,
    $$SalairesTableUpdateCompanionBuilder,
    (Salaire, BaseReferences<_$AppDatabase, $SalairesTable, Salaire>),
    Salaire,
    PrefetchHooks Function()> {
  $$SalairesTableTableManager(_$AppDatabase db, $SalairesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalairesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entrepriseId = const Value.absent(),
            Value<String> personnelId = const Value.absent(),
            Value<int> mois = const Value.absent(),
            Value<int> annee = const Value.absent(),
            Value<double> salaireBrut = const Value.absent(),
            Value<double> cnps = const Value.absent(),
            Value<double> irpp = const Value.absent(),
            Value<double> autresRetenues = const Value.absent(),
            Value<double> salaireNet = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<DateTime?> dateValidation = const Value.absent(),
            Value<String?> validePar = const Value.absent(),
            Value<DateTime?> datePaiement = const Value.absent(),
            Value<String?> modePaiement = const Value.absent(),
            Value<bool> comptabilise = const Value.absent(),
            Value<String?> chargeId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalairesCompanion(
            id: id,
            entrepriseId: entrepriseId,
            personnelId: personnelId,
            mois: mois,
            annee: annee,
            salaireBrut: salaireBrut,
            cnps: cnps,
            irpp: irpp,
            autresRetenues: autresRetenues,
            salaireNet: salaireNet,
            statut: statut,
            dateValidation: dateValidation,
            validePar: validePar,
            datePaiement: datePaiement,
            modePaiement: modePaiement,
            comptabilise: comptabilise,
            chargeId: chargeId,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entrepriseId,
            required String personnelId,
            required int mois,
            required int annee,
            Value<double> salaireBrut = const Value.absent(),
            Value<double> cnps = const Value.absent(),
            Value<double> irpp = const Value.absent(),
            Value<double> autresRetenues = const Value.absent(),
            required double salaireNet,
            Value<String> statut = const Value.absent(),
            Value<DateTime?> dateValidation = const Value.absent(),
            Value<String?> validePar = const Value.absent(),
            Value<DateTime?> datePaiement = const Value.absent(),
            Value<String?> modePaiement = const Value.absent(),
            Value<bool> comptabilise = const Value.absent(),
            Value<String?> chargeId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalairesCompanion.insert(
            id: id,
            entrepriseId: entrepriseId,
            personnelId: personnelId,
            mois: mois,
            annee: annee,
            salaireBrut: salaireBrut,
            cnps: cnps,
            irpp: irpp,
            autresRetenues: autresRetenues,
            salaireNet: salaireNet,
            statut: statut,
            dateValidation: dateValidation,
            validePar: validePar,
            datePaiement: datePaiement,
            modePaiement: modePaiement,
            comptabilise: comptabilise,
            chargeId: chargeId,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalairesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalairesTable,
    Salaire,
    $$SalairesTableFilterComposer,
    $$SalairesTableOrderingComposer,
    $$SalairesTableAnnotationComposer,
    $$SalairesTableCreateCompanionBuilder,
    $$SalairesTableUpdateCompanionBuilder,
    (Salaire, BaseReferences<_$AppDatabase, $SalairesTable, Salaire>),
    Salaire,
    PrefetchHooks Function()>;
typedef $$CongesTableCreateCompanionBuilder = CongesCompanion Function({
  required String id,
  required String personnelId,
  required DateTime dateDebut,
  required DateTime dateFin,
  Value<String> type,
  Value<String?> motif,
  Value<String> statut,
  Value<String?> validePar,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CongesTableUpdateCompanionBuilder = CongesCompanion Function({
  Value<String> id,
  Value<String> personnelId,
  Value<DateTime> dateDebut,
  Value<DateTime> dateFin,
  Value<String> type,
  Value<String?> motif,
  Value<String> statut,
  Value<String?> validePar,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CongesTableFilterComposer
    extends Composer<_$AppDatabase, $CongesTable> {
  $$CongesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motif => $composableBuilder(
      column: $table.motif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validePar => $composableBuilder(
      column: $table.validePar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CongesTableOrderingComposer
    extends Composer<_$AppDatabase, $CongesTable> {
  $$CongesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motif => $composableBuilder(
      column: $table.motif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validePar => $composableBuilder(
      column: $table.validePar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CongesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CongesTable> {
  $$CongesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personnelId => $composableBuilder(
      column: $table.personnelId, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDebut =>
      $composableBuilder(column: $table.dateDebut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFin =>
      $composableBuilder(column: $table.dateFin, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get motif =>
      $composableBuilder(column: $table.motif, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get validePar =>
      $composableBuilder(column: $table.validePar, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CongesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CongesTable,
    Conge,
    $$CongesTableFilterComposer,
    $$CongesTableOrderingComposer,
    $$CongesTableAnnotationComposer,
    $$CongesTableCreateCompanionBuilder,
    $$CongesTableUpdateCompanionBuilder,
    (Conge, BaseReferences<_$AppDatabase, $CongesTable, Conge>),
    Conge,
    PrefetchHooks Function()> {
  $$CongesTableTableManager(_$AppDatabase db, $CongesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CongesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CongesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CongesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> personnelId = const Value.absent(),
            Value<DateTime> dateDebut = const Value.absent(),
            Value<DateTime> dateFin = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> motif = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> validePar = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CongesCompanion(
            id: id,
            personnelId: personnelId,
            dateDebut: dateDebut,
            dateFin: dateFin,
            type: type,
            motif: motif,
            statut: statut,
            validePar: validePar,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String personnelId,
            required DateTime dateDebut,
            required DateTime dateFin,
            Value<String> type = const Value.absent(),
            Value<String?> motif = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<String?> validePar = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CongesCompanion.insert(
            id: id,
            personnelId: personnelId,
            dateDebut: dateDebut,
            dateFin: dateFin,
            type: type,
            motif: motif,
            statut: statut,
            validePar: validePar,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CongesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CongesTable,
    Conge,
    $$CongesTableFilterComposer,
    $$CongesTableOrderingComposer,
    $$CongesTableAnnotationComposer,
    $$CongesTableCreateCompanionBuilder,
    $$CongesTableUpdateCompanionBuilder,
    (Conge, BaseReferences<_$AppDatabase, $CongesTable, Conge>),
    Conge,
    PrefetchHooks Function()>;
typedef $$PiecesJointesTableCreateCompanionBuilder = PiecesJointesCompanion
    Function({
  required String id,
  required String dossierId,
  required String nom,
  required String typeFichier,
  required String cheminLocal,
  Value<String?> urlStorage,
  Value<int?> taille,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PiecesJointesTableUpdateCompanionBuilder = PiecesJointesCompanion
    Function({
  Value<String> id,
  Value<String> dossierId,
  Value<String> nom,
  Value<String> typeFichier,
  Value<String> cheminLocal,
  Value<String?> urlStorage,
  Value<int?> taille,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> notes,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PiecesJointesTableFilterComposer
    extends Composer<_$AppDatabase, $PiecesJointesTable> {
  $$PiecesJointesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeFichier => $composableBuilder(
      column: $table.typeFichier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cheminLocal => $composableBuilder(
      column: $table.cheminLocal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get urlStorage => $composableBuilder(
      column: $table.urlStorage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taille => $composableBuilder(
      column: $table.taille, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PiecesJointesTableOrderingComposer
    extends Composer<_$AppDatabase, $PiecesJointesTable> {
  $$PiecesJointesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dossierId => $composableBuilder(
      column: $table.dossierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeFichier => $composableBuilder(
      column: $table.typeFichier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cheminLocal => $composableBuilder(
      column: $table.cheminLocal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlStorage => $composableBuilder(
      column: $table.urlStorage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taille => $composableBuilder(
      column: $table.taille, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PiecesJointesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PiecesJointesTable> {
  $$PiecesJointesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dossierId =>
      $composableBuilder(column: $table.dossierId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get typeFichier => $composableBuilder(
      column: $table.typeFichier, builder: (column) => column);

  GeneratedColumn<String> get cheminLocal => $composableBuilder(
      column: $table.cheminLocal, builder: (column) => column);

  GeneratedColumn<String> get urlStorage => $composableBuilder(
      column: $table.urlStorage, builder: (column) => column);

  GeneratedColumn<int> get taille =>
      $composableBuilder(column: $table.taille, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PiecesJointesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PiecesJointesTable,
    PiecesJointe,
    $$PiecesJointesTableFilterComposer,
    $$PiecesJointesTableOrderingComposer,
    $$PiecesJointesTableAnnotationComposer,
    $$PiecesJointesTableCreateCompanionBuilder,
    $$PiecesJointesTableUpdateCompanionBuilder,
    (
      PiecesJointe,
      BaseReferences<_$AppDatabase, $PiecesJointesTable, PiecesJointe>
    ),
    PiecesJointe,
    PrefetchHooks Function()> {
  $$PiecesJointesTableTableManager(_$AppDatabase db, $PiecesJointesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PiecesJointesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PiecesJointesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PiecesJointesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dossierId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> typeFichier = const Value.absent(),
            Value<String> cheminLocal = const Value.absent(),
            Value<String?> urlStorage = const Value.absent(),
            Value<int?> taille = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PiecesJointesCompanion(
            id: id,
            dossierId: dossierId,
            nom: nom,
            typeFichier: typeFichier,
            cheminLocal: cheminLocal,
            urlStorage: urlStorage,
            taille: taille,
            latitude: latitude,
            longitude: longitude,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dossierId,
            required String nom,
            required String typeFichier,
            required String cheminLocal,
            Value<String?> urlStorage = const Value.absent(),
            Value<int?> taille = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PiecesJointesCompanion.insert(
            id: id,
            dossierId: dossierId,
            nom: nom,
            typeFichier: typeFichier,
            cheminLocal: cheminLocal,
            urlStorage: urlStorage,
            taille: taille,
            latitude: latitude,
            longitude: longitude,
            notes: notes,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PiecesJointesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PiecesJointesTable,
    PiecesJointe,
    $$PiecesJointesTableFilterComposer,
    $$PiecesJointesTableOrderingComposer,
    $$PiecesJointesTableAnnotationComposer,
    $$PiecesJointesTableCreateCompanionBuilder,
    $$PiecesJointesTableUpdateCompanionBuilder,
    (
      PiecesJointe,
      BaseReferences<_$AppDatabase, $PiecesJointesTable, PiecesJointe>
    ),
    PiecesJointe,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttempt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttempt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttempt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            attempts: attempts,
            createdAt: createdAt,
            lastAttempt: lastAttempt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required String entityId,
            required String operation,
            required String payload,
            Value<int> attempts = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttempt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            attempts: attempts,
            createdAt: createdAt,
            lastAttempt: lastAttempt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ClientContactsTableTableManager get clientContacts =>
      $$ClientContactsTableTableManager(_db, _db.clientContacts);
  $$DossiersTableTableManager get dossiers =>
      $$DossiersTableTableManager(_db, _db.dossiers);
  $$DevisTableTableManager get devis =>
      $$DevisTableTableManager(_db, _db.devis);
  $$DevisLignesTableTableManager get devisLignes =>
      $$DevisLignesTableTableManager(_db, _db.devisLignes);
  $$FacturesTableTableManager get factures =>
      $$FacturesTableTableManager(_db, _db.factures);
  $$FacturesLignesTableTableManager get facturesLignes =>
      $$FacturesLignesTableTableManager(_db, _db.facturesLignes);
  $$ChargesTableTableManager get charges =>
      $$ChargesTableTableManager(_db, _db.charges);
  $$ChargesModelesTableTableManager get chargesModeles =>
      $$ChargesModelesTableTableManager(_db, _db.chargesModeles);
  $$ChargesModeleLinesTableTableManager get chargesModeleLines =>
      $$ChargesModeleLinesTableTableManager(_db, _db.chargesModeleLines);
  $$TaxesTableTableManager get taxes =>
      $$TaxesTableTableManager(_db, _db.taxes);
  $$PersonnelTableTableManager get personnel =>
      $$PersonnelTableTableManager(_db, _db.personnel);
  $$SalairesTableTableManager get salaires =>
      $$SalairesTableTableManager(_db, _db.salaires);
  $$CongesTableTableManager get conges =>
      $$CongesTableTableManager(_db, _db.conges);
  $$PiecesJointesTableTableManager get piecesJointes =>
      $$PiecesJointesTableTableManager(_db, _db.piecesJointes);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
