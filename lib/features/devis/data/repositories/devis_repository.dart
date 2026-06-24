import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/json_utils.dart';
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

  /// Stream réactif pour la liste complète — utilisé par devisAllProvider (évite reload à chaque navigation)
  Stream<List<Devi>> watchAll() => _db.devisDao.watchAll();

  Future<Devi?> getById(String id) => _db.devisDao.getById(id);

  Future<List<DevisLigne>> getLignes(String devisId) => _db.devisDao.getLignes(devisId);

  Future<String> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final numero = FormatUtils.generateLocalNumero('DEV');

    // Calculer totaux HT et taxes depuis les lignes
    double montantHt = 0;
    double totalTaxes = 0;
    double aggregatedTva = 0;
    double aggregatedTps = 0;
    double tauxTvaDetecte = 0;
    double tauxTpsDetecte = 0;

    for (final l in lignes) {
      final qte = (l['quantite'] as num?)?.toDouble() ?? 1;
      final pu = (l['prix_unit'] as num?)?.toDouble() ?? 0;
      final ligneHt = qte * pu;
      montantHt += ligneHt;

      // Agréger les taxes depuis taxes_json de chaque ligne
      final taxesStr = l['taxes_json'] as String?;
      if (taxesStr != null && taxesStr.isNotEmpty) {
        try {
          final taxesList = jsonDecode(taxesStr) as List;
          for (final t in taxesList) {
            final taux = (t['taux'] as num?)?.toDouble() ?? 0;
            final nom = (t['nom'] as String? ?? '').toLowerCase();
            final montant = ligneHt * taux / 100;
            totalTaxes += montant;
            // Identifier TVA et TPS par nom pour les champs du document
            if (nom.contains('tva')) {
              aggregatedTva += montant;
              if (tauxTvaDetecte == 0) tauxTvaDetecte = taux;
            } else if (nom.contains('tps')) {
              aggregatedTps += montant;
              if (tauxTpsDetecte == 0) tauxTpsDetecte = taux;
            }
          }
        } catch (_) {}
      }
    }

    // Si aucune taxe par ligne, utiliser le taux document si fourni
    final tauxTva = aggregatedTva > 0
        ? tauxTvaDetecte
        : (data['taux_tva'] as num?)?.toDouble() ?? 0;
    final tauxTps = aggregatedTps > 0
        ? tauxTpsDetecte
        : (data['taux_tps'] as num?)?.toDouble() ?? 0;
    final montantTva = aggregatedTva > 0 ? aggregatedTva : montantHt * tauxTva / 100;
    final montantTps = aggregatedTps > 0 ? aggregatedTps : montantHt * tauxTps / 100;
    final montantTtc = montantHt + montantTva + montantTps +
        (totalTaxes - aggregatedTva - aggregatedTps); // taxes hors TVA/TPS

    // IDs générés à l'avance pour pouvoir synchroniser les lignes avec Supabase
    final ligneIds = List.generate(lignes.length, (_) => const Uuid().v4());
    // Utilisateur créateur (utilisé côté serveur pour résoudre le jeton INITIALES)
    final creePar = _supabase.auth.currentUser?.id;

    await _db.transaction(() async {
      await _db.devisDao.upsertDevis(DevisCompanion.insert(
        id: id,
        entrepriseId: data['entreprise_id'] as String? ?? 'default',
        clientId: data['client_id'] as String,
        dossierId: drift.Value(data['dossier_id'] as String?),
        creePar: drift.Value(creePar),
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
          id: ligneIds[i],
          devisId: id,
          ordre: drift.Value(i),
          designation: l['designation'] as String,
          quantite: drift.Value(qte),
          unite: drift.Value(l['unite'] as String? ?? 'forfait'),
          prixUnit: drift.Value(pu),
          montantHt: drift.Value(qte * pu),
          // taxes sélectionnées sur le formulaire (JSON encodé)
          taxesJson: drift.Value(l['taxes_json'] as String?),
        ));
      }
    });

    // Champs calculés localement (absents de `data`) mais requis côté Supabase
    final syncData = {
      ...data,
      'id': id,
      'annee': now.year,
      'cree_par': creePar,
      'montant_ht': montantHt,
      'taux_tva': tauxTva,
      'montant_tva': montantTva,
      'taux_tps': tauxTps,
      'montant_tps': montantTps,
      'montant_ttc': montantTtc,
    };

    final lignesPayload = [
      for (var i = 0; i < lignes.length; i++)
        {
          'id': ligneIds[i],
          'devis_id': id,
          'ordre': i,
          'designation': lignes[i]['designation'] as String,
          'quantite': (lignes[i]['quantite'] as num?)?.toDouble() ?? 1,
          'unite': lignes[i]['unite'] as String? ?? 'forfait',
          'prix_unit': (lignes[i]['prix_unit'] as num?)?.toDouble() ?? 0,
          'montant_ht': ((lignes[i]['quantite'] as num?)?.toDouble() ?? 1) *
              ((lignes[i]['prix_unit'] as num?)?.toDouble() ?? 0),
        },
    ];

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, syncData, 'create');
      await _syncLignes(id, lignesPayload);
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'devis', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      if (lignesPayload.isNotEmpty) {
        await _db.syncQueueDao.enqueue(entityType: 'devis_lignes', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignesPayload})));
      }
    }
    return id;
  }

  /// Pousse les lignes d'un devis vers Supabase (table `devis_lignes`).
  Future<void> _syncLignes(String devisId, List<Map<String, dynamic>> lignes) async {
    if (lignes.isEmpty) return;
    try {
      await _supabase.from('devis_lignes').upsert(lignes.map(toJsonSafe).toList());
    } catch (e, s) {
      AppLogger.e('DevisRepository', 'Échec sync lignes devis $devisId', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'devis_lignes', entityId: devisId, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignes})));
    }
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
        final resp = await _supabase.from('devis').insert(toJsonSafe({...data, 'id': id})).select('numero').single();
        final serverNumero = resp['numero'] as String?;
        if (serverNumero != null) {
          await _db.devisDao.updateNumero(id, serverNumero);
        } else {
          await _db.devisDao.markSynced(id);
        }
      }
      AppLogger.i('DevisRepository', 'Devis $id synchronisé avec Supabase');
    } catch (e, s) {
      AppLogger.e('DevisRepository', 'Échec sync Supabase devis $id ($op)', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'devis', entityId: id, operation: op, payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
  }
}
