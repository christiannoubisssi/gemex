# Commande : Créer un Service API

Génère un client API complet avec Dio + Retrofit pour une ressource.

**Service à créer :** $ARGUMENTS

## Ce que tu dois générer

### 1. DioClient — `lib/core/network/dio_client.dart`
*(Générer uniquement s'il n'existe pas encore)*
```dart
// Singleton Dio configuré avec :
// BaseOptions :
//   baseUrl → depuis AppConfig.apiBaseUrl (env variable)
//   connectTimeout : 30s
//   receiveTimeout : 30s
//   headers : Content-Type: application/json, Accept: application/json

// Interceptors dans l'ordre :
// 1. AuthInterceptor   → ajoute Bearer token depuis SecureStorage
// 2. RetryInterceptor  → retry 3x sur erreurs 5xx et timeout
// 3. LoggingInterceptor → logs structurés (uniquement en debug)
// 4. CacheInterceptor  → cache GET 5 minutes (dio_cache_interceptor)
```

### 2. AuthInterceptor — `lib/core/network/auth_interceptor.dart`
```dart
// onRequest → ajoute Authorization: Bearer {token}
// onError (401) → refresh token → retry la requête originale
// Si refresh échoue → logout (event BLoC AuthBloc)
// Token depuis : flutter_secure_storage
```

### 3. Retrofit Service — `lib/features/[feature]/data/datasources/[feature]_api_service.dart`
```dart
// @RestApi(baseUrl: "") — baseUrl héritée de Dio
// Méthodes standard REST :
//   @GET('/[resources]')         getAll({@Queries Map<String, dynamic> filters})
//   @GET('/[resources]/{id}')    getById(@Path() String id)
//   @POST('/[resources]')        create(@Body() Map<String, dynamic> body)
//   @PUT('/[resources]/{id}')    update(@Path() String id, @Body() Map<String, dynamic>)
//   @DELETE('/[resources]/{id}') delete(@Path() String id)
//   @POST('/[resources]/batch')  batchSync(@Body() List<Map<String, dynamic>> items)
// 
// Retourner les types ResponseModel correspondants
// Ajouter @Headers pour endpoints spéciaux (upload, etc.)
```

### 4. ApiResponse Wrapper — `lib/core/network/api_response.dart`
```dart
// Wrapper générique pour toutes les réponses API
// { data: T, message: String, success: bool, errors: List<String>?, 
//   pagination: Pagination? }
// Pagination { page, perPage, total, lastPage }
// fromJson avec factory generic
```

### 5. Gestion d'erreurs réseau — `lib/core/errors/`
```dart
// Exceptions (couche data) :
//   ServerException(statusCode, message)
//   NetworkException (pas de connexion)
//   TimeoutException
//   UnauthorizedException (401)
//   ForbiddenException (403)
//   NotFoundException (404)
//   ValidationException(errors: Map<String, List<String>>)

// Failures (couche domain - Either) :
//   ServerFailure, NetworkFailure, CacheFailure, 
//   UnauthorizedFailure, ValidationFailure(errors)

// NetworkExceptionMapper :
//   DioException → Exception typée → Failure
```

### 6. AppConfig — `lib/core/constants/app_config.dart`
```dart
// Gestion des environnements :
// dev  : apiBaseUrl, enableLogs=true, mockMode=false
// staging : apiBaseUrl, enableLogs=true
// prod : apiBaseUrl, enableLogs=false
// 
// Chargé depuis --dart-define ou .env selon la config CI
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', 
  defaultValue: 'http://10.0.2.2:8000/api'); // Android émulateur
```

### 7. Remote DataSource (implémentation) — `lib/features/[feature]/data/datasources/[feature]_remote_datasource.dart`
```dart
// Wraps le service Retrofit
// Convertit les réponses ApiResponse<T> en List<Model> ou Model
// Gère la pagination (retourne PaginatedResult<Model>)
// DioException → Exception typée (via NetworkExceptionMapper)
// Interface + Impl séparés pour la testabilité
```

## Commandes de génération Retrofit
```bash
# Après génération des fichiers :
dart run build_runner build --delete-conflicting-outputs
```

## Format de sortie
Tous les fichiers dans l'ordre, avec imports complets.
Inclure un exemple d'utilisation dans le Remote DataSource.
