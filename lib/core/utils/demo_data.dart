import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../database/app_database.dart';
import '../constants/app_constants.dart';

/// Données de démonstration inter-modules.
///
/// Chaîne principale illustrée :
///   Client → Dossier → Devis (accepté) → Facture (payée) → Charge (salaire comptabilisé)
///
/// Chaque module (Dossiers, Devis, Factures, Comptabilité, RH, Paie) est alimenté
/// avec des données réalistes couvrant tous les statuts possibles.
class DemoData {
  // ─── Seed complet ────────────────────────────────────────────────────────

  static Future<void> seedAll(AppDatabase db) async {
    final uuid = const Uuid();
    final now = DateTime.now();
    final mois = now.month;
    final annee = now.year;

    // ── 1. Taxes ─────────────────────────────────────────────────────────
    final taxeTvaId = uuid.v4();
    final taxeTpsId = uuid.v4();
    await db.taxesDao.upsert(TaxesCompanion.insert(
      id: taxeTvaId, entrepriseId: 'default', nom: 'TVA',
      taux: const Value(18.0), description: const Value('Taxe sur la Valeur Ajoutée — 18 %'),
      syncStatus: const Value('synced'),
    ));
    await db.taxesDao.upsert(TaxesCompanion.insert(
      id: taxeTpsId, entrepriseId: 'default', nom: 'TPS',
      taux: const Value(2.0), description: const Value('Taxe sur les Prestations de Services — 2 %'),
      syncStatus: const Value('synced'),
    ));

    // ── 2. Clients ────────────────────────────────────────────────────────
    final cIds = List.generate(6, (_) => uuid.v4());
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[0], entrepriseId: 'default', nom: 'Assurances du Gabon',
      typeClient: AppConstants.clientEntreprise,
      email: const Value('contact@assurancesgabon.ga'),
      telephone: const Value('+241 01 77 00 00'), ville: const Value('Libreville'),
      syncStatus: const Value('synced'),
    ));
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[1], entrepriseId: 'default', nom: 'SAHAM Assurance',
      typeClient: AppConstants.clientEntreprise,
      email: const Value('info@saham.ga'),
      telephone: const Value('+241 01 74 15 15'), ville: const Value('Port-Gentil'),
      syncStatus: const Value('synced'),
    ));
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[2], entrepriseId: 'default', nom: 'Jean-Pierre Mba',
      typeClient: AppConstants.clientParticulier,
      telephone: const Value('+241 06 25 30 40'), ville: const Value('Oyem'),
      syncStatus: const Value('synced'),
    ));
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[3], entrepriseId: 'default', nom: 'TotalEnergies Gabon',
      typeClient: AppConstants.clientEntreprise,
      email: const Value('direction@totalenergies.ga'),
      ville: const Value('Port-Gentil'), syncStatus: const Value('synced'),
    ));
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[4], entrepriseId: 'default', nom: 'GAR Assurances',
      typeClient: AppConstants.clientEntreprise,
      email: const Value('sinistres@gar.ga'),
      telephone: const Value('+241 01 72 34 56'), ville: const Value('Libreville'),
      syncStatus: const Value('synced'),
    ));
    await db.clientsDao.upsert(ClientsCompanion.insert(
      id: cIds[5], entrepriseId: 'default', nom: 'Sogéa-Satom Gabon',
      typeClient: AppConstants.clientEntreprise,
      telephone: const Value('+241 01 44 55 66'), ville: const Value('Libreville'),
      syncStatus: const Value('synced'),
    ));

    // ── 3. Personnel ──────────────────────────────────────────────────────
    final pIds = List.generate(4, (_) => uuid.v4());
    await db.personnelDao.upsert(PersonnelCompanion.insert(
      id: pIds[0], entrepriseId: 'default', nom: 'Christian Noubissi',
      poste: const Value('Expert Principal'), departement: const Value('Expertise'),
      typeContrat: const Value('CDI'),
      dateEmbauche: Value(DateTime(annee - 3, 3, 1)),
      salaireBase: const Value(850000.0), actif: const Value(true),
      syncStatus: const Value('synced'),
    ));
    await db.personnelDao.upsert(PersonnelCompanion.insert(
      id: pIds[1], entrepriseId: 'default', nom: 'Marie-Laure Mendome',
      poste: const Value('Assistante Administrative'), departement: const Value('Administration'),
      typeContrat: const Value('CDI'),
      dateEmbauche: Value(DateTime(annee - 1, 9, 1)),
      salaireBase: const Value(350000.0), actif: const Value(true),
      syncStatus: const Value('synced'),
    ));
    await db.personnelDao.upsert(PersonnelCompanion.insert(
      id: pIds[2], entrepriseId: 'default', nom: 'Paul Biyoghe',
      poste: const Value('Expert Junior'), departement: const Value('Expertise'),
      typeContrat: const Value('CDD'),
      dateEmbauche: Value(DateTime(annee, 1, 15)),
      dateFinContrat: Value(DateTime(annee + 1, 1, 14)),
      salaireBase: const Value(450000.0), actif: const Value(true),
      syncStatus: const Value('synced'),
    ));
    await db.personnelDao.upsert(PersonnelCompanion.insert(
      id: pIds[3], entrepriseId: 'default', nom: 'Aurélie Onzamba',
      poste: const Value('Comptable'), departement: const Value('Finance'),
      typeContrat: const Value('CDI'),
      dateEmbauche: Value(DateTime(annee - 2, 6, 1)),
      salaireBase: const Value(500000.0), actif: const Value(true),
      syncStatus: const Value('synced'),
    ));

    // ── 4. Dossiers ───────────────────────────────────────────────────────
    // Tous les statuts représentés pour illustrer le workflow complet
    final dIds = List.generate(6, (_) => uuid.v4());

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[0], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[0]), numero: const Value('AV-2026-001'),
      titre: 'Sinistre Incendie Immeuble ABC',
      description: const Value('Expertise incendie suite à court-circuit électrique'),
      statut: const Value(AppConstants.statutClos),
      priorite: const Value(AppConstants.prioriteHaute),
      dateOuverture: Value(now.subtract(const Duration(days: 45))),
      dateSinistre: Value(now.subtract(const Duration(days: 47))),
      dateExpertise: Value(now.subtract(const Duration(days: 40))),
      dateRapport: Value(now.subtract(const Duration(days: 20))),
      dateCloture: Value(now.subtract(const Duration(days: 5))),
      lieuSinistre: const Value('Libreville, Zone Industrielle Nord'),
      natureSinistre: const Value('Incendie'),
      syncStatus: const Value('synced'),
    ));

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[1], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[1]), numero: const Value('AV-2026-002'),
      titre: 'Collision Camion-Citerne RN1',
      statut: const Value(AppConstants.statutExpertise),
      priorite: const Value(AppConstants.prioriteNormale),
      dateOuverture: Value(now.subtract(const Duration(days: 12))),
      dateSinistre: Value(now.subtract(const Duration(days: 14))),
      dateExpertise: Value(now.subtract(const Duration(days: 10))),
      lieuSinistre: const Value('Route Nationale 1, km 45'),
      natureSinistre: const Value('Accident de circulation'),
      syncStatus: const Value('synced'),
    ));

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[2], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[2]), numero: const Value('AV-2026-003'),
      titre: 'Dégât des eaux — Villa Mba',
      statut: const Value(AppConstants.statutRapport),
      priorite: const Value(AppConstants.prioriteBasse),
      dateOuverture: Value(now.subtract(const Duration(days: 30))),
      dateSinistre: Value(now.subtract(const Duration(days: 32))),
      dateExpertise: Value(now.subtract(const Duration(days: 22))),
      dateRapport: Value(now.subtract(const Duration(days: 3))),
      lieuSinistre: const Value('Oyem, Quartier Résidentiel'),
      natureSinistre: const Value('Dégât des eaux'),
      syncStatus: const Value('synced'),
    ));

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[3], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[3]), numero: const Value('AV-2026-004'),
      titre: 'Dommages Plateforme Pétrolière Anguille',
      statut: const Value(AppConstants.statutNouveau),
      priorite: const Value(AppConstants.prioriteUrgente),
      dateOuverture: Value(now.subtract(const Duration(days: 2))),
      dateSinistre: Value(now.subtract(const Duration(days: 3))),
      lieuSinistre: const Value('Offshore Port-Gentil — Champ Anguille'),
      natureSinistre: const Value('Dommages matériels'),
      syncStatus: const Value('synced'),
    ));

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[4], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[4]), numero: const Value('AV-2026-005'),
      titre: 'Avarie Cargo Maritime MV Libreville',
      statut: const Value(AppConstants.statutClos),
      priorite: const Value(AppConstants.prioriteNormale),
      dateOuverture: Value(now.subtract(const Duration(days: 60))),
      dateSinistre: Value(now.subtract(const Duration(days: 62))),
      dateExpertise: Value(now.subtract(const Duration(days: 55))),
      dateRapport: Value(now.subtract(const Duration(days: 40))),
      dateCloture: Value(now.subtract(const Duration(days: 25))),
      lieuSinistre: const Value('Port-Gentil — Quai Mandji'),
      natureSinistre: const Value('Avarie maritime'),
      syncStatus: const Value('synced'),
    ));

    await db.dossiersDao.upsert(DossiersCompanion.insert(
      id: dIds[5], entrepriseId: 'default', annee: annee,
      clientId: Value(cIds[5]), numero: const Value('AV-2026-006'),
      titre: 'Effondrement Partiel Chantier BTP',
      statut: const Value(AppConstants.statutEnInstruction),
      priorite: const Value(AppConstants.prioriteHaute),
      dateOuverture: Value(now.subtract(const Duration(days: 7))),
      dateSinistre: Value(now.subtract(const Duration(days: 7))),
      lieuSinistre: const Value('Libreville — Chantier Quartier Louis'),
      natureSinistre: const Value('Effondrement'),
      syncStatus: const Value('synced'),
    ));

    // ── 5. Devis ──────────────────────────────────────────────────────────
    // DEV-001: accepté, lié DOS-001 → deviendra FAC-001
    // DEV-002: envoyé, lié DOS-002 (en attente réponse client)
    // DEV-003: brouillon, lié DOS-003
    // DEV-004: refusé, lié DOS-005 (le client a négocié)
    // DEV-005: accepté, lié DOS-005 (version négociée) → FAC-002
    final devIds = List.generate(5, (_) => uuid.v4());

    await db.devisDao.upsertDevis(DevisCompanion.insert(
      id: devIds[0], entrepriseId: 'default', clientId: cIds[0],
      dossierId: Value(dIds[0]), numero: const Value('DEV-2026-001'), annee: annee,
      statut: const Value('accepte'),
      dateEmission: now.subtract(const Duration(days: 38)),
      dateValidite: now.subtract(const Duration(days: 8)),
      objet: const Value('Expertise incendie Immeuble ABC — Honoraires'),
      montantHt: const Value(750000.0), tauxTva: const Value(18.0),
      montantTva: const Value(135000.0), montantTtc: const Value(885000.0),
      syncStatus: const Value('synced'),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[0], ordre: const Value(0),
      designation: 'Visite de terrain et constatations',
      quantite: const Value(1.0), prixUnit: const Value(250000.0), montantHt: const Value(250000.0),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[0], ordre: const Value(1),
      designation: 'Rédaction du rapport d\'expertise complet',
      quantite: const Value(1.0), prixUnit: const Value(400000.0), montantHt: const Value(400000.0),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[0], ordre: const Value(2),
      designation: 'Frais de déplacement et photos',
      quantite: const Value(1.0), prixUnit: const Value(100000.0), montantHt: const Value(100000.0),
    ));

    await db.devisDao.upsertDevis(DevisCompanion.insert(
      id: devIds[1], entrepriseId: 'default', clientId: cIds[1],
      dossierId: Value(dIds[1]), numero: const Value('DEV-2026-002'), annee: annee,
      statut: const Value('envoye'),
      dateEmission: now.subtract(const Duration(days: 8)),
      dateValidite: now.add(const Duration(days: 22)),
      objet: const Value('Expertise collision camion-citerne RN1'),
      montantHt: const Value(620000.0), tauxTva: const Value(18.0),
      montantTva: const Value(111600.0), montantTtc: const Value(731600.0),
      syncStatus: const Value('synced'),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[1], ordre: const Value(0),
      designation: 'Expertise véhicule sinistré',
      quantite: const Value(1.0), prixUnit: const Value(350000.0), montantHt: const Value(350000.0),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[1], ordre: const Value(1),
      designation: 'Rapport et contre-expertise',
      quantite: const Value(1.0), prixUnit: const Value(270000.0), montantHt: const Value(270000.0),
    ));

    await db.devisDao.upsertDevis(DevisCompanion.insert(
      id: devIds[2], entrepriseId: 'default', clientId: cIds[2],
      dossierId: Value(dIds[2]), numero: const Value('DEV-2026-003'), annee: annee,
      statut: const Value('brouillon'),
      dateEmission: now.subtract(const Duration(days: 2)),
      dateValidite: now.add(const Duration(days: 28)),
      objet: const Value('Expertise dégât des eaux — Villa Mba'),
      montantHt: const Value(280000.0), tauxTva: const Value(18.0),
      montantTva: const Value(50400.0), montantTtc: const Value(330400.0),
      syncStatus: const Value('synced'),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[2], ordre: const Value(0),
      designation: 'Inspection et rapport dégât des eaux',
      quantite: const Value(1.0), prixUnit: const Value(280000.0), montantHt: const Value(280000.0),
    ));

    await db.devisDao.upsertDevis(DevisCompanion.insert(
      id: devIds[3], entrepriseId: 'default', clientId: cIds[4],
      dossierId: Value(dIds[4]), numero: const Value('DEV-2026-004'), annee: annee,
      statut: const Value('refuse'),
      dateEmission: now.subtract(const Duration(days: 55)),
      dateValidite: now.subtract(const Duration(days: 25)),
      objet: const Value('Expertise avarie cargo — Honoraires initiaux'),
      montantHt: const Value(1200000.0), tauxTva: const Value(18.0),
      montantTva: const Value(216000.0), montantTtc: const Value(1416000.0),
      syncStatus: const Value('synced'),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[3], ordre: const Value(0),
      designation: 'Expertise cargo maritime complète',
      quantite: const Value(1.0), prixUnit: const Value(1200000.0), montantHt: const Value(1200000.0),
    ));

    // DEV-005: version négociée, acceptée, liée à DOS-005
    await db.devisDao.upsertDevis(DevisCompanion.insert(
      id: devIds[4], entrepriseId: 'default', clientId: cIds[4],
      dossierId: Value(dIds[4]), numero: const Value('DEV-2026-005'), annee: annee,
      statut: const Value('accepte'),
      dateEmission: now.subtract(const Duration(days: 50)),
      dateValidite: now.subtract(const Duration(days: 20)),
      objet: const Value('Expertise avarie cargo MV Libreville — Tarif négocié'),
      montantHt: const Value(950000.0), tauxTva: const Value(18.0),
      montantTva: const Value(171000.0), montantTtc: const Value(1121000.0),
      syncStatus: const Value('synced'),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[4], ordre: const Value(0),
      designation: 'Expertise cargo maritime — chargement marchandises',
      quantite: const Value(1.0), prixUnit: const Value(600000.0), montantHt: const Value(600000.0),
    ));
    await db.devisDao.upsertLigne(DevisLignesCompanion.insert(
      id: uuid.v4(), devisId: devIds[4], ordre: const Value(1),
      designation: 'Rapport final et attestation de perte',
      quantite: const Value(1.0), prixUnit: const Value(350000.0), montantHt: const Value(350000.0),
    ));

    // ── 6. Factures ───────────────────────────────────────────────────────
    // FAC-001: payée ← DEV-001 ← DOS-001 (cycle complet)
    // FAC-002: envoyée ← DEV-005 ← DOS-005
    // FAC-003: en_retard ← (brouillon converti en envoyée, échue)
    // FAC-004: brouillon (DOS-002, pas encore finalisée)
    final facIds = List.generate(3, (_) => uuid.v4());

    await db.facturesDao.upsertFacture(FacturesCompanion.insert(
      id: facIds[0], entrepriseId: 'default', clientId: cIds[0],
      dossierId: Value(dIds[0]), devisId: Value(devIds[0]),
      numero: const Value('FAC-2026-001'), annee: annee,
      statut: const Value('payee'),
      dateEmission: now.subtract(const Duration(days: 30)),
      dateEcheance: now.subtract(const Duration(days: 15)),
      montantHt: const Value(750000.0), tauxTva: const Value(18.0),
      montantTva: const Value(135000.0), montantTtc: const Value(885000.0),
      montantPaye: const Value(885000.0), montantRestant: const Value(0.0),
      objet: const Value('Honoraires — Expertise incendie Immeuble ABC'),
      syncStatus: const Value('synced'),
    ));
    await db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
      id: uuid.v4(), factureId: facIds[0],
      designation: 'Visite de terrain et constatations',
      quantite: const Value(1.0), prixUnit: const Value(250000.0), montantHt: const Value(250000.0),
    ));
    await db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
      id: uuid.v4(), factureId: facIds[0],
      designation: 'Rédaction du rapport d\'expertise complet',
      quantite: const Value(1.0), prixUnit: const Value(400000.0), montantHt: const Value(400000.0),
    ));
    await db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
      id: uuid.v4(), factureId: facIds[0],
      designation: 'Frais de déplacement et photos',
      quantite: const Value(1.0), prixUnit: const Value(100000.0), montantHt: const Value(100000.0),
    ));

    await db.facturesDao.upsertFacture(FacturesCompanion.insert(
      id: facIds[1], entrepriseId: 'default', clientId: cIds[4],
      dossierId: Value(dIds[4]), devisId: Value(devIds[4]),
      numero: const Value('FAC-2026-002'), annee: annee,
      statut: const Value('envoyee'),
      dateEmission: now.subtract(const Duration(days: 22)),
      dateEcheance: now.add(const Duration(days: 8)),
      montantHt: const Value(950000.0), tauxTva: const Value(18.0),
      montantTva: const Value(171000.0), montantTtc: const Value(1121000.0),
      montantPaye: const Value(0.0), montantRestant: const Value(1121000.0),
      objet: const Value('Honoraires — Avarie cargo MV Libreville'),
      syncStatus: const Value('synced'),
    ));
    await db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
      id: uuid.v4(), factureId: facIds[1],
      designation: 'Expertise cargo maritime',
      quantite: const Value(1.0), prixUnit: const Value(600000.0), montantHt: const Value(600000.0),
    ));
    await db.facturesDao.upsertLigne(FacturesLignesCompanion.insert(
      id: uuid.v4(), factureId: facIds[1],
      designation: 'Rapport final et attestation de perte',
      quantite: const Value(1.0), prixUnit: const Value(350000.0), montantHt: const Value(350000.0),
    ));

    // FAC-003: en retard (échéance dépassée, non payée)
    await db.facturesDao.upsertFacture(FacturesCompanion.insert(
      id: facIds[2], entrepriseId: 'default', clientId: cIds[1],
      dossierId: Value(dIds[1]), devisId: Value(devIds[1]),
      numero: const Value('FAC-2026-003'), annee: annee,
      statut: const Value('en_retard'),
      dateEmission: now.subtract(const Duration(days: 35)),
      dateEcheance: now.subtract(const Duration(days: 5)),
      montantHt: const Value(620000.0), tauxTva: const Value(18.0),
      montantTva: const Value(111600.0), montantTtc: const Value(731600.0),
      montantPaye: const Value(0.0), montantRestant: const Value(731600.0),
      objet: const Value('Honoraires — Expertise collision camion RN1'),
      syncStatus: const Value('synced'),
    ));

    // ── 7. Charges ────────────────────────────────────────────────────────
    // Charges opérationnelles + charges liées à des dossiers
    final chargesSalaireIds = List.generate(4, (_) => uuid.v4());

    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Loyer Bureau — Mois $mois/$annee',
      categorie: 'Loyer', montant: 450000.0,
      dateCharge: (DateTime(annee, mois, 5)),
      mois: mois, annee: annee, syncStatus: const Value('synced'),
    ));
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Électricité et eau — Mois $mois/$annee',
      categorie: 'Charges fixes', montant: 85000.0,
      dateCharge: (DateTime(annee, mois, 8)),
      mois: mois, annee: annee, syncStatus: const Value('synced'),
    ));
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Fournitures bureau et papeterie',
      categorie: 'Fournitures', montant: 32500.0,
      dateCharge: (now.subtract(const Duration(days: 10))),
      mois: mois, annee: annee, syncStatus: const Value('synced'),
    ));
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Abonnement téléphonie professionnelle',
      categorie: 'Télécommunications', montant: 45000.0,
      dateCharge: (DateTime(annee, mois, 1)),
      mois: mois, annee: annee, syncStatus: const Value('synced'),
    ));
    // Charges liées à des dossiers (traçabilité mission → charge)
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Carburant mission — Incendie Immeuble ABC (AV-2026-001)',
      categorie: 'Déplacement', montant: 28000.0,
      dateCharge: (now.subtract(const Duration(days: 42))),
      mois: mois, annee: annee, dossierId: Value(dIds[0]),
      syncStatus: const Value('synced'),
    ));
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: uuid.v4(), entrepriseId: 'default',
      libelle: 'Billet avion Port-Gentil — Collision RN1 (AV-2026-002)',
      categorie: 'Déplacement', montant: 95000.0,
      dateCharge: (now.subtract(const Duration(days: 11))),
      mois: mois, annee: annee, dossierId: Value(dIds[1]),
      syncStatus: const Value('synced'),
    ));

    // ── 8. Salaires + Charges salaires (lien RH → Comptabilité) ──────────
    // Les salaires validés génèrent automatiquement une charge comptable
    final salairesBruts = [850000.0, 350000.0, 450000.0, 500000.0];
    final salairesNets = [680000.0, 294000.0, 378000.0, 420000.0];
    final cnps = [85000.0, 35000.0, 45000.0, 50000.0];
    final irpp = [68000.0, 15000.0, 20000.0, 24000.0];

    for (var i = 0; i < pIds.length; i++) {
      await db.salairesDao.upsert(SalairesCompanion.insert(
        id: chargesSalaireIds[i],
        entrepriseId: 'default',
        personnelId: pIds[i],
        mois: mois, annee: annee,
        salaireBrut: Value(salairesBruts[i]),
        cnps: Value(cnps[i]),
        irpp: Value(irpp[i]),
        autresRetenues: const Value(0.0),
        salaireNet: salairesNets[i],
        // Les deux premiers salaires sont validés et comptabilisés
        statut: Value(i < 2 ? 'valide' : 'en_attente'),
        dateValidation: Value(i < 2 ? now.subtract(const Duration(days: 3)) : null),
        comptabilise: Value(i == 0), // Seul le 1er est comptabilisé
        syncStatus: const Value('synced'),
      ));
    }

    // Charge comptable correspondant au salaire de Christian (comptabilisé)
    final chargesSalaireId = uuid.v4();
    await db.chargesDao.upsert(ChargesCompanion.insert(
      id: chargesSalaireId, entrepriseId: 'default',
      libelle: 'Salaire net — Christian Noubissi ($mois/$annee)',
      categorie: 'Salaires', montant: salairesNets[0],
      dateCharge: (DateTime(annee, mois, 28)),
      mois: mois, annee: annee, syncStatus: const Value('synced'),
    ));
    // Mise à jour du lien salaire → charge (comptabilisé)
    await db.salairesDao.marquerComptabilise(chargesSalaireIds[0], chargesSalaireId);
  }

  // ─── Suppression de toutes les données ───────────────────────────────────

  static Future<void> deleteAll(AppDatabase db) async {
    await db.transaction(() async {
      await db.customStatement('DELETE FROM devis_lignes');
      await db.customStatement('DELETE FROM devis');
      await db.customStatement('DELETE FROM factures_lignes');
      await db.customStatement('DELETE FROM factures');
      await db.customStatement('DELETE FROM charges');
      await db.customStatement('DELETE FROM charges_modele_lines');
      await db.customStatement('DELETE FROM charges_modeles');
      await db.customStatement('DELETE FROM conges');
      await db.customStatement('DELETE FROM salaires');
      await db.customStatement('DELETE FROM personnel');
      await db.customStatement('DELETE FROM pieces_jointes');
      await db.customStatement('DELETE FROM dossiers');
      await db.customStatement('DELETE FROM clients');
      await db.customStatement('DELETE FROM taxes');
      await db.customStatement('DELETE FROM sync_queue');
    });
  }
}
