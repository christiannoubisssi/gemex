# PROJECT_SPEC.md — AvarieApp
> Spécification fonctionnelle complète · Version 1.0 · Cabinet Commissaire d'Avarie · Gabon

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Fonctionnalités par module](#2-fonctionnalités-par-module)
3. [Écrans et navigation](#3-écrans-et-navigation)
4. [Entités et modèles de données](#4-entités-et-modèles-de-données)
5. [Services et APIs externes](#5-services-et-apis-externes)
6. [User stories](#6-user-stories)
7. [Règles de gestion](#7-règles-de-gestion)
8. [Hors périmètre](#8-hors-périmètre)

---

## 1. Vue d'ensemble

### Contexte
AvarieApp est l'application de gestion interne d'un cabinet de **commissaire d'avarie** au Gabon.
Un commissaire d'avarie est un expert mandaté par les compagnies d'assurance ou les armateurs
pour constater, évaluer et documenter les sinistres maritimes et autres dommages assurés.

### Utilisateurs cibles

| Rôle | Profil | Usage principal |
|------|--------|----------------|
| **admin** | Direction du cabinet | Configuration, supervision globale, validation |
| **expert** | Commissaire d'avarie | Création et suivi des dossiers de mission |
| **agent** | Assistant administratif | Saisie, classement, suivi administratif |
| **comptable** | Responsable comptabilité | Devis, factures, charges, analyses financières |
| **rh** | Responsable RH | Personnel, congés, salaires |

### Principes fondateurs
- **Offline d'abord** : toutes les fonctionnalités core fonctionnent sans internet
- **Simplicité** : maximum 3 actions pour accomplir n'importe quelle tâche
- **Multi-entreprise** : un même déploiement peut servir plusieurs cabinets isolés
- **Multi-pays** : fiscalité et devise configurables par entreprise

---

## 2. Fonctionnalités par module

### M01 · Authentification & Accès

| ID | Fonctionnalité | Priorité | Rôles |
|----|---------------|----------|-------|
| M01-F01 | Connexion par email + mot de passe | P0 | Tous |
| M01-F02 | Déconnexion | P0 | Tous |
| M01-F03 | Réinitialisation du mot de passe par email | P0 | Tous |
| M01-F04 | Session persistante (rester connecté) | P1 | Tous |
| M01-F05 | Verrouillage automatique après inactivité (configurable) | P2 | Tous |
| M01-F06 | Invitation d'un nouvel utilisateur par l'admin | P1 | admin |
| M01-F07 | Désactivation d'un utilisateur | P1 | admin |
| M01-F08 | Modification du profil (nom, photo, téléphone) | P1 | Tous |
| M01-F09 | Changement de mot de passe depuis le profil | P1 | Tous |

---

### M02 · Tableau de bord

| ID | Fonctionnalité | Priorité | Rôles |
|----|---------------|----------|-------|
| M02-F01 | KPIs dossiers (total, en cours, nouveaux, clos) | P0 | admin, expert |
| M02-F02 | Chiffre d'affaires du mois en cours | P0 | admin, comptable |
| M02-F03 | Total des créances (factures non payées) | P0 | admin, comptable |
| M02-F04 | Total des charges du mois | P0 | admin, comptable |
| M02-F05 | Liste des dossiers urgents (priorité haute/urgente) | P0 | admin, expert |
| M02-F06 | Dossiers avec deadline dépassée | P1 | admin, expert |
| M02-F07 | Factures en retard de paiement | P1 | admin, comptable |
| M02-F08 | Graphique CA mensuel sur 12 mois glissants | P1 | admin, comptable |
| M02-F09 | Graphique répartition dossiers par type de mission | P2 | admin |
| M02-F10 | Tableau de bord RH (congés du mois, salaires à valider) | P1 | admin, rh |
| M02-F11 | Accès rapides vers les actions fréquentes | P0 | Tous |
| M02-F12 | Indicateur de connexion (mode offline visible) | P0 | Tous |
| M02-F13 | Nombre d'éléments non synchronisés | P1 | Tous |

---

### M03 · Gestion des dossiers d'expertise

#### M03-A · Cycle de vie du dossier

| ID | Fonctionnalité | Priorité | Rôles |
|----|---------------|----------|-------|
| M03-F01 | Créer un nouveau dossier (offline capable) | P0 | admin, expert, agent |
| M03-F02 | Numérotation automatique AV-AAAA-NNNN | P0 | Système |
| M03-F03 | Numéro temporaire LOCAL-AAAA-NNNN si offline | P0 | Système |
| M03-F04 | Remplacement du numéro temporaire à la sync | P0 | Système |
| M03-F05 | Modifier un dossier | P0 | admin, expert |
| M03-F06 | Archiver / Clore un dossier | P0 | admin, expert |
| M03-F07 | Annuler un dossier (avec motif obligatoire) | P1 | admin |
| M03-F08 | Dupliquer un dossier (nouveau dossier pré-rempli) | P2 | admin, expert |

#### M03-B · Informations du dossier

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M03-F09 | Titre et description du sinistre | P0 |
| M03-F10 | Nature du sinistre (liste configurable) | P0 |
| M03-F11 | Lieu du sinistre | P0 |
| M03-F12 | Date du sinistre | P0 |
| M03-F13 | Montant déclaré du sinistre | P0 |
| M03-F14 | Compagnie d'assurance + N° de police + courtier | P0 |
| M03-F15 | Expert assigné au dossier | P0 |
| M03-F16 | Client associé | P0 |
| M03-F17 | Type de mission | P0 |
| M03-F18 | Priorité (basse / normale / haute / urgente) | P0 |
| M03-F19 | Deadline / échéance | P1 |
| M03-F20 | Notes internes (visibles uniquement en interne) | P0 |
| M03-F21 | Observations (pour le rapport) | P1 |
| M03-F22 | Dates auto-remplies selon changement de statut | P0 |

#### M03-C · Workflow et statuts

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M03-F23 | Workflow : nouveau → en instruction → expertise en cours → rapport rédigé → clos | P0 |
| M03-F24 | Changement de statut en 1 tap avec confirmation | P0 |
| M03-F25 | Rétrogradation de statut interdite (workflow à sens unique) | P0 |
| M03-F26 | Passage à "annulé" possible depuis tout statut (sauf clos) | P1 |
| M03-F27 | Historique des changements de statut (qui, quand) | P1 |

#### M03-D · Recherche et filtres

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M03-F28 | Recherche full-text (numéro, titre, lieu, client) | P0 |
| M03-F29 | Filtre par statut | P0 |
| M03-F30 | Filtre par priorité | P0 |
| M03-F31 | Filtre par expert assigné | P1 |
| M03-F32 | Filtre par type de mission | P1 |
| M03-F33 | Filtre par période (date d'ouverture) | P1 |
| M03-F34 | Tri (date, priorité, statut) | P1 |

---

### M04 · Pièces jointes & Photos terrain

| ID | Fonctionnalité | Priorité | Notes |
|----|---------------|----------|-------|
| M04-F01 | Joindre un fichier à un dossier (PDF, Word, Excel) | P0 | Via file_picker |
| M04-F02 | Prendre une photo depuis la caméra | P0 | Via image_picker |
| M04-F03 | Importer depuis la galerie | P0 | Via image_picker |
| M04-F04 | Horodatage automatique des photos | P0 | Timestamp local |
| M04-F05 | Géolocalisation automatique des photos terrain | P1 | GPS si permission |
| M04-F06 | Note / légende sur chaque fichier | P1 | |
| M04-F07 | Catégorie de la pièce (photo sinistre, rapport, contrat, autre) | P0 | |
| M04-F08 | Visualisation des fichiers depuis le dossier | P0 | |
| M04-F09 | Suppression d'une pièce jointe | P1 | Admin seulement |
| M04-F10 | Upload en arrière-plan dès retour connexion | P0 | Sync offline |
| M04-F11 | Indicateur d'upload en attente | P0 | |
| M04-F12 | Taille max par fichier : 20 Mo | P0 | Configurable |

---

### M05 · Gestion des clients

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M05-F01 | Créer une fiche client | P0 |
| M05-F02 | Types de client : entreprise, particulier, assurance, armateur | P0 |
| M05-F03 | Informations : nom, contact, email, téléphone, adresse, ville, pays | P0 |
| M05-F04 | Notes libres sur le client | P1 |
| M05-F05 | Modifier les informations client | P0 |
| M05-F06 | Historique des dossiers par client | P0 |
| M05-F07 | Historique des factures par client | P0 |
| M05-F08 | Solde client (total facturé - total payé) | P0 |
| M05-F09 | Alerte client avec solde en retard | P1 |
| M05-F10 | Recherche client (nom, email, téléphone) | P0 |
| M05-F11 | Filtre par type de client | P1 |
| M05-F12 | Archiver un client inactif | P2 |

---

### M06 · Devis

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M06-F01 | Créer un devis lié à un dossier | P0 |
| M06-F02 | Créer un devis sans dossier (devis autonome) | P1 |
| M06-F03 | Numérotation automatique DEV-AAAA-NNNN | P0 |
| M06-F04 | Sélection du client | P0 |
| M06-F05 | Ajout de lignes (désignation, quantité, unité, prix unitaire) | P0 |
| M06-F06 | Calcul automatique montant HT par ligne | P0 |
| M06-F07 | Calcul automatique TVA (taux pré-rempli, modifiable) | P0 |
| M06-F08 | Calcul automatique TPS (taux pré-rempli, modifiable) | P0 |
| M06-F09 | Total TTC calculé en temps réel | P0 |
| M06-F10 | Objet, conditions de vente, notes | P1 |
| M06-F11 | Date d'émission et date de validité | P0 |
| M06-F12 | Statuts : brouillon / envoyé / accepté / refusé / expiré | P0 |
| M06-F13 | Génération PDF du devis (offline) | P0 |
| M06-F14 | Aperçu PDF avant envoi | P0 |
| M06-F15 | Envoi du devis par email (depuis l'app) | P1 |
| M06-F16 | Convertir un devis accepté en facture | P0 |
| M06-F17 | Dupliquer un devis | P1 |
| M06-F18 | Modifier un devis (sauf si déjà converti en facture) | P0 |

---

### M07 · Facturation

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M07-F01 | Créer une facture depuis un devis accepté | P0 |
| M07-F02 | Créer une facture directe (sans devis préalable) | P1 |
| M07-F03 | Numérotation automatique FAC-AAAA-NNNN (annuelle) | P0 |
| M07-F04 | Lignes de facture (désignation, qté, unité, prix) | P0 |
| M07-F05 | Calcul automatique TVA + TPS + TTC | P0 |
| M07-F06 | Date d'émission et date d'échéance | P0 |
| M07-F07 | Statuts : brouillon / émise / partiellement payée / payée / annulée | P0 |
| M07-F08 | Enregistrement d'un paiement (montant, date, mode) | P0 |
| M07-F09 | Calcul automatique du montant restant | P0 |
| M07-F10 | Génération PDF de la facture (offline) | P0 |
| M07-F11 | Mise en page personnalisable (logo, en-tête, pied de page) | P1 |
| M07-F12 | Envoi de la facture par email | P1 |
| M07-F13 | Aperçu PDF avant envoi | P0 |
| M07-F14 | Annuler une facture (avec motif) | P1 |
| M07-F15 | Relance automatique à l'échéance | P2 |
| M07-F16 | Avoir / note de crédit | P2 |
| M07-F17 | Modes de paiement : virement, mobile money (Airtel/Moov), espèces | P0 |

---

### M08 · Comptabilité simplifiée

| ID | Fonctionnalité | Priorité | Notes |
|----|---------------|----------|-------|
| M08-F01 | Enregistrer une charge (catégorie, montant, date) | P0 | |
| M08-F02 | Catégories de charges : loyer, transport, fournitures, télécoms, honoraires externes, impôts, assurance, matériel, autre | P0 | |
| M08-F03 | Joindre un justificatif à une charge | P1 | |
| M08-F04 | Lier une charge à un dossier | P1 | |
| M08-F05 | Analyse CA mensuel (issu des factures émises) | P0 | Vue calculée |
| M08-F06 | Analyse CA par type de mission | P0 | Vue calculée |
| M08-F07 | Total charges par catégorie | P0 | Vue calculée |
| M08-F08 | Résultat brut (CA - charges) par mois | P0 | Vue calculée |
| M08-F09 | Comparaison mois N vs mois N-1 | P1 | |
| M08-F10 | Export CSV/Excel des produits et charges | P1 | Pour cabinet comptable |
| M08-F11 | Filtre par période (mois, trimestre, année) | P0 | |
| M08-F12 | Comptabilisation automatique des salaires payés comme charges | P0 | Trigger automatique |

---

### M09 · Ressources Humaines

#### M09-A · Personnel

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M09-F01 | Fiche personnel (nom, prénom, poste, département) | P0 |
| M09-F02 | Type de contrat : CDI, CDD, stage, consultant, intérim | P0 |
| M09-F03 | Dates de contrat (embauche, fin si applicable) | P0 |
| M09-F04 | Salaire de base référence | P0 |
| M09-F05 | Lien avec le compte utilisateur de l'app (optionnel) | P1 |
| M09-F06 | Archiver un employé inactif | P1 |

#### M09-B · Planning et congés

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M09-F07 | Saisir une absence / congé (type, dates) | P0 |
| M09-F08 | Types : congé annuel, maladie, sans solde, formation | P0 |
| M09-F09 | Vue calendrier des absences du mois | P1 |
| M09-F10 | Solde de congés par employé | P1 |
| M09-F11 | Validation des demandes de congé par l'admin | P1 |

#### M09-C · Paie simplifiée

| ID | Fonctionnalité | Priorité | Notes |
|----|---------------|----------|-------|
| M09-F12 | Saisir le salaire mensuel d'un employé (net pré-calculé) | P0 | Pas de moteur de paie |
| M09-F13 | Champs : brut, CNPS employé, IRPP, autres retenues, net | P0 | |
| M09-F14 | Statuts : en attente / validé / payé | P0 | |
| M09-F15 | Valider les salaires du mois par lot (multi-sélection) | P0 | |
| M09-F16 | Marquer comme payé avec date et mode de paiement | P0 | |
| M09-F17 | Comptabilisation automatique dès statut = payé | P0 | Charge auto créée |
| M09-F18 | Export de la fiche de paie mensuelle (PDF simple) | P1 | |
| M09-F19 | Historique des salaires par employé | P1 | |

---

### M10 · Paramètres & Administration

| ID | Fonctionnalité | Priorité | Rôles |
|----|---------------|----------|-------|
| M10-F01 | Modifier les informations de l'entreprise | P0 | admin |
| M10-F02 | Charger le logo du cabinet | P0 | admin |
| M10-F03 | Configurer l'en-tête et le pied de page des documents | P0 | admin |
| M10-F04 | Configurer les taux TVA et TPS | P0 | admin |
| M10-F05 | Configurer la devise | P0 | admin |
| M10-F06 | Gérer les types de mission (CRUD) | P1 | admin |
| M10-F07 | Gérer les natures de sinistre (CRUD) | P1 | admin |
| M10-F08 | Gérer les utilisateurs (liste, inviter, désactiver) | P0 | admin |
| M10-F09 | Modifier le rôle d'un utilisateur | P0 | admin |
| M10-F10 | Prévisualiser un modèle de document (devis/facture) | P1 | admin |
| M10-F11 | Ajouter un second cabinet (multi-entreprise) | P2 | super-admin |
| M10-F12 | Choisir les modules actifs (ex : masquer RH si non utilisé) | P2 | admin |

---

### M11 · Synchronisation offline/online

| ID | Fonctionnalité | Priorité |
|----|---------------|----------|
| M11-F01 | Toutes les lectures se font depuis Drift (local) | P0 |
| M11-F02 | Toutes les écritures créent d'abord un enregistrement local | P0 |
| M11-F03 | Détection automatique du retour de connexion | P0 |
| M11-F04 | Synchronisation automatique au retour de connexion | P0 |
| M11-F05 | File d'attente des actions offline (queue) | P0 |
| M11-F06 | Badge sur les éléments non synchronisés | P0 |
| M11-F07 | Remplacement des numéros temporaires à la sync | P0 |
| M11-F08 | Log des conflits de synchronisation | P1 |
| M11-F09 | Résolution manuelle d'un conflit (cas exceptionnel) | P2 |
| M11-F10 | Synchronisation forcée manuelle (bouton "Synchroniser") | P1 |

---

## 3. Écrans et navigation

### 3.1 Arborescence complète

```
AvarieApp
│
├── /login                          Connexion
│   └── /login/reset-password       Réinitialisation mot de passe
│
├── /                               Tableau de bord (home)
│
├── /dossiers                       Liste des dossiers
│   ├── /dossiers/new               Nouveau dossier (formulaire)
│   ├── /dossiers/:id               Détail d'un dossier
│   │   ├── /dossiers/:id/edit      Modifier le dossier
│   │   ├── /dossiers/:id/pieces    Pièces jointes du dossier
│   │   ├── /dossiers/:id/devis     Devis liés au dossier
│   │   └── /dossiers/:id/factures  Factures liées au dossier
│   └── /dossiers/new               Formulaire nouveau dossier
│
├── /clients                        Liste des clients
│   ├── /clients/new                Nouveau client
│   └── /clients/:id                Fiche client
│       └── /clients/:id/edit       Modifier le client
│
├── /devis                          Liste des devis
│   ├── /devis/new                  Nouveau devis
│   └── /devis/:id                  Détail du devis
│       └── /devis/:id/edit         Modifier le devis
│
├── /factures                       Liste des factures
│   ├── /factures/new               Nouvelle facture directe
│   └── /factures/:id               Détail de la facture
│
├── /comptabilite                   Tableau de bord comptabilité
│   ├── /comptabilite/charges       Liste des charges
│   ├── /comptabilite/charges/new   Saisir une charge
│   └── /comptabilite/analyses      Analyses et rapports
│
├── /rh                             Tableau de bord RH
│   ├── /rh/personnel               Liste du personnel
│   │   ├── /rh/personnel/new       Nouveau membre
│   │   └── /rh/personnel/:id       Fiche employé
│   ├── /rh/conges                  Gestion des congés
│   └── /rh/paie                    Gestion de la paie
│       └── /rh/paie/:mois/:annee   Paie d'un mois donné
│
├── /parametres                     Paramètres
│   ├── /parametres/entreprise      Infos + logo + en-tête
│   ├── /parametres/documents       Mise en page des documents
│   ├── /parametres/fiscalite       TVA, TPS, devise
│   ├── /parametres/types-mission   Types de mission
│   └── /parametres/utilisateurs    Gestion des utilisateurs
│
└── /profil                         Profil de l'utilisateur connecté
```

### 3.2 Description des écrans principaux

#### `/login` — Connexion
- Champs : email, mot de passe
- Bouton "Mot de passe oublié" → `/login/reset-password`
- Session persistante (rester connecté)
- Logo et nom du cabinet visibles
- Message d'erreur inline (pas de dialog)

#### `/` — Tableau de bord
- Bannière offline si hors connexion
- Bloc KPIs dossiers (total, en cours, nouveaux, clos)
- Bloc KPIs financiers (CA mois, créances, charges) — visible comptable/admin
- Grille accès rapides (6 raccourcis)
- Liste dossiers urgents (priorité haute/urgente, max 5)
- Actualisation par pull-to-refresh

#### `/dossiers` — Liste des dossiers
- Barre de recherche persistante en haut
- Filtres rapides par statut (chips horizontaux scrollables)
- Liste avec : numéro, titre, client, statut, priorité, date
- Badge "Local" orange si non synchronisé
- FAB "Nouveau dossier"
- Tri par date de création (défaut) ou priorité

#### `/dossiers/new` et `/dossiers/:id/edit` — Formulaire dossier
- Sections accordéon : Informations principales · Assurance · Statut & Priorité · Notes
- Date picker natif
- Dropdown avec recherche pour le client
- Validation inline (pas de dialog)
- Bouton "Enregistrer" fixe en bas
- Fonctionne 100% offline

#### `/dossiers/:id` — Détail dossier
- En-tête : numéro, titre, statut, priorité
- Bouton workflow (passer au statut suivant)
- Onglets ou sections scrollables :
  - **Informations** : sinistre, assurance, dates, expert, client
  - **Pièces jointes** : grille de fichiers/photos
  - **Documents** : devis et factures liés
  - **Notes internes**
- Actions rapides : Créer devis, Ajouter photo, Modifier

#### `/clients/:id` — Fiche client
- En-tête : type, nom, contact
- Onglets : **Informations** · **Dossiers** · **Factures**
- Solde (facturé vs payé) en évidence
- Bouton "Nouveau dossier pour ce client"

#### `/devis/:id` — Détail devis
- En-tête : numéro, statut, client, date
- Tableau des lignes (désignation, qté, prix unit, total HT)
- Pied : sous-total HT, TVA (x%), TPS (x%), **Total TTC**
- Boutons : Aperçu PDF · Envoyer · Convertir en facture

#### `/factures/:id` — Détail facture
- Même structure que le devis
- Section paiements reçus (liste + total)
- Montant restant en évidence (rouge si en retard)
- Boutons : Aperçu PDF · Envoyer · Enregistrer paiement

#### `/comptabilite/analyses` — Analyses financières
- Sélecteur de période (mois/trimestre/année)
- Tableau : CA HT, CA TTC, Charges, Résultat brut
- Graphique CA mensuel (barres) sur 12 mois
- Tableau CA par type de mission
- Bouton Export CSV

#### `/rh/paie/:mois/:annee` — Paie mensuelle
- Liste des employés actifs avec champs salaire du mois
- Statut par ligne : en attente / validé / payé
- Multi-sélection + "Valider la sélection" / "Marquer comme payé"
- Total de la masse salariale nette du mois
- Confirmation avant validation (irréversible)

#### `/parametres/documents` — Mise en page documents
- Aperçu live d'un document fictif
- Upload logo (glisser-déposer ou sélecteur)
- Éditeur en-tête (texte riche simple)
- Éditeur pied de page
- Mentions légales
- Bouton "Aperçu PDF complet"

---

## 4. Entités et modèles de données

### 4.1 Entreprise

```
Entreprise
├── id                UUID PK
├── nom               TEXT
├── pays              TEXT (défaut: 'Gabon')
├── devise            TEXT (défaut: 'XAF')
├── tva_taux          NUMERIC (défaut: 18.00)
├── tps_taux          NUMERIC (défaut: 0.00)
├── logo_url          TEXT nullable
├── adresse           TEXT nullable
├── telephone         TEXT nullable
├── email             TEXT nullable
├── entete_texte      TEXT nullable   ← en-tête des documents
├── pied_texte        TEXT nullable   ← pied de page des documents
├── mentions_legales  TEXT nullable
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP
```

### 4.2 Utilisateur

```
Utilisateur
├── id                UUID PK (= id auth.users Supabase)
├── entreprise_id     UUID FK → Entreprise
├── nom               TEXT
├── prenom            TEXT nullable
├── email             TEXT
├── role              ENUM (admin | expert | agent | comptable | rh)
├── telephone         TEXT nullable
├── actif             BOOLEAN (défaut: true)
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP
```

### 4.3 Client

```
Client
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── reference         TEXT nullable (auto-généré optionnel)
├── type_client       ENUM (entreprise | particulier | assurance | armateur)
├── nom               TEXT
├── contact_nom       TEXT nullable
├── email             TEXT nullable
├── telephone         TEXT nullable
├── adresse           TEXT nullable
├── ville             TEXT nullable
├── pays              TEXT (défaut: 'Gabon')
├── notes             TEXT nullable
├── total_facture     NUMERIC calculé
├── total_paye        NUMERIC calculé
├── sync_status       ENUM (synced | pending | conflict)
├── local_id          TEXT nullable
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP

Relations :
└── 1 Client → N Dossiers
└── 1 Client → N Factures
```

### 4.4 TypeMission

```
TypeMission
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── libelle           TEXT
├── code              TEXT nullable (ex: 'AVC')
├── description       TEXT nullable
├── taux_honoraire    NUMERIC nullable (% du sinistre)
├── tarif_forfait     NUMERIC nullable
├── actif             BOOLEAN
└── created_at        TIMESTAMP

Valeurs par défaut :
- Avarie commune (AVC)
- Avarie particulière (AVP)
- Expertise contradictoire (EXC)
- Constat de sinistre (CNS)
- Rapport de visite (RPV)
- Certificat de perte (CDP)
```

### 4.5 Dossier ← entité centrale

```
Dossier
├── id                    UUID PK
├── entreprise_id         UUID FK → Entreprise
├── client_id             UUID FK → Client nullable
├── expert_id             UUID FK → Utilisateur nullable
├── type_mission_id       UUID FK → TypeMission nullable
│
├── numero                TEXT UNIQUE nullable (généré par trigger Supabase)
├── annee                 INTEGER
│
├── titre                 TEXT
├── description           TEXT nullable
├── date_sinistre         DATE nullable
├── lieu_sinistre         TEXT nullable
├── nature_sinistre       TEXT nullable
├── montant_sinistre      NUMERIC nullable
│
├── statut                ENUM (nouveau | en_instruction | expertise_en_cours |
│                               rapport_redige | clos | annule)
├── priorite              ENUM (basse | normale | haute | urgente)
│
├── date_ouverture        DATE (défaut: aujourd'hui)
├── date_expertise        DATE nullable (auto-rempli au changement de statut)
├── date_rapport          DATE nullable (auto-rempli)
├── date_cloture          DATE nullable (auto-rempli)
├── deadline              DATE nullable
│
├── compagnie_assurance   TEXT nullable
├── numero_police         TEXT nullable
├── courtier              TEXT nullable
│
├── notes_internes        TEXT nullable
├── observations          TEXT nullable
├── motif_annulation      TEXT nullable
│
├── sync_status           ENUM (synced | pending | conflict)
├── local_id              UUID (généré offline, = id si créé en ligne)
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP

Relations :
└── 1 Dossier → N PiecesJointes
└── 1 Dossier → N Devis
└── 1 Dossier → N Factures
└── 1 Dossier → N Charges (charges liées à la mission)
```

### 4.6 PieceJointe

```
PieceJointe
├── id                UUID PK
├── dossier_id        UUID FK → Dossier
├── nom               TEXT
├── type_fichier      ENUM (photo_sinistre | rapport | contrat | facture_fournisseur | autre)
├── url_storage       TEXT (Supabase Storage)
├── taille_bytes      INTEGER nullable
├── uploade_par       UUID FK → Utilisateur
├── latitude          NUMERIC nullable
├── longitude         NUMERIC nullable
├── horodatage        TIMESTAMP
├── notes             TEXT nullable
├── sync_status       ENUM (synced | pending)
└── created_at        TIMESTAMP
```

### 4.7 Devis

```
Devis
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── dossier_id        UUID FK → Dossier nullable
├── client_id         UUID FK → Client
├── cree_par          UUID FK → Utilisateur
│
├── numero            TEXT UNIQUE (DEV-AAAA-NNNN)
├── annee             INTEGER
│
├── statut            ENUM (brouillon | envoye | accepte | refuse | expire)
│
├── date_emission     DATE
├── date_validite     DATE (défaut: +30 jours)
│
├── montant_ht        NUMERIC
├── taux_tva          NUMERIC (copié depuis Entreprise à la création)
├── montant_tva       NUMERIC
├── taux_tps          NUMERIC
├── montant_tps       NUMERIC
├── montant_ttc       NUMERIC
│
├── objet             TEXT nullable
├── conditions        TEXT nullable
├── notes             TEXT nullable
│
├── sync_status       ENUM (synced | pending | conflict)
├── local_id          UUID
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP

Relations :
└── 1 Devis → N DevisLignes
└── 1 Devis → 0..1 Facture (si converti)
```

### 4.8 DevisLigne / FactureLigne

```
DevisLigne (même structure pour FactureLigne)
├── id                UUID PK
├── devis_id          UUID FK → Devis
├── ordre             INTEGER (pour réordonner)
├── designation       TEXT
├── description       TEXT nullable
├── quantite          NUMERIC
├── unite             TEXT (forfait | heure | jour | km | autre)
├── prix_unit         NUMERIC
├── montant_ht        NUMERIC (calculé : quantite × prix_unit)
└── created_at        TIMESTAMP
```

### 4.9 Facture

```
Facture
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── dossier_id        UUID FK → Dossier nullable
├── client_id         UUID FK → Client
├── devis_id          UUID FK → Devis nullable (si issue d'un devis)
├── cree_par          UUID FK → Utilisateur
│
├── numero            TEXT UNIQUE (FAC-AAAA-NNNN)
├── annee             INTEGER
│
├── statut            ENUM (brouillon | emise | partiellement_payee | payee | annulee)
│
├── date_emission     DATE
├── date_echeance     DATE
├── date_paiement     DATE nullable
│
├── montant_ht        NUMERIC
├── taux_tva          NUMERIC
├── montant_tva       NUMERIC
├── taux_tps          NUMERIC
├── montant_tps       NUMERIC
├── montant_ttc       NUMERIC
├── montant_paye      NUMERIC (défaut: 0)
├── montant_restant   NUMERIC (calculé : ttc - paye)
│
├── mode_paiement     TEXT nullable (virement | mobile_money | especes | cheque)
├── reference_paiement TEXT nullable
│
├── objet             TEXT nullable
├── conditions        TEXT nullable
├── notes             TEXT nullable
├── motif_annulation  TEXT nullable
│
├── sync_status       ENUM
├── local_id          UUID
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP
```

### 4.10 Charge

```
Charge
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── dossier_id        UUID FK → Dossier nullable
├── saisi_par         UUID FK → Utilisateur
│
├── categorie         ENUM (loyer | salaires | transport | fournitures |
│                          telecommunication | honoraires_externes |
│                          impots_taxes | assurance | materiel | autre)
├── libelle           TEXT
├── montant           NUMERIC
├── date_charge       DATE
├── mois              INTEGER (1-12)
├── annee             INTEGER
├── justificatif_url  TEXT nullable
├── notes             TEXT nullable
│
├── sync_status       ENUM
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP
```

### 4.11 Personnel

```
Personnel
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── utilisateur_id    UUID FK → Utilisateur nullable
├── nom               TEXT
├── prenom            TEXT nullable
├── poste             TEXT nullable
├── departement       TEXT nullable
├── type_contrat      ENUM (CDI | CDD | stage | consultant | interim)
├── date_embauche     DATE nullable
├── date_fin_contrat  DATE nullable
├── salaire_base      NUMERIC nullable (référence, pas utilisé pour le calcul)
├── actif             BOOLEAN
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP
```

### 4.12 Salaire

```
Salaire
├── id                UUID PK
├── entreprise_id     UUID FK → Entreprise
├── personnel_id      UUID FK → Personnel
│
├── mois              INTEGER (1-12)
├── annee             INTEGER
│
├── salaire_brut      NUMERIC
├── cnps              NUMERIC (part employé)
├── irpp              NUMERIC
├── autres_retenues   NUMERIC
├── salaire_net       NUMERIC  ← saisie principale
│
├── statut            ENUM (en_attente | valide | paye)
├── date_validation   TIMESTAMP nullable
├── valide_par        UUID FK → Utilisateur nullable
├── date_paiement     DATE nullable
├── mode_paiement     TEXT nullable
│
├── comptabilise      BOOLEAN (défaut: false)
├── charge_id         UUID FK → Charge nullable (créée automatiquement)
│
├── notes             TEXT nullable
├── created_at        TIMESTAMP
└── updated_at        TIMESTAMP

Contrainte : UNIQUE (personnel_id, mois, annee)
```

---

## 5. Services et APIs externes

### 5.1 Supabase (backend principal)

| Service | Usage | Coût |
|---------|-------|------|
| **Auth** | Authentification email/password, gestion sessions | Gratuit (plan Free) |
| **PostgreSQL** | Base de données principale, RLS multi-tenant | Free → Pro $25/mois |
| **Storage** | Pièces jointes, photos terrain, logos | 1GB gratuit, puis $0.021/GB |
| **Realtime** | Sync en temps réel entre utilisateurs du même cabinet | Inclus |
| **Edge Functions** | Envoi d'emails (Resend), webhooks | 500k invocations/mois gratuit |
| **Row Level Security** | Isolation des données par entreprise | Inclus |

**Configuration requise :**
- URL du projet : `https://[id].supabase.co`
- Clé anonyme (anon key) : dans `lib/core/config/supabase_config.dart`
- Région recommandée : West EU (Ireland) — latence acceptable depuis le Gabon

### 5.2 Resend (emails transactionnels)

| Usage | Détail |
|-------|--------|
| Envoi de devis par email | PDF en pièce jointe |
| Envoi de factures par email | PDF en pièce jointe |
| Relances clients | Template HTML |
| Invitation de nouveaux utilisateurs | Lien d'activation |

**Intégration :** Via Supabase Edge Functions (pas d'appel direct depuis l'app Flutter).
**Coût :** 3 000 emails/mois gratuits. Pro : $20/mois pour 50 000 emails.
**Prérequis :** Domaine email vérifié (ex: `facturation@votrecabinet.ga`).

### 5.3 Firebase Cloud Messaging (notifications push)

| Usage | Détail |
|-------|--------|
| Alerte paiement reçu | Notification push sur Android |
| Nouveau dossier assigné | Notification à l'expert désigné |
| Deadline approchante | 24h avant l'échéance |
| Sync terminée (après offline) | Confirmation silencieuse |

**Coût :** Entièrement gratuit (pas de limite de messages).
**Intégration :** Package `firebase_messaging` + `flutter_local_notifications`.

### 5.4 Vercel (hébergement web)

| Usage | Détail |
|-------|--------|
| Hébergement Flutter Web | Build statique déployé automatiquement |
| Domaine custom | `app.votrecabinet.ga` ou `.com` |
| SSL automatique | Inclus |
| CDN mondial | Inclus |

**Coût :** Hobby gratuit (usage personnel/test). Pro : $20/mois (domaine custom + équipe).
**Déploiement :** GitHub Actions → `flutter build web --release` → push sur Vercel.

### 5.5 Services non utilisés (décisions actées)

| Service | Raison d'exclusion |
|---------|-------------------|
| Stripe / PayPal | Non disponibles au Gabon comme marchand |
| OpenAI | Plus cher que nécessaire, pas de cas d'usage identifié |
| AWS S3 direct | Remplacé par Supabase Storage |
| Firebase Firestore | Remplacé par Supabase PostgreSQL |
| Backend Node/Django custom | Remplacé par Supabase Edge Functions |

---

## 6. User stories

### Priorité 0 — Fondamentaux (MVP)

---

**US-001 · Connexion**
> En tant qu'utilisateur du cabinet,
> je veux me connecter avec mon email et mon mot de passe,
> afin d'accéder à mes dossiers de manière sécurisée.

**Critères d'acceptation :**
- [ ] Je saisis mon email et mon mot de passe
- [ ] Si les identifiants sont corrects, je suis redirigé vers le tableau de bord
- [ ] Si les identifiants sont incorrects, un message d'erreur s'affiche sans recharger la page
- [ ] Mon session est maintenue jusqu'à déconnexion explicite
- [ ] L'écran de connexion est accessible sans connexion internet (formulaire affiché)
- [ ] La tentative de connexion échoue gracieusement sans internet (message clair)

---

**US-002 · Créer un dossier offline**
> En tant qu'expert sur le terrain,
> je veux créer un nouveau dossier d'expertise sans connexion internet,
> afin de commencer à travailler immédiatement même en zone sans réseau.

**Critères d'acceptation :**
- [ ] Je peux ouvrir le formulaire de création sans connexion
- [ ] Je remplis les informations minimales : titre, nature sinistre, lieu, date
- [ ] Le dossier est sauvegardé localement avec un numéro temporaire (LOCAL-2025-XXXX)
- [ ] Le dossier apparaît dans la liste avec un badge orange "Non synchronisé"
- [ ] Dès le retour de la connexion, le dossier est synchronisé automatiquement
- [ ] Le numéro temporaire est remplacé par le numéro définitif (AV-2025-NNNN)
- [ ] Je reçois une confirmation visuelle de la synchronisation

---

**US-003 · Suivre l'avancement d'un dossier**
> En tant qu'expert,
> je veux faire avancer un dossier dans son workflow,
> afin de refléter l'état réel de la mission et d'informer la direction.

**Critères d'acceptation :**
- [ ] Depuis le détail d'un dossier, je vois le statut actuel et le bouton "Passer à : [statut suivant]"
- [ ] Un dialog de confirmation s'affiche avant le changement
- [ ] La date correspondante est automatiquement renseignée (ex: date_expertise si → expertise_en_cours)
- [ ] Je ne peux pas revenir en arrière dans le workflow
- [ ] Je peux passer un dossier en "Annulé" depuis n'importe quel statut (sauf "Clos")
- [ ] Le tableau de bord se met à jour immédiatement

---

**US-004 · Générer un devis**
> En tant que comptable,
> je veux créer un devis pour un dossier d'expertise,
> afin d'envoyer une proposition chiffrée au client rapidement.

**Critères d'acceptation :**
- [ ] Je peux créer un devis depuis la fiche d'un dossier
- [ ] J'ajoute des lignes avec : désignation, quantité, unité, prix unitaire
- [ ] Le montant HT, TVA (18% pré-rempli mais modifiable) et TTC sont calculés en temps réel
- [ ] Je peux apercevoir le PDF avant de finaliser
- [ ] Le devis reçoit automatiquement un numéro DEV-2025-NNNN
- [ ] Je peux envoyer le devis directement par email depuis l'app
- [ ] Le statut du devis passe à "Envoyé" après l'envoi

---

**US-005 · Facturer un client**
> En tant que comptable,
> je veux convertir un devis accepté en facture,
> afin de finaliser la facturation sans ressaisir les informations.

**Critères d'acceptation :**
- [ ] Depuis un devis au statut "Accepté", j'ai le bouton "Convertir en facture"
- [ ] La facture est pré-remplie avec toutes les lignes du devis
- [ ] Je peux ajuster les lignes avant validation
- [ ] La facture reçoit un numéro FAC-2025-NNNN unique
- [ ] Je génère et envoie la facture PDF en 2 clics
- [ ] La facture apparaît dans l'historique du client

---

**US-006 · Enregistrer un paiement**
> En tant que comptable,
> je veux enregistrer qu'un client a payé une facture,
> afin de tenir à jour le solde des créances.

**Critères d'acceptation :**
- [ ] Depuis une facture, je clique "Enregistrer un paiement"
- [ ] Je saisis : montant reçu, date, mode de paiement, référence
- [ ] Le montant restant se recalcule automatiquement
- [ ] Si montant restant = 0, le statut passe automatiquement à "Payée"
- [ ] Si montant reçu < total, le statut passe à "Partiellement payée"
- [ ] Le solde du client est mis à jour immédiatement
- [ ] La charge correspondante est comptabilisée (côté produit)

---

**US-007 · Photographier un sinistre**
> En tant qu'expert sur le terrain,
> je veux prendre des photos directement depuis l'application,
> afin qu'elles soient automatiquement attachées au dossier en cours avec horodatage.

**Critères d'acceptation :**
- [ ] Depuis le détail d'un dossier, j'accède à "Ajouter une photo"
- [ ] J'utilise la caméra ou la galerie de mon téléphone
- [ ] La photo est sauvegardée localement avec timestamp automatique
- [ ] Si la permission GPS est accordée, les coordonnées sont enregistrées
- [ ] La photo est visible immédiatement dans la liste des pièces jointes
- [ ] Elle est uploadée sur Supabase Storage au retour de la connexion

---

**US-008 · Valider les salaires par lot**
> En tant que responsable RH,
> je veux valider et marquer comme payés les salaires du mois en une seule opération,
> afin de gagner du temps et d'éviter les oublis.

**Critères d'acceptation :**
- [ ] Je sélectionne le mois et l'année
- [ ] Je vois la liste de tous les employés actifs avec leur salaire net
- [ ] Je peux saisir ou modifier le salaire net de chaque employé
- [ ] Je sélectionne plusieurs employés et clique "Valider la sélection"
- [ ] Un dialog de confirmation résume le total de la masse salariale
- [ ] Après confirmation, les salaires passent au statut "Validé"
- [ ] Je peux ensuite sélectionner les salaires validés et cliquer "Marquer comme payé"
- [ ] Dès le passage à "Payé", une charge catégorie "salaires" est créée automatiquement
- [ ] Cette charge apparaît dans les analyses comptables du mois

---

### Priorité 1 — Important

---

**US-009 · Tableau de bord financier**
> En tant que directeur du cabinet,
> je veux voir en un coup d'œil les indicateurs financiers du mois,
> afin de piloter l'activité sans ouvrir Excel.

**Critères d'acceptation :**
- [ ] Le dashboard affiche : CA HT et TTC du mois en cours
- [ ] Total des créances (factures non entièrement payées)
- [ ] Total des charges du mois (toutes catégories)
- [ ] Résultat brut estimé (CA HT - charges)
- [ ] Graphique CA mensuel des 12 derniers mois
- [ ] Ces données sont disponibles offline (calculées depuis Drift)
- [ ] Pull-to-refresh pour synchroniser avec Supabase

---

**US-010 · Inviter un collaborateur**
> En tant qu'administrateur,
> je veux inviter un nouveau membre de l'équipe,
> afin qu'il puisse accéder à l'application avec les bons droits.

**Critères d'acceptation :**
- [ ] Je saisis l'email du nouveau collaborateur et son rôle
- [ ] Il reçoit un email d'invitation avec un lien d'activation
- [ ] Il crée son mot de passe via le lien
- [ ] Son compte est lié à mon entreprise (même tenant)
- [ ] Il ne voit que les données de mon cabinet (RLS Supabase)
- [ ] Je peux modifier son rôle ou désactiver son accès depuis les paramètres

---

**US-011 · Configurer la mise en page des documents**
> En tant qu'administrateur,
> je veux personnaliser l'en-tête et le pied de page des devis et factures,
> afin que les documents refètent l'identité professionnelle du cabinet.

**Critères d'acceptation :**
- [ ] Je peux charger le logo du cabinet (PNG ou JPEG, max 2 Mo)
- [ ] Je saisis un texte d'en-tête (adresse, téléphone, RCCM, NIF)
- [ ] Je saisis un texte de pied de page (coordonnées bancaires, mentions légales)
- [ ] Un aperçu PDF live se met à jour à chaque modification
- [ ] Les réglages s'appliquent à tous les nouveaux documents générés

---

**US-012 · Exporter les données comptables**
> En tant que comptable,
> je veux exporter les produits et charges d'une période,
> afin de les transmettre au cabinet comptable externe.

**Critères d'acceptation :**
- [ ] Je sélectionne une période (mois, trimestre, année)
- [ ] Je génère un fichier CSV avec : date, catégorie, libellé, montant, TVA
- [ ] Le fichier est partageable directement depuis l'app (WhatsApp, email, Drive)

---

### Priorité 2 — Améliorations

---

**US-013 · Relances automatiques**
> En tant que comptable,
> je veux que l'application m'alerte quand une facture dépasse son échéance,
> afin de ne jamais oublier de relancer un client.

**Critères d'acceptation :**
- [ ] Une notification push est envoyée le jour de l'échéance si facture non payée
- [ ] Le dashboard affiche une section "Factures en retard"
- [ ] Je peux envoyer un email de relance en 1 clic depuis la facture

---

**US-014 · Dupliquer un dossier similaire**
> En tant qu'expert,
> je veux créer un nouveau dossier basé sur un dossier existant similaire,
> afin de ne pas ressaisir les informations communes.

**Critères d'acceptation :**
- [ ] Depuis le détail d'un dossier, je clique "Dupliquer"
- [ ] Un nouveau dossier est créé avec : type de mission, compagnie d'assurance, courtier copiés
- [ ] Le numéro, les dates, le statut et les pièces jointes ne sont pas copiés
- [ ] Je suis redirigé vers le formulaire d'édition du nouveau dossier

---

## 7. Règles de gestion

### RG-001 · Numérotation
- Les numéros sont générés côté serveur (trigger PostgreSQL) uniquement
- En offline : numéro temporaire `AV-LOCAL-[timestamp]` affiché avec badge orange
- À la synchronisation : le numéro définitif remplace le numéro temporaire dans Drift
- La numérotation est annuelle (reset au 1er janvier de chaque année)
- La numérotation est indépendante par entreprise

### RG-002 · Fiscalité
- Les taux TVA et TPS sont **copiés sur le document à sa création** (snapshot fiscal)
- Une modification des taux dans les paramètres n'affecte pas les documents déjà créés
- Le calcul est : `TTC = HT × (1 + tva/100) × (1 + tps/100)` si TPS s'applique après TVA, ou `TTC = HT + HT×tva/100 + HT×tps/100` si les deux s'appliquent sur le HT (à confirmer avec comptable)
- Les montants sont arrondis à 2 décimales dans la DB, affichés sans décimale en XAF

### RG-003 · Workflow dossier
- Transitions autorisées : `nouveau → en_instruction`, `en_instruction → expertise_en_cours`, `expertise_en_cours → rapport_redige`, `rapport_redige → clos`
- `annule` est accessible depuis tout statut sauf `clos`
- Aucun retour arrière n'est possible
- Seuls `admin` et `expert` peuvent changer le statut

### RG-004 · Comptabilisation automatique des salaires
- Dès qu'un salaire passe au statut `paye`, une charge est créée automatiquement
- Catégorie : `salaires`, montant : `salaire_net`, date : `date_paiement`
- Cette opération est irréversible (la charge peut être corrigée manuellement si erreur)

### RG-005 · Multi-tenant
- Chaque utilisateur appartient à une et une seule entreprise
- Le Row Level Security de Supabase garantit qu'aucun utilisateur ne peut accéder aux données d'une autre entreprise, même avec une clé API valide
- Cette règle s'applique à toutes les tables sans exception

### RG-006 · Suppression
- Aucune suppression physique en production (soft delete avec `deleted_at`)
- Exception : les brouillons de devis et factures peuvent être supprimés définitivement
- Les pièces jointes peuvent être supprimées par un `admin` uniquement

---

## 8. Hors périmètre

Les éléments suivants sont **explicitement exclus** de cette version de l'application.

| Exclusion | Raison |
|-----------|--------|
| Calcul automatique de la paie (CNPS, IRPP, CNAMGS) | Complexité réglementaire, risque légal — externalisé |
| Module comptabilité en partie double (débit/crédit) | Hors compétence — externalisé au cabinet comptable |
| Portail client (accès externe pour les clients) | Hors périmètre V1 |
| Application iOS | Non ciblé pour l'instant |
| Paiement en ligne intégré | Stripe/PayPal non disponibles au Gabon |
| Gestion du stock / inventaire | Pas de stock physique dans un cabinet d'avarie |
| Signature électronique | Non requis pour V1 |
| Import de données depuis un autre logiciel | Non prioritaire |
| Application offline complète sur Web | Flutter Web offline partiel uniquement (service worker limité) |
| Chat ou messagerie interne | Non requis |
| Génération automatique du rapport d'expertise | Possible en V2 via IA (Claude API) |

---

*Document généré le 2025 · À maintenir à jour à chaque sprint*
