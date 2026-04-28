# ARCHITECTURE.md — AvarieApp
> Référence technique de l'architecture · À lire avant de modifier la structure du projet

---

## Table des matières

1. [Pattern architectural](#1-pattern-architectural)
2. [Diagramme des couches](#2-diagramme-des-couches)
3. [Arborescence complète des dossiers](#3-arborescence-complète-des-dossiers)
4. [Détail de chaque couche](#4-détail-de-chaque-couche)
5. [Architecture offline-first](#5-architecture-offline-first)
6. [Flux de données — exemples concrets](#6-flux-de-données--exemples-concrets)
7. [Packages Flutter — liste complète et justifications](#7-packages-flutter--liste-complète-et-justifications)
8. [Conventions et règles strictes](#8-conventions-et-règles-strictes)
9. [État d'avancement de la migration](#9-état-davancement-de-la-migration)

---

## 1. Pattern architectural

### Choix : Feature-first + Repository Pattern + Riverpod

AvarieApp combine trois approches complémentaires :

```
┌─────────────────────────────────────────────────────────────┐
│  FEATURE-FIRST ORGANIZATION                                  │
│  Le code est organisé par fonctionnalité métier,            │
│  pas par type technique.                                     │
│  → lib/features/dossiers/  lib/features/clients/  etc.      │
├─────────────────────────────────────────────────────────────┤
│  REPOSITORY PATTERN (couche d'abstraction données)           │
│  Chaque feature possède un Repository qui orchestre          │
│  la lecture/écriture entre Drift (local) et Supabase.       │
│  → L'UI ne sait pas d'où viennent les données               │
├─────────────────────────────────────────────────────────────┤
│  RIVERPOD (state management)                                 │
│  Les Providers exposent les données à l'UI.                  │
│  Les Notifiers gèrent les mutations.                         │
│  → Pas de setState(), pas de BuildContext dans la logique    │
└─────────────────────────────────────────────────────────────┘
```

### Pourquoi pas Clean Architecture ?

Clean Architecture (avec les couches domain/data/presentation strictes) aurait été trop
verbeux pour une équipe réduite. Elle nécessite des interfaces (abstract classes),
des use cases séparés, et des mappers entre chaque couche.

Le pattern retenu offre **80% des bénéfices pour 30% de la complexité** :

| Critère | Clean Architecture | Notre pattern |
|---------|-------------------|---------------|
| Séparation UI / logique | ✅ | ✅ |
| Testabilité | ✅✅ | ✅ |
| Lisibilité pour un junior | ❌ | ✅ |
| Volume de fichiers | Très élevé | Modéré |
| Adapté à une petite équipe | ❌ | ✅ |

### Pourquoi pas BLoC ?

BLoC est excellent pour des équipes qui veulent un historique d'événements strict et
des tests exhaustifs. La courbe d'apprentissage et le boilerplate sont significatifs.
Riverpod couvre tous nos besoins avec moins de cérémonie.

---

## 2. Diagramme des couches

```
╔══════════════════════════════════════════════════════════════════╗
║                     PRESENTATION LAYER                          ║
║                                                                  ║
║   Screens          Widgets           Shell                       ║
║  ┌──────────┐    ┌─────────────┐   ┌────────────────┐           ║
║  │ List     │    │ StatusBadge │   │ MainShell      │           ║
║  │ Detail   │    │ KpiCard     │   │ (Sidebar +     │           ║
║  │ Form     │    │ OfflineBann.│   │  AppBar adapt.)│           ║
║  └────┬─────┘    └──────┬──────┘   └────────────────┘           ║
║       │                 │                                        ║
║       └────────┬────────┘                                        ║
║                ▼                                                  ║
║         ConsumerWidget / ref.watch()                             ║
╠══════════════════════════════════════════════════════════════════╣
║                     PROVIDER LAYER (Riverpod)                    ║
║                                                                  ║
║   FutureProvider          StateNotifier / AsyncNotifier          ║
║  ┌────────────────┐      ┌──────────────────────────┐           ║
║  │ dossiersProvider│      │ DossierNotifier          │           ║
║  │ clientsProvider │      │ .create()                │           ║
║  │ dashboardProvider│     │ .update()                │           ║
║  │ facturesProvider│      │ .changerStatut()         │           ║
║  └────────┬───────┘      └────────────┬─────────────┘           ║
║           │                           │                          ║
║           └──────────────┬────────────┘                          ║
║                          ▼                                        ║
║              Repository (par feature)                            ║
╠══════════════════════════════════════════════════════════════════╣
║                     REPOSITORY LAYER                             ║
║                                                                  ║
║  ┌─────────────────────────────────────────────────────────┐    ║
║  │  DossierRepository                                       │    ║
║  │                                                          │    ║
║  │  getAll()   → lit depuis Drift (toujours)               │    ║
║  │  getById()  → Drift d'abord, fallback Supabase          │    ║
║  │  create()   → écrit Drift, enqueue sync Supabase        │    ║
║  │  update()   → écrit Drift, enqueue sync Supabase        │    ║
║  │  delete()   → soft-delete Drift, enqueue sync           │    ║
║  └──────┬─────────────────────────────┬────────────────────┘    ║
║         │                             │                          ║
║         ▼                             ▼                          ║
╠═══════════════╦══════════════════════════════════════════════════╣
║  LOCAL LAYER  ║           REMOTE LAYER                          ║
║  (Drift/SQLite)║          (Supabase)                            ║
║               ║                                                  ║
║  ┌──────────┐ ║   ┌──────────┐  ┌──────────┐  ┌────────────┐  ║
║  │  Tables  │ ║   │ PostgREST│  │  Auth    │  │  Storage   │  ║
║  │  (DAOs)  │ ║   │  (REST)  │  │  (JWT)   │  │  (S3)      │  ║
║  │          │ ║   │          │  │          │  │            │  ║
║  │ Dossiers │ ║   │ dossiers │  │auth.users│  │  fichiers/ │  ║
║  │ Clients  │◄╬──►│ clients  │  │utilisateurs│ │  photos/   │  ║
║  │ Factures │ ║   │ factures │  │          │  │            │  ║
║  │ Charges  │ ║   │ charges  │  └──────────┘  └────────────┘  ║
║  │ Personnel│ ║   │ personnel│                                  ║
║  └──────────┘ ║   └──────────┘                                  ║
║               ║                                                  ║
║   sync_queue  ║        ▲  SyncService                           ║
║   (pending    ║────────┘  (toutes les 30s si online)            ║
║    operations)║                                                  ║
╚═══════════════╩══════════════════════════════════════════════════╝
```

### Règle d'or du flux de données

```
           LECTURE                          ÉCRITURE
              │                                │
              ▼                                ▼
        Drift (local)                    Drift (local)
              │                          sync_status = pending
              │ (toujours)                     │
              ▼                                ▼
           UI affiche               SyncService (background)
         immédiatement                         │
                                    si online → Supabase
                                    si ok    → sync_status = synced
                                    si erreur→ retry queue
```

**L'UI ne parle JAMAIS directement à Supabase.** Tout passe par le Repository.

---

## 3. Arborescence complète des dossiers

```
avarie_app/
│
├── CLAUDE.md                          ← Lu par Claude Code en premier
├── ARCHITECTURE.md                    ← Ce fichier
├── PROJECT_SPEC.md                    ← Spécifications fonctionnelles
├── README.md                          ← Guide d'installation
│
├── pubspec.yaml                       ← Dépendances
├── pubspec.lock
├── analysis_options.yaml              ← Règles lint
│
├── android/                           ← Config Android (ne pas modifier manuellement)
│   └── app/
│       └── build.gradle               ← minSdkVersion 21
│
├── web/                               ← Config Flutter Web
│   ├── index.html
│   └── manifest.json
│
├── assets/
│   ├── images/
│   │   └── logo.png                   ← Logo du cabinet (fourni par le client)
│   └── fonts/                         ← (vide pour l'instant)
│
├── database/
│   └── schema.sql                     ← Schéma PostgreSQL Supabase (source de vérité)
│
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql     ← Migration initiale
│
├── test/
│   ├── unit/
│   │   ├── repositories/
│   │   └── providers/
│   └── widget/
│       └── screens/
│
└── lib/
    │
    ├── main.dart                      ← Point d'entrée
    │                                    Init : Supabase, Drift, SyncService
    │
    ├── app.dart                       ← MaterialApp.router + theme
    │
    ├── core/                          ← Code transverse (aucune logique métier)
    │   │
    │   ├── config/
    │   │   └── supabase_config.dart   ← URL + anon key (⚠ ne pas commiter)
    │   │
    │   ├── theme/
    │   │   ├── app_theme.dart         ← ThemeData complet
    │   │   ├── app_colors.dart        ← Palette (navy, teal, accent, etc.)
    │   │   └── app_text_styles.dart   ← TextStyle nommés
    │   │
    │   ├── constants/
    │   │   └── app_constants.dart     ← Statuts, priorités, listes métier
    │   │
    │   ├── router/
    │   │   └── app_router.dart        ← GoRouter avec ShellRoute
    │   │
    │   ├── shell/
    │   │   └── main_shell.dart        ← Layout adaptatif (sidebar web / drawer mobile)
    │   │
    │   ├── network/
    │   │   └── connectivity_service.dart ← Stream online/offline
    │   │
    │   └── utils/
    │       ├── format_utils.dart      ← Dates, montants FCFA
    │       ├── pdf_utils.dart         ← Helpers génération PDF
    │       └── validators.dart        ← Règles de validation formulaires
    │
    ├── database/                      ← Couche Drift (base locale SQLite)
    │   │
    │   ├── app_database.dart          ← @DriftDatabase, AppDatabase singleton
    │   ├── app_database.g.dart        ← Généré par build_runner (ne pas éditer)
    │   │
    │   ├── tables/                    ← Définition des tables (schéma Drift)
    │   │   ├── dossiers_table.dart
    │   │   ├── clients_table.dart
    │   │   ├── devis_table.dart
    │   │   ├── devis_lignes_table.dart
    │   │   ├── factures_table.dart
    │   │   ├── factures_lignes_table.dart
    │   │   ├── charges_table.dart
    │   │   ├── personnel_table.dart
    │   │   ├── salaires_table.dart
    │   │   └── sync_queue_table.dart  ← File d'attente des opérations offline
    │   │
    │   └── daos/                      ← Data Access Objects (une par entité)
    │       ├── dossiers_dao.dart
    │       ├── clients_dao.dart
    │       ├── devis_dao.dart
    │       ├── factures_dao.dart
    │       ├── charges_dao.dart
    │       ├── personnel_dao.dart
    │       ├── salaires_dao.dart
    │       └── sync_queue_dao.dart
    │
    ├── shared/                        ← Services partagés entre features
    │   └── services/
    │       ├── sync_service.dart      ← Orchestration sync Drift ↔ Supabase
    │       ├── pdf_service.dart       ← Génération PDF devis/factures
    │       └── email_service.dart     ← Envoi via Supabase Edge Functions
    │
    └── features/                      ← Fonctionnalités métier (une par domaine)
        │
        ├── auth/
        │   ├── data/
        │   │   ├── auth_provider.dart         ← currentUserProvider, AuthNotifier
        │   │   └── models/
        │   │       └── user_local_model.dart  ← Profil utilisateur en cache local
        │   └── presentation/
        │       └── screens/
        │           ├── login_screen.dart
        │           └── reset_password_screen.dart
        │
        ├── dashboard/
        │   ├── data/
        │   │   └── dashboard_provider.dart    ← KPIs, statistiques
        │   └── presentation/
        │       ├── screens/
        │       │   └── dashboard_screen.dart
        │       └── widgets/
        │           ├── kpi_card.dart
        │           ├── activity_chart_widget.dart
        │           └── recent_dossiers_widget.dart
        │
        ├── dossiers/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   └── dossier_repository.dart    ← Orchestre Drift + Supabase
        │   │   └── models/
        │   │       └── dossier_local_model.dart   ← Entité Drift locale
        │   └── presentation/
        │       ├── providers/
        │       │   └── dossier_provider.dart      ← dossiersProvider, DossierNotifier
        │       ├── screens/
        │       │   ├── dossiers_list_screen.dart
        │       │   ├── dossier_detail_screen.dart
        │       │   └── dossier_form_screen.dart
        │       └── widgets/
        │           ├── dossier_card.dart
        │           ├── status_badge.dart
        │           ├── priorite_badge.dart
        │           └── workflow_button.dart
        │
        ├── clients/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   └── client_repository.dart
        │   │   └── models/
        │   │       └── client_local_model.dart
        │   └── presentation/
        │       ├── providers/
        │       │   └── client_provider.dart
        │       └── screens/
        │           ├── clients_list_screen.dart
        │           ├── client_detail_screen.dart
        │           └── client_form_screen.dart
        │
        ├── devis/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   └── devis_repository.dart
        │   │   └── models/
        │   │       └── devis_local_model.dart
        │   └── presentation/
        │       ├── providers/
        │       │   └── devis_provider.dart
        │       └── screens/
        │           ├── devis_list_screen.dart
        │           ├── devis_form_screen.dart
        │           └── devis_detail_screen.dart
        │
        ├── factures/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   └── facture_repository.dart
        │   │   └── models/
        │   │       └── facture_local_model.dart
        │   └── presentation/
        │       ├── providers/
        │       │   └── facture_provider.dart
        │       └── screens/
        │           ├── factures_list_screen.dart
        │           └── facture_detail_screen.dart
        │
        ├── comptabilite/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   └── charge_repository.dart
        │   │   └── models/
        │   │       └── charge_local_model.dart
        │   └── presentation/
        │       ├── providers/
        │       │   └── comptabilite_provider.dart
        │       └── screens/
        │           ├── comptabilite_screen.dart     ← Analyses + KPIs
        │           ├── charges_list_screen.dart
        │           └── charge_form_screen.dart
        │
        ├── rh/
        │   ├── data/
        │   │   ├── repositories/
        │   │   │   ├── personnel_repository.dart
        │   │   │   └── salaire_repository.dart
        │   │   └── models/
        │   │       ├── personnel_local_model.dart
        │   │       └── salaire_local_model.dart
        │   └── presentation/
        │       ├── providers/
        │       │   └── rh_provider.dart
        │       └── screens/
        │           ├── rh_dashboard_screen.dart
        │           ├── personnel_list_screen.dart
        │           ├── personnel_form_screen.dart
        │           ├── conges_screen.dart
        │           └── paie_screen.dart             ← Validation par lot
        │
        └── parametres/
            ├── data/
            │   └── repositories/
            │       └── parametres_repository.dart
            └── presentation/
                ├── providers/
                │   └── parametres_provider.dart
                └── screens/
                    ├── parametres_screen.dart       ← Hub paramètres
                    ├── entreprise_screen.dart
                    ├── documents_screen.dart        ← Logo + en-tête + pied de page
                    ├── fiscalite_screen.dart        ← TVA, TPS, devise
                    ├── types_mission_screen.dart
                    └── utilisateurs_screen.dart
```

---

## 4. Détail de chaque couche

### 4.1 `core/` — Infrastructure transverse

Contient **uniquement** du code sans logique métier, utilisable par n'importe quelle feature.

```
Règle : aucun fichier dans core/ ne doit importer depuis features/
```

| Fichier | Rôle |
|---------|------|
| `supabase_config.dart` | Constantes de connexion (URL, anon key) |
| `app_theme.dart` | ThemeData Material 3, couleurs, typographie |
| `app_constants.dart` | Listes de valeurs métier (statuts, priorités, catégories) |
| `app_router.dart` | Toutes les routes GoRouter + ShellRoute + guards auth |
| `main_shell.dart` | Layout responsive (sidebar fixe sur web ≥ 1024px, drawer sur mobile) |
| `connectivity_service.dart` | `isOnlineProvider` : stream bool de connectivité |
| `format_utils.dart` | `formatFcfa()`, `formatDate()`, `formatDateCourte()` |

### 4.2 `database/` — Couche locale Drift

La base de données SQLite locale. **Toute la persistence offline passe par ici.**

```
Règle : les DAOs retournent des objets du domaine (Map ou classes simples),
        jamais des types Drift bruts vers l'extérieur de la couche database/
```

**Structure d'un DAO type :**
```dart
// database/daos/dossiers_dao.dart
@DriftAccessor(tables: [Dossiers, SyncQueue])
class DossiersDao extends DatabaseAccessor<AppDatabase> {

  // Lecture — toujours depuis Drift
  Future<List<DossierData>> getAll({String? statut}) { ... }
  Future<DossierData?> getById(String id) { ... }
  Stream<List<DossierData>> watchAll() { ... }    // Stream réactif

  // Écriture — met à jour sync_status = pending
  Future<void> upsert(DossierCompanion d) { ... }
  Future<void> markSynced(String id) { ... }

  // Sync queue
  Future<List<DossierData>> getPending() { ... }  // Éléments à synchroniser
}
```

**Table `sync_queue` — file d'attente offline :**
```
sync_queue
├── id           INTEGER PK autoincrement
├── entity_type  TEXT  (dossier | client | facture | ...)
├── entity_id    TEXT  (UUID de l'entité)
├── operation    TEXT  (create | update | delete)
├── payload      TEXT  (JSON de la donnée à envoyer)
├── attempts     INTEGER (nb de tentatives, max 5)
├── created_at   TIMESTAMP
└── last_attempt TIMESTAMP nullable
```

### 4.3 `shared/services/` — Services partagés

Services utilisés par plusieurs features. **Ne contiennent pas de logique UI.**

| Service | Responsabilité |
|---------|---------------|
| `SyncService` | Écoute la connectivité, dépile la `sync_queue`, gère les retries |
| `PdfService` | Génère les PDF devis/factures en local (package `pdf`) |
| `EmailService` | Appelle Supabase Edge Function qui appelle Resend API |

**`SyncService` — algorithme :**
```
1. S'abonne à Connectivity().onConnectivityChanged
2. Au retour online :
   a. Récupère tous les éléments de sync_queue (attempts < 5)
   b. Pour chaque élément, tente l'opération Supabase correspondante
   c. Si succès : supprime de sync_queue + marque synced dans la table locale
   d. Si échec  : incrémente attempts, programme retry exponentiel
3. Timer toutes les 30s : retente les échecs précédents
4. Expose syncStatusProvider (idle | syncing | error | offline)
```

### 4.4 `features/[name]/data/` — Repositories

Chaque feature possède un Repository qui est **la seule classe à connaître
à la fois Drift et Supabase**. Il implémente la stratégie offline-first.

**Pattern Repository :**
```dart
class DossierRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  // LECTURE — toujours Drift en premier
  Future<List<Dossier>> getAll({String? statut, String? search}) async {
    return _db.dossiersDao.getAll(statut: statut, search: search);
    // Note : pas de fallback Supabase en lecture
    // Les données Supabase arrivent via la sync, pas à la demande
  }

  // ÉCRITURE — Drift d'abord, Supabase si online
  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();

    // 1. Écriture locale immédiate
    await _db.dossiersDao.upsert(DossierCompanion(
      id: Value(id),
      syncStatus: const Value('pending'),
      ...
    ));

    // 2. Écriture distante si connecté
    if (_ref.read(isOnlineProvider)) {
      await _syncToSupabase(id, data, operation: 'create');
    } else {
      // 3. Sinon : enqueue pour plus tard
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: 'create',
        payload: jsonEncode(data),
      );
    }

    return id;
  }
}
```

### 4.5 `features/[name]/presentation/` — UI

**Règle absolue :** les Screens et Widgets **ne font qu'afficher et réagir**.
Toute logique est dans les Providers ou Repositories.

```dart
// ✅ Correct
class DossierListScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dossiersProvider);
    return async.when(
      data:    (list) => DossierListView(list),
      loading: () => const LoadingIndicator(),
      error:   (e, _) => ErrorView(error: e),
    );
  }
}

// ❌ Interdit : logique dans le build
class DossierListScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client; // NON
    final data = supabase.from('dossiers').select(); // NON
    ...
  }
}
```

---

## 5. Architecture offline-first

### Principe de stockage local

```
Chaque entité métier a DEUX représentations :
┌─────────────────────────────────────────────────┐
│ 1. Table Drift locale (SQLite sur l'appareil)   │
│    → Toujours disponible, même sans internet    │
│    → Source de vérité pour l'UI                  │
├─────────────────────────────────────────────────┤
│ 2. Table PostgreSQL Supabase (cloud)             │
│    → Source de vérité pour la persistence long  │
│    → Synchronisée de manière asynchrone         │
└─────────────────────────────────────────────────┘
```

### Champ `sync_status` — cycle de vie

```
                  ┌─────────────────┐
    création  ───►│    pending      │
    / modif        └────────┬────────┘
                            │
                   SyncService tente
                   l'envoi à Supabase
                            │
              ┌─────────────┴──────────────┐
              │ succès                     │ échec
              ▼                            ▼
       ┌─────────────┐            ┌──────────────────┐
       │   synced    │            │  pending (retry)  │
       └─────────────┘            │  attempts += 1    │
                                  └──────────┬─────────┘
                                             │ attempts >= 5
                                             ▼
                                     ┌──────────────┐
                                     │   conflict   │  ← Intervention manuelle
                                     └──────────────┘
```

### Numéros de documents en mode offline

```
Mode online  → numéro généré par trigger PostgreSQL côté Supabase
               Exemple : AV-2025-0042

Mode offline → numéro temporaire généré localement
               Exemple : AV-LOCAL-2025-1748263847
               Affiché avec un badge orange "LOCAL"

À la sync   → le numéro temporaire est remplacé par le numéro
               définitif Supabase dans la table Drift locale
               Le badge disparaît
```

### Pièces jointes (upload différé)

```
1. Photo prise / fichier sélectionné
2. Sauvegardé dans le dossier documents de l'appareil
3. Chemin local stocké dans Drift (table pieces_jointes)
4. Affiché immédiatement dans l'UI (depuis le fichier local)
5. Au retour online → upload vers Supabase Storage
6. URL Storage remplace le chemin local dans Drift
7. Fichier local supprimé (ou gardé en cache selon préférence)
```

---

## 6. Flux de données — exemples concrets

### Cas 1 : Afficher la liste des dossiers

```
DossiersListScreen
  │ ref.watch(dossiersProvider)
  ▼
dossiersProvider (FutureProvider)
  │ DossierRepository.getAll(statut: ...)
  ▼
DossierRepository
  │ _db.dossiersDao.getAll()
  ▼
DossiersDao (Drift)
  │ SELECT * FROM dossiers WHERE ... ORDER BY created_at DESC
  ▼
SQLite local → List<DossierData>
  ▼
DossierRepository → List<Dossier> (objet domaine)
  ▼
dossiersProvider → AsyncData<List<Dossier>>
  ▼
DossiersListScreen → affiche les cartes
```

→ **0 appel réseau** en lecture normale. Les données Supabase
  arrivent via la sync background, pas à la demande de l'UI.

### Cas 2 : Créer un dossier offline

```
DossierFormScreen
  │ ref.read(dossierNotifierProvider.notifier).create(data)
  ▼
DossierNotifier (AsyncNotifier)
  │ await _repository.create(data)
  ▼
DossierRepository.create()
  │
  ├─ [TOUJOURS] Drift: upsert(syncStatus: pending)
  │
  ├─ [SI ONLINE] Supabase: from('dossiers').insert()
  │   └─ succès → Drift: update(syncStatus: synced)
  │   └─ erreur → sync_queue: enqueue(create, payload)
  │
  └─ [SI OFFLINE] sync_queue: enqueue(create, payload)
  ▼
DossierNotifier → ref.invalidate(dossiersProvider)
  ▼
dossiersProvider se reconstruit → UI se met à jour
```

### Cas 3 : Retour online après période offline

```
ConnectivityService détecte online
  │
  ▼
SyncService.start()
  │ sync_queue: getPending() → [op1, op2, op3 ...]
  ▼
Pour chaque opération dans la queue :
  │
  ├─ create → Supabase.from(table).insert(payload)
  ├─ update → Supabase.from(table).update(payload).eq('id', id)
  └─ delete → Supabase.from(table).update({deleted_at: now}).eq('id', id)
  │
  ├─ Succès → sync_queue.delete(op.id)
  │            Drift.update(entity.syncStatus = synced)
  │            Si dossier : remplacer numéro LOCAL par numéro définitif
  │
  └─ Échec  → sync_queue.update(op.attempts += 1)
               Si attempts >= 5 → Drift.update(entity.syncStatus = conflict)
  ▼
ref.invalidate(dossiersProvider) → UI se rafraîchit
```

---

## 7. Packages Flutter — liste complète et justifications

### 7.1 Backend & synchronisation

| Package | Version | Justification |
|---------|---------|---------------|
| `supabase_flutter` | ^2.5.0 | SDK officiel Supabase. Auth, PostgREST, Storage, Realtime. Remplace un backend custom entier. SDK Flutter natif et maintenu activement. |

### 7.2 State management

| Package | Version | Justification |
|---------|---------|---------------|
| `flutter_riverpod` | ^2.5.1 | **Choix principal.** Typé, compile-safe, pas de BuildContext dans la logique. `FutureProvider.autoDispose` gère la mémoire automatiquement. Plus simple que BLoC, plus puissant que Provider simple. |
| `riverpod_annotation` | ^2.3.5 | Génération de code Riverpod via `@riverpod`. Réduit le boilerplate des providers. **Optionnel si l'équipe préfère écrire les providers manuellement.** |

### 7.3 Base de données locale (offline-first)

| Package | Version | Justification |
|---------|---------|---------------|
| `drift` | ^2.20.0 | **Décision actée (remplace Isar).** ORM SQLite typé pour Flutter. Génère des classes Dart depuis les définitions de tables. Requêtes complexes en SQL pur si besoin. Maintenu activement (pub.dev : 99% like). |
| `drift_flutter` | ^0.2.1 | Intégration native Flutter pour Drift (remplace `moor_flutter`). |
| `sqlite3_flutter_libs` | ^0.5.24 | Binaires SQLite natifs pour Android et Web. Requis par Drift. |
| `path` | ^1.9.0 | Gestion des chemins de fichiers pour localiser la DB SQLite. |
| `path_provider` | ^2.1.3 | Accès au dossier documents de l'appareil (où stocker la DB). |

> **Note sur la migration :** Le code actuel utilise encore Isar (voir `local_db_service.dart`).
> La migration vers Drift est la prochaine étape technique prioritaire.
> Voir section 9 pour le plan de migration.

### 7.4 Navigation

| Package | Version | Justification |
|---------|---------|---------------|
| `go_router` | ^14.0.2 | Router déclaratif officiel recommandé par l'équipe Flutter. Gère les deep links, le web (URL dans la barre d'adresse), et les `ShellRoute` (layout persistant). Remplace Navigator 2.0 brut qui est très verbeux. |

### 7.5 Génération PDF (offline)

| Package | Version | Justification |
|---------|---------|---------------|
| `pdf` | ^3.11.1 | Génération de PDF en Dart pur, sans serveur, fonctionne 100% offline. Supporte images, tableaux, couleurs, polices custom. Maintenu activement. |
| `printing` | ^5.13.1 | Aperçu PDF in-app, impression, partage (WhatsApp, email, Drive). Utilise le `PdfPreview` widget pour l'aperçu. |

### 7.6 Formulaires et validation

| Package | Version | Justification |
|---------|---------|---------------|
| `flutter_form_builder` | ^9.4.0 | Formulaires avec état centralisé. Évite de gérer manuellement les `TextEditingController` pour chaque champ. Compatible avec tous les types de champs (text, date, dropdown, checkbox). |
| `form_builder_validators` | ^10.0.1 | Règles de validation pré-construites (required, email, number, min/max). Localisation française incluse. |

### 7.7 Fichiers et médias

| Package | Version | Justification |
|---------|---------|---------------|
| `file_picker` | ^8.0.7 | Sélection de fichiers multi-format (PDF, Word, Excel) depuis le système de fichiers. Fonctionne Android et Web. |
| `image_picker` | ^1.1.2 | Accès caméra et galerie photo. Indispensable pour les photos de sinistres terrain. |

### 7.8 Réseau et connectivité

| Package | Version | Justification |
|---------|---------|---------------|
| `connectivity_plus` | ^6.0.3 | Détection online/offline en temps réel (Stream). Notifie le SyncService au retour de connexion. Package officiel du Flutter team. |

### 7.9 Sécurité

| Package | Version | Justification |
|---------|---------|---------------|
| `flutter_secure_storage` | ^9.2.2 | Stockage chiffré des tokens Supabase et des clés de chiffrement Drift. Utilise le Keychain sur iOS, EncryptedSharedPreferences sur Android. |

### 7.10 Internationalisation et formatage

| Package | Version | Justification |
|---------|---------|---------------|
| `intl` | ^0.19.0 | Formatage des dates (`DateFormat('dd/MM/yyyy')`), des nombres (`NumberFormat('#,###')`), et des monnaies. Requis pour l'affichage correct des montants en FCFA. |

### 7.11 Utilitaires

| Package | Version | Justification |
|---------|---------|---------------|
| `uuid` | ^4.4.2 | Génération d'UUIDs v4 localement (clés primaires offline). Évite les collisions entre entités créées hors ligne par différents utilisateurs. |
| `shared_preferences` | ^2.3.1 | Stockage de préférences légères (thème, dernière route, réglages UI). Pour les données non sensibles seulement. |
| `equatable` | ^2.0.5 | Égalité structurelle des classes de données sans écrire `==` et `hashCode` manuellement. Utile pour les comparaisons dans Riverpod. |

### 7.12 Dev dependencies

| Package | Version | Justification |
|---------|---------|---------------|
| `build_runner` | ^2.4.11 | Générateur de code. **Obligatoire** après toute modification de table Drift ou provider annoté Riverpod. Commande : `dart run build_runner build --delete-conflicting-outputs` |
| `drift_dev` | ^2.20.0 | Générateur de code Drift (tables → classes Dart, DAOs → méthodes typées). |
| `riverpod_generator` | ^2.4.3 | Générateur de code pour les providers annotés `@riverpod`. **Optionnel** si on écrit les providers manuellement. |
| `flutter_lints` | ^4.0.0 | Règles lint officielles Flutter. 0 warning requis avant tout commit. |
| `logger` | ^2.4.0 | Logs structurés avec niveaux (debug, info, warning, error). Remplace `print()`. |

### 7.13 Packages intentionnellement absents

| Package | Raison d'exclusion |
|---------|--------------------|
| `bloc` / `flutter_bloc` | Trop verbeux pour notre taille d'équipe. Riverpod suffit. |
| `get` / `GetX` | Anti-pattern : trop magique, difficile à déboguer, mélange tout. |
| `provider` (seul) | Remplacé par Riverpod qui est son successeur naturel. |
| `dio` | `supabase_flutter` gère les requêtes HTTP. Dio n'est pas nécessaire. |
| `firebase_firestore` | Remplacé par Supabase PostgreSQL. Coûts imprévisibles, pas de SQL. |
| `isar` | **Migration en cours → Drift.** Voir section 9. |
| `hive` | Moins typé que Drift, pas de SQL, moins adapté aux données relationnelles. |

---

## 8. Conventions et règles strictes

### Nommage des fichiers

```
feature/data/models/   → [entity]_local_model.dart
feature/data/repos/    → [entity]_repository.dart
feature/presentation/  → [entity]_[list|detail|form]_screen.dart
feature/presentation/  → [descriptif]_widget.dart
core/                  → [descriptif]_[type].dart   (ex: app_theme.dart)
database/tables/       → [entity]s_table.dart        (pluriel)
database/daos/         → [entity]s_dao.dart          (pluriel)
```

### Nommage des providers

```dart
// Lecture (FutureProvider / StreamProvider) → camelCase + Provider
final dossiersProvider        = FutureProvider<List<Dossier>>(...);
final dossierDetailProvider   = FutureProvider.family<Dossier?, String>(...);
final isOnlineProvider        = StateProvider<bool>(...);

// Mutation (AsyncNotifier) → PascalCase + Notifier / camelCase + NotifierProvider
class DossierNotifier extends AsyncNotifier<void> { ... }
final dossierNotifierProvider = AsyncNotifierProvider<DossierNotifier, void>(...);
```

### Imports — ordre obligatoire

```dart
// 1. SDK Dart
import 'dart:async';
import 'dart:convert';

// 2. Packages Flutter
import 'package:flutter/material.dart';

// 3. Packages tiers (pub.dev)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Imports internes (relatifs)
import '../../../core/theme/app_theme.dart';
import '../providers/dossier_provider.dart';
```

### Structure d'un écran standard

```dart
class MonScreen extends ConsumerStatefulWidget {
  // 1. Paramètres de route
  final String id;
  const MonScreen({super.key, required this.id});

  @override
  ConsumerState<MonScreen> createState() => _MonScreenState();
}

class _MonScreenState extends ConsumerState<MonScreen> {
  // 2. State local minimal (UI state seulement : bool _loading, etc.)

  // 3. initState si nécessaire

  // 4. dispose() pour nettoyer les controllers

  // 5. Méthodes privées d'action (_submit, _confirm, etc.)

  // 6. build() — le plus court possible
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(monProvider(widget.id));
    return Scaffold(
      appBar: AppBar(title: ...),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => ErrorView(error: e),
        data:    (d) => _buildContent(d),
      ),
    );
  }

  Widget _buildContent(MonModel data) { ... }
}
```

---

## 9. État d'avancement de la migration

### Situation actuelle (à la rédaction de ce document)

```
⚠  DETTE TECHNIQUE : Le code utilise encore Isar (local_db_service.dart,
   dossier_local_model.dart) alors que la décision actée est d'utiliser Drift.
   Cette migration est la priorité technique #1.
```

### Plan de migration Isar → Drift

```
Étape 1 : Créer la couche database/ avec Drift
  ├── database/app_database.dart         (AppDatabase @DriftDatabase)
  ├── database/tables/*.dart             (toutes les tables)
  └── database/daos/*.dart               (tous les DAOs)
  → dart run build_runner build

Étape 2 : Migrer DossierRepository
  ├── Remplacer LocalDbService.db.dossierLocalModels par DossiersDao
  ├── Adapter les types (DossierData Drift au lieu de DossierLocalModel Isar)
  └── Supprimer local_db_service.dart et dossier_local_model.dart

Étape 3 : Migrer les autres features au fur et à mesure
  (clients, factures, charges, personnel, salaires)

Étape 4 : Supprimer Isar du pubspec.yaml
  - isar: ^3.1.0+1
  - isar_flutter_libs: ^3.1.0+1
  → Ajouter drift, drift_flutter, sqlite3_flutter_libs, drift_dev

Étape 5 : Ajouter build_runner watch en développement
```

### Fichiers à NE PAS toucher jusqu'à la migration

```
lib/shared/services/local_db_service.dart    ← sera supprimé
lib/features/dossiers/data/models/
  dossier_local_model.dart                   ← sera remplacé
lib/features/auth/data/models/
  user_local_model.dart                      ← sera remplacé
```

### Fichiers déjà conformes à l'architecture cible

```
✅ lib/core/router/app_router.dart
✅ lib/core/shell/main_shell.dart
✅ lib/core/network/connectivity_service.dart
✅ lib/features/auth/data/auth_provider.dart
✅ lib/features/dossiers/data/repositories/dossier_repository.dart
✅ lib/shared/services/sync_service.dart
✅ lib/features/dossiers/presentation/screens/*.dart
✅ lib/features/dashboard/presentation/screens/*.dart
```

---

*ARCHITECTURE.md — à mettre à jour à chaque décision structurelle*
