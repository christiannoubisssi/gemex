import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/services/app_logger.dart';
import '../../database/app_database.dart';
import '../../features/clients/presentation/providers/client_provider.dart';
import '../../features/comptabilite/presentation/providers/charge_provider.dart';
import '../../features/devis/presentation/providers/devis_provider.dart';
import '../../features/dossiers/presentation/providers/dossier_provider.dart';
import '../../features/factures/presentation/providers/facture_provider.dart';
import '../../features/paie/presentation/providers/salaire_provider.dart';
import '../../features/stock/presentation/providers/stock_provider.dart';

enum SyncStatus { idle, syncing, error, offline }

final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.idle);

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class SyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;
  Timer? _retryTimer;
  bool _isSyncing = false;

  SyncService({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  void start() {
    if (_ref.read(isOnlineProvider)) syncNow();

    _ref.listen<bool>(isOnlineProvider, (prev, isOnline) {
      if (isOnline && prev != true) syncNow();
      if (!isOnline) {
        _ref.read(syncStatusProvider.notifier).state = SyncStatus.offline;
      }
    });

    _retryTimer = Timer.periodic(
      const Duration(seconds: AppConstants.syncIntervalSeconds),
      (_) {
        if (_ref.read(isOnlineProvider)) syncNow();
      },
    );
  }

  void dispose() => _retryTimer?.cancel();

  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _ref.read(syncStatusProvider.notifier).state = SyncStatus.syncing;

    try {
      AppLogger.i('SyncService', 'Début de la synchronisation');

      // ── Pull Supabase → Drift (respecte l'ordre des FK) ─────────────────
      await _pullClients();
      await _pullClientContacts();
      await _pullDossiers();
      await _pullDevis();
      await _pullDevisLignes();
      await _pullFactures();
      await _pullFacturesLignes();
      await _pullCharges();
      await _pullPersonnel();
      await _pullProduits();
      await _pullStockMouvements();
      await _pullReferentiels();
      await _pullTaxes();
      await _pullSalaires();
      await _pullConges();
      await _pullChargesModeles();
      await _pullChargesModeleLines();
      await _pullDocumentsRapport();
      await _pullPiecesJointesMeta();

      // ── Push Drift pending → Supabase ─────────────────────────────────
      final pending = await _db.syncQueueDao
          .getPending(maxAttempts: AppConstants.maxSyncAttempts);
      AppLogger.d('SyncService', '${pending.length} élément(s) en attente');
      for (final item in pending) {
        await _processItem(item);
      }

      AppLogger.i('SyncService', 'Synchronisation terminée');
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.idle;
    } catch (e, s) {
      AppLogger.e('SyncService', 'Erreur de synchronisation', error: e, stack: s);
      _ref.read(syncStatusProvider.notifier).state = SyncStatus.error;
    } finally {
      _isSyncing = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PULL : Supabase → Drift
  // Chaque méthode est silencieuse (try/catch) — une entité défaillante
  // ne bloque pas les autres.
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _pullClients() async {
    try {
      final rows = await _supabase.from('clients').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.clientsDao.upsert(ClientsCompanion(
          id:           drift.Value(_s(m, 'id')!),
          entrepriseId: drift.Value(_s(m, 'entreprise_id') ?? 'default'),
          typeClient:   drift.Value(_s(m, 'type_client') ?? AppConstants.clientEntreprise),
          nom:          drift.Value(_s(m, 'nom') ?? ''),
          contactNom:   drift.Value(_s(m, 'contact_nom')),
          email:        drift.Value(_s(m, 'email')),
          telephone:    drift.Value(_s(m, 'telephone')),
          adresse:      drift.Value(_s(m, 'adresse')),
          ville:        drift.Value(_s(m, 'ville')),
          pays:         drift.Value(_s(m, 'pays') ?? 'Gabon'),
          numeroTva:     drift.Value(_s(m, 'numero_tva')),
          rccm:          drift.Value(_s(m, 'rccm')),
          nif:           drift.Value(_s(m, 'nif')),
          notes:         drift.Value(_s(m, 'notes')),
          reference:     drift.Value(_s(m, 'reference')),
          refOleaUnique: drift.Value(_s(m, 'ref_olea_unique')),
          refAgl:        drift.Value(_s(m, 'ref_agl')),
          refDs:         drift.Value(_s(m, 'ref_ds')),
          cabinetBce:    drift.Value(_s(m, 'cabinet_bce')),
          syncStatus:    const drift.Value('synced'),
        ));
      }
      _ref.invalidate(clientsProvider);
      _ref.invalidate(clientsMapProvider);
      AppLogger.d('SyncService', 'Pull clients : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull clients échoué', error: e);
    }
  }

  Future<void> _pullClientContacts() async {
    try {
      final rows = await _supabase.from('client_contacts').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.clientContactsDao.upsert(ClientContactsCompanion(
          id:         drift.Value(_s(m, 'id')!),
          clientId:   drift.Value(_s(m, 'client_id')!),
          nom:        drift.Value(_s(m, 'nom') ?? ''),
          fonction:   drift.Value(_s(m, 'fonction')),
          telephone:  drift.Value(_s(m, 'telephone')),
          email:      drift.Value(_s(m, 'email')),
          syncStatus: const drift.Value('synced'),
        ));
      }
      AppLogger.d('SyncService', 'Pull client_contacts : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull client_contacts échoué', error: e);
    }
  }

  Future<void> _pullDossiers() async {
    try {
      final rows = await _supabase.from('dossiers').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        final remoteNumero = _s(m, 'numero');
        // Ne pas écraser un numéro local existant avec null
        final localDossier = await _db.dossiersDao.getById(_s(m, 'id')!);
        final numero = remoteNumero ?? localDossier?.numero;

        await _db.dossiersDao.upsert(DossiersCompanion.insert(
          id:                 _s(m, 'id')!,
          entrepriseId:       _s(m, 'entreprise_id') ?? 'default',
          titre:              _s(m, 'titre') ?? '',
          annee:              _i(m, 'annee') ?? DateTime.now().year,
          numero:             drift.Value(numero),
          clientId:           drift.Value(_s(m, 'client_id')),
          expertId:           drift.Value(_s(m, 'expert_id')),
          typeMissionId:      drift.Value(_s(m, 'type_mission_id')),
          statut:             drift.Value(_s(m, 'statut') ?? AppConstants.statutBrouillon),
          priorite:           drift.Value(_s(m, 'priorite') ?? 'normale'),
          description:        drift.Value(_s(m, 'description')),
          dateSinistre:       drift.Value(_dt(m, 'date_sinistre')),
          lieuSinistre:       drift.Value(_s(m, 'lieu_sinistre')),
          natureSinistre:     drift.Value(_s(m, 'nature_sinistre')),
          montantSinistre:    drift.Value(_f(m, 'montant_sinistre')),
          compagnieAssurance: drift.Value(_s(m, 'compagnie_assurance')),
          numeroPolice:       drift.Value(_s(m, 'numero_police')),
          courtier:           drift.Value(_s(m, 'courtier')),
          notesInternes:      drift.Value(_s(m, 'notes_internes')),
          observations:       drift.Value(_s(m, 'observations')),
          motifAnnulation:    drift.Value(_s(m, 'motif_annulation')),
          dateExpertise:      drift.Value(_dt(m, 'date_expertise')),
          dateRapport:        drift.Value(_dt(m, 'date_rapport')),
          dateCloture:        drift.Value(_dt(m, 'date_cloture')),
          deadline:           drift.Value(_dt(m, 'deadline')),
          syncStatus:         const drift.Value('synced'),
          createdAt:          drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:          drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      _ref.invalidate(dossiersProvider);
      _ref.invalidate(dossierStatsProvider);
      AppLogger.d('SyncService', 'Pull dossiers : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull dossiers échoué', error: e);
    }
  }

  Future<void> _pullDevis() async {
    try {
      final rows = await _supabase.from('devis').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        final remoteNumero = _s(m, 'numero');
        final localDevis = await _db.devisDao.getById(_s(m, 'id')!);
        final numero = remoteNumero ?? localDevis?.numero;

        await _db.devisDao.upsertDevis(DevisCompanion.insert(
          id:           _s(m, 'id')!,
          entrepriseId: _s(m, 'entreprise_id') ?? 'default',
          clientId:     _s(m, 'client_id') ?? '',
          annee:        _i(m, 'annee') ?? DateTime.now().year,
          dateEmission: _dt(m, 'date_emission') ?? DateTime.now(),
          dateValidite: _dt(m, 'date_validite') ??
              DateTime.now().add(const Duration(days: 30)),
          dossierId:    drift.Value(_s(m, 'dossier_id')),
          creePar:      drift.Value(_s(m, 'cree_par')),
          numero:       drift.Value(numero),
          statut:       drift.Value(_s(m, 'statut') ?? 'brouillon'),
          montantHt:    drift.Value(_f(m, 'montant_ht') ?? 0),
          tauxTva:      drift.Value(_f(m, 'taux_tva') ?? 18),
          montantTva:   drift.Value(_f(m, 'montant_tva') ?? 0),
          tauxTps:      drift.Value(_f(m, 'taux_tps') ?? 0),
          montantTps:   drift.Value(_f(m, 'montant_tps') ?? 0),
          montantTtc:   drift.Value(_f(m, 'montant_ttc') ?? 0),
          objet:        drift.Value(_s(m, 'objet')),
          conditions:   drift.Value(_s(m, 'conditions')),
          notes:        drift.Value(_s(m, 'notes')),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      // devisAllProvider est StreamProvider → auto-update via Drift
      _ref.invalidate(devisListProvider);
      AppLogger.d('SyncService', 'Pull devis : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull devis échoué', error: e);
    }
  }

  Future<void> _pullDevisLignes() async {
    try {
      final rows = await _supabase.from('devis_lignes').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        // Champs requis : id, devisId, designation
        await _db.devisDao.upsertLigne(DevisLignesCompanion.insert(
          id:          _s(m, 'id')!,
          devisId:     _s(m, 'devis_id') ?? '',
          designation: _s(m, 'designation') ?? '',
          ordre:       drift.Value(_i(m, 'ordre') ?? 0),
          description: drift.Value(_s(m, 'description')),
          quantite:    drift.Value(_f(m, 'quantite') ?? 1),
          unite:       drift.Value(_s(m, 'unite') ?? 'forfait'),
          prixUnit:    drift.Value(_f(m, 'prix_unit') ?? 0),
          montantHt:   drift.Value(_f(m, 'montant_ht') ?? 0),
          taxesJson:   drift.Value(_s(m, 'taxes_json')),
        ));
      }
      AppLogger.d('SyncService', 'Pull devis_lignes : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull devis_lignes échoué', error: e);
    }
  }

  Future<void> _pullFactures() async {
    try {
      final rows = await _supabase.from('factures').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        final remoteNumero = _s(m, 'numero');
        final localFacture = await _db.facturesDao.getById(_s(m, 'id')!);
        final numero = remoteNumero ?? localFacture?.numero;

        await _db.facturesDao.upsertFacture(FacturesCompanion.insert(
          id:                _s(m, 'id')!,
          entrepriseId:      _s(m, 'entreprise_id') ?? 'default',
          clientId:          _s(m, 'client_id') ?? '',
          annee:             _i(m, 'annee') ?? DateTime.now().year,
          dateEmission:      _dt(m, 'date_emission') ?? DateTime.now(),
          dateEcheance:      _dt(m, 'date_echeance') ??
              DateTime.now().add(const Duration(days: 30)),
          dossierId:         drift.Value(_s(m, 'dossier_id')),
          devisId:           drift.Value(_s(m, 'devis_id')),
          creePar:           drift.Value(_s(m, 'cree_par')),
          numero:            drift.Value(numero),
          statut:            drift.Value(_s(m, 'statut') ?? 'brouillon'),
          datePaiement:      drift.Value(_dt(m, 'date_paiement')),
          montantHt:         drift.Value(_f(m, 'montant_ht') ?? 0),
          tauxTva:           drift.Value(_f(m, 'taux_tva') ?? 18),
          montantTva:        drift.Value(_f(m, 'montant_tva') ?? 0),
          tauxTps:           drift.Value(_f(m, 'taux_tps') ?? 0),
          montantTps:        drift.Value(_f(m, 'montant_tps') ?? 0),
          montantTtc:        drift.Value(_f(m, 'montant_ttc') ?? 0),
          montantPaye:       drift.Value(_f(m, 'montant_paye') ?? 0),
          montantRestant:    drift.Value(_f(m, 'montant_restant') ?? 0),
          modePaiement:      drift.Value(_s(m, 'mode_paiement')),
          referencePaiement: drift.Value(_s(m, 'reference_paiement')),
          objet:             drift.Value(_s(m, 'objet')),
          conditions:        drift.Value(_s(m, 'conditions')),
          notes:             drift.Value(_s(m, 'notes')),
          motifAnnulation:   drift.Value(_s(m, 'motif_annulation')),
          syncStatus:        const drift.Value('synced'),
          createdAt:         drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:         drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      _ref.invalidate(facturesProvider);
      _ref.invalidate(facturesEnRetardProvider);
      AppLogger.d('SyncService', 'Pull factures : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull factures échoué', error: e);
    }
  }

  Future<void> _pullFacturesLignes() async {
    try {
      final rows = await _supabase.from('factures_lignes').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        // Champs requis : id, factureId, designation
        await _db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
          id:          _s(m, 'id')!,
          factureId:   _s(m, 'facture_id') ?? '',
          designation: _s(m, 'designation') ?? '',
          ordre:       drift.Value(_i(m, 'ordre') ?? 0),
          description: drift.Value(_s(m, 'description')),
          quantite:    drift.Value(_f(m, 'quantite') ?? 1),
          unite:       drift.Value(_s(m, 'unite') ?? 'forfait'),
          prixUnit:    drift.Value(_f(m, 'prix_unit') ?? 0),
          montantHt:   drift.Value(_f(m, 'montant_ht') ?? 0),
          taxesJson:   drift.Value(_s(m, 'taxes_json')),
        ));
      }
      AppLogger.d('SyncService', 'Pull factures_lignes : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull factures_lignes échoué', error: e);
    }
  }

  Future<void> _pullCharges() async {
    try {
      final rows = await _supabase.from('charges').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        // Champs requis : id, entrepriseId, categorie, libelle, montant, dateCharge, mois, annee
        await _db.chargesDao.upsert(ChargesCompanion.insert(
          id:              _s(m, 'id')!,
          entrepriseId:    _s(m, 'entreprise_id') ?? 'default',
          categorie:       _s(m, 'categorie') ?? 'autre',
          libelle:         _s(m, 'libelle') ?? '',
          montant:         _f(m, 'montant') ?? 0,
          dateCharge:      _dt(m, 'date_charge') ?? DateTime.now(),
          mois:            _i(m, 'mois') ?? DateTime.now().month,
          annee:           _i(m, 'annee') ?? DateTime.now().year,
          dossierId:       drift.Value(_s(m, 'dossier_id')),
          saisiPar:        drift.Value(_s(m, 'saisi_par')),
          justificatifUrl: drift.Value(_s(m, 'justificatif_url')),
          notes:           drift.Value(_s(m, 'notes')),
          recurrence:      drift.Value(_s(m, 'recurrence') ?? 'unique'),
          syncStatus:      const drift.Value('synced'),
          createdAt:       drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:       drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      _ref.invalidate(chargesProvider);
      _ref.invalidate(totalChargesProvider);
      AppLogger.d('SyncService', 'Pull charges : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull charges échoué', error: e);
    }
  }

  Future<void> _pullPersonnel() async {
    try {
      final rows = await _supabase.from('personnel').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        // Champs requis : id, entrepriseId, nom
        await _db.personnelDao.upsert(PersonnelCompanion.insert(
          id:             _s(m, 'id')!,
          entrepriseId:   _s(m, 'entreprise_id') ?? 'default',
          nom:            _s(m, 'nom') ?? '',
          utilisateurId:  drift.Value(_s(m, 'utilisateur_id')),
          prenom:         drift.Value(_s(m, 'prenom')),
          poste:          drift.Value(_s(m, 'poste')),
          departement:    drift.Value(_s(m, 'departement')),
          typeContrat:    drift.Value(_s(m, 'type_contrat') ?? 'CDI'),
          dateEmbauche:   drift.Value(_dt(m, 'date_embauche')),
          dateFinContrat: drift.Value(_dt(m, 'date_fin_contrat')),
          salaireBase:    drift.Value(_f(m, 'salaire_base')),
          actif:          drift.Value(m['actif'] as bool? ?? true),
          syncStatus:     const drift.Value('synced'),
          createdAt:      drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:      drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      // personnelListProvider est StreamProvider → auto-update via Drift
      _ref.invalidate(salairesProvider);
      AppLogger.d('SyncService', 'Pull personnel : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull personnel échoué', error: e);
    }
  }

  Future<void> _pullProduits() async {
    try {
      final rows = await _supabase.from('produits').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.produitsDao.upsert(ProduitsCompanion.insert(
          id:           _s(m, 'id')!,
          entrepriseId: _s(m, 'entreprise_id') ?? 'default',
          code:         _s(m, 'code') ?? '',
          nom:          _s(m, 'nom') ?? '',
          description:  drift.Value(_s(m, 'description')),
          unite:        drift.Value(_s(m, 'unite') ?? 'unité'),
          prixVente:    drift.Value(_f(m, 'prix_vente') ?? 0),
          prixAchat:    drift.Value(_f(m, 'prix_achat') ?? 0),
          estVente:     drift.Value(m['est_vente'] as bool? ?? true),
          estAchat:     drift.Value(m['est_achat'] as bool? ?? false),
          categorie:    drift.Value(_s(m, 'categorie')),
          stockMin:     drift.Value(_f(m, 'stock_min') ?? 0),
          actif:        drift.Value(m['actif'] as bool? ?? true),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      // produitsProvider est StreamProvider → auto-update
      AppLogger.d('SyncService', 'Pull produits : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull produits échoué', error: e);
    }
  }

  Future<void> _pullStockMouvements() async {
    try {
      final rows = await _supabase.from('stock_mouvements').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.stockMouvementsDao.upsert(StockMouvementsCompanion.insert(
          id:             _s(m, 'id')!,
          entrepriseId:   _s(m, 'entreprise_id') ?? 'default',
          produitId:      _s(m, 'produit_id') ?? '',
          type:           _s(m, 'type') ?? 'entree',
          quantite:       _f(m, 'quantite') ?? 0,
          dateMouvement:  _dt(m, 'date_mouvement') ?? DateTime.now(),
          prixUnitaire:   drift.Value(_f(m, 'prix_unitaire') ?? 0),
          reference:      drift.Value(_s(m, 'reference')),
          dossierId:      drift.Value(_s(m, 'dossier_id')),
          effectuePar:    drift.Value(_s(m, 'effectue_par')),
          notes:          drift.Value(_s(m, 'notes')),
          syncStatus:     const drift.Value('synced'),
          createdAt:      drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:      drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      _ref.invalidate(stockQuantitesProvider);
      AppLogger.d('SyncService', 'Pull stock_mouvements : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull stock_mouvements échoué', error: e);
    }
  }

  Future<void> _pullReferentiels() async {
    try {
      final rows = await _supabase.from('referentiels').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.referentielsDao.upsert(ReferentielsCompanion(
          id:           drift.Value(_s(m, 'id')!),
          entrepriseId: drift.Value(_s(m, 'entreprise_id') ?? 'default'),
          type:         drift.Value(_s(m, 'type')!),
          nom:          drift.Value(_s(m, 'nom') ?? ''),
          actif:        drift.Value(m['actif'] as bool? ?? true),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull referentiels : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull referentiels échoué', error: e);
    }
  }

  Future<void> _pullTaxes() async {
    try {
      final rows = await _supabase.from('taxes').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.taxesDao.upsert(TaxesCompanion(
          id:           drift.Value(_s(m, 'id')!),
          entrepriseId: drift.Value(_s(m, 'entreprise_id') ?? 'default'),
          nom:          drift.Value(_s(m, 'nom') ?? ''),
          taux:         drift.Value(_f(m, 'taux') ?? 0),
          description:  drift.Value(_s(m, 'description')),
          actif:        drift.Value(m['actif'] as bool? ?? true),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull taxes : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull taxes échoué', error: e);
    }
  }

  Future<void> _pullSalaires() async {
    try {
      final rows = await _supabase.from('salaires').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.salairesDao.upsert(SalairesCompanion.insert(
          id:              _s(m, 'id')!,
          entrepriseId:    _s(m, 'entreprise_id') ?? 'default',
          personnelId:     _s(m, 'personnel_id') ?? '',
          mois:            _i(m, 'mois') ?? DateTime.now().month,
          annee:           _i(m, 'annee') ?? DateTime.now().year,
          salaireNet:      _f(m, 'salaire_net') ?? 0,
          salaireBrut:     drift.Value(_f(m, 'salaire_brut') ?? 0),
          cnps:            drift.Value(_f(m, 'cnps') ?? 0),
          irpp:            drift.Value(_f(m, 'irpp') ?? 0),
          autresRetenues:  drift.Value(_f(m, 'autres_retenues') ?? 0),
          statut:          drift.Value(_s(m, 'statut') ?? 'en_attente'),
          dateValidation:  drift.Value(_dt(m, 'date_validation')),
          validePar:       drift.Value(_s(m, 'valide_par')),
          datePaiement:    drift.Value(_dt(m, 'date_paiement')),
          modePaiement:    drift.Value(_s(m, 'mode_paiement')),
          comptabilise:    drift.Value(m['comptabilise'] as bool? ?? false),
          chargeId:        drift.Value(_s(m, 'charge_id')),
          notes:           drift.Value(_s(m, 'notes')),
          syncStatus:      const drift.Value('synced'),
          createdAt:       drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:       drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      _ref.invalidate(salairesProvider);
      AppLogger.d('SyncService', 'Pull salaires : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull salaires échoué', error: e);
    }
  }

  Future<void> _pullConges() async {
    try {
      final rows = await _supabase.from('conges').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.congesDao.upsert(CongesCompanion.insert(
          id:           _s(m, 'id')!,
          personnelId:  _s(m, 'personnel_id') ?? '',
          dateDebut:    _dt(m, 'date_debut') ?? DateTime.now(),
          dateFin:      _dt(m, 'date_fin') ?? DateTime.now(),
          type:         drift.Value(_s(m, 'type') ?? 'conge_annuel'),
          motif:        drift.Value(_s(m, 'motif')),
          statut:       drift.Value(_s(m, 'statut') ?? 'demande'),
          validePar:    drift.Value(_s(m, 'valide_par')),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull conges : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull conges échoué', error: e);
    }
  }

  Future<void> _pullChargesModeles() async {
    try {
      final rows = await _supabase.from('charges_modeles').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.chargesModelesDao.upsert(ChargesModelesCompanion.insert(
          id:              _s(m, 'id')!,
          entrepriseId:    _s(m, 'entreprise_id') ?? 'default',
          mois:            _i(m, 'mois') ?? DateTime.now().month,
          annee:           _i(m, 'annee') ?? DateTime.now().year,
          titre:           _s(m, 'titre') ?? '',
          soumisParId:     drift.Value(_s(m, 'soumis_par_id')),
          soumisParNom:    drift.Value(_s(m, 'soumis_par_nom')),
          statut:          drift.Value(_s(m, 'statut') ?? 'brouillon'),
          motifRefus:      drift.Value(_s(m, 'motif_refus')),
          dateSubmission:  drift.Value(_dt(m, 'date_submission')),
          dateValidation:  drift.Value(_dt(m, 'date_validation')),
          valideParId:     drift.Value(_s(m, 'valide_par_id')),
          valideParNom:    drift.Value(_s(m, 'valide_par_nom')),
          syncStatus:      const drift.Value('synced'),
          createdAt:       drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:       drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull charges_modeles : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull charges_modeles échoué', error: e);
    }
  }

  Future<void> _pullChargesModeleLines() async {
    try {
      final rows = await _supabase.from('charges_modele_lines').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.chargesModelesDao.upsertLigne(ChargesModeleLinesCompanion.insert(
          id:            _s(m, 'id')!,
          modeleId:      _s(m, 'modele_id') ?? '',
          designation:   _s(m, 'designation') ?? '',
          ordre:         drift.Value(_i(m, 'ordre') ?? 0),
          montant:       drift.Value(_f(m, 'montant') ?? 0),
          dateEcheance:  drift.Value(_dt(m, 'date_echeance')),
          priorite:      drift.Value(_s(m, 'priorite') ?? 'normale'),
          statut:        drift.Value(_s(m, 'statut') ?? 'pending'),
          motifRefus:    drift.Value(_s(m, 'motif_refus')),
          notes:         drift.Value(_s(m, 'notes')),
        ));
      }
      AppLogger.d('SyncService', 'Pull charges_modele_lines : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull charges_modele_lines échoué', error: e);
    }
  }

  Future<void> _pullDocumentsRapport() async {
    try {
      final rows = await _supabase.from('documents_rapport').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        await _db.documentsRapportDao.upsert(DocumentsRapportCompanion(
          id:           drift.Value(_s(m, 'id')!),
          dossierId:    drift.Value(_s(m, 'dossier_id') ?? ''),
          type:         drift.Value(_s(m, 'type') ?? ''),
          contenuJson:  drift.Value(_s(m, 'contenu_json') ?? '{}'),
          statut:       drift.Value(_s(m, 'statut') ?? 'brouillon'),
          entrepriseId: drift.Value(_s(m, 'entreprise_id') ?? 'default'),
          syncStatus:   const drift.Value('synced'),
          createdAt:    drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:    drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull documents_rapport : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull documents_rapport échoué', error: e);
    }
  }

  /// Pull métadonnées des pièces jointes (pas les fichiers binaires).
  /// Les fichiers sont téléchargés à la demande via PieceJointeRepository.download().
  Future<void> _pullPiecesJointesMeta() async {
    try {
      final rows = await _supabase.from('pieces_jointes').select() as List;
      for (final raw in rows) {
        final m = _row(raw);
        final id = _s(m, 'id')!;
        // Ne pas écraser chemin_local si le fichier existe déjà en local
        final local = await _db.piecesJointesDao.getById(id);
        final cheminLocal = local?.cheminLocal ?? '';

        await _db.piecesJointesDao.upsert(PiecesJointesCompanion(
          id:          drift.Value(id),
          dossierId:   drift.Value(_s(m, 'dossier_id') ?? ''),
          nom:         drift.Value(_s(m, 'nom') ?? ''),
          typeFichier: drift.Value(_s(m, 'type_fichier') ?? 'document'),
          cheminLocal: drift.Value(cheminLocal),
          urlStorage:  drift.Value(_s(m, 'url_storage')),
          taille:      drift.Value(_i(m, 'taille')),
          latitude:    drift.Value(_f(m, 'latitude')),
          longitude:   drift.Value(_f(m, 'longitude')),
          notes:       drift.Value(_s(m, 'notes')),
          syncStatus:  const drift.Value('synced'),
          createdAt:   drift.Value(_dt(m, 'created_at') ?? DateTime.now()),
          updatedAt:   drift.Value(_dt(m, 'updated_at') ?? DateTime.now()),
        ));
      }
      AppLogger.d('SyncService', 'Pull pieces_jointes (méta) : ${rows.length}');
    } catch (e) {
      AppLogger.w('SyncService', 'Pull pieces_jointes échoué', error: e);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PUSH : Drift local → Supabase (SyncQueue)
  // ═══════════════════════════════════════════════════════════════════════

  static const Map<String, String> _tableOverrides = {
    'piece_jointe': 'pieces_jointes',
    'charge_modele': 'charges_modeles',
    'personnel': 'personnel',
    'produit': 'produits',
    'stock_mouvement': 'stock_mouvements',
    'referentiel': 'referentiels',
    'taxe': 'taxes',
    'document_rapport': 'documents_rapport',
  };

  static const Set<String> _lignesTypes = {
    'devis_lignes',
    'factures_lignes',
    'charges_modele_lines',
  };

  Future<void> _processItem(SyncQueueData item) async {
    try {
      if (item.operation == 'upload' && item.entityType == 'piece_jointe') {
        await _uploadPieceJointe(item);
      } else if (_lignesTypes.contains(item.entityType)) {
        await _processLignesItem(item);
      } else {
        final table = _tableOverrides[item.entityType] ?? '${item.entityType}s';
        switch (item.operation) {
          case 'create':
            await _supabase
                .from(table)
                .insert(_parsePayload(item.payload));
          case 'update':
            await _supabase
                .from(table)
                .update(_parsePayload(item.payload))
                .eq('id', item.entityId);
          case 'delete':
            await _supabase
                .from(table)
                .delete()
                .eq('id', item.entityId);
        }
      }
      await _db.syncQueueDao.deleteItem(item.id);
      await _markEntitySynced(item.entityType, item.entityId);
    } catch (e) {
      AppLogger.w(
        'SyncService',
        'Échec sync ${item.entityType}#${item.entityId} '
            '(tentative ${item.attempts + 1})',
        error: e,
      );
      await _db.syncQueueDao.incrementAttempts(item.id);
      if (item.attempts + 1 >= AppConstants.maxSyncAttempts) {
        await _markEntityConflict(item.entityType, item.entityId);
      }
    }
  }

  Future<void> _processLignesItem(SyncQueueData item) async {
    final payload = _parsePayload(item.payload);
    final lignes = (payload['lignes'] as List? ?? [])
        .map((l) => Map<String, dynamic>.from(l as Map))
        .toList();
    final replaceKey = payload['replace_key'] as String?;
    final replaceValue = payload['replace_value'] as String?;
    if (replaceKey != null && replaceValue != null) {
      await _supabase
          .from(item.entityType)
          .delete()
          .eq(replaceKey, replaceValue);
    }
    if (lignes.isEmpty) return;
    await _supabase.from(item.entityType).upsert(lignes);
  }

  Future<void> _uploadPieceJointe(SyncQueueData item) async {
    final data = _parsePayload(item.payload);
    final cheminLocal = data['chemin_local'] as String?;
    final dossierId = data['dossier_id'] as String?;
    final nom = data['nom'] as String?;
    if (cheminLocal == null || dossierId == null || nom == null) return;
    final file = File(cheminLocal);
    if (!await file.exists()) return;
    final path = 'dossiers/$dossierId/$nom';
    await _supabase.storage.from('pieces-jointes').upload(path, file);
    final url = _supabase.storage.from('pieces-jointes').getPublicUrl(path);
    await _db.piecesJointesDao.updateUrlStorage(item.entityId, url);
  }

  Future<void> _markEntitySynced(String entityType, String entityId) async {
    switch (entityType) {
      case 'dossier':
        await _db.dossiersDao.markSynced(entityId);
      case 'client':
        await _db.clientsDao.markSynced(entityId);
      case 'devis':
        await _db.devisDao.markSynced(entityId);
      case 'facture':
        await _db.facturesDao.markSynced(entityId);
      case 'charge':
        await _db.chargesDao.markSynced(entityId);
      case 'charge_modele':
        await _db.chargesModelesDao.markSynced(entityId);
      case 'personnel':
        await _db.personnelDao.markSynced(entityId);
      case 'conge':
        await _db.congesDao.markSynced(entityId);
      case 'salaire':
        await _db.salairesDao.markSynced(entityId);
      case 'piece_jointe':
        await _db.piecesJointesDao.markSynced(entityId);
      case 'client_contact':
        await _db.clientContactsDao.markSynced(entityId);
      case 'produit':
        await _db.produitsDao.markSynced(entityId);
      case 'stock_mouvement':
        await _db.stockMouvementsDao.markSynced(entityId);
      case 'referentiel':
        await _db.referentielsDao.markSynced(entityId);
      case 'taxe':
        await _db.taxesDao.upsert(TaxesCompanion(
          id: drift.Value(entityId),
          syncStatus: const drift.Value('synced'),
        ));
      case 'document_rapport':
        await _db.documentsRapportDao.markSynced(entityId);
    }
  }

  Future<void> _markEntityConflict(String entityType, String entityId) async {
    // TODO(dev): exposer un UI de résolution de conflit en V2 — 2026-06
    AppLogger.w(
      'SyncService',
      'Conflit non résolu après ${AppConstants.maxSyncAttempts} tentatives : '
          '$entityType#$entityId',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Helpers de conversion JSON → types Dart (null-safe)
  // ═══════════════════════════════════════════════════════════════════════

  static Map<String, dynamic> _row(dynamic raw) =>
      Map<String, dynamic>.from(raw as Map);

  static String? _s(Map<String, dynamic> m, String k) => m[k] as String?;

  static double? _f(Map<String, dynamic> m, String k) {
    final v = m[k];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static int? _i(Map<String, dynamic> m, String k) {
    final v = m[k];
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static DateTime? _dt(Map<String, dynamic> m, String k) {
    final v = m[k];
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      return Map<String, dynamic>.from(
        jsonDecode(payload) as Map<String, dynamic>,
      );
    } catch (_) {
      return {};
    }
  }
}
