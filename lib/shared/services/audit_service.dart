import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/connectivity_service.dart';
import '../../core/services/app_logger.dart';
import '../../core/theme/app_colors.dart';
import '../../database/app_database.dart';
import '../../features/parametres/data/user_management_service.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Constantes
// ══════════════════════════════════════════════════════════════════════════════

/// Types d'actions traçées dans le journal.
class AuditActions {
  // Dossiers
  static const String dossierCree         = 'dossier.created';
  static const String dossierModifie      = 'dossier.updated';
  static const String dossierStatutChange = 'dossier.status_changed';
  static const String dossierAnnule       = 'dossier.cancelled';
  static const String dossierClos         = 'dossier.closed';
  // Clients
  static const String clientCree          = 'client.created';
  static const String clientModifie       = 'client.updated';
  static const String clientSupprime      = 'client.deleted';
  // Devis
  static const String devisCree           = 'devis.created';
  static const String devisModifie        = 'devis.updated';
  static const String devisRefuse         = 'devis.refused';
  static const String devisValide         = 'devis.accepted';
  // Factures
  static const String factureCree         = 'facture.created';
  static const String factureModifie      = 'facture.updated';
  static const String facturePaye         = 'facture.paid';
  static const String factureAnnulee      = 'facture.cancelled';
  // Documents & PJ
  static const String documentAjoute      = 'document.added';
  static const String documentSupprime    = 'document.deleted';
  // Auth
  static const String userConnecte        = 'user.login';
}

/// Libellés lisibles pour l'UI.
class AuditLabels {
  static const Map<String, String> _actions = {
    'dossier.created':        'Dossier créé',
    'dossier.updated':        'Dossier modifié',
    'dossier.status_changed': 'Statut changé',
    'dossier.cancelled':      'Dossier annulé',
    'dossier.closed':         'Dossier clôturé',
    'client.created':         'Client créé',
    'client.updated':         'Client modifié',
    'client.deleted':         'Client supprimé',
    'devis.created':          'Devis créé',
    'devis.updated':          'Devis modifié',
    'devis.refused':          'Devis refusé',
    'devis.accepted':         'Devis validé',
    'facture.created':        'Facture créée',
    'facture.updated':        'Facture modifiée',
    'facture.paid':           'Facture payée',
    'facture.cancelled':      'Facture annulée',
    'document.added':         'Document ajouté',
    'document.deleted':       'Document supprimé',
    'user.login':             'Connexion',
  };

  static String forAction(String actionType) =>
      _actions[actionType] ?? actionType;

  static IconData iconForAction(String a) {
    if (a.contains('created') || a.contains('added')) {
      return Icons.add_circle_outline;
    }
    if (a.contains('updated')) return Icons.edit_outlined;
    if (a.contains('status_changed')) return Icons.swap_horiz_outlined;
    if (a.contains('cancelled') || a.contains('deleted')) {
      return Icons.cancel_outlined;
    }
    if (a.contains('closed')) return Icons.lock_outline;
    if (a.contains('paid')) return Icons.payments_outlined;
    if (a.contains('refused')) return Icons.thumb_down_outlined;
    if (a.contains('accepted')) return Icons.thumb_up_outlined;
    if (a.contains('login')) return Icons.login_outlined;
    return Icons.history_outlined;
  }

