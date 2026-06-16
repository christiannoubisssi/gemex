class AppConstants {
  // Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String monthYearFormat = 'MM/yyyy';

  // Devise
  static const String devise = 'XAF';
  static const String deviseSuffix = 'FCFA';
  static const double tvaTauxDefaut = 18.0;
  static const double tpsTauxDefaut = 0.0;

  // Statuts dossiers — workflow : brouillon → en_instruction → en_cours → termine
  static const String statutBrouillon = 'brouillon';
  static const String statutEnInstruction = 'en_instruction';
  static const String statutEnCours = 'en_cours';
  static const String statutTermine = 'termine';
  static const String statutAnnule = 'annule';

  static const List<String> statutsDossier = [
    statutBrouillon,
    statutEnInstruction,
    statutEnCours,
    statutTermine,
    statutAnnule,
  ];

  static const Map<String, String> statutLabels = {
    statutBrouillon: 'Brouillon',
    statutEnInstruction: 'En instruction',
    statutEnCours: 'En cours',
    statutTermine: 'Terminé',
    statutAnnule: 'Annulé',
  };

  // Transitions autorisées (workflow à sens unique — pas de retour arrière)
  static const Map<String, String?> nextStatut = {
    statutBrouillon: statutEnInstruction,
    statutEnInstruction: statutEnCours,
    statutEnCours: statutTermine,
    statutTermine: null,
    statutAnnule: null,
  };

  // Priorités
  static const String prioriteBasse = 'basse';
  static const String prioriteNormale = 'normale';
  static const String prioriteHaute = 'haute';
  static const String prioriteUrgente = 'urgente';

  static const List<String> priorites = [
    prioriteBasse,
    prioriteNormale,
    prioriteHaute,
    prioriteUrgente,
  ];

  static const Map<String, String> prioriteLabels = {
    prioriteBasse: 'Basse',
    prioriteNormale: 'Normale',
    prioriteHaute: 'Haute',
    prioriteUrgente: 'Urgente',
  };

  // Statuts devis
  static const String devisBrouillon = 'brouillon';
  static const String devisEnvoye = 'envoye';
  static const String devisAccepte = 'accepte';
  static const String devisRefuse = 'refuse';
  static const String devisExpire = 'expire';

  static const Map<String, String> devisStatutLabels = {
    devisBrouillon: 'Brouillon',
    devisEnvoye: 'Envoyé',
    devisAccepte: 'Accepté',
    devisRefuse: 'Refusé',
    devisExpire: 'Expiré',
  };

  // Statuts factures
  static const String factureBrouillon = 'brouillon';
  static const String factureEmise = 'emise';
  static const String facturePartielle = 'partiellement_payee';
  static const String facturePayee = 'payee';
  static const String factureAnnulee = 'annulee';

  static const Map<String, String> factureStatutLabels = {
    factureBrouillon: 'Brouillon',
    factureEmise: 'Validée',
    facturePartielle: 'Part. payée',
    facturePayee: 'Payée',
    factureAnnulee: 'Annulée',
  };

  // Types de client
  static const String clientEntreprise = 'entreprise';
  static const String clientParticulier = 'particulier';
  static const String clientAssurance = 'assurance';
  static const String clientArmateur = 'armateur';

  static const Map<String, String> typeClientLabels = {
    clientEntreprise: 'Entreprise',
    clientParticulier: 'Particulier',
    clientAssurance: 'Assurance',
    clientArmateur: 'Armateur',
  };

  // Catégories de charges
  static const Map<String, String> categorieChargeLabels = {
    'loyer': 'Loyer',
    'salaires': 'Salaires',
    'transport': 'Transport',
    'fournitures': 'Fournitures',
    'telecommunication': 'Télécommunications',
    'honoraires_externes': 'Honoraires externes',
    'impots_taxes': 'Impôts & taxes',
    'assurance': 'Assurance',
    'materiel': 'Matériel',
    'autre': 'Autre',
  };

  // Modes de paiement
  static const Map<String, String> modePaiementLabels = {
    'virement': 'Virement bancaire',
    'mobile_money': 'Mobile Money',
    'especes': 'Espèces',
    'cheque': 'Chèque',
  };

  // Sync statuts
  static const String syncPending = 'pending';
  static const String syncSynced = 'synced';
  static const String syncConflict = 'conflict';

  // Rôles
  static const String roleAdmin = 'admin';
  static const String roleExpert = 'expert';
  static const String roleAgent = 'agent';
  static const String roleComptable = 'comptable';
  static const String roleRh = 'rh';

  // Numérotation
  static const int maxSyncAttempts = 5;
  static const int syncIntervalSeconds = 30;
}
