import 'dart:convert';
import 'dart:math' show pi;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

import '../../features/parametres/data/parametres_service.dart';

class DocumentSecuriteConfig {
  final bool qrActif;
  final bool signatureActif;
  final bool filigraneActif;
  final String filigraneTexte;
  final String signatureTexte;
  final String hmacSecret;

  const DocumentSecuriteConfig({
    required this.qrActif,
    required this.signatureActif,
    required this.filigraneActif,
    required this.filigraneTexte,
    required this.signatureTexte,
    required this.hmacSecret,
  });

  bool get hasFooter => qrActif || signatureActif;
  bool get hasAny => qrActif || signatureActif || filigraneActif;

  static Future<DocumentSecuriteConfig> load() async {
    final data = await ParametresService.getSecurite();
    return DocumentSecuriteConfig(
      qrActif: data['qr_actif'] as bool,
      signatureActif: data['signature_actif'] as bool,
      filigraneActif: data['filigrane_actif'] as bool,
      filigraneTexte: (data['filigrane_texte'] as String).isEmpty
          ? 'ORIGINAL'
          : data['filigrane_texte'] as String,
      signatureTexte: data['signature_texte'] as String,
      hmacSecret: data['hmac_secret'] as String,
    );
  }
}

class DocSecuriteResult {
  final pw.BuildCallback? footer;
  final pw.BuildCallback? background;
  // Extra bottom margin needed to accommodate the footer
  final double extraBottomMargin;

  const DocSecuriteResult({
    this.footer,
    this.background,
    this.extraBottomMargin = 0,
  });
}

class DocumentSecuriteService {
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  // Footer height: ~115 points (≈ 40mm, well within 1/6 of A4 = 49.5mm)
  static const double _footerHeight = 115.0;

  static String computeHmac(String message, String secret) {
    final key = utf8.encode(secret);
    final msg = utf8.encode(message);
    final hmac = Hmac(sha256, key);
    return hmac.convert(msg).toString().substring(0, 16);
  }

  static String buildQrPayload({
    required String type,
    required String numero,
    required String id,
    required DateTime date,
    required String hmacSecret,
  }) {
    final dateStr = DateFormat('yyyyMMdd').format(date);
    final message = '$type|$numero|$id|$dateStr';
    final hmac = computeHmac(message, hmacSecret);
    return 'avarie://verify/$type/$numero/$id/$dateStr/$hmac';
  }

