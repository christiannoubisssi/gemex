# ROADMAP.md — AvarieApp
> Plan de développement par phases · Basé sur l'état réel du code au démarrage

---

## Légende

\`\`\`
[✅] Terminé et validé          [🔄] En cours / migration requise
[⏳] À démarrer                [🔒] Bloqué (dépend d'une autre tâche)
[💡] Post-MVP (V2)             [⚠ ] Dette technique identifiée
\`\`\`

**Dépendances** : une tâche marquée \`→ dépend de [T-XX]\` ne peut pas démarrer
tant que la tâche référencée n'est pas terminée.


---

## État de départ — Inventaire du code existant

> Ce qui est déjà en place avant le premier sprint.

| Fichier / Module | État | Note |
|-----------------|------|------|
| Schéma PostgreSQL Supabase (`database/schema.sql`) | ✅ | Complet, triggers inclus |
| Thème et couleurs (`core/theme/app_theme.dart`) | ✅ | Charte maritime validée |
| Constantes (`core/constants/app_constants.dart`) | ✅ | Statuts, priorités, catégories |
| Router (`core/router/app_router.dart`) | ✅ | GoRouter + ShellRoute |
| Shell adaptatif (`core/shell/main_shell.dart`) | ✅ | Sidebar web / Drawer mobile |
| Connectivité (`core/network/connectivity_service.dart`) | ✅ | `isOnlineProvider` |
| Auth provider + Login screen | ✅ | Supabase Auth |
| Dashboard screen + widgets KPI | ✅ | Branché Supabase direct |
| Dossiers — List / Detail / Form screens | ✅ | UI présente |
| Dossier repository (`dossier_repository.dart`) | 🔄 | Branché Isar → migrer Drift |
| Sync service (`sync_service.dart`) | 🔄 | Squelette présent, Isar à retirer |
| Local DB (`local_db_service.dart`) | ⚠  | Isar — à remplacer intégralement |
| `dossier_local_model.dart` | ⚠  | Isar — à remplacer par table Drift |
| Fichiers dupliqués dans `lib/screens/` et `lib/models/` | ⚠  | Doublons à supprimer |

---

## Vue d'ensemble des phases

```
PHASE 0  ──────────────────────────────────────────  Semaines 1-2
Fondations techniques (migration Drift, nettoyage)

PHASE 1  ──────────────────────────────────────────  Semaines 3-6
MVP Core : Dossiers + Clients + Devis + Factures

PHASE 2  ──────────────────────────────────────────  Semaines 7-9
MVP Complet : Pièces jointes + Sync robuste + Paramètres

PHASE 3  ──────────────────────────────────────────  Semaines 10-13
Gestion interne : Comptabilité + RH + Paie

PHASE 4  ──────────────────────────────────────────  Semaines 14-16
Qualité & Production : PDF, Emails, Tests, Déploiement

PHASE 5  ──────────────────────────────────────────  Post-lancement
Extensions V2 : IA, Portail client, Notifications push
```

---

## PHASE 0 — Fondations techniques
### Semaines 1–2 · Pré-requis de tout le reste

> **Objectif :** Éliminer la dette technique Isar, stabiliser la structure,
> poser les fondations offline-first sur lesquelles tout le reste sera construit.
> Aucune nouvelle fonctionnalité n'est développée dans cette phase.

---

### T-01 · Migration Isar → Drift
**Durée estimée :** 3-4 jours
**Priorité :** 🔴 Critique — bloque toutes les autres tâches
**Dépend de :** rien

```
T-01a  Mettre à jour pubspec.yaml
       - Supprimer : isar, isar_flutter_libs
       - Ajouter   : drift ^2.20.0
                     drift_flutter ^0.2.1
                     sqlite3_flutter_libs ^0.5.24
                     drift_dev ^2.20.0 (dev)
                     build_runner ^2.4.11 (dev)
       → flutter pub get

T-01b  Créer database/app_database.dart
       - @DriftDatabase(tables: [...])
       - Singleton AppDatabase avec QueryExecutor adaptatif
         (NativeDatabase sur Android, WasmDatabase sur Web)
       - Chiffrement : encryptionKey depuis flutter_secure_storage

