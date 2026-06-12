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

  /// Toutes les clés modifiables depuis l'écran admin "Utilisateurs".
  static const all = [
    dossiersAnnuler,
    facturesValider,
    facturesEncaisser,
  ];

  static const labels = {
    dossiersAnnuler: 'Annuler un dossier',
    facturesValider: 'Valider une facture',
    facturesEncaisser: 'Enregistrer un paiement sur facture',
  };
}

/// Permissions par défaut de chaque rôle (cf. CLAUDE.md §10).
const Map<String, Map<String, bool>> kRolePermissionDefaults = {
  'admin': {
    AppPermissions.dossiersAnnuler: true,
    AppPermissions.facturesValider: true,
    AppPermissions.facturesEncaisser: true,
  },
  'expert': {
    AppPermissions.dossiersAnnuler: true,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
  },
  'agent': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
  },
  'comptable': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: true,
    AppPermissions.facturesEncaisser: true,
  },
  'rh': {
    AppPermissions.dossiersAnnuler: false,
    AppPermissions.facturesValider: false,
    AppPermissions.facturesEncaisser: false,
  },
};
