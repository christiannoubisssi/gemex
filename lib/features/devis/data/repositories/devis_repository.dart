import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';

final devisRepositoryProvider = Provider<DevisRepository>((ref) =>
    DevisRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref));

class DevisRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  DevisRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<Devi>> getAll({String? statut, String? clientId, String? dossierId}) =>
      _db.devisDao.getAll(statut: statut, clientId: clientId, dossierId: dossierId);

  Future<Devi?> getById(String id) => _db.devisDao.getById(id);

  Future<List<DevisLigne>> getLignes(String devisId) => _db.devisDao.getLignes(devisId);

  Future<String> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final numero = FormatUtils.generateLocalNumero('DEV');

    // Calculer totaux
    double montantHt = 0;
    for (final l in lignes) {
      final qte = (l['quantite'] as num?)?.toDouble() ?? 1;
      final pu = (l['prix_unit'] as num?)?.toDouble() ?? 0;
      montantHt += qte * pu;
    }
    final tauxTva = (data['taux_tva'] as num?)?.toDouble() ?? AppConstants.tvaTauxDefaut;
    final tauxTps = (data['taux_tps'] as num?)?.toDouble() ?? AppConstants.tpsTauxDefaut;
    final montantTva = montantHt * tauxTva / 100;
    final montantTps = montantHt * tauxTps / 100;
    final montantTtc = montantHt + montantTva + montantTps;

    await _db.transaction(() async {
      await _db.devisDao.upsertDevis(DevisCompanion.insert(
        id: id,
        entrepriseId: data['entreprise_id'] as String? ?? 'default',
        clientId: data['client_id'] as String,
        dossierId: drift.Value(data['dossier_id'] as String?),
        annee: now.year,
        numero: drift.Value(numero),
        dateEmission: data['date_emission'] as DateTime? ?? now,
        dateValidite: data['date_validite'] as DateTime? ?? now.add(const Duration(days: 30)),
        montantHt: drift.Value(montantHt),
        tauxTva: drift.Value(tauxTva),
        montantTva: drift.Value(montantTva),
        tauxTps: drift.Value(tauxTps),
        montantTps: drift.Value(montantTps),
        montantTtc: drift.Value(montantTtc),
        objet: drift.Value(data['objet'] as String?),
        conditions: drift.Value(data['conditions'] as String?),
        syncStatus: const drift.Value(AppConstants.syncPending),
      ));

      for (var i = 0; i < lignes.length; i++) {
        final l = lignes[i];
        final qte = (l['quantite'] as num?)?.toDouble() ?? 1;
        final pu = (l['prix_unit'] as num?)?.toDouble() ?? 0;
        await _db.devisDao.upsertLigne(DevisLignesCompanion.insert(
          id: const Uuid().v4(),
          devisId: id,
          ordre: drift.Value(i),
          designation: l['designation'] as String,
          quantite: drift.Value(qte),
          unite: drift.Value(l['unite'] as String? ?? 'forfait'),
          prixUnit: drift.Value(pu),
          montantHt: drift.Value(qte * pu),
        ));
      }
    });

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, data, 'create');
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'devis', entityId: id, operation: 'create', payload: jsonEncode({...data, 'id': id}));
    }
    return id;
  }

  Future<void> updateStatut(String id, String statut) async {
    await _db.devisDao.updateStatut(id, statut);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('devis').update({'statut': statut}).eq('id', id);
        await _db.devisDao.markSynced(id);
      } catch (_) {}
    }
  }

  Future<void> _trySync(String id, Map<String, dynamic> data, String op) async {
    try {
      if (op == 'create') {
        final resp = await _supabase.from('devis').insert({...data, 'id': id}).select('numero').single();
        final serverNumero = resp['numero'] as String?;
        if (serverNumero != null) {
          await _db.devisDao.updateStatut(id, 'brouillon');
        }
        await _db.devisDao.markSynced(id);
      }
    } catch (_) {
      await _db.syncQueueDao.enqueue(entityType: 'devis', entityId: id, operation: op, payload: jsonEncode({...data, 'id': id}));
    }
  }
}
