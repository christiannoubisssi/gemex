# Commande : Créer un Modèle de Données Complet

Génère l'ensemble des couches de données pour un modèle.

**Modèle à créer :** $ARGUMENTS

## Ce que tu dois générer

### 1. Entity (Domain)
```dart
// lib/features/[feature]/domain/entities/[model].dart
// - Extends Equatable
// - Tous les champs final, types stricts
// - Pas d'import Flutter ni de packages externes
// - copyWith() complet
// - toString() lisible pour debug
// - Constructeur const
```

### 2. Drift Table (Data/Local)
```dart
// lib/features/[feature]/data/datasources/local/[model]_table.dart
// Champs OBLIGATOIRES dans toute table :
//   id           → TextColumn (UUID v4, primaryKey, clientDefault)
//   serverId     → TextColumn nullable (null si créé offline)
//   createdAt    → DateTimeColumn (clientDefault: DateTime.now)
//   updatedAt    → DateTimeColumn (clientDefault: DateTime.now)
//   isSynced     → BoolColumn (withDefault: false)
//   isDeleted    → BoolColumn (withDefault: false) ← soft delete
// + champs métier du modèle
// Indices sur les colonnes fréquemment filtrées
```

### 3. Model DTO (Data)
```dart
// lib/features/[feature]/data/models/[model]_model.dart
// - Annotations @JsonSerializable
// - fromJson / toJson
// - fromEntity($Entity entity) → $Model
// - toEntity() → $Entity
// - fromDrift($TableData data) → $Model  
// - toDriftCompanion() → $TableCompanion
// - Gestion des nullables et valeurs par défaut
// - Types DateTime → ISO8601 string en JSON
```

### 4. Params (Domain/UseCases)
```dart
// lib/features/[feature]/domain/usecases/params/
// Create[Model]Params — champs requis pour création
// Update[Model]Params — champs modifiables (tous optionnels)
// Filter[Model]Params — critères de recherche/filtrage
// Tous Equatable
```

### 5. Mapper Extension
```dart
// lib/features/[feature]/data/models/[model]_mapper.dart
// Extension sur l'entité et le modèle pour conversions
// Logique de mapping complexe (enum ↔ string, nested objects)
```

## Règles de typage

| Type métier | Dart | JSON | Drift |
|---|---|---|---|
| Identifiant | `String` (UUID) | `string` | `TextColumn` |
| Texte court | `String` | `string` | `TextColumn` |
| Texte long | `String` | `string` | `TextColumn` |
| Nombre entier | `int` | `number` | `IntColumn` |
| Décimal/Prix | `double` | `number` | `RealColumn` |
| Booléen | `bool` | `boolean` | `BoolColumn` |
| Date/Heure | `DateTime` | ISO8601 string | `DateTimeColumn` |
| Enum | `EnumType` | `string` | `TextColumn` + converter |
| Liste | `List<T>` | `array` | JSON string dans `TextColumn` |
| Objet imbriqué | `OtherEntity` | `object` | Relation ou JSON |

## Format de sortie
Générer les 5 fichiers dans l'ordre, chacun complet et compilable.
Indiquer les imports nécessaires pour chaque fichier.
