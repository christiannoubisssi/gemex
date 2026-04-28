# CLAUDE.md — AvarieApp
> Fichier de référence pour Claude Code. À lire intégralement avant toute modification du projet.

---

## 1. Description & objectif

**AvarieApp** est une application Flutter multi-plateforme de gestion interne pour un cabinet de
commissaire d'avarie basé au **Gabon** (déploiement multi-pays possible).

### Ce que fait l'application
- Gestion des **dossiers d'expertise** : création, suivi du workflow, archivage
- **Devis & facturation** avec calcul automatique TVA/TPS et génération PDF
- Suivi **clients** : fiches, historique, relances automatiques
- **Comptabilité simplifiée** : enregistrement produits/charges, tableaux d'analyse
- **RH simplifiée** : contrats, planning, congés, saisie et validation des salaires
- **Tableaux de bord** automatiques par métier (opérationnel, financier, RH)
- Envoi d'emails (devis, factures, relances) depuis l'application

### Contraintes critiques
- L'application doit fonctionner **100 % offline** (terrain, bord de mer, zones sans réseau)
- La synchronisation avec Supabase est **automatique et transparente** au retour de la connexion
- **Équipe réduite** : la simplicité prime sur la complétude des fonctionnalités
- Pas de complexité inutile : un junior Flutter doit pouvoir comprendre le code

---

## 2. Stack technique

### Flutter & Dart
```
Flutter : stable channel, ≥ 3.19.0
Dart    : ≥ 3.3.0
Cibles  : Android (API 21+) · Web (Chrome/Edge)
iOS     : NON ciblé pour l'instant
```

### Packages — pubspec.yaml (liste de référence)

#### Backend & Auth
| Package | Version | Usage |
|---------|---------|-------|
| `supabase_flutter` | ^2.5.0 | Auth, DB realtime, Storage |

#### State management
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_riverpod` | ^2.5.1 | State management principal |

#### Base de données locale (offline-first)
| Package | Version | Usage |
|---------|---------|-------|
| `drift` | ^2.20.0 | Base SQLite locale typée |
| `drift_flutter` | ^0.2.1 | Intégration Flutter pour Drift |
| `sqlite3_flutter_libs` | ^0.5.24 | Binaires SQLite natifs |
| `path` | ^1.9.0 | Chemins fichiers pour Drift |
| `path_provider` | ^2.1.3 | Dossier documents de l'appareil |

> **Décision actée** : Drift (SQLite) à la place de Isar.
> Raison : Isar v3 n'est plus maintenu activement. Drift est stable, typé, et basé sur SQLite standard.

#### Navigation
| Package | Version | Usage |
|---------|---------|-------|
| `go_router` | ^14.0.2 | Routing déclaratif web + mobile |

#### PDF (génération locale, fonctionne offline)
| Package | Version | Usage |
|---------|---------|-------|
| `pdf` | ^3.11.1 | Génération PDF en Dart |
| `printing` | ^5.13.1 | Aperçu, impression, partage PDF |

#### Formulaires
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_form_builder` | ^9.4.0 | Formulaires avec validation |
| `form_builder_validators` | ^10.0.1 | Règles de validation |

#### Fichiers & médias
| Package | Version | Usage |
|---------|---------|-------|
| `file_picker` | ^8.0.7 | Sélection fichiers |
| `image_picker` | ^1.1.2 | Photos terrain (caméra/galerie) |

#### Réseau & connectivité
| Package | Version | Usage |
|---------|---------|-------|
| `connectivity_plus` | ^6.0.3 | Détection online/offline |

#### Sécurité
| Package | Version | Usage |
|---------|---------|-------|
| `flutter_secure_storage` | ^9.2.2 | Stockage sécurisé des tokens |

#### Utilitaires
| Package | Version | Usage |
|---------|---------|-------|
| `uuid` | ^4.4.2 | Génération UUIDs locaux (offline) |
| `intl` | ^0.19.0 | Formatage dates et monnaie |
| `shared_preferences` | ^2.3.1 | Préférences utilisateur |
| `equatable` | ^2.0.5 | Égalité des objets |

#### Dev
| Package | Version | Usage |
|---------|---------|-------|
| `build_runner` | ^2.4.11 | Génération de code |
| `drift_dev` | ^2.20.0 | Génération code Drift |
| `flutter_lints` | ^4.0.0 | Règles lint |

---

## 3. Architecture des dossiers