T-01c  Créer les tables Drift (database/tables/)
       - dossiers_table.dart
       - clients_table.dart
       - devis_table.dart + devis_lignes_table.dart
       - factures_table.dart + factures_lignes_table.dart
       - charges_table.dart
       - personnel_table.dart
       - salaires_table.dart
       - sync_queue_table.dart     ← file d'attente offline

T-01d  Générer le code
       → dart run build_runner build --delete-conflicting-outputs

T-01e  Créer les DAOs (database/daos/)
       - dossiers_dao.dart  (getAll, getById, upsert, markSynced, getPending)
       - clients_dao.dart
       - sync_queue_dao.dart  (enqueue, dequeue, getByEntity, markFailed)

T-01f  Adapter DossierRepository
       - Remplacer LocalDbService.db par AppDatabase.instance
       - Remplacer DossierLocalModel Isar par DossierData Drift
       - Tester create / getAll offline

T-01g  Nettoyer les fichiers Isar
       - Supprimer lib/shared/services/local_db_service.dart
       - Supprimer lib/features/*/data/models/*_local_model.dart (Isar)
       - Supprimer toute référence Isar dans le code
```

---

### T-02 · Nettoyage de la structure
**Durée estimée :** 1 jour
**Priorité :** 🔴 Critique
**Dépend de :** T-01

```
T-02a  Supprimer les doublons
       - lib/screens/   → tout déplacer dans lib/features/
       - lib/models/    → intégrer dans les features concernées
       - lib/providers/ → intégrer dans lib/features/*/presentation/providers/
       - lib/services/  → intégrer dans lib/features/*/data/repositories/

T-02b  Consolider l'arborescence
       - Vérifier que lib/ correspond à ARCHITECTURE.md §3
       - Un seul login_screen.dart, un seul dashboard_screen.dart

T-02c  Vérifier les imports
       - flutter analyze → 0 erreur, 0 warning
```

---

### T-03 · SyncService — finalisation
**Durée estimée :** 2 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-01, T-02

```
T-03a  Réécrire sync_service.dart avec Drift
       - Utiliser SyncQueueDao.getAll() au lieu de Isar
       - Implémenter _processQueue() : parcourt sync_queue, appelle Supabase
       - Stratégie last-write-wins (updated_at)

T-03b  Gestion des retries
       - Max 5 tentatives par opération
       - Backoff exponentiel : 30s, 2min, 10min, 30min, abandon
       - Si attempts >= 5 → syncStatus = conflict sur l'entité

T-03c  Remplacement des numéros temporaires
       - Après sync réussie d'un dossier créé offline :
         récupérer le numero_dossier définitif de Supabase
         mettre à jour le champ numero dans Drift

T-03d  Tests manuels
       - Créer un dossier offline → vérifier badge LOCAL
       - Rétablir connexion → vérifier sync + remplacement numéro
```

---

### T-04 · Configuration Supabase
**Durée estimée :** 0.5 jour
**Priorité :** 🔴 Critique
**Dépend de :** rien

```
T-04a  Exécuter database/schema.sql dans Supabase SQL Editor
T-04b  Configurer lib/core/config/supabase_config.dart (URL + anon key)
T-04c  Créer la première entreprise en SQL
       INSERT INTO entreprises (nom, pays, devise, tva_taux)
       VALUES ('Mon Cabinet', 'Gabon', 'XAF', 18.00);
T-04d  Créer le premier utilisateur admin (Supabase Auth + INSERT utilisateurs)
T-04e  Vérifier le RLS : l'utilisateur ne voit que ses données
```

**Critères de validation Phase 0 :**
- `flutter analyze` → 0 erreur
- L'app se lance sur Android et Chrome
- Connexion / déconnexion fonctionnelles
- Création d'un dossier offline → badge LOCAL visible
- Retour connexion → dossier synchronisé, numéro définitif affiché

---

## PHASE 1 — MVP Core
### Semaines 3–6 · Ce que le client utilise au quotidien

> **Objectif :** Les 4 modules qui génèrent directement de la valeur.
> À la fin, le cabinet gère dossiers, clients, devis et factures.

---

### T-05 · Module Clients — complet
**Durée estimée :** 3 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-01, T-02, T-03

```
T-05a  Drift — ClientsDao (getAll, getById, upsert, watchSolde)
T-05b  ClientRepository (offline-first, même pattern que DossierRepository)
T-05c  Providers Riverpod (clientsProvider, clientDetailProvider, ClientNotifier)
T-05d  Écrans UI
       - clients_list_screen.dart (liste + recherche + filtre type)
       - client_detail_screen.dart (onglets : infos / dossiers / factures)
       - client_form_screen.dart
T-05e  Intégration dans DossierForm (dropdown sélection client)
T-05f  Routes : /clients, /clients/new, /clients/:id, /clients/:id/edit
```

---

### T-06 · Module Devis — complet
**Durée estimée :** 4 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-05

```
T-06a  Drift — DevisDao + DevisLignesDao
T-06b  DevisRepository
       - create(devis, lignes) → transaction atomique Drift
       - convertirEnFacture() — pré-remplit la facture avec les lignes
       - Calcul TTC : TTC = HT + HT×tva/100 + HT×tps/100
T-06c  Providers Riverpod (devisProvider, devisDetailProvider, DevisNotifier)
T-06d  devis_form_screen.dart
       - Ajout / suppression / réordonnancement des lignes
       - Calcul HT / TVA / TPS / TTC en temps réel
       - Taux TVA pré-rempli depuis Entreprise, modifiable
T-06e  devis_detail_screen.dart
       - Aperçu lignes + totaux
       - Boutons : Aperçu PDF | Marquer accepté | Convertir en facture
T-06f  Numérotation DEV-AAAA-NNNN (online) / DEV-LOCAL-AAAA-ts (offline)
```

---

### T-07 · Module Factures — complet
**Durée estimée :** 4 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-06

```
T-07a  Drift — FacturesDao + FacturesLignesDao
T-07b  FactureRepository
       - createFromDevis(devisId) → copie les lignes
       - enregistrerPaiement(factureId, montant, date, mode)
         · Recalcule montant_restant
         · Met à jour statut : partiellement_payee ou payee
         · Met à jour solde client automatiquement
       - annuler(factureId, motif)
T-07c  Providers Riverpod (facturesProvider, facturesEnRetardProvider, FactureNotifier)
T-07d  factures_list_screen.dart (onglets : Toutes | En attente | Payées | En retard)
T-07e  facture_detail_screen.dart
       - En-tête + tableau lignes + section paiements reçus
       - Montant restant en rouge si en retard
       - Dialog enregistrement paiement (montant, date, mode, référence)
T-07f  Numérotation FAC-AAAA-NNNN (annuelle, reset 1er janvier)
```

---

### T-08 · Génération PDF (offline)
**Durée estimée :** 2 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-06, T-07

```
T-08a  PdfService — structure de base
       - En-tête : logo + infos entreprise + en-tête configurable
       - Pied de page : coordonnées bancaires + mentions légales
T-08b  Template PDF Devis
       - Tableau lignes (désignation | qté | unité | PU HT | total HT)
       - Pied tableau : sous-total HT | TVA (x%) | TPS (x%) | Total TTC
T-08c  Template PDF Facture (même structure + mention paiement si payée)
T-08d  PdfPreview widget + bouton Partager (WhatsApp, email, Drive)
T-08e  Cache local des PDFs générés (dossier temporaire)
```

---

### T-09 · Dashboard — données réelles
**Durée estimée :** 1.5 jours
**Priorité :** 🟡 Important
**Dépend de :** T-05, T-06, T-07

```
T-09a  Rebrancher dashboard_provider sur Drift (offline-first)
       - KPIs dossiers depuis DossiersDao
       - CA mois depuis FacturesDao
       - Créances (montant_restant > 0)
T-09b  Widget graphique CA 12 mois (fl_chart)
T-09c  Widget dossiers urgents (priorité haute/urgente, non clos)
T-09d  Widget factures en retard (echeance < aujourd'hui, solde > 0)
```

**Critères de validation Phase 1 :**
- Flux complet : client → dossier → devis → facture → paiement
- PDF généré correctement avec logo et en-tête
- Tout fonctionne en mode offline
- Dashboard affiche des données réelles

---

## PHASE 2 — MVP Complet
### Semaines 7–9 · Production-ready

---

### T-10 · Module Pièces jointes
**Durée estimée :** 3 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-03

```
T-10a  Drift — PiecesJointesDao
       - Champs : id, dossier_id, nom, type_fichier, chemin_local,
                  url_storage, latitude, longitude, horodatage, notes, sync_status
T-10b  PieceJointeRepository
       - addPhoto(dossierId, source: camera|galerie) → local + enqueue upload
       - Upload différé dans SyncService (Supabase Storage)
       - Mise à jour url_storage dans Drift après succès
T-10c  Écran pièces jointes
       - Grille photos + liste documents
       - FAB : Caméra | Galerie | Fichier
       - Aperçu plein écran + légende + badge "Upload en attente"
T-10d  Métadonnées auto : horodatage + GPS si permission accordée
```

---

### T-11 · Module Paramètres — Administration
**Durée estimée :** 3 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-01

```
T-11a  Écran entreprise (nom, adresse, téléphone, email, RCCM, NIF, logo)
T-11b  Écran mise en page documents
       - En-tête, pied de page, mentions légales
       - Aperçu PDF live mis à jour en temps réel
T-11c  Écran fiscalité (TVA, TPS, devise) + avertissement non-rétroactif
T-11d  Écran types de mission (CRUD configurable)
T-11e  Écran utilisateurs (liste, inviter, changer rôle, désactiver)
T-11f  Écran profil (modifier nom, téléphone, mot de passe)
```

---

### T-12 · Tests d'intégration offline/online
**Durée estimée :** 2 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-03, T-05, T-06, T-07, T-10

```
Scénario 1 : Création complète offline
  Mode avion → créer client + dossier + devis + facture
  Rétablir connexion → vérifier sync complète, badges LOCAL disparus

Scénario 2 : Conflit de modification
  Deux utilisateurs modifient le même dossier offline
  Rétablir connexion → last-write-wins, aucune perte de données

Scénario 3 : Upload pièces jointes différé
  5 photos en mode avion → rétablir → vérifier upload Supabase Storage

Scénario 4 : Perte connexion pendant sync
  Couper en milieu de sync → vérifier reprise propre, pas de doublons

Scénario 5 : Session expirée offline
  Token expiré pendant période offline → refresh automatique au retour
```

**Critères de validation Phase 2 :**
- Workflow terrain complet offline → sync automatique au retour
- Paramètres entreprise reflétés dans les PDFs générés
- Aucun crash en cas de perte de connexion

---

## PHASE 3 — Gestion interne
### Semaines 10–13 · Comptabilité, RH, Paie

---

### T-13 · Module Comptabilité — Charges & Analyses
**Durée estimée :** 3 jours
**Priorité :** 🟡 Important
**Dépend de :** T-07

```
T-13a  Drift — ChargesDao (getAll, getTotalParCategorie, getByDossier)
T-13b  ChargeRepository + provider
T-13c  charge_form_screen.dart (catégorie, libellé, montant, date, lien dossier, justificatif)
T-13d  comptabilite_screen.dart
       - Sélecteur période (mois / trimestre / année)
       - Tableau : CA HT | CA TTC | Total charges | Résultat brut
       - Graphique CA mensuel 12 mois (fl_chart)
       - Répartition charges par catégorie
T-13e  Export CSV (date, catégorie, libellé, montant, TVA)
T-13f  Comptabilisation auto des salaires payés
       - Trigger : salaire statut → paye → créer charge catégorie salaires
       - Lien charge ↔ salaire dans la DB
```

---

### T-14 · Module RH — Personnel & Congés
**Durée estimée :** 2.5 jours
**Priorité :** 🟡 Important
**Dépend de :** T-01, T-11

```
T-14a  Drift — PersonnelDao + CongesDao
T-14b  PersonnelRepository
T-14c  personnel_list_screen.dart (filtre actif / archivé)
T-14d  personnel_detail_screen.dart (contrat + historique congés + historique salaires)
T-14e  personnel_form_screen.dart
T-14f  conges_screen.dart
       - Vue calendrier mensuel (tous employés)
       - Saisir absence : type, employé, dates
       - Types : congé annuel, maladie, sans solde, formation
       - Validation par admin
```

---

### T-15 · Module Paie — Saisie et validation
**Durée estimée :** 3 jours
**Priorité :** 🟡 Important
**Dépend de :** T-13, T-14

```
T-15a  Drift — SalairesDao (getByMoisAnnee, getTotalMasseSalariale)
T-15b  SalaireRepository
       - initierMois(mois, annee) → crée lignes pour chaque employé actif
       - validerSelection(ids) → en_attente → valide
       - marquerPayes(ids, date, mode) → valide → paye
         · Déclenche comptabilisation automatique (T-13f)
       - Contrainte unique (personnel_id, mois, annee)
T-15c  paie_screen.dart
       - Sélecteur mois/année
       - Liste employés : brut, CNPS, IRPP, retenues, net
       - Statut par ligne + multi-sélection
       - "Valider sélection" et "Marquer comme payé"
       - Dialog confirmation avec total masse salariale nette
T-15d  Validation irréversible (une fois payé, aucune modif possible)
T-15e  Export PDF fiche de paie par employé/mois
```

**Critères de validation Phase 3 :**
- Charges du mois visibles dans les analyses immédiatement après saisie
- Salaires payés → charges créées automatiquement → visibles en comptabilité
- Export CSV lisible par un cabinet comptable externe

---

## PHASE 4 — Qualité & Production
### Semaines 14–16 · Déploiement réel

---

### T-16 · Envoi d'emails
**Durée estimée :** 2 jours
**Priorité :** 🟡 Important
**Dépend de :** T-08, T-11

```
T-16a  Supabase Edge Function : send-email
       - Input : { to, subject, body, attachmentBase64, attachmentName }
       - Appelle Resend API → retourne { success, messageId }
T-16b  EmailService Flutter (appelle Edge Function, charge PDF en base64)
T-16c  Envoi depuis devis_detail_screen
       - Pré-remplit destinataire (email client), objet, message
       - Statut devis → "envoyé" après succès
T-16d  Envoi depuis facture_detail_screen (même logique)
T-16e  Log des envois (horodatage + destinataire sur le dossier)
```

---

### T-17 · Tests automatisés
**Durée estimée :** 2.5 jours
**Priorité :** 🟡 Important
**Dépend de :** T-07, T-08, T-15

```
Tests unitaires — Repositories
  - DossierRepository : create offline, create online, sync
  - FactureRepository : calcul TTC, enregistrement paiement

Tests unitaires — Calculs fiscaux
  - TVA 18% + TPS 0% : TTC = HT × 1.18
  - Vérification arrondi 2 décimales DB, 0 décimales affichage XAF

Tests widget — Écrans critiques
  - DossierFormScreen : validation formulaire
  - PaieScreen : sélection multiple, boutons désactivés si rien sélectionné

Tests intégration — Flux complets
  - Flux client → dossier → devis → facture → paiement
  - Flux paie : saisie → validation → comptabilisation automatique
```

---

### T-18 · Build et déploiement
**Durée estimée :** 1.5 jours
**Priorité :** 🔴 Critique
**Dépend de :** T-17

```
T-18a  Android production
       - minSdkVersion 21, targetSdkVersion 34
       - Keystore de signature (générer + conserver)
       - flutter build apk --release --split-per-abi

T-18b  Flutter Web production
       - flutter build web --release --pwa-strategy offline-first
       - web/manifest.json : nom, couleurs, icônes

T-18c  Déploiement Vercel
       - Connecter repo GitHub à Vercel
       - Build : flutter build web --release | Output : build/web
       - Domaine custom (app.votrecabinet.ga ou .com)

T-18d  GitHub Actions — CI/CD
       - Workflow build.yml : flutter pub get → analyze → test → build → deploy
       - Secrets : SUPABASE_URL, SUPABASE_ANON_KEY
```

---

### T-19 · Sécurité & chiffrement
**Durée estimée :** 1 jour
**Priorité :** 🔴 Critique
**Dépend de :** T-01

```
T-19a  Chiffrement Drift : clé AES-256 stockée dans flutter_secure_storage
T-19b  Timeout session configurable (défaut 30 min d'inactivité)
T-19c  Audit trail : table audit_log (user_id, entity, action, timestamp)
T-19d  Revue RLS Supabase : tester isolation inter-entreprises
```

**Critères de validation Phase 4 :**
- APK signé installable sur Android réel
- Web accessible depuis l'URL de production
- Emails envoyés (devis + factures + pièce jointe PDF)
- Tests : couverture > 60% sur la logique métier
- Chiffrement Drift actif

---

## PHASE 5 — Extensions V2
### Post-lancement · Selon retours terrain

| ID | Fonctionnalité | Effort | Dépend de |
|----|---------------|--------|-----------|
| T-20 | **Notifications push** FCM : paiement reçu, deadline, sync | 2j | T-18 |
| T-21 | **Relances auto** email J+0 et J+7 après échéance | 2j | T-16 |
| T-22 | **Rapport expertise IA** (Claude API Haiku) depuis les données du dossier | 3j | T-10 |
| T-23 | **Portail client** web lecture seule (dossier + factures) | 5j | T-18 |
| T-24 | **Checklist terrain** : formulaire offline structuré + photos géolocalisées | 3j | T-10 |
| T-25 | **Honoraires auto** : barème % sinistre configurable par type de mission | 2j | T-06 |
| T-26 | **Multi-devise** : affichage EUR / USD en parallèle XAF | 2j | T-07 |
| T-27 | **Multi-cabinet UI** : changer de cabinet sans se déconnecter | 4j | T-11 |
| T-28 | **Export FEC** (Fichier d'Écriture Comptable) pour cabinet externe | 3j | T-13 |
| T-29 | **Application iOS** : provisioning profile + TestFlight | 2j | T-18 |

---

## Tableau de dépendances

```
T-04 ──────────────────────────────────────────────────────────────► T-12
T-01 ──► T-02 ──► T-03 ──► T-05 ──► T-06 ──► T-07 ──► T-08 ──► T-16
                  │         │                   │         │
                  │         │                   └──► T-09 │
                  │         └──────────────────────────── ► T-09
                  │
                  ├──► T-10 ──────────────────────────────────────► T-12
                  └──► T-11 ──► T-14 ──► T-15 ──► T-13
                                                   │
                                          T-07 ────┘
                                                   │
T-07 + T-08 + T-15 ──────────────────────────────► T-17 ──► T-18 ──► T-19
```

**Chemin critique (sans marge) :**
```
T-04 → T-01 → T-02 → T-03 → T-05 → T-06 → T-07 → T-08 → T-16 → T-17 → T-18
```

---

## Calendrier synthétique

| Semaine | Phase | Tâches | Livrable attendu |
|---------|-------|--------|-----------------|
| S1 | 0 | T-04, T-01a→T-01e | Drift installé, tables générées |
| S2 | 0 | T-01f→T-01g, T-02, T-03 | Migration Isar→Drift complète |
| S3 | 1 | T-05 | Module Clients |
| S4 | 1 | T-06 | Module Devis |
| S5 | 1 | T-07 | Module Factures |
| S6 | 1 | T-08, T-09 | PDF offline + Dashboard réel |
| S7 | 2 | T-10 | Pièces jointes + photos terrain |
| S8 | 2 | T-11 | Paramètres + administration |
| S9 | 2 | T-12 | Tests offline/online + stabilisation |
| S10 | 3 | T-13 | Module Comptabilité |
| S11 | 3 | T-14 | Module RH |
| S12-13 | 3 | T-15 | Module Paie + comptabilisation auto |
| S14 | 4 | T-16, T-19 | Emails + sécurité |
| S15 | 4 | T-17 | Tests automatisés |
| S16 | 4 | **T-18** | **🚀 Déploiement production** |
| S17+ | 5 | T-20→T-29 | Extensions selon retours terrain |

---

## Commandes de référence

```bash
# Phase 0 : setup Drift
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze                        # doit retourner 0 erreur

# Développement quotidien
dart run build_runner watch            # regénère code Drift à chaque modif
flutter run -d chrome                  # web
flutter run                            # Android

# Avant chaque commit
flutter analyze && flutter test
flutter build web --release            # vérifier que le build passe

# Build production
flutter build apk --release --split-per-abi
flutter build web --release --pwa-strategy offline-first
```

---

*ROADMAP.md — mis à jour à chaque fin de phase*
