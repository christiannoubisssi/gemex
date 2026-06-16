import '../../database/app_database.dart';
import '../../shared/services/dossier_documents_service.dart';

/// Définit les sections saisissables pour chaque type de document professionnel.
/// [cle]         : clé de stockage dans contenu_json
/// [label]       : libellé affiché dans le formulaire
/// [multiline]   : true = textarea, false = champ simple
/// [lignesVides] : nb de lignes vides dans le PDF si la section est vide
/// [placeholder] : texte d'exemple
class SectionDoc {
  final String cle;
  final String label;
  final bool multiline;
  final int lignesVides;
  final String placeholder;

  const SectionDoc({
    required this.cle,
    required this.label,
    this.multiline = false,
    this.lignesVides = 1,
    this.placeholder = '',
  });
}

class DocumentRapportConstants {
  /// Sections par type de document
  static List<SectionDoc> sections(TypeDocumentMetier type) {
    switch (type) {
      case TypeDocumentMetier.ordreMission:
        return _ordreMission;
      case TypeDocumentMetier.lettreMission:
        return _lettreMission;
      case TypeDocumentMetier.ficheConstatation:
        return _ficheConstatation;
      case TypeDocumentMetier.rapportPrelim:
        return _rapportPrelim;
      case TypeDocumentMetier.rapportExpertise:
        return _rapportExpertise;
      case TypeDocumentMetier.pvConstatation:
        return _pvConstatation;
    }
  }

