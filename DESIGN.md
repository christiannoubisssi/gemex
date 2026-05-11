# Gemex ERP - Design System & Spécifications

Ce document regroupe les jetons de style, le dictionnaire des champs et l'audit de conformité entre le mockup Stitch et la codebase actuelle.

## 1. Global Design System

### Palette de Couleurs (HEX)
| Token | Valeur Mockup (JSON) | Valeur Mockup (Text) | Code Actuel (`AppColors`) | Statut |
| :--- | :--- | :--- | :--- | :--- |
| **Primary** | `#004ac6` | `#2563EB` | `#2563EB` | ✅ (Texte) / ⚠️ (JSON) |
| **Secondary**| `#565e74` | `#0F172A` | `#0F172A` | ✅ (Texte) / ⚠️ (JSON) |
| **Background**| `#f7f9fb` | `#F8FAFC` | `#FFFFFF` | ❌ Discrépance |
| **Surface** | `#f7f9fb` | `#FFFFFF` | `#FFFFFF` | ✅ |
| **Error** | `#ba1a1a` | `#EF4444` | `#EF4444` | ✅ |

> [!IMPORTANT]
> Il existe une contradiction entre les jetons JSON (Material 3) et les directives textuelles du mockup. Le code suit actuellement les directives textuelles. Il est recommandé d'adopter le fond **Slate-50 (#F8FAFC)** pour réduire la fatigue visuelle.

### Typographie
*   **Police Principale** : Inter (Display-LG: 36px Bold, Body-MD: 14px Regular).
*   **Police Monospace** : JetBrains Mono (utilisée pour les montants FCFA et IDs).

### Composants Réutilisables Identifiés
1.  **Sidebar (Shell)** : Fixed 260px, Fond Deep Navy (#0F172A).
2.  **Data Tables** : Headers Slate-100, Row height 48px, Alignement monétaire à droite.
3.  **KPI Cards** : Valeurs en Display-LG avec indicateurs de tendance (+/- %).
4.  **Input Fields** : Hauteur standard 40px, bordure Slate-300, focus Primary Blue.

---

## 2. Dictionnaire des Champs (Consolidé)

### Module RH & Paie
| Champ ID | Label | Type | Usage |
| :--- | :--- | :--- | :--- |
| `field-employee-name` | Nom Complet | Texte | Fiche Employé |
| `field-gross-salary` | Salaire Brut | Devise | Paie |
| `field-net-pay` | Net à payer | Devise | Paie |
| `input-search-leaves` | Recherche congés | Texte | Gestion Congés |
| `select-period` | Période | Dropdown | Paie |

### Module Comptabilité
| Champ ID | Label | Type | Usage |
| :--- | :--- | :--- | :--- |
| `input-search-global` | Recherche globale | Texte | Dashboard / Journal |
| `input-date-range` | Intervalle | Date Range | Journal |
| `stat-total-amount` | Montant Total | KPI | Charges & Déclarations |
| `input-business-id` | SIRET / ID | Texte | Profil Entreprise |
| `table-tax-rates` | Taux de Taxe | Table | Fiscalité |

---

## 3. Audit de Conformité & Rapport d'Écarts

### Écarts Fonctionnels (Mockup vs Code)
| Fonction Mockup | ID Identifié | État dans le Code | Fichier Impacté |
| :--- | :--- | :--- | :--- |
| **Export SEPA** | `btn-export-sepa` | ❌ Manquant | `paie_screen.dart` |
| **Déclaration DSN** | `btn-dsn-declaration` | ❌ Manquant | `paie_screen.dart` |
| **Audit IA (Insights)** | `ai-audit-card` | ❌ Manquant | `comptabilite_screen.dart` |
| **Scanner Document** | `btn-scan-doc` | ❌ Manquant | `dossiers_list_screen.dart` |
| **Aperçu PDF (Batch)** | `btn-batch-export` | ❌ Manquant | `paie_screen.dart` |

### Audit des Champs
*   **Fichiers Flutter** : Les IDs de champs (`input-search-global`, etc.) ne sont pas utilisés comme clés de référence ou `ValueKey`. Le code utilise des `TextEditingController` locaux sans lien explicite avec les IDs du design system.
*   **Validation des Dépenses** : Le mockup prévoit un "Panneau Intelligence Gamis" pour l'audit IA, totalement absent de la version actuelle.

### Rapport d'Écarts de Style
1.  **Surfaces** : Le code utilise un fond `Colors.white` pur au lieu du `Slate-50` du mockup, ce qui rompt la hiérarchie visuelle des cartes (`Level 1` vs `Level 0`).
2.  **Navigation** : Le `SideNavBar` dans le code Flutter semble moins dense que les spécifications "Expert Density" (48px par ligne recommandés).
3.  **Graphiques** : La palette `_chartColors` dans `comptabilite_screen.dart` n'est pas synchronisée avec les jetons sémantiques du design system.

---
*Généré par Antigravity le 11 Mai 2026.*