import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../database/app_database.dart';
import 'document_securite_service.dart';

class PdfService {
  static final _fcfa = NumberFormat('#,###', 'fr_FR');
  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  static Future<pw.Document> genererDevis({
    required Devi devis,
    required List<DevisLigne> lignes,
    Client? client,
    String? nomEntreprise,
    String? adresseEntreprise,
    Uint8List? logoBytes,
  }) async {
    final doc = pw.Document();
    final roboto = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();

    final securiteConfig = await DocumentSecuriteConfig.load();
    final securite = await DocumentSecuriteService.buildFor(
      config: securiteConfig,
      type: 'DEV',
      numero: devis.numero ?? devis.id.substring(0, 8).toUpperCase(),
      id: devis.id,
      date: devis.dateEmission,
      roboto: roboto,
      robotoBold: robotoBold,
    );

    final bottomMargin = 40.0 + securite.extraBottomMargin;

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.fromLTRB(40, 40, 40, bottomMargin),
          buildBackground: securite.background,
        ),
        footer: securite.footer,
        build: (ctx) => [
          _buildHeader(
            type: 'DEVIS',
            numero: devis.numero ?? devis.id.substring(0, 8).toUpperCase(),
            date: _dateFormat.format(devis.dateEmission),
            validite: _dateFormat.format(devis.dateValidite),
            nomEntreprise: nomEntreprise ?? 'Cabinet d\'Avarie',
            adresseEntreprise: adresseEntreprise ?? 'Libreville, Gabon',
            client: client,
            roboto: roboto,
            robotoBold: robotoBold,
            logoBytes: logoBytes,
          ),
          pw.SizedBox(height: 24),
          if (devis.objet != null) ...[
            pw.Text('Objet : ${devis.objet}',
                style: pw.TextStyle(font: robotoBold, fontSize: 11)),
            pw.SizedBox(height: 16),
          ],
          _buildLignesTable(
            lignes: lignes.map((l) => _LignePdf(
              designation: l.designation,
              description: l.description,
              quantite: l.quantite,
              unite: l.unite,
              prixUnit: l.prixUnit,
              montantHt: l.montantHt,
            )).toList(),
            roboto: roboto,
            robotoBold: robotoBold,
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: _buildTotaux(
              montantHt: devis.montantHt,
              tauxTva: devis.tauxTva,
              montantTva: devis.montantTva,
              tauxTps: devis.tauxTps,
              montantTps: devis.montantTps,
              montantTtc: devis.montantTtc,
              roboto: roboto,
              robotoBold: robotoBold,
            ),
          ),
          if (devis.conditions != null) ...[
            pw.SizedBox(height: 24),
            pw.Text('Conditions', style: pw.TextStyle(font: robotoBold, fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(devis.conditions!, style: pw.TextStyle(font: roboto, fontSize: 9)),
          ],
          if (devis.notes != null) ...[
            pw.SizedBox(height: 16),
            pw.Text('Notes', style: pw.TextStyle(font: robotoBold, fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(devis.notes!, style: pw.TextStyle(font: roboto, fontSize: 9)),
          ],
          pw.SizedBox(height: 24),
          _buildSignature(roboto: roboto, robotoBold: robotoBold),
        ],
      ),
    );
    return doc;
  }

  static Future<pw.Document> genererFacture({
    required Facture facture,
    required List<FacturesLigne> lignes,
    Client? client,
    String? nomEntreprise,
    String? adresseEntreprise,
    Uint8List? logoBytes,
  }) async {
    final doc = pw.Document();
    final roboto = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();

    final securiteConfig = await DocumentSecuriteConfig.load();
    final securite = await DocumentSecuriteService.buildFor(
      config: securiteConfig,
      type: 'FAC',
      numero: facture.numero ?? facture.id.substring(0, 8).toUpperCase(),
      id: facture.id,
      date: facture.dateEmission,
      roboto: roboto,
      robotoBold: robotoBold,
    );

    final bottomMargin = 40.0 + securite.extraBottomMargin;

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.fromLTRB(40, 40, 40, bottomMargin),
          buildBackground: securite.background,
        ),
        footer: securite.footer,
        build: (ctx) => [
          _buildHeader(
            type: 'FACTURE',
            numero: facture.numero ?? facture.id.substring(0, 8).toUpperCase(),
            date: _dateFormat.format(facture.dateEmission),
            validite: 'Échéance : ${_dateFormat.format(facture.dateEcheance)}',
            nomEntreprise: nomEntreprise ?? 'Cabinet d\'Avarie',
            adresseEntreprise: adresseEntreprise ?? 'Libreville, Gabon',
            client: client,
            roboto: roboto,
            robotoBold: robotoBold,
            logoBytes: logoBytes,
          ),
          pw.SizedBox(height: 24),
          if (facture.objet != null) ...[
            pw.Text('Objet : ${facture.objet}',
                style: pw.TextStyle(font: robotoBold, fontSize: 11)),
            pw.SizedBox(height: 16),
          ],
          _buildLignesTable(
            lignes: lignes.map((l) => _LignePdf(
              designation: l.designation,
              description: l.description,
              quantite: l.quantite,
              unite: l.unite,
              prixUnit: l.prixUnit,
              montantHt: l.montantHt,
            )).toList(),
            roboto: roboto,
            robotoBold: robotoBold,
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: _buildTotaux(
              montantHt: facture.montantHt,
              tauxTva: facture.tauxTva,
              montantTva: facture.montantTva,
              tauxTps: facture.tauxTps,
              montantTps: facture.montantTps,
              montantTtc: facture.montantTtc,
              roboto: roboto,
              robotoBold: robotoBold,
              montantPaye: facture.montantPaye > 0 ? facture.montantPaye : null,
              montantRestant: facture.montantRestant > 0 ? facture.montantRestant : null,
            ),
          ),
          if (facture.conditions != null) ...[
            pw.SizedBox(height: 24),
            pw.Text('Conditions de paiement',
                style: pw.TextStyle(font: robotoBold, fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(facture.conditions!, style: pw.TextStyle(font: roboto, fontSize: 9)),
          ],
          if (facture.notes != null) ...[
            pw.SizedBox(height: 16),
            pw.Text('Notes', style: pw.TextStyle(font: robotoBold, fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(facture.notes!, style: pw.TextStyle(font: roboto, fontSize: 9)),
          ],
          pw.SizedBox(height: 24),
          _buildSignature(roboto: roboto, robotoBold: robotoBold),
        ],
      ),
    );
    return doc;
  }

  // ── Widgets internes ─────────────────────────────────────────────────────────

  static pw.Widget _buildHeader({
    required String type,
    required String numero,
    required String date,
    required String validite,
    required String nomEntreprise,
    required String adresseEntreprise,
    required Client? client,
    required pw.Font roboto,
    required pw.Font robotoBold,
    Uint8List? logoBytes,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Bloc émetteur
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoBytes != null)
                pw.Image(pw.MemoryImage(logoBytes), height: 50)
              else
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFF0D2137),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'AvarieApp',
                    style: pw.TextStyle(
                      font: robotoBold,
                      color: PdfColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              pw.SizedBox(height: 8),
              pw.Text(nomEntreprise, style: pw.TextStyle(font: robotoBold, fontSize: 11)),
              pw.Text(adresseEntreprise, style: pw.TextStyle(font: roboto, fontSize: 9)),
            ],
          ),
        ),
        // Bloc document
        pw.SizedBox(width: 24),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              type,
              style: pw.TextStyle(
                font: robotoBold,
                fontSize: 22,
                color: const PdfColor.fromInt(0xFF1A8A9A),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text('N° $numero', style: pw.TextStyle(font: robotoBold, fontSize: 11)),
            pw.Text('Date : $date', style: pw.TextStyle(font: roboto, fontSize: 9)),
            pw.Text(validite, style: pw.TextStyle(font: roboto, fontSize: 9)),
            if (client != null) ...[
              pw.SizedBox(height: 12),
              pw.Text('Destinataire :', style: pw.TextStyle(font: robotoBold, fontSize: 9)),
              pw.Text(client.nom, style: pw.TextStyle(font: robotoBold, fontSize: 11)),
              if (client.email != null)
                pw.Text(client.email!, style: pw.TextStyle(font: roboto, fontSize: 9)),
              if (client.telephone != null)
                pw.Text(client.telephone!, style: pw.TextStyle(font: roboto, fontSize: 9)),
              if (client.numeroTva != null)
                pw.Text('TVA : ${client.numeroTva}', style: pw.TextStyle(font: roboto, fontSize: 9)),
              if (client.rccm != null)
                pw.Text('RCCM : ${client.rccm}', style: pw.TextStyle(font: roboto, fontSize: 9)),
              if (client.nif != null)
                pw.Text('NIF : ${client.nif}', style: pw.TextStyle(font: roboto, fontSize: 9)),
            ],
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildLignesTable({
    required List<_LignePdf> lignes,
    required pw.Font roboto,
    required pw.Font robotoBold,
  }) {
    final headerStyle = pw.TextStyle(font: robotoBold, fontSize: 9, color: PdfColors.white);
    final cellStyle = pw.TextStyle(font: roboto, fontSize: 9);
    const headerBg = PdfColor.fromInt(0xFF0D2137);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FixedColumnWidth(50),
        2: const pw.FixedColumnWidth(45),
        3: const pw.FixedColumnWidth(70),
        4: const pw.FixedColumnWidth(70),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: headerBg),
          children: [
            _cell('Désignation', headerStyle),
            _cell('Qté', headerStyle, align: pw.Alignment.centerRight),
            _cell('Unité', headerStyle),
            _cell('P.U. HT', headerStyle, align: pw.Alignment.centerRight),
            _cell('Montant HT', headerStyle, align: pw.Alignment.centerRight),
          ],
        ),
        for (final l in lignes)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(l.designation, style: pw.TextStyle(font: robotoBold, fontSize: 9)),
                    if (l.description != null)
                      pw.Text(l.description!, style: pw.TextStyle(font: roboto, fontSize: 8, color: PdfColors.grey600)),
                  ],
                ),
              ),
              _cell(_fmt(l.quantite), cellStyle, align: pw.Alignment.centerRight),
              _cell(l.unite, cellStyle),
              _cell('${_fcfa.format(l.prixUnit)} XAF', cellStyle, align: pw.Alignment.centerRight),
              _cell('${_fcfa.format(l.montantHt)} XAF', cellStyle, align: pw.Alignment.centerRight),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildTotaux({
    required double montantHt,
    required double tauxTva,
    required double montantTva,
    required double tauxTps,
    required double montantTps,
    required double montantTtc,
    required pw.Font roboto,
    required pw.Font robotoBold,
    double? montantPaye,
    double? montantRestant,
  }) {
    return pw.Container(
      width: 220,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          _totalRow('Sous-total HT', '${_fcfa.format(montantHt)} XAF', roboto, robotoBold),
          _totalRow('TVA (${tauxTva.toStringAsFixed(0)} %)', '${_fcfa.format(montantTva)} XAF', roboto, robotoBold),
          if (tauxTps > 0)
            _totalRow('TPS (${tauxTps.toStringAsFixed(1)} %)', '${_fcfa.format(montantTps)} XAF', roboto, robotoBold),
          pw.Container(height: 0.5, color: PdfColors.grey300),
          _totalRow('TOTAL TTC', '${_fcfa.format(montantTtc)} XAF', robotoBold, robotoBold,
              highlight: true),
          if (montantPaye != null)
            _totalRow('Déjà payé', '- ${_fcfa.format(montantPaye)} XAF', roboto, roboto,
                color: PdfColors.green700),
          if (montantRestant != null)
            _totalRow('Reste à payer', '${_fcfa.format(montantRestant)} XAF', robotoBold,
                robotoBold, highlight: true, highlightColor: const PdfColor.fromInt(0xFFF0A500)),
        ],
      ),
    );
  }

  static pw.Widget _buildSignature({
    required pw.Font roboto,
    required pw.Font robotoBold,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Pour l\'entreprise :', style: pw.TextStyle(font: robotoBold, fontSize: 9)),
            pw.SizedBox(height: 40),
            pw.Container(width: 120, height: 0.5, color: PdfColors.grey),
            pw.Text('Signature et cachet', style: pw.TextStyle(font: roboto, fontSize: 8, color: PdfColors.grey600)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Pour le client :', style: pw.TextStyle(font: robotoBold, fontSize: 9)),
            pw.SizedBox(height: 40),
            pw.Container(width: 120, height: 0.5, color: PdfColors.grey),
            pw.Text('Signature et cachet', style: pw.TextStyle(font: roboto, fontSize: 8, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _cell(String text, pw.TextStyle style,
      {pw.Alignment align = pw.Alignment.centerLeft}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Align(
        alignment: align,
        child: pw.Text(text, style: style),
      ),
    );
  }

  static pw.Widget _totalRow(
    String label,
    String value,
    pw.Font labelFont,
    pw.Font valueFont, {
    bool highlight = false,
    PdfColor? highlightColor,
    PdfColor? color,
  }) {
    final bg = highlight ? (highlightColor ?? const PdfColor.fromInt(0xFF0D2137)) : null;
    final textColor = highlight ? PdfColors.white : (color ?? PdfColors.black);
    return pw.Container(
      decoration: bg != null ? pw.BoxDecoration(color: bg) : null,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(font: labelFont, fontSize: 9, color: textColor)),
          pw.Text(value,
              style: pw.TextStyle(font: valueFont, fontSize: 9, color: textColor)),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }
}

class _LignePdf {
  final String designation;
  final String? description;
  final double quantite;
  final String unite;
  final double prixUnit;
  final double montantHt;

  const _LignePdf({
    required this.designation,
    this.description,
    required this.quantite,
    required this.unite,
    required this.prixUnit,
    required this.montantHt,
  });
}
