import 'package:flutter/material.dart';

class AppColors {
  // Palette Corporate ERP
  static const Color navy = Color(0xFF0F172A); // Navigation latérale
  static const Color primary = Color(0xFF2563EB); // Bleu Vif (Actions)
  static const Color slate = Color(0xFF334155); // Gris Ardoise (Texte secondaire, icônes)
  static const Color emerald = Color(0xFF059669); // Émeraude (Succès)
  
  // Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color pageBg = Color(0xFFFCF8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  // Sémantiques
  static const Color success = emerald;
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color info = primary;

  // Design system — layout / typography
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color tableHeaderBg = Color(0xFFF8FAFC);
  
  // Compatibilité
  static const Color teal = emerald;
  static const Color gold = Color(0xFFF59E0B);
  
  // Statuts dossiers — synchronisés avec AppConstants.statut*
  static const Color statutBrouillon = Color(0xFF94A3B8);     // Slate — brouillon/draft
  static const Color statutEnInstruction = Color(0xFF6366F1); // Indigo — en attente
  static const Color statutEnCours = Color(0xFFF59E0B);       // Amber  — travail en cours
  static const Color statutTermine = emerald;                  // Vert   — terminé
  static const Color statutAnnule = danger;                    // Rouge  — annulé

  // Priorités
  static const Color prioriteBasse = Color(0xFF94A3B8);
  static const Color prioriteNormale = primary;
  static const Color prioriteHaute = Color(0xFFF59E0B);
  static const Color prioriteUrgente = danger;
  
  // Sync
  static const Color syncPending = Color(0xFFF59E0B);
  static const Color syncConflict = danger;
  static const Color syncSynced = emerald;
}
