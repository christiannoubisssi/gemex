# Commande : Créer un Écran Complet

Génère une page Flutter complète, responsive, connectée à son BLoC.

**Écran à créer :** $ARGUMENTS

## Ce que tu dois générer

### 1. Analyse du contexte
Avant de générer, détermine automatiquement :
- S'agit-il d'une page **liste**, **détail**, **formulaire**, **dashboard**, **auth**, **settings** ?
- Quels widgets réutilisables de `lib/core/widgets/` peuvent être utilisés ?
- Quel BLoC existant connecter, ou faut-il en créer un nouveau ?

### 2. Structure de la page

```dart
// lib/features/[feature]/presentation/pages/[screen]_page.dart

class [Screen]Page extends StatelessWidget {
  // Paramètres de navigation via go_router
  // BlocProvider wrappé ici ou via injection go_router
  
  // Scaffold avec :
  // - AppBar personnalisé (actions contextuelles)
  // - Body avec BlocBuilder (gérer TOUS les états)
  // - Optionnel : BottomNavigationBar, FAB, BottomSheet
}
```

### 3. Gestion obligatoire de TOUS les états BLoC
```dart
// CHAQUE page doit gérer :
// Loading    → Shimmer skeleton (pas de CircularProgressIndicator générique)
// Loaded     → Contenu principal
// Empty      → EmptyStateWidget avec illustration + CTA
// Error      → ErrorWidget avec message + bouton "Réessayer"
// Offline    → Badge/bannière + contenu local disponible
```

### 4. Layout responsive (OBLIGATOIRE)
```dart
// Mobile (< 600px) : vue pleine largeur, navigation par drawer/bottom nav
// Tablet (600-1024px) : layout 2 colonnes si pertinent
// Desktop/Web (> 1024px) : sidebar + contenu, max-width 1200px centré

LayoutBuilder(builder: (context, constraints) {
  if (constraints.maxWidth > 1024) return _DesktopLayout();
  if (constraints.maxWidth > 600)  return _TabletLayout();
  return _MobileLayout();
})
```

### 5. Navigation
```dart
// Utiliser go_router uniquement (jamais Navigator.push directement)
// context.go('/route')    → remplace la stack
// context.push('/route')  → empile
// context.pop()           → retour
// Passer les paramètres via pathParameters ou extra
```

### 6. UX Patterns selon le type d'écran

**Liste :**
- `CustomScrollView` + `SliverAppBar` collapsible
- `RefreshIndicator` (pull-to-refresh → déclenche BLoC event)
- Pagination infinie (`ScrollController` + event LoadMore)
- Filtre/recherche en temps réel (debounce 300ms)
- Swipe-to-delete avec undo SnackBar (5s)
- Multi-sélection avec AppBar contextuelle

**Formulaire :**
- `Form` avec `GlobalKey<FormState>`
- Validation inline (onChanged) + globale (onSubmit)
- Auto-save brouillon en local (debounce 1s)
- Confirmation si modifications non sauvegardées (WillPopScope)
- Bouton submit : désactivé pendant loading, feedback visuel
- Keyboard scroll automatique (SingleChildScrollView)

**Dashboard :**
- Cards avec métriques clés
- Graphiques si données temporelles
- Actions rapides (shortcuts)
- Section "dernière sync" avec timestamp

**Détail :**
- Hero animation depuis la liste (tag = id de l'item)
- Actions flottantes (éditer, supprimer, partager)
- Scroll fluide (CustomScrollView + SliverList)

### 7. Gestion du cycle de vie
```dart
// Si besoin de listener unique (ex: notification push) :
// Utiliser BlocListener avec listenWhen pour éviter les doublons
// 
// onInit → dispatch LoadEvent
// onDispose → annuler streams si nécessaire (via StatefulWidget)
```

### 8. Feedback utilisateur
```dart
// Succès  → SnackBar vert, disparaît en 3s
// Erreur  → SnackBar rouge avec bouton "Retry"
// Warning → SnackBar orange
// Info    → SnackBar bleu
// Utiliser ScaffoldMessenger.of(context) dans BlocListener
```

### 9. Performance
- `const` sur tous les widgets statiques
- `AutomaticKeepAliveClientMixin` si la page est dans un `TabBarView`
- Images → `CachedNetworkImage` avec placeholder shimmer
- Listes longues → `ListView.builder` jamais `ListView` avec children

## Format de sortie
1. Fichier page complet
2. Si nouveaux widgets locaux nécessaires → les inclure dans le fichier
3. Snippet de route go_router à ajouter
4. Imports complets en tête de fichier
