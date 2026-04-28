import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';

final pieceJointeRepositoryProvider = Provider<PieceJointeRepository>((ref) {
  return PieceJointeRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class PieceJointeRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  PieceJointeRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<PiecesJointe>> getByDossier(String dossierId) =>
      _db.piecesJointesDao.getByDossier(dossierId);

  Stream<List<PiecesJointe>> watchByDossier(String dossierId) =>
      _db.piecesJointesDao.watchByDossier(dossierId);

  Future<String> add({
    required String dossierId,
    required String cheminLocal,
    required String nom,
    required String typeFichier,
    int? taille,
    double? latitude,
    double? longitude,
    String? notes,
  }) async {
    final id = const Uuid().v4();
    final companion = PiecesJointesCompanion.insert(
      id: id,
      dossierId: dossierId,
      nom: nom,
      typeFichier: typeFichier,
      cheminLocal: cheminLocal,
      taille: drift.Value(taille),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      notes: drift.Value(notes),
      syncStatus: const drift.Value('pending'),
    );
    await _db.piecesJointesDao.upsert(companion);

    if (_ref.read(isOnlineProvider)) {
      await _uploadToSupabase(id, dossierId, cheminLocal, nom, typeFichier);
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'piece_jointe',
        entityId: id,
        operation: 'upload',
        payload: jsonEncode({
          'id': id,
          'dossier_id': dossierId,
          'nom': nom,
          'type_fichier': typeFichier,
          'chemin_local': cheminLocal,
        }),
      );
    }
    return id;
  }

  Future<void> updateNotes(String id, String notes) async {
    await _db.piecesJointesDao.upsert(PiecesJointesCompanion(
      id: drift.Value(id),
      notes: drift.Value(notes),
      syncStatus: const drift.Value('pending'),
      updatedAt: drift.Value(DateTime.now()),
    ));
  }

  Future<void> delete(String id) async {
    final pj = await _db.piecesJointesDao.getById(id);
    if (pj != null) {
      // Supprimer le fichier local
      final file = File(pj.cheminLocal);
      if (await file.exists()) await file.delete();
      // Supprimer de Supabase si synchronisé
      if (pj.urlStorage != null && _ref.read(isOnlineProvider)) {
        final path = _storagePath(pj.dossierId, pj.nom);
        try {
          await _supabase.storage.from('pieces-jointes').remove([path]);
        } catch (_) {}
      }
    }
    await _db.piecesJointesDao.deleteById(id);
  }

  Future<void> _uploadToSupabase(
      String id, String dossierId, String cheminLocal, String nom, String typeFichier) async {
    try {
      final file = File(cheminLocal);
      if (!await file.exists()) return;
      final path = _storagePath(dossierId, nom);
      await _supabase.storage.from('pieces-jointes').upload(path, file);
      final url = _supabase.storage.from('pieces-jointes').getPublicUrl(path);
      await _db.piecesJointesDao.updateUrlStorage(id, url);
    } catch (_) {
      await _db.syncQueueDao.enqueue(
        entityType: 'piece_jointe',
        entityId: id,
        operation: 'upload',
        payload: jsonEncode({
          'id': id,
          'dossier_id': dossierId,
          'nom': nom,
          'type_fichier': typeFichier,
          'chemin_local': cheminLocal,
        }),
      );
    }
  }

  String _storagePath(String dossierId, String nom) =>
      'dossiers/$dossierId/$nom';
}
