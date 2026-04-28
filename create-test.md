# Commande : Créer les Tests

Génère les tests complets pour un fichier ou une feature.

**Cible à tester :** $ARGUMENTS

## Détecter le type de test nécessaire

### Si usecase / domain → Unit Test
```dart
// test/features/[feature]/domain/usecases/[usecase]_test.dart
// - Mocker le repository avec mocktail
// - Tester le cas succès : Right(entity)
// - Tester le cas échec : Left(failure)  
// - Tester les validations de params
// - Vérifier les appels au repository (verify)
// Utiliser : flutter_test, mocktail
```

### Si repository / datasource → Unit Test
```dart
// test/features/[feature]/data/repositories/[repo]_test.dart
// Mocker : RemoteDataSource, LocalDataSource, ConnectivityService
// Scénarios OBLIGATOIRES :
//   ✓ Online + succès réseau → retourne données fraîches + sauvegarde local
//   ✓ Online + échec réseau → retourne données locales (fallback)
//   ✓ Offline → retourne données locales directement
//   ✓ Offline + write → sauvegarde local + enqueue sync
//   ✓ Erreur locale → Left(CacheFailure)
//   ✓ Données inexistantes → Left(NotFoundFailure)
```

### Si BLoC → BLoC Test
```dart
// test/features/[feature]/presentation/bloc/[feature]_bloc_test.dart
// Utiliser : bloc_test
// blocTest<FeatureBloc, FeatureState>(
//   'description claire du scénario',
//   build: () => FeatureBloc(mockUseCase),
//   act: (bloc) => bloc.add(LoadFeatureEvent()),
//   expect: () => [FeatureLoading(), FeatureLoaded(items: [...])],
// )
// Scénarios OBLIGATOIRES :
//   ✓ Chargement → Loading puis Loaded
//   ✓ Chargement → Loading puis Error
//   ✓ Création succès → OperationSuccess
//   ✓ Création échec → Error avec message
//   ✓ Suppression avec confirmation
//   ✓ Sync déclenchée après write
```

### Si Widget → Widget Test
```dart
// test/features/[feature]/presentation/widgets/[widget]_test.dart
// Utiliser : flutter_test, mocktail, bloc_test
// - Créer un MaterialApp wrapper avec le theme
// - Mocker le BLoC avec MockBloc
// - Tester :
//   ✓ Affichage correct des données
//   ✓ Rendu en état Loading (shimmer visible)
//   ✓ Rendu en état Empty (message visible)
//   ✓ Rendu en état Error (message + bouton retry visibles)
//   ✓ Tap sur un item → navigation correcte
//   ✓ Pull-to-refresh → event dispatché
```

### Si flow complet → Integration Test
```dart
// integration_test/[feature]_flow_test.dart
// Utiliser : integration_test, flutter_driver
// Scénario offline → sync :
//   1. Démarrer sans connexion (mock ConnectivityService)
//   2. Créer un item → vérifier apparition dans liste
//   3. Quitter et relancer l'app → item toujours présent (persisté)
//   4. Simuler reconnexion → vérifier sync (item marqué synced)
//   5. Vérifier aucune duplication
```

## Helpers de test à générer

**Fixtures** — `test/fixtures/[feature]_fixture.dart`
```dart
// Données de test réutilisables :
// final tEntity = FeatureEntity(id: 'test-uuid', ...);
// final tModel = FeatureModel.fromEntity(tEntity);
// final tDriftData = FeatureTableData(...);
// final tJson = {'id': 'test-uuid', ...};
// final tCreateParams = CreateFeatureParams(...);
```

**Mocks** — `test/mocks/[feature]_mocks.dart`
```dart
// class MockFeatureRepository extends Mock implements FeatureRepository {}
// class MockGetAllFeature extends Mock implements GetAllFeature {}
// class MockFeatureBloc extends MockBloc<FeatureEvent, FeatureState> implements FeatureBloc {}
// class MockConnectivityService extends Mock implements ConnectivityService {}
```

## Règles
- Chaque test → nom descriptif en français ("doit retourner les données locales quand offline")
- Groupe logiquement avec `group()`
- setUp() pour initialisation commune
- tearDown() pour nettoyage
- Couverture minimum 80% pour les usecases et repositories
- Pas de `sleep()` dans les tests → utiliser `pumpAndSettle()` ou `fakeAsync`

## Format de sortie
Fichier(s) de test complets, prêts à exécuter avec `flutter test`.