```
lib/
├── main.dart                        # Point d'entrée, init Supabase + Drift
├── app.dart                         # MaterialApp + GoRouter
│
├── core/                            # Code partagé, sans dépendance aux features
│   ├── config/
│   │   └── supabase_config.dart     # URL + anonKey (NE PAS commiter les vraies valeurs)
│   ├── theme/
│   │   └── app_theme.dart           # ThemeData, couleurs, typographie
│   ├── constants/
│   │   └── app_constants.dart       # Constantes globales (statuts, listes, formats)
│   └── utils/
│       ├── date_utils.dart          # Helpers dates
│       ├── number_utils.dart        # Formatage FCFA, pourcentages
│       └── pdf_utils.dart           # Helpers génération PDF
│
├── database/                        # Couche Drift (base locale)
│   ├── app_database.dart            # @DriftDatabase, connexion SQLite
│   ├── tables/                      # Définition des tables Drift
│   │   ├── dossiers_table.dart
│   │   ├── clients_table.dart
│   │   ├── factures_table.dart
│   │   ├── devis_table.dart
│   │   ├── charges_table.dart
│   │   ├── personnel_table.dart
│   │   └── salaires_table.dart
│   └── daos/                        # Data Access Objects Drift
│       ├── dossiers_dao.dart
│       ├── clients_dao.dart
│       ├── factures_dao.dart
│       └── sync_dao.dart            # Gestion sync_status pour tous les objets
│
├── models/                          # Classes de données pures (pas de logique UI)
│   ├── dossier_model.dart
│   ├── client_model.dart
│   ├── devis_model.dart
│   ├── facture_model.dart
│   ├── charge_model.dart
│   ├── personnel_model.dart
│   └── salaire_model.dart
│
├── services/                        # Accès Supabase (remote) — toujours wrappés par les providers
│   ├── auth_service.dart
│   ├── dossier_service.dart
│   ├── client_service.dart
│   ├── facture_service.dart
│   ├── sync_service.dart            # Orchestration sync Drift ↔ Supabase
│   ├── pdf_service.dart             # Génération PDF devis/factures
│   └── email_service.dart           # Envoi emails via Supabase Edge Functions
│
├── providers/                       # Riverpod providers (pont entre services et UI)
│   ├── auth_provider.dart
│   ├── dossier_provider.dart
│   ├── client_provider.dart
│   ├── facture_provider.dart
│   ├── charge_provider.dart
│   └── dashboard_provider.dart
│
└── screens/                         # UI uniquement — pas de logique métier
    ├── auth/
    │   └── login_screen.dart
    ├── dashboard/
    │   └── dashboard_screen.dart
    ├── dossiers/
    │   ├── dossiers_list_screen.dart
    │   ├── dossier_detail_screen.dart
    │   └── dossier_form_screen.dart
    ├── clients/
    │   ├── clients_list_screen.dart
    │   ├── client_detail_screen.dart
    │   └── client_form_screen.dart
    ├── devis/
    │   ├── devis_list_screen.dart
    │   └── devis_form_screen.dart
    ├── factures/
    │   ├── factures_list_screen.dart
    │   └── facture_detail_screen.dart
    ├── comptabilite/
    │   └── comptabilite_screen.dart
    ├── rh/
    │   ├── personnel_list_screen.dart
    │   └── salaires_screen.dart
    └── widgets/                     # Widgets réutilisables cross-screens
        ├── app_drawer.dart
        ├── status_badge.dart
        ├── offline_banner.dart
        ├── confirm_dialog.dart
        └── empty_state.dart

database/
└── schema.sql                       # Schéma Supabase (PostgreSQL) — source de vérité

assets/
├── images/
│   └── logo.png
└── fonts/                           # Si polices custom ajoutées
```

---

## 4. Décisions techniques actées (NE PAS remettre en question sans accord)

