import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/documents_rapport_dao.dart';
import '../../../../database/tables/documents_rapport_table.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../shared/services/dossier_documents_service.dart';

final documentRapportRepositoryProvider =
    Provider<DocumentRapportRepository>((ref) {
  return DocumentRapportRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class DocumentRapportRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  DocumentRapportRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  /// Retourne le contenu sauvegardé pour un document, ou null si jamais renseigné
  Future<DocumentsRapportData?> get(
      String dossierId, TypeDocumentMetier type) {
    return _db.documentsRapportDao.getByDossierAndType(dossierId, type.name);
  }

  /// Stream des documents d'un dossier (pour l'onglet Documents)
  Stream<List<DocumentsRapportData>> watchByDossier(String dossierId) {
    return _db.documentsRapportDao.watchByDossier(dossierId);
  }

  /// Sauvegarde (crée ou met à jour) le contenu d'un document
  Future<String> save({
    required String dossierId,
    required TypeDocumentMetier type,
    required Map<String, String> contenu,
    required String statut, // 'brouillon' ou 'finalise'
    required String entrepriseId,
  }) async {
    final existing = await get(dossierId, type);
    final id = existing?.id ?? const Uuid().v4();
    final now = DateTime.now();

    final companion = DocumentsRapportCompanion(
      id: drift.Value(id),
      dossierId: drift.Value(dossierId),
      type: drift.Value(type.name),
      contenuJson: drift.Value(jsonEncode(contenu)),
      statut: drift.Value(statut),
      entrepriseId: drift.Value(entrepriseId),
      updatedAt: drift.Value(now),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );

    await _db.documentsRapportDao.upsert(companion);

    // Sync Supabase en arrière-plan
    if (_ref.read(isOnlineProvider)) {
      _syncToSupabase(id, dossierId, type, contenu, statut, entrepriseId);
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'document_rapport',
        entityId: id,
        operation: existing == null ? 'create' : 'update',
        payload: jsonEncode(toJsonSafe({
          'id': id,
          'dossier_id': dossierId,
          'type': type.name,
          'contenu_json': jsonEncode(contenu),
          'statut': statut,
          'entreprise_id': entrepriseId,
        })),
      );
    }

    return id;
  }

  void _syncToSupabase(
    String id,
    String dossierId,
    TypeDocumentMetier type,
    Map<String, String> contenu,
    String statut,
    String entrepriseId,
  ) async {
    try {
      await _supabase.from('documents_rapport').upsert({
        'id': id,
        'dossier_id': dossierId,
        'type': type.name,
        'contenu_json': jsonEncode(contenu),
        'statut': statut,
        'entreprise_id': entrepriseId,
        'updated_at': DateTime.now().toIso8601String(),
      });
      await _db.documentsRapportDao.markSynced(id);
      AppLogger.i('DocumentRapportRepository', 'Document $type/$dossierId synchronisé');
    } catch (e, s) {
      AppLogger.e('DocumentRapportRepository', 'Échec sync Supabase', error: e, stack: s);
    }
  }
}