  /// Pré-remplit les sections à partir des données du dossier.
  /// Retourne uniquement les clés qui ont une valeur pré-remplie.
  static Map<String, String> prefill(TypeDocumentMetier type, Dossier d) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    switch (type) {
      case TypeDocumentMetier.ordreMission:
        return {
          if (d.natureSinistre?.isNotEmpty == true)
            'objet_mission': d.natureSinistre!,
          if (d.lieuSinistre?.isNotEmpty == true)
            'lieu_intervention': d.lieuSinistre!,
          'date_document': dateStr,
        };

      case TypeDocumentMetier.lettreMission:
        return {
          'date_document': dateStr,
          if (d.compagnieAssurance?.isNotEmpty == true)
            'destinataire_nom': d.compagnieAssurance!,
        };

      case TypeDocumentMetier.ficheConstatation:
        return {
          'date_visite': dateStr,
          if (d.lieuSinistre?.isNotEmpty == true)
            'lieu_visite': d.lieuSinistre!,
        };

      case TypeDocumentMetier.rapportPrelim:
        return {'date_document': dateStr};

      case TypeDocumentMetier.rapportExpertise:
        return {'date_document': dateStr};

      case TypeDocumentMetier.pvConstatation:
        return {
          'date_reunion': dateStr,
          if (d.lieuSinistre?.isNotEmpty == true)
            'lieu_reunion': d.lieuSinistre!,
        };
    }
  }

  // ── Sections ──────────────────────────────────────────────────────────────

  static const _ordreMission = [
    SectionDoc(cle: 'date_document', label: 'Date du document',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'expert_designe',
        label: 'Expert désigné (nom & titre)',
        placeholder: 'M. / Mme …, Ingénieur spécialisé'),
    SectionDoc(cle: 'objet_mission', label: 'Objet de la mission',
        multiline: true, lignesVides: 3,
        placeholder: 'Nature du sinistre et étendue de la mission confiée…'),
    SectionDoc(cle: 'lieu_intervention', label: 'Lieu d\'intervention',
        placeholder: 'Adresse, ville, zone…'),
    SectionDoc(cle: 'date_debut', label: 'Date de début prévue',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'date_limite', label: 'Date limite de remise du rapport',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'moyens', label: 'Moyens mis à disposition',
        multiline: true, lignesVides: 2,
        placeholder: 'Véhicule, appareils de mesure, contacts sur place…'),
    SectionDoc(cle: 'instructions',
        label: 'Instructions particulières / Observations',
        multiline: true, lignesVides: 3,
        placeholder: 'Toute instruction spécifique pour l\'exécution de la mission…'),
  ];

  static const _lettreMission = [
    SectionDoc(cle: 'date_document', label: 'Date de la lettre',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'destinataire_nom', label: 'Destinataire — Nom / Société',
        placeholder: 'Compagnie d\'assurance, courtier, assuré…'),
    SectionDoc(cle: 'destinataire_adresse', label: 'Adresse du destinataire',
        multiline: true, lignesVides: 2,
        placeholder: 'Adresse complète…'),
    SectionDoc(cle: 'etendue_mission', label: 'Étendue de la mission',
        multiline: true, lignesVides: 4,
        placeholder: 'Détail des opérations à réaliser, périmètre d\'intervention…'),
    SectionDoc(cle: 'documents_a_remettre',
        label: 'Documents complémentaires à remettre',
        multiline: true, lignesVides: 3,
        placeholder: 'En complément des documents standards listés dans la lettre…'),
  ];

  static const _ficheConstatation = [
    SectionDoc(cle: 'date_visite', label: 'Date de la visite',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'heure_arrivee_depart', label: 'Heure d\'arrivée / de départ',
        placeholder: 'Ex : 09h30 / 12h45'),
    SectionDoc(cle: 'lieu_visite', label: 'Lieu précis de la visite',
        placeholder: 'Adresse exacte, bâtiment, niveau…'),
    SectionDoc(cle: 'conditions_meteo', label: 'Conditions météorologiques',
        placeholder: 'Ensoleillé, nuageux, pluie, vent…'),
    SectionDoc(cle: 'personnes_presentes',
        label: 'Personnes présentes (nom — qualité — société)',
        multiline: true, lignesVides: 4,
        placeholder: 'Ex :\n• M. Dupont — Directeur technique — Assuré SA\n• Mme Martin — Inspectrice — Assurance GA'),
    SectionDoc(cle: 'description_dommages',
        label: 'Description des dommages constatés',
        multiline: true, lignesVides: 6,
        placeholder: 'Description précise et exhaustive des dommages observés…'),
    SectionDoc(cle: 'evaluation_prelim',
        label: 'Évaluation préliminaire des dommages',
        multiline: true, lignesVides: 5,
        placeholder: 'Désignation — localisation — nature — quantité estimée…'),
    SectionDoc(cle: 'mesures_conservatoires',
        label: 'Mesures conservatoires recommandées',
        multiline: true, lignesVides: 3,
        placeholder: 'Actions immédiates recommandées pour limiter l\'aggravation…'),
    SectionDoc(cle: 'documents_recueillis',
        label: 'Documents et pièces recueillis sur place',
        multiline: true, lignesVides: 2,
        placeholder: 'Factures, photos, rapports, certificats…'),
    SectionDoc(cle: 'conclusions_prelim',
        label: 'Conclusions préliminaires',
        multiline: true, lignesVides: 4,
        placeholder: 'Premières conclusions suite aux constatations effectuées…'),
  ];

  static const _rapportPrelim = [
    SectionDoc(cle: 'date_document', label: 'Date du rapport',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'circonstances',
        label: 'I. Circonstances du sinistre',
        multiline: true, lignesVides: 5,
        placeholder: 'Telles qu\'elles nous ont été relatées par les parties…'),
    SectionDoc(cle: 'constatations_initiales',
        label: 'II. Constatations initiales',
        multiline: true, lignesVides: 6,
        placeholder: 'Résumé des premiers constats effectués lors de la visite initiale…'),
    SectionDoc(cle: 'evaluation_prelim',
        label: 'III. Évaluation préliminaire (postes de dommage et montants)',
        multiline: true, lignesVides: 5,
        placeholder: 'Poste | Description | Montant estimé (FCFA)…'),
    SectionDoc(cle: 'total_estime', label: 'Total estimé (FCFA)',
        placeholder: 'ex : 1 500 000 FCFA'),
    SectionDoc(cle: 'reserves',
        label: 'IV. Réserves et points en attente',
        multiline: true, lignesVides: 4,
        placeholder: 'Éléments non encore disponibles ou à confirmer…'),
    SectionDoc(cle: 'prochaines_etapes',
        label: 'V. Prochaines étapes / Suite à donner',
        multiline: true, lignesVides: 3,
        placeholder: 'Visite complémentaire, demande de devis, réunion de concertation…'),
  ];

  static const _rapportExpertise = [
    SectionDoc(cle: 'date_document', label: 'Date du rapport',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'objet_cadre',
        label: 'I. Objet et cadre de la mission',
        multiline: true, lignesVides: 4,
        placeholder: 'Contexte de la mission, mandant, base d\'intervention…'),
    SectionDoc(cle: 'docs_consultes',
        label: 'II. Documents et informations consultés',
        multiline: true, lignesVides: 4,
        placeholder: 'Police, déclaration sinistre, factures, B/L, témoignages…'),
    SectionDoc(cle: 'circonstances',
        label: 'III.1 Circonstances du sinistre',
        multiline: true, lignesVides: 4,
        placeholder: 'Description des circonstances telles qu\'établies…'),
    SectionDoc(cle: 'nature_dommages',
        label: 'III.2 Nature et étendue des dommages',
        multiline: true, lignesVides: 5,
        placeholder: 'Description exhaustive des dommages constatés…'),
    SectionDoc(cle: 'analyse_technique',
        label: 'IV. Analyse technique',
        multiline: true, lignesVides: 6,
        placeholder: 'Analyse des causes, mécanisme du sinistre, expertise technique…'),
    SectionDoc(cle: 'evaluation_financiere',
        label: 'V. Évaluation financière (tableau des dommages)',
        multiline: true, lignesVides: 6,
        placeholder: 'Poste | Base de calcul | Montant retenu (FCFA) | Justification…'),
    SectionDoc(cle: 'total_dommages',
        label: 'Total dommages retenus (FCFA)',
        placeholder: 'ex : 4 250 000 FCFA'),
    SectionDoc(cle: 'responsabilites',
        label: 'VI. Responsabilités et garanties applicables',
        multiline: true, lignesVides: 4,
        placeholder: 'Analyse des responsabilités et applicabilité des garanties…'),
    SectionDoc(cle: 'conclusion',
        label: 'VII. Conclusion',
        multiline: true, lignesVides: 5,
        placeholder: 'Synthèse, position définitive de l\'expert, recommandations…'),
  ];

  static const _pvConstatation = [
    SectionDoc(cle: 'date_reunion', label: 'Date de la réunion',
        placeholder: 'jj/mm/aaaa'),
    SectionDoc(cle: 'heure', label: 'Heure de début',
        placeholder: 'ex : 10h00'),
    SectionDoc(cle: 'lieu_reunion', label: 'Lieu de la réunion',
        placeholder: 'Adresse ou désignation du lieu…'),
    SectionDoc(cle: 'parties_presentes',
        label: 'Parties présentes (qualité — nom — représentant de)',
        multiline: true, lignesVides: 5,
        placeholder: 'Ex :\n• L\'Assuré : M. Nzamba Jean — Directeur — Société XY\n• L\'Assureur : Mme Ondo — Inspectrice — GA Vie'),
    SectionDoc(cle: 'constatations',
        label: 'Constatations',
        multiline: true, lignesVides: 8,
        placeholder: 'Description détaillée et objective des constatations effectuées…'),
    SectionDoc(cle: 'declarations_assure',
        label: 'Déclarations de l\'assuré',
        multiline: true, lignesVides: 3,
        placeholder: 'Position et déclarations de l\'assuré ou de son représentant…'),
    SectionDoc(cle: 'declarations_assureur',
        label: 'Déclarations de la compagnie d\'assurance',
        multiline: true, lignesVides: 3,
        placeholder: 'Position et déclarations du représentant de l\'assureur…'),
  ];
}