  static Future<Uint8List> _qrToBytes(String data) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: ui.Color(0xFF000000),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: ui.Color(0xFF000000),
      ),
    );
    final image = await painter.toImage(200);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static bool verifyQrPayload(String payload, String hmacSecret) {
    if (!payload.startsWith('avarie://verify/')) return false;
    final parts = payload.replaceFirst('avarie://verify/', '').split('/');
    if (parts.length != 5) return false;
    final type = parts[0];
    final numero = parts[1];
    final id = parts[2];
    final dateStr = parts[3];
    final receivedHmac = parts[4];
    final message = '$type|$numero|$id|$dateStr';
    final expectedHmac = computeHmac(message, hmacSecret);
    return receivedHmac == expectedHmac;
  }

  static Map<String, String>? parseQrPayload(String payload) {
    if (!payload.startsWith('avarie://verify/')) return null;
    final parts = payload.replaceFirst('avarie://verify/', '').split('/');
    if (parts.length != 5) return null;
    return {
      'type': parts[0],
      'numero': parts[1],
      'id': parts[2],
      'date': parts[3],
      'hmac': parts[4],
    };
  }

  static Future<DocSecuriteResult> buildFor({
    required DocumentSecuriteConfig config,
    required String type,
    required String numero,
    required String id,
    required DateTime date,
    required pw.Font roboto,
    required pw.Font robotoBold,
  }) async {
    if (!config.hasAny) return const DocSecuriteResult();

    Uint8List? qrBytes;
    if (config.qrActif) {
      final payload = buildQrPayload(
        type: type,
        numero: numero,
        id: id,
        date: date,
        hmacSecret: config.hmacSecret,
      );
      qrBytes = await _qrToBytes(payload);
    }

    pw.BuildCallback? footerBuilder;
    if (config.hasFooter) {
      final capturedQr = qrBytes;
      footerBuilder = (ctx) => _buildFooter(
            config: config,
            qrBytes: capturedQr,
            numero: numero,
            date: date,
            roboto: roboto,
            robotoBold: robotoBold,
          );
    }

    pw.BuildCallback? backgroundBuilder;
    if (config.filigraneActif) {
      backgroundBuilder = (ctx) => pw.Center(
            child: pw.Transform.rotate(
              angle: -pi / 4,
              child: pw.Opacity(
                opacity: 0.07,
                child: pw.Text(
                  config.filigraneTexte.toUpperCase(),
                  style: pw.TextStyle(
                    font: robotoBold,
                    fontSize: 72,
                    color: const PdfColor.fromInt(0xFF0D2137),
                  ),
                ),
              ),
            ),
          );
    }

    return DocSecuriteResult(
      footer: footerBuilder,
      background: backgroundBuilder,
      extraBottomMargin: footerBuilder != null ? _footerHeight : 0,
    );
  }

  static pw.Widget _buildFooter({
    required DocumentSecuriteConfig config,
    required Uint8List? qrBytes,
    required String numero,
    required DateTime date,
    required pw.Font roboto,
    required pw.Font robotoBold,
  }) {
    const navy = PdfColor.fromInt(0xFF0D2137);
    const teal = PdfColor.fromInt(0xFF1A8A9A);
    final dateStr = _dateFormat.format(date);

    return pw.Column(children: [
      pw.Divider(color: PdfColors.grey400, thickness: 0.5),
      pw.SizedBox(height: 6),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Zone QR
          if (config.qrActif && qrBytes != null) ...[
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(pw.MemoryImage(qrBytes), width: 72, height: 72),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Scannez pour verifier',
                  style: pw.TextStyle(font: roboto, fontSize: 6, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.SizedBox(width: 8),
            pw.Container(width: 0.5, height: 84, color: PdfColors.grey300),
            pw.SizedBox(width: 8),
          ],
          // Zone signature / certification
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (config.signatureActif) ...[
                  pw.Text(
                    'Document certifie conforme',
                    style: pw.TextStyle(font: robotoBold, fontSize: 8, color: navy),
                  ),
                  pw.SizedBox(height: 3),
                  if (config.signatureTexte.isNotEmpty)
                    pw.Text(
                      config.signatureTexte,
                      style: pw.TextStyle(font: roboto, fontSize: 8),
                    ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Signe le $dateStr',
                    style: pw.TextStyle(font: roboto, fontSize: 7, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    width: 100,
                    height: 0.5,
                    color: PdfColors.grey400,
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Signature autorisee',
                    style: pw.TextStyle(font: roboto, fontSize: 7, color: PdfColors.grey600),
                  ),
                ] else ...[
                  pw.Text(
                    'N° $numero',
                    style: pw.TextStyle(font: roboto, fontSize: 7, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Emis le $dateStr',
                    style: pw.TextStyle(font: roboto, fontSize: 7, color: PdfColors.grey600),
                  ),
                ],
              ],
            ),
          ),
          // Branding AvarieApp
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: pw.BoxDecoration(
                  color: teal,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  'AvarieApp',
                  style: pw.TextStyle(font: robotoBold, fontSize: 7, color: PdfColors.white),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Document authentifie',
                style: pw.TextStyle(font: roboto, fontSize: 6, color: PdfColors.grey500),
              ),
              pw.SizedBox(height: 2),
              if (config.qrActif)
                pw.Text(
                  'Ref: ${numero.length > 16 ? numero.substring(0, 16) : numero}',
                  style: pw.TextStyle(font: roboto, fontSize: 6, color: PdfColors.grey500),
                ),
            ],
          ),
        ],
      ),
    ]);
  }
}
