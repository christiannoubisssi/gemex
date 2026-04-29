import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/format_utils.dart';
import '../../database/app_database.dart';

const _moisLabels = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

const _statutLabels = {
  'brouillon': 'Brouillon',
  'soumis': 'Soumis',
  'valide': 'Validé',
  'refuse': 'Refusé',
  'reporte': 'Reporté',
};

const _prioriteLabels = {
  'basse': 'Basse',
  'normale': 'Normale',
  'haute': 'Haute',
  'urgente': 'Urgente',
};

const _ligneStatutLabels = {
  'pending': '-',
  'valide': 'Validée',
  'refuse': 'Refusée',
  'reporte': 'Reportée',
};

class ChargesModelePdfService {
  static Future<Uint8List> generate(
    ChargesModele modele,
    List<ChargesModeleLine> lignes,
  ) async {
    final pdf = pw.Document();
    final total = lignes.fold<double>(0, (s, l) => s + l.montant);
    final periode = '${_moisLabels[modele.mois]} ${modele.annee}';
    final statut = _statutLabels[modele.statut] ?? modele.statut;
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
        ),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MODÈLE DE CHARGES MENSUELLES',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                            color: PdfColors.blueGrey800)),
                    pw.SizedBox(height: 2),
                    pw.Text(modele.titre, style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Période : $periode',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text('Statut : $statut', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Imprimé le $now',
                        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.blueGrey800),
            pw.SizedBox(height: 4),
          ],
        ),
        build: (context) => [
          // Infos soumission / validation
          if (modele.soumisParNom != null || modele.valideParNom != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (modele.soumisParNom != null)
                    pw.Text('Soumis par : ${modele.soumisParNom}',
                        style: const pw.TextStyle(fontSize: 10)),
                  if (modele.dateSubmission != null)
                    pw.Text(
                        'Date soumission : ${DateFormat('dd/MM/yyyy').format(modele.dateSubmission!)}',
                        style: const pw.TextStyle(fontSize: 10)),
                  if (modele.valideParNom != null)
                    pw.Text('Validé/Traité par : ${modele.valideParNom}',
                        style: const pw.TextStyle(fontSize: 10)),
                  if (modele.dateValidation != null)
                    pw.Text(
                        'Date traitement : ${DateFormat('dd/MM/yyyy').format(modele.dateValidation!)}',
                        style: const pw.TextStyle(fontSize: 10)),
                  if (modele.motifRefus != null)
                    pw.Text('Motif refus : ${modele.motifRefus}',
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColors.red700, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),

          pw.SizedBox(height: 12),

          // Tableau des lignes
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(24),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(80),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(60),
              5: const pw.FixedColumnWidth(60),
            },
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
                children: [
                  _th('#'),
                  _th('Désignation'),
                  _th('Montant'),
                  _th('Échéance'),
                  _th('Priorité'),
                  _th('Statut'),
                ],
              ),
              // Rows
              ...lignes.asMap().entries.map((e) {
                final l = e.value;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: e.key.isEven ? PdfColors.white : PdfColors.grey50,
                  ),
                  children: [
                    _td('${e.key + 1}'),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(l.designation, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                          if (l.notes != null && l.notes!.isNotEmpty)
                            pw.Text(l.notes!, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                        ],
                      ),
                    ),
                    _td(FormatUtils.formatFcfa(l.montant), align: pw.TextAlign.right),
                    _td(
                      l.dateEcheance != null ? DateFormat('dd/MM/yy').format(l.dateEcheance!) : '—',
                      align: pw.TextAlign.center,
                    ),
                    _td(_prioriteLabels[l.priorite] ?? l.priorite, align: pw.TextAlign.center),
                    _td(_ligneStatutLabels[l.statut] ?? l.statut, align: pw.TextAlign.center),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('TOTAL : ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(FormatUtils.formatFcfa(total),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 13,
                      color: PdfColors.blueGrey800)),
            ],
          ),

          pw.SizedBox(height: 32),
          // Signatures
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _signatureBlock('Soumis par', modele.soumisParNom),
              _signatureBlock('Validé par', modele.valideParNom),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _th(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: pw.Text(text,
            style: pw.TextStyle(
                color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9)),
      );

  static pw.Widget _td(String text, {pw.TextAlign? align}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: pw.Text(text,
            textAlign: align,
            style: const pw.TextStyle(fontSize: 9)),
      );

  static pw.Widget _signatureBlock(String role, String? nom) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
          pw.SizedBox(height: 4),
          pw.Text(nom ?? '________________', style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 24),
          pw.Container(width: 120, height: 0.5, color: PdfColors.grey),
          pw.SizedBox(height: 2),
          pw.Text('Signature & date', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ],
      );
}
