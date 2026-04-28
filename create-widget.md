# Commande : Créer un Widget Réutilisable

Crée un widget Flutter **production-grade** dans `lib/core/widgets/`.

**Widget à créer :** $ARGUMENTS

## Spécifications obligatoires

### Structure du fichier
```
lib/core/widgets/
└── [nom_widget].dart
```

### Règles de génération

**1. Interface**
- Paramètres via constructeur avec `required` et optionnels avec valeurs par défaut
- `const` constructor si aucun état interne
- Documenter chaque paramètre avec `///` dartdoc

**2. Responsivité**
- Utiliser `LayoutBuilder` ou `MediaQuery` pour adaptation mobile/web
- Breakpoints depuis `AppBreakpoints` (core/constants)

**3. Design**
- Couleurs → `Theme.of(context).colorScheme.*` uniquement
- Typographie → `Theme.of(context).textTheme.*` uniquement
- Espacements → `AppSpacing.*` uniquement (multiples de 4)
- Animations → `AnimationController` ou `AnimatedSwitcher` si pertinent

**4. États à gérer** (selon le type de widget)
- Loading skeleton si le widget affiche des données async
- Empty state si le widget affiche une liste
- Error state avec message et bouton retry si applicable

**5. Accessibilité**
- `Semantics()` wrapper avec label descriptif
- Support `darkMode` automatique via Theme
- Tailles minimales touch target : 48x48 logical pixels

**6. Performance**
- `const` partout où possible
- `RepaintBoundary` si widget complexe et isolé
- Éviter rebuilds inutiles avec `Selector` ou `BlocSelector`

## Types de widgets courants — génère selon le nom

| Nom contient | Génère |
|---|---|
| `card` | Card avec ombre, border-radius 12, padding 16 |
| `button` | ElevatedButton/OutlinedButton/TextButton selon contexte |
| `input` | TextFormField stylé avec validation intégrée |
| `list` | ListView.builder avec separateur et pull-to-refresh |
| `empty` | Illustration SVG + titre + sous-titre + CTA optionnel |
| `loading` | Shimmer skeleton adapté au contexte |
| `badge` | Badge coloré avec compteur |
| `avatar` | CircleAvatar avec fallback initiales |
| `dialog` | AlertDialog stylé avec actions |
| `snackbar` | Helper statique success/error/info/warning |
| `chip` | FilterChip ou ChoiceChip stylé |
| `banner` | Bandeau informatif (offline, sync, warning) |

## Format de sortie
1. Fichier widget complet et fonctionnel
2. Exemple d'utilisation en commentaire en bas de fichier
3. Si le widget nécessite un BLoC → indiquer comment l'intégrer
