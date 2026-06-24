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

final factureRepositoryProvider = Provider<FactureRepository>((ref) =>
    FactureRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref));

class FactureRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  FactureRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<Facture>> getAll({String? statut, String? clientId, String? dossierId}) =>
      _db.facturesDao.getAll(statut: statut, clientId: clientId, dossierId: dossierId);

  Future<Facture?> getById(String id) => _db.facturesDao.getById(id);

  Future<List<FacturesLigne>> getLignes(String factureId) => _db.facturesDao.getLignes(factureId);

  Future<List<Facture>> getEnRetard() => _db.facturesDao.getEnRetard();

  Future<double> getTotalCreances() => _db.facturesDao.getTotalCreances();

  Future<String> createFromDevis(String devisId) async {
    final devis = await _db.devisDao.getById(devisId);
    if (devis == null) throw Exception('Devis introuvable');
    final lignes = await _db.devisDao.getLignes(devisId);
    final id = const Uuid().v4();
    final now = DateTime.now();
    final numero = FormatUtils.generateLocalNumero('FAC');

    // IDs générés à l'avance pour pouvoir synchroniser les lignes avec Supabase
    final ligneIds = List.generate(lignes.length, (_) => const Uuid().v4());
    // Utilisateur créateur (utilisé côté serveur pour résoudre le jeton INITIALES)
    final creePar = _supabase.auth.currentUser?.id;

    await _db.transaction(() async {
      await _db.facturesDao.upsertFacture(FacturesCompanion.insert(
        id: id,
        entrepriseId: devis.entrepriseId,
        clientId: devis.clientId,
        devisId: drift.Value(devisId),
        dossierId: drift.Value(devis.dossierId),
        creePar: drift.Value(creePar),
        annee: now.year,
        numero: drift.Value(numero),
        dateEmission: now,
        dateEcheance: now.add(const Duration(days: 30)),
        montantHt: drift.Value(devis.montantHt),
        tauxTva: drift.Value(devis.tauxTva),
        montantTva: drift.Value(devis.montantTva),
        tauxTps: drift.Value(devis.tauxTps),
        montantTps: drift.Value(devis.montantTps),
        montantTtc: drift.Value(devis.montantTtc),
        montantRestant: drift.Value(devis.montantTtc),
        objet: drift.Value(devis.objet),
        syncStatus: const drift.Value(AppConstants.syncPending),
      ));
      for (var i = 0; i < lignes.length; i++) {
        final l = lignes[i];
        await _db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
          id: ligneIds[i],
          factureId: id,
          ordre: drift.Value(i),
          designation: l.designation,
          quantite: drift.Value(l.quantite),
          unite: drift.Value(l.unite),
          prixUnit: drift.Value(l.prixUnit),
          montantHt: drift.Value(l.montantHt),
        ));
      }
    });

    // Payload complet : 'client_id' est requis (NOT NULL) côté Supabase
    final syncData = {
      'id': id,
      'entreprise_id': devis.entrepriseId,
      'client_id': devis.clientId,
      'devis_id': devisId,
      'dossier_id': devis.dossierId,
      'cree_par': creePar,
      'annee': now.year,
      'date_emission': now.toIso8601String(),
      'date_echeance': now.add(const Duration(days: 30)).toIso8601String(),
      'montant_ht': devis.montantHt,
      'taux_tva': devis.tauxTva,
      'montant_tva': devis.montantTva,
      'taux_tps': devis.tauxTps,
      'montant_tps': devis.montantTps,
      'montant_ttc': devis.montantTtc,
      'montant_restant': devis.montantTtc,
      'objet': devis.objet,
    };

    final lignesPayload = [
      for (var i = 0; i < lignes.length; i++)
        {
          'id': ligneIds[i],
          'facture_id': id,
          'ordre': i,
          'designation': lignes[i].designation,
          'quantite': lignes[i].quantite,
          'unite': lignes[i].unite,
          'prix_unit': lignes[i].prixUnit,
          'montant_ht': lignes[i].montantHt,
        },
    ];

    if (_ref.read(isOnlineProvider)) {
      try {
        final resp = await _supabase.from('factures').insert(toJsonSafe(syncData)).select('numero').single();
        final serverNumero = resp['numero'] as String?;
        if (serverNumero != null) {
          await _db.facturesDao.updateNumero(id, serverNumero);
        } else {
          await _db.facturesDao.markSynced(id);
        }
        AppLogger.i('FactureRepository', 'Facture $id synchronisée avec Supabase');
      } catch (e, s) {
        AppLogger.e('FactureRepository', 'Échec sync Supabase facture $id (createFromDevis)', error: e, stack: s);
        await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      }
      await _syncLignes(id, lignesPayload);
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      if (lignesPayload.isNotEmpty) {
        await _db.syncQueueDao.enqueue(entityType: 'factures_lignes', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignesPayload})));
      }
    }
    return id;
  }

  Future<String> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final numero = FormatUtils.generateLocalNumero('FAC');

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

    // IDs générés à l'avance pour pouvoir synchroniser les lignes avec Supabase
    final ligneIds = List.generate(lignes.length, (_) => const Uuid().v4());
    // Utilisateur créateur (utilisé côté serveur pour résoudre le jeton INITIALES)
    final creePar = _supabase.auth.currentUser?.id;

    await _db.transaction(() async {
      await _db.facturesDao.upsertFacture(FacturesCompanion.insert(
        id: id,
        entrepriseId: data['entreprise_id'] as String? ?? 'default',
        clientId: data['client_id'] as String,
        devisId: drift.Value(data['devis_id'] as String?),
        dossierId: drift.Value(data['dossier_id'] as String?),
        creePar: drift.Value(creePar),
        annee: now.year,
        numero: drift.Value(numero),
        dateEmission: data['date_emission'] as DateTime? ?? now,
        dateEcheance: data['date_echeance'] as DateTime? ?? now.add(const Duration(days: 30)),
        montantHt: drift.Value(montantHt),
        tauxTva: drift.Value(tauxTva),
        montantTva: drift.Value(montantTva),
        tauxTps: drift.Value(tauxTps),
        montantTps: drift.Value(montantTps),
        montantTtc: drift.Value(montantTtc),
        montantRestant: drift.Value(montantTtc),
        objet: drift.Value(data['objet'] as String?),
        syncStatus: const drift.Value(AppConstants.syncPending),
      ));

      for (var i = 0; i < lignes.length; i++) {
        final l = lignes[i];
        final qte = (l['quantite'] as num?)?.toDouble() ?? 1;
        final pu = (l['prix_unit'] as num?)?.toDouble() ?? 0;
        await _db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
          id: ligneIds[i],
          factureId: id,
          ordre: drift.Value(i),
          designation: l['designation'] as String,
          quantite: drift.Value(qte),
          unite: drift.Value(l['unite'] as String? ?? 'forfait'),
          prixUnit: drift.Value(pu),
          montantHt: drift.Value(qte * pu),
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
      'montant_restant': montantTtc,
    };

    final lignesPayload = [
      for (var i = 0; i < lignes.length; i++)
        {
          'id': ligneIds[i],
          'facture_id': id,
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
      try {
        final resp = await _supabase.from('factures').insert(toJsonSafe(syncData)).select('numero').single();
        final serverNumero = resp['numero'] as String?;
        if (serverNumero != null) {
          await _db.facturesDao.updateNumero(id, serverNumero);
        } else {
          await _db.facturesDao.markSynced(id);
        }
        AppLogger.i('FactureRepository', 'Facture $id synchronisée avec Supabase');
      } catch (e, s) {
        AppLogger.e('FactureRepository', 'Échec sync Supabase facture $id (create)', error: e, stack: s);
        await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      }
      await _syncLignes(id, lignesPayload);
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      if (lignesPayload.isNotEmpty) {
        await _db.syncQueueDao.enqueue(entityType: 'factures_lignes', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignesPayload})));
      }
    }
    return id;
  }

  /// Pousse les lignes d'une facture vers Supabase (table `factures_lignes`).
  Future<void> _syncLignes(String factureId, List<Map<String, dynamic>> lignes) async {
    if (lignes.isEmpty) return;
    try {
      await _supabase.from('factures_lignes').upsert(lignes.map(toJsonSafe).toList());
    } catch (e, s) {
      AppLogger.e('FactureRepository', 'Échec sync lignes facture $factureId', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'factures_lignes', entityId: factureId, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignes})));
    }
  }

  /// Valide une facture en brouillon : passage au statut 'emise' (Validée).
  /// Une fois validée, la facture ne doit plus être modifiée.
  Future<void> validerFacture(String id) async {
    await _db.facturesDao.updateStatut(id, AppConstants.factureEmise);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('factures').update({'statut': AppConstants.factureEmise}).eq('id', id);
        await _db.facturesDao.markSynced(id);
      } catch (e, s) {
        AppLogger.e('FactureRepository', 'Échec sync Supabase facture $id (validation)', error: e, stack: s);
        await _db.syncQueueDao.enqueue(
          entityType: 'facture',
          entityId: id,
          operation: 'update',
          payload: jsonEncode({'id': id, 'statut': AppConstants.factureEmise}),
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'facture',
        entityId: id,
        operation: 'update',
        payload: jsonEncode({'id': id, 'statut': AppConstants.factureEmise}),
      );
    }
  }

  /// Annule une facture (brouillon ou émise uniquement).
  Future<void> annulerFacture(String id) async {
    await _db.facturesDao.updateStatut(id, AppConstants.factureAnnulee);
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('factures').update({'statut': AppConstants.factureAnnulee}).eq('id', id);
        await _db.facturesDao.markSynced(id);
      } catch (e, s) {
        AppLogger.e('FactureRepository', 'Échec sync Supabase facture $id (annulation)', error: e, stack: s);
        await _db.syncQueueDao.enqueue(
          entityType: 'facture',
          entityId: id,
          operation: 'update',
          payload: jsonEncode({'id': id, 'statut': AppConstants.factureAnnulee}),
        );
      }
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'facture',
        entityId: id,
        operation: 'update',
        payload: jsonEncode({'id': id, 'statut': AppConstants.factureAnnulee}),
      );
    }
  }

  Future<void> enregistrerPaiement(String id, double montant, String? mode, String? reference) async {
    await _db.facturesDao.enregistrerPaiement(id, montant, mode, reference);
    if (_ref.read(isOnlineProvider)) {
      try {
        final facture = await _db.facturesDao.getById(id);
        if (facture != null) {
          await _supabase.from('factures').update({
            'montant_paye': facture.montantPaye,
            'montant_restant': facture.montantRestant,
            'statut': facture.statut,
          }).eq('id', id);
          await _db.facturesDao.markSynced(id);
        }
      } catch (e, s) {
        AppLogger.e('FactureRepository', 'Échec sync Supabase facture $id (paiement)', error: e, stack: s);
      }
    }
  }
}
