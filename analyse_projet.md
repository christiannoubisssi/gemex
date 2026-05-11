# Analyse du Projet ERP Gemex

Ce document présente un état des lieux complet du projet Gemex, un système ERP modulaire développé avec Flutter pour la gestion d'activités d'expertise et d'entreprise.

---

## 1. Résumé du Projet

**Gemex** est une application multiplateforme (Mobile/Desktop) conçue pour centraliser les opérations d'un cabinet d'expertise. L'architecture suit les principes de la **Clean Architecture** par fonctionnalités (features), utilisant **Riverpod** pour la gestion d'état et **GoRouter** pour la navigation.

### Points clés :
- **Gestion de Dossiers** : Cœur du système, permettant le suivi complet des missions d'expertise.
- **Cycle de Vente** : Gestion intégrée des clients, des devis et des factures.
- **Finances et Comptabilité** : Suivi du CA, des charges, du résultat net et des taxes.
- **Ressources Humaines** : Gestion du personnel, des congés et de la paie.
- **Synchronisation** : Système capable de gérer des données locales avec un mécanisme de synchronisation.
- **Rapports** : Génération de rapports PDF (Rapports mensuels, Devis, Factures).

---

## 2. Inventaire des Pages Créées

Voici l'ensemble des écrans répertoriés dans le projet, classés par module :

### 🔐 Authentification & Sécurité
- `LoginScreen` : Interface de connexion.
- `ResetPasswordScreen` : Réinitialisation du mot de passe.
- `ScannerScreen` : Scanner (probablement pour la validation de documents ou QR codes).

### 📊 Tableau de Bord (Dashboard)
- `DashboardScreen` : Vue d'ensemble de l'activité, KPIs financiers et dossiers urgents.

### 📁 Gestion des Dossiers
- `DossiersListScreen` : Liste filtrable des dossiers avec KPIs.
- `DossierDetailScreen` : Vue détaillée d'un dossier (informations, étapes, pièces jointes).
- `DossierFormScreen` : Création et édition d'un dossier.
- `PiecesJointesScreen` : Gestion des documents liés à un dossier.

### 👥 Gestion des Clients
- `ClientsListScreen` : Annuaire des clients.
- `ClientDetailScreen` : Fiche client complète.
- `ClientFormScreen` : Création et modification de clients.

### 📄 Facturation (Devis & Factures)
- `DevisListScreen` : Liste des devis émis.
- `DevisDetailScreen` : Visualisation et gestion d'un devis.
- `DevisFormScreen` : Créateur de devis.
- `FacturesListScreen` : Liste des factures avec suivi des paiements.
- `FactureDetailScreen` : Détails d'une facture.
- `FactureFormScreen` : Créateur de factures.

### 💰 Comptabilité & Fiscalité
- `ComptabiliteScreen` : Interface de gestion comptable.
- `ChargeFormScreen` : Enregistrement des dépenses/charges.
- `ChargesModelesListScreen` : Gestion des modèles de charges récurrentes.
- `ChargesModelesDetailScreen` / `FormScreen` : Détails et édition des modèles.
- `TaxesScreen` : Configuration et suivi des taxes.

### 👔 Ressources Humaines & Paie
- `RhDashboardScreen` : Tableau de bord RH (effectifs, alertes).
- `PersonnelListScreen` : Liste des employés.
- `PersonnelDetailScreen` : Fiche employé (contrat, infos personnelles).
- `PersonnelFormScreen` : Ajout/Modification d'employés.
- `CongesScreen` : Gestion des demandes de congés.
- `PaieScreen` : Gestion des bulletins de paie.

### ⚙️ Paramètres & Configuration
- `ParametresScreen` : Menu principal des réglages.
- `ProfilScreen` : Gestion du profil utilisateur courant.
- `EntrepriseScreen` : Informations légales de l'entreprise.
- `DocumentLayoutScreen` : Configuration visuelle des PDF (logos, pieds de page).
- `FiscaliteScreen` : Réglages fiscaux globaux.
- `TypesMissionScreen` : Paramétrage des catégories de missions.
- `UtilisateursScreen` : Gestion des accès et rôles.
- `SecuriteScreen` : Paramètres de sécurité avancés.

---

## 3. Contenus et Fonctionnalités des Pages Principales

| Page | Composants Clés / Contenus | Fonctionnalités |
| :--- | :--- | :--- |
| **Dashboard** | KPI Cards (CA, Charges, Résultat), Graphiques (Evolution 6 mois), Liste Dossiers Urgents, Accès Rapides. | Synthèse visuelle, génération de rapport PDF mensuel, navigation rapide. |
| **Dossiers (Liste)** | KPI (Total, En cours, Clos), Barre de recherche, Chips de filtrage par statut, Table/Liste responsive. | Recherche multicritère, filtrage par statut, création de dossier. |
| **Dossier (Détail)** | En-tête avec statut, Onglets (Infos, Documents, Facturation), Timeline de l'expertise. | Changement de statut, ajout de pièces jointes, conversion en devis/facture. |
| **Factures (Liste)** | Filtres (Brouillon, Envoyée, Payée, En retard), Totaux par statut. | Suivi des créances, relance client, impression PDF. |
| **RH Dashboard** | Statistiques effectifs, Calendrier des congés, Prochains contrats à expiration. | Pilotage des ressources humaines. |
| **Paramètres** | Liste d'options avec icônes. | Centralisation des réglages techniques et métier. |

---

> [!NOTE]
> L'application utilise un système de navigation par "Shell", ce qui signifie qu'un menu latéral ou une barre de navigation est persistante sur la majorité des écrans pour faciliter le passage d'un module à l'autre.