| Sujet | Décision | Raison |
|-------|----------|--------|
| Base locale | **Drift** (pas Isar) | Isar v3 non maintenu, Drift plus stable |
| Numérotation factures | **Annuelle** : FAC-2025-0001 | Choix du client |
| Numérotation dossiers | **Annuelle** : AV-2025-0001 | Cohérence avec factures |
| Numérotation devis | **Annuelle** : DEV-2025-0001 | Cohérence |
| Pays principal | **Gabon** · Devise : **XAF** · TVA : **18 %** | Explicitement confirmé |
| TPS/CSS | **Configurable par entreprise**, défaut 0 % | Taux exact à confirmer avec comptable |
| Langue UI | **Français uniquement** | Gabon francophone |
| Cible mobile | **Android uniquement** (pas iOS pour l'instant) | Décision initiale |
| Cible web | **Oui** — Flutter Web (build statique → Vercel) | Confirmé |
| State management | **Riverpod** | Choix initial, pas de migration |
| Navigation | **go_router** | Standard Flutter recommandé |
| Backend | **Supabase** | Compte déjà créé et configuré |
| Multi-tenant | **entreprise_id + RLS Supabase** | Isolation données par cabinet |
| Sync offline | **last write wins** via `updated_at` | Équipe réduite, conflits improbables |
| Génération PDF | **Locale** (package `pdf`) | Fonctionne offline |
| Couleurs | Navy #0D2137 · Teal #1A8A9A · Or #F0A500 | Charte maritime validée |
| Format date | **dd/MM/yyyy** | Standard francophone |
| Format monnaie | **`#,### FCFA`** (séparateur milliers espace) | Standard gabonais |

---

## 5. Règles métier — workflow dossiers

```
nouveau → en_instruction → expertise_en_cours → rapport_rédigé → clos
                                    ↘ annulé (possible depuis tout statut sauf clos)
```

- Les retours arrière dans le workflow sont **interdits** (pas de passage de `clos` à `en_instruction`)
- La date correspondante est **auto-renseignée** lors d'un changement de statut :
  - `expertise_en_cours` → remplit `date_expertise`
  - `rapport_rédigé` → remplit `date_rapport`
  - `clos` → remplit `date_cloture`
- Seul un **admin ou expert** peut changer le statut d'un dossier

---

## 6. Conventions de code

### Nommage
```dart
// Fichiers : snake_case
dossier_service.dart
dossier_form_screen.dart

// Classes : PascalCase
class DossierService {}
class DossierFormScreen extends ConsumerWidget {}

// Variables & méthodes : camelCase
final dossierList = <Dossier>[];
Future<void> createDossier() async {}

// Constantes : camelCase dans des classes const
class AppConstants {
  static const String dateFormat = 'dd/MM/yyyy';
}

// Providers Riverpod : suffixe Provider
final dossiersProvider = FutureProvider.autoDispose<List<Dossier>>(...);
final dossierNotifierProvider = AsyncNotifierProvider<DossierNotifier, void>(...);
```

### Structure d'un écran (règle absolue)
```dart
// ✅ Correct — toute la logique dans le provider, l'écran ne fait qu'afficher
class DossierListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dossiers = ref.watch(dossiersProvider);
    return dossiers.when(
      loading: () => const LoadingWidget(),
      error:   (e, _) => ErrorWidget(e),
      data:    (list) => DossierListView(list),
    );
  }
}

// ❌ Interdit — logique métier dans le build()
class DossierListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Supabase.instance.client.from('dossiers').select(); // NON
    ...
  }
}
```

### Services — règle d'accès
```dart
// ✅ Les services sont appelés UNIQUEMENT depuis les providers (Notifiers)
// ❌ Jamais appelés directement depuis un écran ou un widget

// ✅ Correct
class DossierNotifier extends AsyncNotifier<void> {
  Future<void> create(payload) async {
    await DossierService.create(payload); // ici c'est ok
  }
}

// ❌ Interdit
ElevatedButton(
  onPressed: () => DossierService.create(payload), // jamais directement
)
```

### Drift — conventions DAO
```dart
// Chaque DAO expose des méthodes claires et retourne des objets du domaine (models),
// jamais des objets Drift bruts hors de la couche database/
class DossiersDao extends DatabaseAccessor<AppDatabase> {
  Future<List<Dossier>> getAll() async { ... }
  Future<Dossier> getById(String id) async { ... }
  Future<void> upsert(Dossier d) async { ... }  // utilisé pour la sync
  Future<List<Dossier>> getPendingSync() async { ... }
}
```

### Gestion des erreurs
```dart
// ✅ Toujours catcher les erreurs dans les Notifiers, jamais laisser remonter à l'UI
Future<void> createDossier(payload) async {
  state = const AsyncLoading();
  state = await AsyncValue.guard(() => DossierService.create(payload));
}

// Affichage erreur dans l'UI
ref.listen(dossierNotifierProvider, (_, next) {
  if (next.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error.toString()), backgroundColor: AppTheme.danger),
    );
  }
});
```

### Commentaires
```dart
// Français uniquement dans les commentaires
// Format TODOs : // TODO(username): description et date
// TODO(dev): implémenter la sync offline — 2025-07

/// Doc publique des méthodes importantes (triple slash)
/// Retourne null si le dossier n'existe pas localement.
Future<Dossier?> getById(String id) async { ... }
```

---

## 7. Architecture offline-first — règle absolue

```
UI → Provider → DAO (Drift local) → affichage immédiat
                      ↓ en arrière-plan
               SyncService → Supabase (si connecté)
```

**Principe** : l'application lit et écrit **toujours** en local (Drift) en premier.
La synchronisation avec Supabase est **asynchrone et en arrière-plan**.

### Champ sync_status sur chaque entité locale
```
'synced'  → donnée identique en local et sur Supabase
'pending' → modification locale non encore envoyée
'conflict'→ conflit détecté (nécessite intervention)
```

### UUIDs locaux
- Chaque enregistrement créé offline reçoit un UUID généré localement (`const Uuid().v4()`)
- Le même UUID est utilisé comme clé primaire sur Supabase
- Pas d'auto-increment numérique — toujours des UUIDs v4

### Règle de résolution de conflit
- Stratégie : **last write wins** via `updated_at`
- Exception : les montants de factures → toujours demander à l'utilisateur en cas de conflit

---

## 8. Fiscalité — règles de calcul

```
Montant HT
  × taux_tva  (défaut 18 % au Gabon, configurable par entreprise) → montant_tva
  × taux_tps  (défaut 0 %, configurable)                          → montant_tps
= Montant TTC = HT + TVA + TPS
```

- Les taux sont **stockés sur la facture/devis au moment de l'émission** (pas recalculés après)
- Les taux configurés dans `entreprises.tva_taux` sont des **valeurs par défaut**, pas des valeurs figées
- L'utilisateur peut modifier le taux manuellement sur chaque document

---

## 9. Numérotation des documents

| Document | Format | Exemple | Reset |
|----------|--------|---------|-------|
| Dossier  | `AV-AAAA-NNNN` | AV-2025-0042 | Annuel |
| Devis    | `DEV-AAAA-NNNN` | DEV-2025-0007 | Annuel |
| Facture  | `FAC-AAAA-NNNN` | FAC-2025-0015 | Annuel |

- Les numéros sont générés par des **triggers PostgreSQL côté Supabase** (cf. `database/schema.sql`)
- En mode **offline**, un numéro temporaire est attribué : `AV-LOCAL-<timestamp>`
- Ce numéro temporaire est **remplacé** lors de la synchronisation par le numéro définitif Supabase
- Afficher clairement le numéro temporaire à l'utilisateur (badge "Local" orange)

---

## 10. Rôles utilisateurs et permissions

| Rôle | Dossiers | Clients | Devis | Factures | Charges | RH/Paie | Admin |
|------|----------|---------|-------|----------|---------|---------|-------|
| `admin` | ✅ CRUD | ✅ CRUD | ✅ CRUD | ✅ CRUD | ✅ CRUD | ✅ CRUD | ✅ |
| `expert` | ✅ CRUD | ✅ Lecture | ✅ Créer | ✅ Lecture | ❌ | ❌ | ❌ |
| `agent` | ✅ Créer/Lire | ✅ Créer/Lire | ❌ | ❌ | ❌ | ❌ | ❌ |
| `comptable` | ✅ Lecture | ✅ Lecture | ✅ CRUD | ✅ CRUD | ✅ CRUD | ✅ Lecture | ❌ |
| `rh` | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ CRUD | ❌ |

> **⚠ Note** : Ces permissions sont appliquées côté UI (masquage des actions).
> La sécurité réelle est assurée par le **Row Level Security (RLS) de Supabase**.
> Ne jamais faire confiance au rôle stocké côté client seul.

---

## 11. Commandes clés

```bash
# ── Développement ─────────────────────────────────────────────
flutter pub get                        # Installer les dépendances
flutter run -d chrome                  # Lancer en mode web
flutter run                            # Lancer sur Android connecté
flutter run --flavor production        # Mode production

# ── Génération de code (Drift) ─────────────────────────────────
# ⚠ À exécuter après toute modification d'une table Drift
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch            # Mode watch (génération auto)

# ── Build & déploiement ───────────────────────────────────────
flutter build web --release            # Build Flutter Web → build/web/
flutter build apk --release            # APK Android universel
flutter build apk --split-per-abi      # APK par architecture (plus léger)
flutter build appbundle --release      # AAB pour Google Play

# ── Qualité du code ───────────────────────────────────────────
flutter analyze                        # Analyse statique (0 erreur requis)
flutter test                           # Lancer les tests
flutter test --coverage               # Avec couverture de code

# ── Utilitaires ───────────────────────────────────────────────
flutter doctor                         # Vérifier l'environnement
flutter clean && flutter pub get       # Nettoyer et reconstruire
flutter pub upgrade --major-versions   # Mettre à jour les packages
flutter pub deps                       # Arbre des dépendances
```

---

## 12. Variables d'environnement & configuration

### Fichier à configurer (NE PAS commiter avec de vraies valeurs)
```
lib/core/config/supabase_config.dart
```

```dart
class SupabaseConfig {
  static const String url     = 'https://xxxx.supabase.co';  // Supabase > Settings > API
  static const String anonKey = 'eyJhbGci...';               // Supabase > Settings > API
}
```

### .gitignore — vérifier que ces fichiers sont exclus
```
# Supabase credentials (si mis dans un fichier .env)
.env
.env.local
lib/core/config/supabase_config.dart  # Si contient de vraies clés

# Build outputs
build/
.dart_tool/
*.g.dart  # Fichiers générés Drift — NE PAS exclure si vous les committez
```

> **Recommandation** : Utiliser des **variables d'environnement CI/CD** (GitHub Actions secrets)
> pour injecter les clés en production. Ne jamais hardcoder les clés dans le code versionné.

---

## 13. État d'avancement

### ✅ Décidé et validé
- [x] Stack complète (Flutter + Drift + Supabase + Riverpod)
- [x] Architecture dossiers
- [x] Schéma base de données Supabase (`database/schema.sql`)
- [x] Thème et charte graphique (`core/theme/app_theme.dart`)
- [x] Constantes et conventions
- [x] Modèles `Dossier` et `Client`
- [x] `DossierService` (CRUD Supabase)
- [x] Providers Riverpod dossiers
- [x] Écrans : Login, Dashboard, Liste dossiers, Détail dossier, Formulaire dossier
- [x] Widgets : `StatusBadge`, `PrioriteBadge`, `OfflineBanner`

### 🔄 En cours / à migrer
- [ ] Remplacer Isar par **Drift** dans `pubspec.yaml` (décision actée)
- [ ] Créer `database/app_database.dart` (AppDatabase Drift)
- [ ] Créer les tables Drift (`database/tables/`)
- [ ] Créer les DAOs (`database/daos/`)
- [ ] Implémenter `SyncService` (Drift ↔ Supabase)

### 📋 À développer (dans cet ordre)
1. [ ] **Module Drift complet** — tables + DAOs + migration schema
2. [ ] **Module Clients** — liste, fiche, historique dossiers
3. [ ] **Module Devis** — création, lignes, calcul TVA, PDF
4. [ ] **Module Factures** — génération depuis devis, suivi paiement, PDF
5. [ ] **Pièces jointes** — upload photos terrain + documents
6. [ ] **SyncService** — synchronisation offline/online robuste
7. [ ] **Module Comptabilité** — saisie produits/charges, analyses
8. [ ] **Module RH** — personnel, planning, congés
9. [ ] **Module Paie** — saisie salaires, validation par lot, comptabilisation auto
10. [ ] **Tableaux de bord** — graphiques, KPIs, export
11. [ ] **Emails** — envoi devis/factures via Supabase Edge Functions + Resend
12. [ ] **Gestion utilisateurs** — admin, rôles, invitations
13. [ ] **Paramètres entreprise** — logo, en-tête, TVA, mise en page documents

---

## 14. Points en attente de décision

> Ces éléments nécessitent une réponse du client avant d'être implémentés.

| Sujet | Question | Impact |
|-------|----------|--------|
| TPS/CSS | Quel est le taux exact applicable aux honoraires d'un commissaire d'avarie au Gabon ? | Calcul fiscal |
| Calcul honoraires | Comment calculez-vous vos honoraires ? % du sinistre, forfait, taux horaire, ou mix ? | Formulaire devis |
| Navigation mobile | Drawer latéral ou Bottom Navigation Bar ? | UX mobile |
| Taille max pièces jointes | Quelle taille max par fichier est acceptable ? (Supabase Storage : 50 MB/fichier par défaut) | Storage |
| Domaine email | Quel sera l'expéditeur des emails (ex: facturation@votrecabinet.ga) ? | Config Resend |
| Charte graphique | Avez-vous un logo et des couleurs officiels du cabinet à intégrer ? | Thème, PDF |

---

## 15. Références

- [Supabase Dashboard](https://supabase.com/dashboard) — votre projet
- [Drift documentation](https://drift.simonbinder.eu/) — ORM SQLite Flutter
- [Riverpod docs](https://riverpod.dev/) — state management
- [go_router docs](https://pub.dev/packages/go_router)
- [pdf package](https://pub.dev/packages/pdf) — génération PDF locale
- [Flutter docs](https://docs.flutter.dev/)
- `database/schema.sql` — schéma PostgreSQL Supabase complet
- `README.md` — guide d'installation et démarrage rapide
