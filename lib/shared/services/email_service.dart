import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../database/app_database.dart';
import '../../features/parametres/data/parametres_service.dart';
import 'pdf_service.dart';

final emailServiceProvider = Provider<EmailService>((ref) => EmailService());

/// Appelle la Supabase Edge Function `send-email`.
/// La fonction reçoit : type, recipientEmail, recipientName, documentNumero,
/// montant (optionnel), pdfBase64 (optionnel).
class EmailService {
  final _client = Supabase.instance.client;

  Future<void> envoyerDevis({
    required Devi devis,
    required List<DevisLigne> lignes,
    required String destinataire,
    String? nomDestinataire,
  }) async {
    final entreprise = await ParametresService.getEntreprise();
    final logoBytes = await ParametresService.getLogoBytes();
    final pdf = await PdfService.genererDevis(
      devis: devis,
      lignes: lignes,
      nomEntreprise: entreprise['nom']?.isNotEmpty == true ? entreprise['nom'] : null,
      adresseEntreprise: entreprise['adresse']?.isNotEmpty == true ? entreprise['adresse'] : null,
      logoBytes: logoBytes,
    );
    final bytes = await pdf.save();
    await _invoke(
      type: 'devis',
      recipientEmail: destinataire,
      recipientName: nomDestinataire,
      documentNumero: devis.numero ?? devis.id.substring(0, 8),
      montant: devis.montantTtc,
      pdfBase64: base64Encode(bytes),
    );
  }

  Future<void> envoyerFacture({
    required Facture facture,
    required List<FacturesLigne> lignes,
    required String destinataire,
    String? nomDestinataire,
  }) async {
    final entreprise = await ParametresService.getEntreprise();
    final logoBytes = await ParametresService.getLogoBytes();
    final pdf = await PdfService.genererFacture(
      facture: facture,
      lignes: lignes,
      nomEntreprise: entreprise['nom']?.isNotEmpty == true ? entreprise['nom'] : null,
      adresseEntreprise: entreprise['adresse']?.isNotEmpty == true ? entreprise['adresse'] : null,
      logoBytes: logoBytes,
    );
    final bytes = await pdf.save();
    await _invoke(
      type: 'facture',
      recipientEmail: destinataire,
      recipientName: nomDestinataire,
      documentNumero: facture.numero ?? facture.id.substring(0, 8),
      montant: facture.montantTtc,
      pdfBase64: base64Encode(bytes),
    );
  }

  Future<void> envoyerRelance({
    required Facture facture,
    required String destinataire,
    String? nomDestinataire,
  }) async {
    await _invoke(
      type: 'relance',
      recipientEmail: destinataire,
      recipientName: nomDestinataire,
      documentNumero: facture.numero ?? facture.id.substring(0, 8),
      montant: facture.montantRestant,
    );
  }

  Future<void> _invoke({
    required String type,
    required String recipientEmail,
    String? recipientName,
    required String documentNumero,
    double? montant,
    String? pdfBase64,
  }) async {
    final response = await _client.functions.invoke(
      'send-email',
      body: {
        'type': type,
        'recipientEmail': recipientEmail,
        if (recipientName != null) 'recipientName': recipientName,
        'documentNumero': documentNumero,
        if (montant != null) 'montant': montant,
        if (pdfBase64 != null) 'pdfBase64': pdfBase64,
      },
    );
    if (response.status != 200) {
      throw Exception('Erreur envoi email : ${response.data}');
    }
  }
}
