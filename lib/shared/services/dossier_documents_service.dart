import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../database/app_database.dart';

enum TypeDocumentMetier {
  ordreMission,
  lettreMission,
  ficheConstatation,
  rapportPrelim,
  rapportExpertise,
  pvConstatation,
}

extension TypeDocumentMetierExt on TypeDocumentMetier {
  String get label {
    switch (this) {
      case TypeDocumentMetier.ordreMission:
        return 'Ordre de mission';
      case TypeDocumentMetier.lettreMission:
        return 'Lettre de mission';
      case TypeDocumentMetier.ficheConstatation:
        return 'Fiche de constatation';
      case TypeDocumentMetier.rapportPrelim:
        return 'Rapport préliminaire';
      case TypeDocumentMetier.rapportExpertise:
        return "Rapport d'expertise";
      case TypeDocumentMetier.pvConstatation:
        return 'PV de constatation';
    }
  }

  String get description {
    switch (this) {
      case TypeDocumentMetier.ordreMission:
        return "Mission assignée à l'expert du cabinet";
      case TypeDocumentMetier.lettreMission:
        return "Lettre formelle à l'assureur ou à l'assuré";
      case TypeDocumentMetier.ficheConstatation:
        return 'Document terrain — observations et dommages constatés';
      case TypeDocumentMetier.rapportPrelim:
        return 'Premiers constats avant analyse technique complète';
      case TypeDocumentMetier.rapportExpertise:
        return 'Rapport technique complet avec conclusions et évaluation';
      case TypeDocumentMetier.pvConstatation:
        return 'Procès-verbal officiel de constatation signé des parties';
    }
  }

  String get prefix {
    switch (this) {
      case TypeDocumentMetier.ordreMission:
        return 'OM';
      case TypeDocumentMetier.lettreMission:
        return 'LM';
      case TypeDocumentMetier.ficheConstatation:
        return 'FC';
      case TypeDocumentMetier.rapportPrelim:
        return 'RP';
      case TypeDocumentMetier.rapportExpertise:
        return 'RE';
      case TypeDocumentMetier.pvConstatation:
        return 'PV';
    }
  }
}

class DossierDocumentsService {
  static final _date = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final _dateHeure = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR');

  /// [contenu] : Map<sectionCle, texteLibre> issu du formulaire.
  /// Si null ou vide → sections vierges (comportement d'origine).
  static Future<void> previsualiser({
    required TypeDocumentMetier type,
    required Dossier dossier,
    Map<String, String>? contenu,
    String nomCabinet = 'Cabinet de Commissaire d\'Avarie',
    String adresseCabinet = 'Libreville, Gabon',
  }) async {
    final doc = await _generer(
      type: type,
      dossier: dossier,
      contenu: contenu ?? {},
      nomCabinet: nomCabinet,
      adresseCabinet: adresseCabinet,
    );
    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }

