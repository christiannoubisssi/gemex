# Commande : Revue de Code et Optimisation

Analyse, critique et améliore le code d'un fichier ou d'une feature.

**Cible :** $ARGUMENTS

## Grille d'analyse complète

### 🏗️ Architecture
- [ ] Respect de la séparation des couches (domain ne dépend de rien, data dépend de domain)
- [ ] Pas de logique métier dans les widgets ou le BLoC
- [ ] UseCases avec une seule responsabilité
- [ ] Repository respecte le contrat de l'interface domain
- [ ] Pas d'accès direct à la DB depuis le BLoC

### 🔄 Offline / Sync
- [ ] Chaque write passe par local d'abord
- [ ] `isSynced` correctement géré
- [ ] SyncQueue utilisé pour les opérations offline
- [ ] Pas de perte de données en cas de coupure réseau
- [ ] Gestion des conflits documentée

### 🧱 BLoC
- [ ] Chaque Event a un handler dédié
- [ ] States immutables avec copyWith
- [ ] Pas de `await` non géré (utiliser `emit` dans les catch)
- [ ] `listenWhen`/`buildWhen` utilisés pour limiter les rebuilds
- [ ] Fermeture correcte des streams (close())

### ⚡ Performance
- [ ] `const` sur tous les widgets statiques identifiés
- [ ] Pas de `setState` inutile ou en cascade
- [ ] Listes avec `ListView.builder` (jamais de children avec map())
- [ ] Images avec cache et dimensions définies
- [ ] Pas de calculs lourds dans `build()`

### 🛡️ Gestion d'erreurs
- [ ] Tout `Future` encapsulé dans try/catch
- [ ] Exceptions converties en Failures (Either)
- [ ] L'utilisateur reçoit un message lisible pour chaque erreur
- [ ] Pas d'erreurs silencieuses (catch vides)
- [ ] Logs pour le debug (pas en prod)

### 🔒 Sécurité
- [ ] Tokens en SecureStorage (pas en SharedPreferences)
- [ ] Pas de données sensibles dans les logs
- [ ] Validation des inputs avant envoi à l'API
- [ ] Intercepteur 401 → logout automatique
- [ ] Pas de secrets hardcodés (URLs, clés API)

### 📱 UX / Accessibilité
- [ ] Loading states visibles pour toute opération > 300ms
- [ ] Feedback après chaque action (succès/erreur)
- [ ] Pas de bouton qui ne répond pas visuellement
- [ ] Textes avec contraste suffisant

### 🧪 Testabilité
- [ ] Dépendances injectées (pas de singletons statiques appelés directement)
- [ ] Pas de `DateTime.now()` direct (passer via une interface Clock)
- [ ] Pas de `Random()` direct dans la logique métier

## Format de sortie

**1. Rapport de revue**
```
🔴 CRITIQUE (à corriger avant de continuer)
🟡 IMPORTANT (à corriger bientôt)
🟢 SUGGESTION (amélioration optionnelle)
```

**2. Code corrigé**
Pour chaque problème critique et important → fournir le code corrigé.

**3. Résumé**
Score global /10 et priorités de correction.
