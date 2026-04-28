# Commande : Créer / Mettre à jour le Service de Synchronisation

Génère ou met à jour les services de synchronisation offline → online.

**Contexte :** $ARGUMENTS

## Architecture de Sync à générer

### 1. ConnectivityService — `lib/core/network/connectivity_service.dart`
```dart
// Singleton via GetIt
// Stream<ConnectivityStatus> → émet à chaque changement réseau
// ConnectivityStatus : online | offline | unknown
// Méthodes :
//   isOnline() → bool (check synchrone)
//   onConnected() → Stream (filtre uniquement les passages online)
// Utilise : connectivity_plus
// Initialiser dans main() avant runApp()
```

### 2. SyncQueue — `lib/core/sync/sync_queue.dart`
```dart
// File d'attente persistante (stockée dans Drift table: sync_operations)
// SyncOperation {
//   id: String (UUID)
//   feature: String (nom de la feature)
//   operationType: SyncOperationType (create | update | delete)
//   payload: String (JSON sérialisé)
//   attempts: int (default 0)
//   maxAttempts: int (default 5)
//   createdAt: DateTime
//   lastAttemptAt: DateTime?
//   error: String? (dernière erreur)
// }
// Méthodes :
//   enqueue(SyncOperation) → Future<void>
//   dequeue() → Future<SyncOperation?> (prend le plus ancien non-maxed)
//   markSuccess(id) → Future<void> (supprime l'opération)
//   markFailed(id, error) → Future<void> (incrémente attempts)
//   getPending() → Future<List<SyncOperation>>
//   clear() → Future<void>
```

### 3. SyncManager — `lib/core/sync/sync_manager.dart`
```dart
// Orchestrateur principal — singleton via GetIt
// Écoute ConnectivityService.onConnected()
// À la reconnexion :
//   1. Émettre SyncStatus.syncing
//   2. Récupérer toutes SyncOperation de la queue
//   3. Traiter séquentiellement (ou par batch de 10 max)
//   4. Retry exponentiel : delaySeconds = 2^attempts (max 32s)
//   5. Émettre SyncStatus.success ou SyncStatus.partialFailure
// 
// SyncStatus : idle | syncing | success | partialFailure | failed
// Stream<SyncStatus> syncStatus → pour les widgets
// Stream<int> pendingCount → nombre d'opérations en attente
//
// Méthodes publiques :
//   initialize() → Future<void>
//   triggerSync() → Future<void> (sync manuelle)
//   registerHandler(feature, SyncHandler) → void
```

### 4. SyncHandler (interface) — `lib/core/sync/sync_handler.dart`
```dart
// Interface que chaque feature doit implémenter
abstract class SyncHandler {
  String get featureName;
  Future<Either<Failure, void>> handleCreate(Map<String, dynamic> payload);
  Future<Either<Failure, void>> handleUpdate(String id, Map<String, dynamic> payload);
  Future<Either<Failure, void>> handleDelete(String id);
}
```

### 5. SyncStatusWidget — `lib/core/widgets/sync_status_widget.dart`
```dart
// Widget à placer dans l'AppBar ou en bas d'écran
// Affiche selon SyncStatus :
//   idle     → rien (invisible)
//   syncing  → CircularProgressIndicator + "Synchronisation..."
//   success  → Icône check verte 2 secondes puis disparaît
//   failed   → Icône warning rouge + "X erreurs" + bouton retry
// Écoute SyncManager.syncStatus via StreamBuilder
// pendingCount > 0 → badge sur l'icône cloud
```

### 6. OfflineBanner — `lib/core/widgets/offline_banner.dart`
```dart
// AnimatedContainer qui apparaît/disparaît selon connectivité
// Quand offline : bandeau rouge/orange en haut "Mode hors connexion"
// Quand reconnecté : bandeau vert "Connexion rétablie" → 2s → disparaît
// Écoute ConnectivityService.connectivityStatus
// Placer dans le Scaffold principal (AppShell)
```

### 7. Intégration dans Repository (exemple)
```dart
// Pattern à suivre dans CHAQUE repository pour les writes :

Future<Either<Failure, Entity>> create(CreateParams params) async {
  try {
    // 1. Créer localement immédiatement
    final localModel = ModelMapper.fromParams(params, isSynced: false);
    await localDataSource.insert(localModel);
    
    // 2. Enqueue sync operation
    await syncQueue.enqueue(SyncOperation(
      feature: 'feature_name',
      operationType: SyncOperationType.create,
      payload: jsonEncode(localModel.toJson()),
    ));
    
    // 3. Si connecté → tenter sync immédiate en arrière-plan
    if (connectivityService.isOnline()) {
      syncManager.triggerSync(); // fire & forget
    }
    
    return Right(localModel.toEntity());
  } catch (e) {
    return Left(LocalStorageFailure(e.toString()));
  }
}
```

## Initialisation dans main.dart
```dart
// Ajouter dans setupDependencies() :
void _initSync() {
  sl.registerSingleton<ConnectivityService>(ConnectivityServiceImpl());
  sl.registerSingleton<SyncQueue>(SyncQueueImpl(sl()));
  sl.registerSingleton<SyncManager>(SyncManagerImpl(sl(), sl()));
  
  // Enregistrer les handlers de chaque feature
  sl<SyncManager>().registerHandler('feature_name', FeatureSyncHandler(sl()));
}

// Dans main() :
await sl<ConnectivityService>().initialize();
await sl<SyncManager>().initialize();
```

## Règles
- Le SyncManager ne doit JAMAIS bloquer l'UI
- Toutes les opérations de sync → try/catch → log l'erreur mais ne crash pas
- Les conflits serveur → log + notifier l'utilisateur (pas de perte silencieuse)
- Tests : mocker ConnectivityService pour simuler offline/online
