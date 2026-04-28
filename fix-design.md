# Commande : Corriger et Améliorer le Design UI

Analyse et améliore le design d'un widget, page ou composant.

**Cible à améliorer :** $ARGUMENTS

## Analyse obligatoire avant de modifier

Inspecte le fichier cible et vérifie chaque point :

### ✅ Checklist Design

**Cohérence du Theme**
- [ ] Toutes les couleurs viennent de `Theme.of(context).colorScheme.*`
- [ ] Toutes les typos viennent de `Theme.of(context).textTheme.*`
- [ ] Aucune valeur de couleur hardcodée (Color(0x...) ou Colors.*)
- [ ] Support darkMode automatique (pas de conditions if darkMode)

**Espacements**
- [ ] Tous les paddings/margins sont des multiples de 4
- [ ] Utilisation de `AppSpacing.*` ou constantes nommées
- [ ] Consistance des espacements similaires dans l'écran

**Typographie**
- [ ] Hiérarchie visuelle claire (titre > sous-titre > corps > label)
- [ ] Pas de fontSize hardcodé (utiliser textTheme styles)
- [ ] Textes longs avec `overflow: TextOverflow.ellipsis` ou `maxLines`

**Responsive**
- [ ] Layout adaptatif (mobile / tablet / web)
- [ ] Pas de largeurs/hauteurs fixes absolues (préférer `double.infinity` ou `Flexible`)
- [ ] SafeArea correctement appliqué

**Accessibilité**
- [ ] `Semantics` sur les éléments interactifs sans texte visible
- [ ] Contrast ratio suffisant (4.5:1 pour le texte normal)
- [ ] Touch targets ≥ 48x48 logical pixels

**Performance**
- [ ] `const` sur les widgets statiques
- [ ] `RepaintBoundary` sur les animations complexes
- [ ] Images avec `fit: BoxFit.cover` et dimensions définies

**Material Design 3**
- [ ] Élévations via `elevation` + `shadowColor`, pas de boxShadow custom
- [ ] Formes via `ShapeBorder` (RoundedRectangleBorder), pas Container+decoration
- [ ] Boutons : ElevatedButton / FilledButton / OutlinedButton / TextButton (pas GestureDetector)
- [ ] Cartes : Card widget (pas Container avec BoxDecoration)

## Améliorations à appliquer

### Animations manquantes
Ajouter si pertinent :
- Transition de page : `FadeTransition` ou `SlideTransition` via go_router
- Apparition des items liste : `AnimationLimiter` + `AnimationConfiguration`
- Boutons : Feedback tactile (`HapticFeedback.lightImpact()`)
- Loading states : Shimmer skeleton (package shimmer)
- Indicateur sync : Icône rotative animée

### États visuels améliorés
- Loading → Skeleton shimmer adapté à la vraie structure du contenu
- Empty → Illustration SVG + message contextuel + CTA
- Error → Message lisible + icône + bouton retry
- Offline → Indicateur subtil (pas bloquant)

### Micro-interactions
- ListTile → `InkWell` avec borderRadius = card radius
- Bouton delete → confirmation AnimatedDialog
- Swipe actions → `Dismissible` avec background coloré
- Formulaire → focus automatique sur le premier champ

## Format de sortie
1. Liste des problèmes trouvés avec leur localisation (ligne)
2. Fichier corrigé complet
3. Explication des changements importants
