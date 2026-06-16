/// Permissions granulaires — clés stockées dans `profiles.permissions` (jsonb)
/// pour surcharger les permissions par défaut du rôle d'un utilisateur.
///
/// Sémantique tri-state :
/// - clé absente  → on applique la valeur par défaut du rôle ([kRolePermissionDefaults])
/// - valeur true  → autorisation forcée (même si le rôle ne l'accorde pas par défaut)
/// - valeur false → interdiction forcée (même si le rôle l'accorde par défaut)
///
/// ⚠️ Ces permissions ne sont qu'un filtre côté UI. La sécurité réelle est
/// assurée par les politiques RLS de Supabase (cf. CLAUDE.md §10 : "Ne jamais
/// faire confiance au rôle stocké côté client seul").
class AppPermissions {
  static const dossiersAnnuler = 'dossiers.annuler';
  static const facturesValider = 'factures.valider';
  static const facturesEncaisser = 'factures.encaisser';

  // ── Documents professionnels ────────────────────────────────────────────────
  /// Saisir/modifier les ordres de mission et lettres de mission
  static const docsMissionEcrire = 'docs.mission.ecrire';
  /// Saisir/modifier les fiches de constatation et PV de constatation
  static const docsConstatEcrire = 'docs.constat.ecrire';
  /// Saisir/modifier les rapports (préliminaire et expertise)
  static const docsRapportEcrire = 'docs.rapport.ecrire';

  /// Toutes les clés modifiables depuis l'écran admin "Utilisateurs".
  static const all = [
    dossiersAnnuler,
    facturesValider,
    facturesEncaisser,
    docsMissionEcrire,
    docsConstatEcrire,
    docsRapportEcrire,
  ];

  static const labels = {
    dossiersAnnuler: 'Annuler un dossier',
    facturesValider: 'Valider une facture',
    facturesEncaisser: 'Enregistrer un paiement sur facture',
    docsMissionEcrire: 'Saisir les ordres/lettres de mission',
    docsConstatEcrire: 'Saisir les fiches/PV de constatation',
    docsRapportEcrire: 'Rédiger les rapports d\'expertise',
  };
}

/// Permissions par défaut de chaque rôle (cf. CLAUDE.md §10).
const Map<String, Map<String, bool>> kRolePermissionDefaults = {
  'admin': {
    AppPermissions.dossiersAnnuler: true,
    AppPermissions.facturesValider: true,
    AppPermissions.facturesEncaisser: true,
    AppPermissions.docsMissionEcrire: true,
    AppPermissions.docsConstatEcrire: true,
    AppPermissions.docsRapportEcrire: true,
  },
  'expert': {
    AppPermissions.dossiersAnnuler: true,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
    AppPermissions.docsMissionEcrire: true,
    AppPermissions.docsConstatEcrire: true,
    AppPermissions.docsRapportEcrire: true,
  },
  'agent': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
    AppPermissions.docsMissionEcrire: false,
    AppPermissions.docsConstatEcrire: true,  // agent peut saisir les constats terrain
    AppPermissions.docsRapportEcrire: false,
  },
  'comptable': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: true,
    AppPermissions.facturesEncaisser: true,
    AppPermissions.docsMissionEcrire: false,
    AppPermissions.docsConstatEcrire: false,
    AppPermissions.docsRapportEcrire: false,
  },
  'rh': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
    AppPermissions.docsMissionEcrire: false,
    AppPermissions.docsConstatEcrire: false,
    AppPermissions.docsRapportEcrire: false,
  },
};