  static Color colorForAction(String a) {
    if (a.contains('created') || a.contains('added') || a.contains('accepted') ||
        a.contains('paid') || a.contains('closed')) {
      return AppColors.success;
    }
    if (a.contains('deleted') || a.contains('cancelled') || a.contains('refused')) {
      return AppColors.danger;
    }
    if (a.contains('status_changed')) return AppColors.gold;
    return AppColors.navy;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Service
// ══════════════════════════════════════════════════════════════════════════════

final auditServiceProvider = Provider<AuditService>((ref) {
  return AuditService(ref: ref);
});

/// Fournisseur pour le stream complet des logs (admin).
final auditLogsStreamProvider = StreamProvider.autoDispose<List<AuditLog>>(
  (ref) => AppDatabase.instance.auditLogsDao.watchAll(),
);

/// Fournisseur pour le stream des logs d'une entité précise (ex : un dossier).
final auditByEntityProvider =
    StreamProvider.autoDispose.family<List<AuditLog>, String>(
  (ref, entityId) =>
      AppDatabase.instance.auditLogsDao.watchByEntityId(entityId),
);

class AuditService {
  final Ref _ref;
  final AppDatabase _db = AppDatabase.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  AuditService({required Ref ref}) : _ref = ref;

  // ─── Enregistrement ───────────────────────────────────────────────────────

  /// Enregistre une action en local et pousse vers Supabase si connecté.
  /// **Fire-and-forget** : ne bloque jamais l'action métier appelante.
  Future<void> log({
    required String actionType,
    required String entityType,
    required String entityId,
    String? entityLabel,
    required String description,
    String? ancienneValeur,
    String? nouvelleValeur,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Identité : profil mis en cache par currentProfileProvider
      final profile = _ref.read(currentProfileProvider).valueOrNull;
      final userId  = profile?.id  ?? _supabase.auth.currentUser?.id ?? 'unknown';
      final userNom = profile?.nom ?? profile?.email
          ?? _supabase.auth.currentUser?.email ?? 'Inconnu';

      final id = const Uuid().v4();
      await _db.auditLogsDao.insert(AuditLogsCompanion.insert(
        id:             id,
        userId:         userId,
        userNom:        userNom,
        actionType:     actionType,
        entityType:     entityType,
        entityId:       entityId,
        entityLabel:    drift.Value(entityLabel),
        description:    description,
        ancienneValeur: drift.Value(ancienneValeur),
        nouvelleValeur: drift.Value(nouvelleValeur),
        metadataJson:   drift.Value(
            metadata != null ? jsonEncode(metadata) : null),
        syncStatus: const drift.Value('pending'),
      ));

      if (_ref.read(isOnlineProvider)) _pushToSupabase(id);
    } catch (e) {
      // Ne jamais faire échouer une action métier à cause d'un log d'audit
      AppLogger.w('AuditService', 'Impossible d\'enregistrer le log : $e');
    }
  }

  // ─── Synchronisation ──────────────────────────────────────────────────────

  /// Pousse un log précis vers Supabase.
  Future<void> _pushToSupabase(String id) async {
    try {
      final log = await _db.auditLogsDao.getById(id);
      if (log == null) return;
      await _supabase.from('audit_logs').upsert({
        'id':             log.id,
        'entreprise_id':  log.entrepriseId,
        'user_id':        log.userId,
        'user_nom':       log.userNom,
        'action_type':    log.actionType,
        'entity_type':    log.entityType,
        'entity_id':      log.entityId,
        'entity_label':   log.entityLabel,
        'description':    log.description,
        'ancienne_valeur':log.ancienneValeur,
        'nouvelle_valeur':log.nouvelleValeur,
        'metadata_json':  log.metadataJson != null
            ? jsonDecode(log.metadataJson!) : null,
        'created_at':     log.createdAt.toUtc().toIso8601String(),
      });
      await _db.auditLogsDao.markSynced(id);
    } catch (e) {
      AppLogger.w('AuditService', 'Échec push audit log $id', error: e);
    }
  }

  /// Pousse tous les logs locaux en attente (au retour de connexion).
  Future<void> pushPending() async {
    try {
      final pending = await _db.auditLogsDao.getPending();
      AppLogger.d('AuditService', 'Push pending : ${pending.length} log(s)');
      for (final log in pending) {
        await _pushToSupabase(log.id);
      }
    } catch (e) {
      AppLogger.w('AuditService', 'Erreur pushPending', error: e);
    }
  }

  /// Pull les logs depuis Supabase — réservé à l'administrateur (RLS).
  Future<int> pullFromSupabase({int limit = 500}) async {
    try {
      final rows = await _supabase
          .from('audit_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(limit) as List;

      for (final raw in rows) {
        final m = raw as Map<String, dynamic>;
        await _db.auditLogsDao.upsert(AuditLogsCompanion(
          id:             drift.Value(m['id'] as String),
          entrepriseId:   drift.Value(m['entreprise_id'] as String? ?? 'default'),
          userId:         drift.Value(m['user_id'] as String),
          userNom:        drift.Value(m['user_nom'] as String? ?? ''),
          actionType:     drift.Value(m['action_type'] as String),
          entityType:     drift.Value(m['entity_type'] as String),
          entityId:       drift.Value(m['entity_id'] as String),
          entityLabel:    drift.Value(m['entity_label'] as String?),
          description:    drift.Value(m['description'] as String),
          ancienneValeur: drift.Value(m['ancienne_valeur'] as String?),
          nouvelleValeur: drift.Value(m['nouvelle_valeur'] as String?),
          metadataJson:   drift.Value(m['metadata_json'] != null
              ? jsonEncode(m['metadata_json']) : null),
          syncStatus:     const drift.Value('synced'),
          createdAt:      drift.Value(
              DateTime.parse(m['created_at'] as String).toLocal()),
        ));
      }
      AppLogger.d('AuditService', 'Pull ${rows.length} logs depuis Supabase');
      return rows.length;
    } catch (e) {
      AppLogger.w('AuditService', 'Pull audit logs échoué', error: e);
      return 0;
    }
  }

  // ─── Export CSV ───────────────────────────────────────────────────────────

  String exportToCsv(List<AuditLog> logs) {
    final buf = StringBuffer();
    buf.writeln('Date,Utilisateur,Action,Entité,Référence,Description,Ancienne valeur,Nouvelle valeur');
    for (final l in logs) {
      final date = '${l.createdAt.day.toString().padLeft(2, '0')}/'
          '${l.createdAt.month.toString().padLeft(2, '0')}/'
          '${l.createdAt.year} '
          '${l.createdAt.hour.toString().padLeft(2, '0')}:'
          '${l.createdAt.minute.toString().padLeft(2, '0')}';
      buf.writeln([
        date,
        _csv(l.userNom),
        _csv(AuditLabels.forAction(l.actionType)),
        _csv(l.entityType),
        _csv(l.entityLabel ?? ''),
        _csv(l.description),
        _csv(l.ancienneValeur ?? ''),
        _csv(l.nouvelleValeur ?? ''),
      ].join(','));
    }
    return buf.toString();
  }

  String _csv(String v) {
    final s = v.replaceAll('"', '""');
    return s.contains(',') || s.contains('"') || s.contains('\n')
        ? '"$s"' : s;
  }
}
