# Commande : Initialiser le Projet Flutter Complet

Génère toute l'infrastructure de base du projet en une seule fois.

**Paramètres :** $ARGUMENTS *(ex: "MonApp com.example.monapp")*

## Ce que tu dois générer dans l'ordre

### ÉTAPE 1 — pubspec.yaml
```yaml
# Générer le pubspec.yaml complet avec toutes les dépendances :
dependencies:
  # State management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  
  # Navigation
  go_router: ^14.0.0
  
  # DI
  get_it: ^7.7.0
  injectable: ^2.4.1
  
  # Base de données locale (offline + web)
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.0    # Android/Desktop
  drift_db_viewer: ^2.0.0         # Debug viewer
  
  # Réseau
  dio: ^5.7.0
  retrofit: ^4.3.0
  connectivity_plus: ^6.0.0
  
  # Stockage sécurisé
  flutter_secure_storage: ^9.2.2
  
  # Fonctionnel
  dartz: ^0.10.1
  uuid: ^4.5.0
  
  # Cache images
  cached_network_image: ^3.4.1
  
  # UI
  shimmer: ^3.0.0
  
  # Internationalisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

dev_dependencies:
  # Génération de code
  build_runner: ^2.4.13
  injectable_generator: ^2.6.1
  drift_dev: ^2.20.0
  retrofit_generator: ^9.1.0
  json_serializable: ^6.8.0
  
  # Tests
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  integration_test:
    sdk: flutter
```

### ÉTAPE 2 — Structure des dossiers
Créer tous les dossiers vides avec un `.gitkeep` :
```
lib/
├── core/
│   ├── constants/      (app_config.dart, app_spacing.dart, app_strings.dart)
│   ├── errors/         (failures.dart, exceptions.dart, exception_mapper.dart)
│   ├── network/        (dio_client.dart, auth_interceptor.dart, connectivity_service.dart)
│   ├── sync/           (sync_manager.dart, sync_queue.dart, sync_handler.dart)
│   ├── theme/          (app_theme.dart, color_scheme.dart, text_theme.dart)
│   ├── utils/          (extensions.dart, validators.dart, date_utils.dart)
│   └── widgets/        (widgets core réutilisables)
├── features/
└── l10n/               (app_fr.arb, app_en.arb)
```

### ÉTAPE 3 — AppTheme complet
```dart
// lib/core/theme/app_theme.dart
// Material Design 3 avec ColorScheme.fromSeed()
// lightTheme + darkTheme
// ThemeExtension pour les couleurs custom (sync status, offline badge)
// AppSpacing : constantes d'espacement (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48)
// AppRadius : border-radius (sm=8, md=12, lg=16, xl=24, full=100)
```

### ÉTAPE 4 — Database (Drift)
```dart
// lib/core/database/app_database.dart
// @DriftDatabase avec toutes les tables
// Inclure : SyncOperationsTable (pour SyncQueue)
// LazyDatabase avec sqlite3 (Android) ou web worker (Web)
// Migration strategy avec schéma versionné
```

### ÉTAPE 5 — Injection de dépendances
```dart
// lib/injection_container.dart
// @InjectableInit
// Enregistrer : AppDatabase, DioClient, ConnectivityService, SyncManager, SyncQueue
// injection_container.config.dart sera auto-généré
```

### ÉTAPE 6 — Router
```dart
// lib/core/navigation/app_router.dart
// GoRouter avec :
//   ShellRoute pour la navigation principale (bottom nav / sidebar)
//   Redirect sur auth si non connecté
//   Error page 404 custom
//   Transitions personnalisées
```

### ÉTAPE 7 — AppShell
```dart
// lib/core/widgets/app_shell.dart
// Widget racine avec :
//   OfflineBanner en haut
//   SyncStatusWidget dans AppBar
//   Adaptive layout : BottomNavBar (mobile) vs NavigationRail (web/tablet)
//   BlocListener pour les erreurs globales
```

### ÉTAPE 8 — main.dart
```dart
// Initialisation dans l'ordre :
// 1. WidgetsFlutterBinding.ensureInitialized()
// 2. configureDependencies() (GetIt)
// 3. await sl<AppDatabase>().initialize()
// 4. await sl<ConnectivityService>().initialize()
// 5. await sl<SyncManager>().initialize()
// 6. runApp(MyApp())
// 
// MyApp : MultiBlocProvider (AuthBloc, ConnectivityBloc, SyncBloc)
// MaterialApp.router avec GoRouter
// ThemeMode depuis SharedPreferences
```

### ÉTAPE 9 — Localisation
```arb
// lib/l10n/app_fr.arb — Français (langue principale)
// lib/l10n/app_en.arb — Anglais
// Clés de base : appName, loading, error, retry, save, cancel, delete, 
//                offline_banner, sync_pending, sync_success, sync_error
```

### ÉTAPE 10 — CI/CD de base
```yaml
// .github/workflows/flutter.yml (si GitHub) ou gitlab-ci.yml
// Jobs : analyze → test → build_apk → build_web
// flutter analyze --no-fatal-warnings
// flutter test --coverage
// Upload artifacts : APK + web build
```

## Après génération
Lancer dans l'ordre :
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

## Format de sortie
Générer chaque fichier complet dans l'ordre des étapes.
Indiquer clairement le chemin de chaque fichier.
