import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../shared/services/document_securite_service.dart';
import 'dashboard_provider.dart';

class RapportPdfService {
  static final _fcfa = NumberFormat('#,###', 'fr_FR');
  static final _date = DateFormat('MMMM yyyy', 'fr_FR');

  static Future<pw.Document> generer(DashboardStats stats, {Uint8List? logoBytes}) async {
    final doc = pw.Document();
    final roboto = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();

    final now = DateTime.now();
    final navy = PdfColor.fromHex('0D2137');
    final teal = PdfColor.fromHex('1A8A9A');
    final danger = PdfColor.fromHex('E53935');
    final success = PdfColor.fromHex('2E7D32');

    final moisLabel = DateFormat('MMyyyy').format(now);
    final securiteConfig = await DocumentSecuriteConfig.load();
    final securite = await DocumentSecuriteService.buildFor(
      config: securiteConfig,
      type: 'RPT',
      numero: 'RPT-$moisLabel',
      id: 'rapport-$moisLabel',
      date: now,
      roboto: roboto,
      robotoBold: robotoBold,
    );

    final bottomMargin = 40.0 + securite.extraBottomMargin;

    doc.addPage(pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(40, 40, 40, bottomMargin),
        buildBackground: securite.background,
      ),
      footer: securite.footer,
      header: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  if (logoBytes != null) ...[
                    pw.Image(pw.MemoryImage(logoBytes), height: 36),
                    pw.SizedBox(width: 8),
                  ],
                  pw.Text('RAPPORT MENSUEL',
                      style: pw.TextStyle(font: robotoBold, fontSize: 18, color: navy)),
                ],
              ),
              pw.Text(_date.format(now).toUpperCase(),
                  style: pw.TextStyle(font: roboto, fontSize: 12, color: teal)),
            ],
          ),
          pw.Divider(color: navy, thickness: 1.5),
          pw.SizedBox(height: 8),
        ],
      ),
      build: (ctx) => [
        // KPIs dossiers
        _sectionTitle('Dossiers', robotoBold, navy),
        pw.SizedBox(height: 8),
        pw.Row(children: [
          _kpiBox('Total', '${stats.totalDossiers}', roboto, robotoBold, navy),
          pw.SizedBox(width: 8),
          _kpiBox('En cours', '${stats.dossiersEnCours}', roboto, robotoBold, teal),
          pw.SizedBox(width: 8),
          _kpiBox('Clos', '${stats.dossiersClos}', roboto, robotoBold, success),
          pw.SizedBox(width: 8),
          _kpiBox('Nouveaux', '${stats.dossiersNouveaux}', roboto, robotoBold, PdfColors.orange700),
        ]),
        pw.SizedBox(height: 16),

        // KPIs financiers
        _sectionTitle('Résultats financiers du mois', robotoBold, navy),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            _tableRow(['Indicateur', 'Montant'], robotoBold, PdfColor.fromHex('E8EDF2'), navy),
            _tableRow(['Chiffre d\'affaires', '${_fcfa.format(stats.caMois)} FCFA'], roboto, PdfColors.white, PdfColors.black),
            _tableRow(['Charges', '${_fcfa.format(stats.chargesMois)} FCFA'], roboto, PdfColors.grey50, PdfColors.black),
            _tableRow(
              ['Résultat net', '${_fcfa.format(stats.resultatMois)} FCFA'],
              robotoBold,
              PdfColors.white,
              stats.resultatMois >= 0 ? success : danger,
            ),
            _tableRow(['Créances', '${_fcfa.format(stats.totalCreances)} FCFA'], roboto, PdfColors.grey50, PdfColors.black),
            _tableRow(['Taux de recouvrement', '${stats.tauxRecouvrement.toStringAsFixed(1)} %'], roboto, PdfColors.white, PdfColors.black),
            _tableRow(['Masse salariale nette', '${_fcfa.format(stats.masseSalarialeMois)} FCFA'], roboto, PdfColors.grey50, PdfColors.black),
          ],
        ),
        pw.SizedBox(height: 16),

        // Évolution CA vs charges
        if (stats.ca6Mois.any((v) => v > 0) || stats.charges6Mois.any((v) => v > 0)) ...[
          _sectionTitle('Évolution sur 6 mois', robotoBold, navy),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              _tableRow(['Mois', 'CA', 'Charges', 'Résultat'], robotoBold, PdfColor.fromHex('E8EDF2'), navy),
              ...List.generate(stats.ca6Mois.length, (i) {
                final res = stats.ca6Mois[i] - stats.charges6Mois[i];
                return _tableRow(
                  [
                    stats.labels6Mois[i],
                    '${_fcfa.format(stats.ca6Mois[i])} FCFA',
                    '${_fcfa.format(stats.charges6Mois[i])} FCFA',
                    '${_fcfa.format(res)} FCFA',
                  ],
                  roboto,
                  i.isEven ? PdfColors.grey50 : PdfColors.white,
                  res >= 0 ? PdfColors.black : danger,
                );
              }),
            ],
          ),
          pw.SizedBox(height: 16),
        ],

        // Factures en retard
        if (stats.facturesEnRetard.isNotEmpty) ...[
          _sectionTitle('Factures en retard (${stats.facturesEnRetard.length})', robotoBold, danger),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              _tableRow(['N° Facture', 'Montant restant'], robotoBold, PdfColor.fromHex('E8EDF2'), navy),
              ...stats.facturesEnRetard.map((f) => _tableRow(
                    [f.numero ?? f.id.substring(0, 8), '${_fcfa.format(f.montantRestant)} FCFA'],
                    roboto, PdfColors.white, danger,
                  )),
            ],
          ),
          pw.SizedBox(height: 16),
        ],

        // Pied de page
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Généré le ${DateFormat('dd/MM/yyyy à HH:mm').format(now)}',
            style: pw.TextStyle(font: roboto, fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      ],
    ));

    return doc;
  }

  static pw.Widget _sectionTitle(String title, pw.Font bold, PdfColor color) =>
      pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 13, color: color));

  static pw.Widget _kpiBox(String label, String value, pw.Font regular, pw.Font bold, PdfColor color) =>
      pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: color, width: 1),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 18, color: color)),
            pw.Text(label, style: pw.TextStyle(font: regular, fontSize: 10, color: PdfColors.grey700)),
          ]),
        ),
      );

  static pw.TableRow _tableRow(List<String> cells, pw.Font font, PdfColor bg, PdfColor textColor) =>
      pw.TableRow(
        decoration: pw.BoxDecoration(color: bg),
        children: cells.map((c) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: pw.Text(c, style: pw.TextStyle(font: font, fontSize: 10, color: textColor)),
        )).toList(),
      );
}
