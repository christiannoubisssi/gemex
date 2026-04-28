# Commande : Créer une Feature Complète

Génère le scaffold **complet** d'une feature en Clean Architecture pour ce projet Flutter.

**Feature à créer :** $ARGUMENTS

## Ce que tu dois générer (dans l'ordre)

### 1. DOMAIN LAYER

**Entity** — `lib/features/$feature/domain/entities/$feature_entity.dart`
```dart
// Entité pure : pas d'import Flutter, pas de JSON, pas de DB
// Extends Equatable
// Tous les champs final
// Inclure copyWith()
```

**Repository (contrat)** — `lib/features/$feature/domain/repositories/$feature_repository.dart`
```dart
// Interface abstraite uniquement
// Retourner Either<Failure, T> (dartz)
// Méthodes : getAll, getById, create, update, delete, syncPending
```

**UseCases** — Un fichier par action dans `lib/features/$feature/domain/usecases/`
```dart
// GetAll$Feature, Get$FeatureById, Create$Feature, Update$Feature, Delete$Feature
// Chaque usecase : classe avec call() → Either<Failure, T>
// Injecter le repository en constructeur
```

---

### 2. DATA LAYER

**Drift Table** — `lib/features/$feature/data/datasources/local/$feature_table.dart`
```dart
// Table Drift avec ces champs obligatoires :
// - id: TextColumn (UUID, primaryKey)
// - createdAt: DateTimeColumn
// - updatedAt: DateTimeColumn  
// - isSynced: BoolColumn (default false)
// - serverId: TextColumn nullable (null = créé offline)
// + tous les champs métier de l'entité
```

**Local DataSource** — `lib/features/$feature/data/datasources/$feature_local_datasource.dart`
```dart
// CRUD complet via Drift
// getUnsyncedItems() → liste des items avec isSynced = false
// markAsSynced(id) → met isSynced = true + serverId
// watchAll() → Stream<List<$FeatureModel>> (reactive)
```

**Remote DataSource** — `lib/features/$feature/data/datasources/$feature_remote_datasource.dart`
```dart
// Dio + intercepteurs du projet
// Méthodes : fetchAll, fetchById, create, update, delete
// Gestion d'erreurs : DioException → ServerException typé
// Timeout : 30s connection, 30s receive
```

**Model (DTO)** — `lib/features/$feature/data/models/$feature_model.dart`
```dart
// Extends ou wraps l'entité
// fromJson / toJson (json_annotation)
// fromEntity() + toEntity()
// fromDrift() + toDriftCompanion()
```

**Repository (implémentation)** — `lib/features/$feature/data/repositories/$feature_repository_impl.dart`
```dart
// Stratégie offline-first :
// READ  → Drift d'abord, fetch réseau en arrière-plan si connecté
// WRITE → Drift immédiatement (isSynced=false) + enqueue sync
// Wrapper try/catch → Either<Failure, T>
// Écouter ConnectivityService pour déclencher sync
```

---

### 3. PRESENTATION LAYER

**Events** — `lib/features/$feature/presentation/bloc/$feature_event.dart`
```dart
// Extends Equatable
// LoadAll$Feature, Load$FeatureById(id), 
// Create$Feature(params), Update$Feature(id, params),
// Delete$Feature(id), Sync$Feature, RefreshFromServer
```

**States** — `lib/features/$feature/presentation/bloc/$feature_state.dart`
```dart
// $FeatureInitial, $FeatureLoading, 
// $FeatureLoaded(items, hasPendingSync),
// $FeatureError(message, canRetry),
// $FeatureOperationSuccess(message)
// Tous Equatable, tous immutables avec copyWith
```

**BLoC** — `lib/features/$feature/presentation/bloc/$feature_bloc.dart`
```dart
// Un handler par event
// Utiliser les usecases injectés (jamais le repository directement)
// Émettre LoadingState avant toute opération
// fold() sur Either pour gérer succès/erreur
// Inclure logique de debounce pour les recherches
```

**Page principale** — `lib/features/$feature/presentation/pages/$feature_list_page.dart`
```dart
// BlocProvider + BlocConsumer (listener pour messages flash)
// AppBar avec titre + bouton refresh + indicateur sync
// Corps : BlocBuilder avec tous les états
// FloatingActionButton pour création
// Pull-to-refresh (RefreshIndicator)
// Empty state illustré quand liste vide
// Bannière offline si pas de connexion
```

**Page détail/formulaire** — `lib/features/$feature/presentation/pages/$feature_form_page.dart`
```dart
// Formulaire avec validation complète (Form + GlobalKey)
// Pré-remplissage si mode édition
// Bouton save désactivé pendant chargement
// Feedback visuel (SnackBar success/error)
// Confirmation avant suppression (AlertDialog)
```

**Widgets** — `lib/features/$feature/presentation/widgets/`
```dart
// $FeatureCard  → item de liste avec gestion état sync (icône pending)
// $FeatureEmpty → state vide illustré
// $FeatureSyncBanner → bandeau "X modifications en attente"
```

---

### 4. INJECTION DI

Ajouter dans `lib/injection_container.dart` :
```dart
// Enregistrer : RemoteDataSource, LocalDataSource, Repository, 
// tous les UseCases, le BLoC (factory)
```

### 5. ROUTING

Ajouter dans le router go_router :
```dart
// Route liste : /$feature
// Route détail : /$feature/:id
// Route création : /$feature/new
// Route édition : /$feature/:id/edit
```

---

## Règles impératives
- Aucune valeur hardcodée (couleurs, tailles, textes)
- Tout texte affiché → clé AppLocalizations
- Responsive : adapter layout si largeur > 600px (liste + détail côte à côte)
- Ajouter les imports nécessaires dans chaque fichier
- Commenter les parties non-triviales en français
- Respecter les conventions de CLAUDE.md
