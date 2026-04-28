import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/format_utils.dart';
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

    await _db.transaction(() async {
      await _db.facturesDao.upsertFacture(FacturesCompanion.insert(
        id: id,
        entrepriseId: devis.entrepriseId,
        clientId: devis.clientId,
        devisId: drift.Value(devisId),
        dossierId: drift.Value(devis.dossierId),
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
          id: const Uuid().v4(),
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

    if (_ref.read(isOnlineProvider)) {
      try {
        final resp = await _supabase.from('factures').insert({'id': id, 'devis_id': devisId}).select('numero').single();
        final serverNumero = resp['numero'] as String?;
        if (serverNumero != null) {
          await _db.facturesDao.markSynced(id);
        }
      } catch (_) {
        await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode({'id': id, 'devis_id': devisId}));
      }
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'facture', entityId: id, operation: 'create', payload: jsonEncode({'id': id, 'devis_id': devisId}));
    }
    return id;
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
      } catch (_) {}
    }
  }
}