  static Future<pw.Document> _generer({
    required TypeDocumentMetier type,
    required Dossier dossier,
    required Map<String, String> contenu,
    required String nomCabinet,
    required String adresseCabinet,
  }) async {
    final roboto = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();
    final robotoItalic = await PdfGoogleFonts.robotoItalic();

    switch (type) {
      case TypeDocumentMetier.ordreMission:
        return _ordreMission(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
      case TypeDocumentMetier.lettreMission:
        return _lettreMission(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
      case TypeDocumentMetier.ficheConstatation:
        return _ficheConstatation(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
      case TypeDocumentMetier.rapportPrelim:
        return _rapportPrelim(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
      case TypeDocumentMetier.rapportExpertise:
        return _rapportExpertise(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
      case TypeDocumentMetier.pvConstatation:
        return _pvConstatation(dossier, roboto, robotoBold, robotoItalic, nomCabinet, adresseCabinet, contenu);
    }
  }

  /// Affiche le contenu s'il est non vide, sinon des lignes vierges.
  static pw.Widget _contenuOuLignes(
      String? valeur, int lignesVides, pw.Font regular) {
    if (valeur != null && valeur.trim().isNotEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Text(
          valeur.trim(),
          style: pw.TextStyle(font: regular, fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
      );
    }
    return _lignesVides(lignesVides, regular);
  }

  // ── Widgets réutilisables ────────────────────────────────────────────────

  static pw.Widget _header(
    String nomCabinet,
    String adresseCabinet,
    String typeDoc,
    String numero,
    String dateDoc,
    pw.Font bold,
    pw.Font regular,
  ) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(nomCabinet, style: pw.TextStyle(font: bold, fontSize: 13, color: _navy)),
          pw.SizedBox(height: 2),
          pw.Text(adresseCabinet, style: pw.TextStyle(font: regular, fontSize: 9, color: _grey)),
          pw.Text('Commissaire d\'Avarie Agréé',
              style: pw.TextStyle(font: regular, fontSize: 9, color: _grey)),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text(typeDoc.toUpperCase(),
              style: pw.TextStyle(font: bold, fontSize: 14, color: _gold)),
          pw.SizedBox(height: 2),
          pw.Text('N° $numero', style: pw.TextStyle(font: bold, fontSize: 10, color: _navy)),
          pw.Text('Date : $dateDoc', style: pw.TextStyle(font: regular, fontSize: 9, color: _grey)),
        ]),
      ]),
      pw.SizedBox(height: 6),
      pw.Divider(thickness: 2, color: _navy),
      pw.SizedBox(height: 12),
    ]);
  }

  static pw.Widget _dossierBandeau(Dossier d, pw.Font bold, pw.Font regular) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F0F4F8'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: _navy, width: 0.5),
      ),
      child: pw.Row(children: [
        pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          _kv('Dossier', d.numero ?? 'LOCAL', bold, regular),
          _kv('Nature', d.natureSinistre ?? '—', bold, regular),
          _kv('Date sinistre', d.dateSinistre != null ? _date.format(d.dateSinistre!) : '—', bold, regular),
        ])),
        pw.SizedBox(width: 16),
        pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          _kv('Lieu', d.lieuSinistre ?? '—', bold, regular),
          _kv('Assureur', d.compagnieAssurance ?? '—', bold, regular),
          _kv('N° police', d.numeroPolice ?? '—', bold, regular),
        ])),
      ]),
    );
  }

  static pw.Widget _kv(String k, String v, pw.Font bold, pw.Font regular) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.RichText(
        text: pw.TextSpan(children: [
          pw.TextSpan(text: '$k : ', style: pw.TextStyle(font: bold, fontSize: 9, color: _grey)),
          pw.TextSpan(text: v, style: pw.TextStyle(font: regular, fontSize: 9)),
        ]),
      ),
    );
  }

  static pw.Widget _sectionTitle(String title, pw.Font bold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 10, color: _navy)),
        pw.Divider(thickness: 1, color: _navy),
      ]),
    );
  }

  static pw.Widget _lignesVides(int count, pw.Font regular, {double lineHeight = 16}) {
    return pw.Column(
      children: List.generate(count, (_) => pw.Column(children: [
        pw.SizedBox(height: lineHeight - 2),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
      ])),
    );
  }

  static pw.Widget _signatureBlock(
      List<String> signataires, pw.Font bold, pw.Font regular) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: signataires.map((s) => pw.Column(children: [
        pw.SizedBox(height: 40),
        pw.Container(width: 120, height: 0.5, color: PdfColors.black),
        pw.SizedBox(height: 4),
        pw.Text(s, style: pw.TextStyle(font: bold, fontSize: 9, color: _navy)),
      ])).toList(),
    );
  }

  static pw.Widget _footer(pw.Font regular, String nomCabinet) {
    return pw.Column(children: [
      pw.Divider(thickness: 0.5, color: _grey),
      pw.SizedBox(height: 4),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Document généré par AvarieApp — $nomCabinet',
            style: pw.TextStyle(font: regular, fontSize: 7, color: _grey)),
        pw.Text('Page ', style: pw.TextStyle(font: regular, fontSize: 7, color: _grey)),
      ]),
    ]);
  }

  // ── Documents ────────────────────────────────────────────────────────────

  static Future<pw.Document> _ordreMission(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'OM-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_document']?.isNotEmpty == true ? c['date_document']! : _date.format(DateTime.now());

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (ctx) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _header(cabinet, adresse, 'Ordre de mission', numero, dateDoc, b, r),
        _dossierBandeau(d, b, r),
        _sectionTitle('Mission confiée', b),
        pw.Text(
          'Par la présente, le Cabinet mandate l\'expert soussigné pour procéder à l\'expertise du sinistre référencé ci-dessus.',
          style: pw.TextStyle(font: r, fontSize: 10),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Expert désigné :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['expert_designe'], 1, r),
        pw.SizedBox(height: 8),
        pw.Text('Objet de la mission :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['objet_mission'], 3, r),
        _sectionTitle('Délais et conditions', b),
        pw.Row(children: [
          pw.Text('Date de début : ', style: pw.TextStyle(font: b, fontSize: 10)),
          pw.Text(c['date_debut']?.isNotEmpty == true ? c['date_debut']! : '________________',
              style: pw.TextStyle(font: r, fontSize: 10)),
          pw.SizedBox(width: 24),
          pw.Text('Date limite de remise : ', style: pw.TextStyle(font: b, fontSize: 10)),
          pw.Text(c['date_limite']?.isNotEmpty == true ? c['date_limite']! : '________________',
              style: pw.TextStyle(font: r, fontSize: 10)),
        ]),
        pw.SizedBox(height: 10),
        pw.Text('Lieu d\'intervention :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['lieu_intervention'], 1, r),
        pw.SizedBox(height: 8),
        pw.Text('Moyens mis à disposition :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['moyens'], 2, r),
        _sectionTitle('Instructions particulières / Observations', b),
        _contenuOuLignes(c['instructions'], 3, r),
        pw.SizedBox(height: 24),
        _signatureBlock(['Le Directeur du Cabinet', 'L\'Expert désigné'], b, r),
        pw.Spacer(),
        _footer(r, cabinet),
      ]),
    ));
    return doc;
  }

  static Future<pw.Document> _lettreMission(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'LM-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_document']?.isNotEmpty == true ? c['date_document']! : _date.format(DateTime.now());
    final destinataireNom = c['destinataire_nom'] ?? '';
    final destinataireAdr = c['destinataire_adresse'] ?? '';

    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (ctx) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _header(cabinet, adresse, 'Lettre de mission', numero, dateDoc, b, r),
        pw.Row(children: [
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('De :', style: pw.TextStyle(font: b, fontSize: 10, color: _grey)),
            pw.Text(cabinet, style: pw.TextStyle(font: b, fontSize: 10)),
            pw.Text(adresse, style: pw.TextStyle(font: r, fontSize: 9, color: _grey)),
          ])),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('À :', style: pw.TextStyle(font: b, fontSize: 10, color: _grey)),
            if (destinataireNom.isNotEmpty) pw.Text(destinataireNom, style: pw.TextStyle(font: b, fontSize: 10)),
            if (destinataireAdr.isNotEmpty) pw.Text(destinataireAdr, style: pw.TextStyle(font: r, fontSize: 9)),
            if (destinataireNom.isEmpty && destinataireAdr.isEmpty) _lignesVides(2, r),
          ])),
        ]),
        pw.SizedBox(height: 12),
        pw.Text(
          'Objet : Mission d\'expertise — Dossier ${d.numero ?? 'en cours'}',
          style: pw.TextStyle(font: b, fontSize: 11, color: _navy),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Référence police : ${d.numeroPolice ?? '—'} — Compagnie : ${d.compagnieAssurance ?? '—'}',
            style: pw.TextStyle(font: r, fontSize: 9, color: _grey)),
        pw.SizedBox(height: 16),
        pw.Text('Madame, Monsieur,', style: pw.TextStyle(font: r, fontSize: 10)),
        pw.SizedBox(height: 8),
        pw.Text(
          'Suite à votre demande concernant le sinistre survenu le ${d.dateSinistre != null ? _date.format(d.dateSinistre!) : '___________'} '
          'à ${d.lieuSinistre ?? '___________'}, portant sur ${d.natureSinistre ?? '___________'}, '
          'notre cabinet a désigné un expert chargé de mener les investigations nécessaires.',
          style: pw.TextStyle(font: r, fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Vous trouverez ci-après les conditions et modalités de la mission qui lui est confiée. '
          'Nous vous saurions gré de bien vouloir accorder toute facilité à notre représentant '
          'pour l\'exécution de sa mission.',
          style: pw.TextStyle(font: r, fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
        _sectionTitle('Étendue de la mission', b),
        _contenuOuLignes(c['etendue_mission'], 4, r),
        _sectionTitle('Documents à remettre', b),
        pw.Text(
          '☐  Rapport de constatation\n'
          '☐  Factures ou devis de réparation\n'
          '☐  Témoignages écrits\n'
          '☐  Tout autre document justificatif',
          style: pw.TextStyle(font: r, fontSize: 10),
        ),
        if (c['documents_a_remettre']?.isNotEmpty == true) ...[
          pw.SizedBox(height: 6),
          pw.Text(c['documents_a_remettre']!, style: pw.TextStyle(font: r, fontSize: 10)),
        ],
        pw.Spacer(),
        pw.Text('Veuillez agréer, Madame, Monsieur, l\'expression de nos salutations distinguées.',
            style: pw.TextStyle(font: r, fontSize: 10)),
        pw.SizedBox(height: 24),
        _signatureBlock(['Pour le Cabinet', 'Cachet & Signature'], b, r),
        pw.SizedBox(height: 8),
        _footer(r, cabinet),
      ]),
    ));
    return doc;
  }

  static Future<pw.Document> _ficheConstatation(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'FC-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_visite']?.isNotEmpty == true ? c['date_visite']! : _date.format(DateTime.now());

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      footer: (ctx) => _footer(r, cabinet),
      build: (ctx) => [
        _header(cabinet, adresse, 'Fiche de constatation', numero, dateDoc, b, r),
        _dossierBandeau(d, b, r),
        _sectionTitle('Conditions de la visite', b),
        pw.Row(children: [
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Date de visite :', style: pw.TextStyle(font: b, fontSize: 10)),
            _contenuOuLignes(c['date_visite'], 1, r),
          ])),
          pw.SizedBox(width: 16),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Heure d\'arrivée / départ :', style: pw.TextStyle(font: b, fontSize: 10)),
            _contenuOuLignes(c['heure_arrivee_depart'], 1, r),
          ])),
        ]),
        pw.SizedBox(height: 8),
        pw.Text('Lieu précis de la visite :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['lieu_visite'], 1, r),
        pw.SizedBox(height: 8),
        pw.Text('Conditions météorologiques :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['conditions_meteo'], 1, r),
        _sectionTitle('Personnes présentes', b),
        _contenuOuLignes(c['personnes_presentes'], 4, r),
        _sectionTitle('Description des dommages constatés', b),
        _contenuOuLignes(c['description_dommages'], 6, r),
        _sectionTitle('Évaluation préliminaire des dommages', b),
        _contenuOuLignes(c['evaluation_prelim'], 5, r),
        _sectionTitle('Mesures conservatoires recommandées', b),
        _contenuOuLignes(c['mesures_conservatoires'], 3, r),
        _sectionTitle('Documents et pièces recueillis', b),
        _contenuOuLignes(c['documents_recueillis'], 2, r),
        _sectionTitle('Conclusions préliminaires', b),
        _contenuOuLignes(c['conclusions_prelim'], 4, r),
        pw.SizedBox(height: 16),
        pw.Text(
          'La présente fiche a été établie le ${_dateHeure.format(DateTime.now())}.',
          style: pw.TextStyle(font: i, fontSize: 9, color: _grey),
        ),
        pw.SizedBox(height: 24),
        _signatureBlock(['L\'Expert', 'Représentant de l\'assuré', 'Représentant assureur'], b, r),
      ],
    ));
    return doc;
  }

  static Future<pw.Document> _rapportPrelim(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'RP-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_document']?.isNotEmpty == true ? c['date_document']! : _date.format(DateTime.now());

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      footer: (ctx) => _footer(r, cabinet),
      build: (ctx) => [
        _header(cabinet, adresse, 'Rapport préliminaire', numero, dateDoc, b, r),
        _dossierBandeau(d, b, r),
        _sectionTitle('I. Circonstances du sinistre', b),
        pw.Text('Telles qu\'elles nous ont été relatées :', style: pw.TextStyle(font: i, fontSize: 9, color: _grey)),
        _contenuOuLignes(c['circonstances'], 5, r),
        _sectionTitle('II. Constatations initiales', b),
        pw.Text('Résumé des premiers constats effectués lors de la visite initiale :',
            style: pw.TextStyle(font: i, fontSize: 9, color: _grey)),
        _contenuOuLignes(c['constatations_initiales'], 6, r),
        _sectionTitle('III. Évaluation préliminaire', b),
        _contenuOuLignes(c['evaluation_prelim'], 5, r),
        pw.SizedBox(height: 8),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Text('TOTAL ESTIMÉ : ', style: pw.TextStyle(font: b, fontSize: 11)),
          pw.Text(
            c['total_estime']?.isNotEmpty == true ? '${c['total_estime']!} FCFA' : '_________________________ FCFA',
            style: pw.TextStyle(font: b, fontSize: 11, color: _navy),
          ),
        ]),
        _sectionTitle('IV. Réserves et points en attente', b),
        _contenuOuLignes(c['reserves'], 4, r),
        _sectionTitle('V. Prochaines étapes', b),
        _contenuOuLignes(c['prochaines_etapes'], 3, r),
        pw.SizedBox(height: 24),
        _signatureBlock(['L\'Expert', 'Le Directeur du Cabinet'], b, r),
        pw.SizedBox(height: 8),
        pw.Text(
          'Ce rapport préliminaire est susceptible d\'être modifié à l\'issue des investigations complémentaires.',
          style: pw.TextStyle(font: i, fontSize: 8, color: _grey),
          textAlign: pw.TextAlign.center,
        ),
      ],
    ));
    return doc;
  }

  static Future<pw.Document> _rapportExpertise(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'RE-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_document']?.isNotEmpty == true ? c['date_document']! : _date.format(DateTime.now());

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      footer: (ctx) => _footer(r, cabinet),
      build: (ctx) => [
        _header(cabinet, adresse, "Rapport d'expertise", numero, dateDoc, b, r),
        _dossierBandeau(d, b, r),
        _sectionTitle('I. Objet et cadre de la mission', b),
        _contenuOuLignes(c['objet_cadre'], 4, r),
        _sectionTitle('II. Documents et informations consultés', b),
        _contenuOuLignes(c['docs_consultes'], 4, r),
        _sectionTitle('III. Description du sinistre', b),
        pw.Text('3.1  Circonstances', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['circonstances'], 4, r),
        pw.SizedBox(height: 8),
        pw.Text('3.2  Nature et étendue des dommages', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['nature_dommages'], 5, r),
        _sectionTitle('IV. Analyse technique', b),
        _contenuOuLignes(c['analyse_technique'], 6, r),
        _sectionTitle('V. Évaluation financière des dommages', b),
        _contenuOuLignes(c['evaluation_financiere'], 6, r),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _navy, width: 1),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Row(children: [
            pw.Expanded(child: pw.Column(children: [
              pw.Text('TOTAL DOMMAGES RETENUS', style: pw.TextStyle(font: b, fontSize: 10, color: _navy)),
              pw.SizedBox(height: 4),
              pw.Text(
                c['total_dommages']?.isNotEmpty == true
                    ? '${c['total_dommages']!} FCFA'
                    : '___________________________ FCFA',
                style: pw.TextStyle(font: b, fontSize: 12),
              ),
            ])),
          ]),
        ),
        _sectionTitle('VI. Responsabilités et garanties applicables', b),
        _contenuOuLignes(c['responsabilites'], 4, r),
        _sectionTitle('VII. Conclusion', b),
        _contenuOuLignes(c['conclusion'], 5, r),
        pw.SizedBox(height: 24),
        _signatureBlock(["L'Expert en Chef", 'Le Directeur du Cabinet'], b, r),
        pw.SizedBox(height: 16),
        pw.Text(
          'Ce rapport a été établi en toute indépendance, sur la base des constatations effectuées '
          'et des pièces communiquées. Il engage la responsabilité professionnelle de son auteur.',
          style: pw.TextStyle(font: i, fontSize: 8, color: _grey),
          textAlign: pw.TextAlign.center,
        ),
      ],
    ));
    return doc;
  }

  static Future<pw.Document> _pvConstatation(
    Dossier d, pw.Font r, pw.Font b, pw.Font i,
    String cabinet, String adresse, Map<String, String> c,
  ) async {
    final doc = pw.Document();
    final numero = 'PV-${DateTime.now().year}-${d.numero?.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0') ?? '0001'}';
    final dateDoc = c['date_reunion']?.isNotEmpty == true ? c['date_reunion']! : _date.format(DateTime.now());

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      footer: (ctx) => _footer(r, cabinet),
      build: (ctx) => [
        _header(cabinet, adresse, 'Procès-verbal de constatation', numero, dateDoc, b, r),
        pw.Center(
          child: pw.Text(
            'PROCÈS-VERBAL DE CONSTATATION N° $numero',
            style: pw.TextStyle(font: b, fontSize: 13, color: _navy),
          ),
        ),
        pw.SizedBox(height: 8),
        _dossierBandeau(d, b, r),
        _sectionTitle('Réunion de constatation', b),
        pw.Text(
          'Le ${c['date_reunion']?.isNotEmpty == true ? c['date_reunion']! : '________________________________'}, '
          'à ${c['heure']?.isNotEmpty == true ? c['heure']! : '__________'} heures, au lieu suivant :',
          style: pw.TextStyle(font: r, fontSize: 10),
        ),
        _contenuOuLignes(c['lieu_reunion'], 1, r),
        pw.SizedBox(height: 8),
        pw.Text(
          'Le soussigné, $cabinet, Commissaire d\'Avarie agréé, a procédé aux constatations suivantes :',
          style: pw.TextStyle(font: r, fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
        _sectionTitle('Parties présentes', b),
        _contenuOuLignes(c['parties_presentes'], 5, r),
        _sectionTitle('Constatations', b),
        _contenuOuLignes(c['constatations'], 8, r),
        _sectionTitle('Déclarations des parties', b),
        pw.Text('Déclarations de l\'assuré :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['declarations_assure'], 3, r),
        pw.SizedBox(height: 8),
        pw.Text('Déclarations de la compagnie d\'assurance :', style: pw.TextStyle(font: b, fontSize: 10)),
        _contenuOuLignes(c['declarations_assureur'], 3, r),
        pw.SizedBox(height: 16),
        pw.Text(
          'Le présent procès-verbal, dressé à l\'issue de la réunion, a été lu et approuvé par les parties. '
          'Toute réserve doit être formulée par écrit dans les 48 heures.',
          style: pw.TextStyle(font: i, fontSize: 9, color: _grey),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 24),
        _signatureBlock(["L'Expert", 'L\'Assuré', "L'Assureur"], b, r),
      ],
    ));
    return doc;
  }

  static const _navy = PdfColor.fromInt(0xFF0D2137);
  static const _gold = PdfColor.fromInt(0xFFF0A500);
  static const _grey = PdfColor.fromInt(0xFF6B7280);
}
