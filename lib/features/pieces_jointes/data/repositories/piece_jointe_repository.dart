import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
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

  // ═══════════════════════════════════════════════════════════════════════
  // Téléchargement à la demande + cache local
  // ═══════════════════════════════════════════════════════════════════════

  /// Taille max du cache local (200 MB)
  static const int _maxCacheBytes = 200 * 1024 * 1024;

  /// Répertoire cache pour les pièces jointes
  static Future<Directory> _cacheDir() async {
    final appDir = await getApplicationCacheDirectory();
    final dir = Directory('${appDir.path}/pj_cache');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Télécharge un fichier depuis Supabase Storage et le met en cache local.
  /// Retourne le chemin local du fichier téléchargé.
  /// Si le fichier est déjà en cache, retourne directement le chemin sans télécharger.
  Future<String?> download(String pieceJointeId) async {
    final pj = await _db.piecesJointesDao.getById(pieceJointeId);
    if (pj == null) return null;

    // Déjà en cache local ?
    if (pj.cheminLocal.isNotEmpty) {
      final localFile = File(pj.cheminLocal);
      if (await localFile.exists()) return pj.cheminLocal;
    }

    // Pas d'URL distante → impossible de télécharger
    if (pj.urlStorage == null || pj.urlStorage!.isEmpty) return null;
    if (!_ref.read(isOnlineProvider)) return null;

    try {
      final dir = await _cacheDir();
      final localPath = '${dir.path}/${pj.dossierId}_${pj.nom}';
      final path = _storagePath(pj.dossierId, pj.nom);

      // Télécharger depuis Supabase Storage
      final bytes = await _supabase.storage.from('pieces-jointes').download(path);
      final file = File(localPath);
      await file.writeAsBytes(bytes);

      // Mettre à jour le chemin local en Drift
      await _db.piecesJointesDao.upsert(PiecesJointesCompanion(
        id: drift.Value(pieceJointeId),
        cheminLocal: drift.Value(localPath),
      ));

      AppLogger.d('PieceJointeRepository', 'Fichier téléchargé : ${pj.nom} (${bytes.length} octets)');

      // Nettoyage auto si le cache dépasse la limite
      await _cleanupCache();

      return localPath;
    } catch (e) {
      AppLogger.w('PieceJointeRepository', 'Échec téléchargement ${pj.nom}', error: e);
      return null;
    }
  }

  /// Vérifie si le fichier est disponible en local (cache ou original)
  Future<bool> isAvailableLocally(String pieceJointeId) async {
    final pj = await _db.piecesJointesDao.getById(pieceJointeId);
    if (pj == null || pj.cheminLocal.isEmpty) return false;
    return File(pj.cheminLocal).exists();
  }

  /// Nettoie le cache si la taille dépasse _maxCacheBytes.
  /// Supprime les fichiers les plus anciens en premier.
  Future<void> _cleanupCache() async {
    try {
      final dir = await _cacheDir();
      final files = dir.listSync().whereType<File>().toList();
      if (files.isEmpty) return;

      int totalSize = 0;
      for (final f in files) {
        totalSize += await f.length();
      }

      if (totalSize <= _maxCacheBytes) return;

      // Trier par date de modification (plus ancien d'abord)
      files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));

      for (final f in files) {
        if (totalSize <= _maxCacheBytes) break;
        final size = await f.length();
        await f.delete();
        totalSize -= size;
        AppLogger.d('PieceJointeRepository', 'Cache nettoyé : ${f.path}');
      }
    } catch (e) {
      AppLogger.w('PieceJointeRepository', 'Erreur nettoyage cache', error: e);
    }
  }

  /// Taille totale du cache en octets
  Future<int> getCacheSize() async {
    try {
      final dir = await _cacheDir();
      final files = dir.listSync().whereType<File>().toList();
      int total = 0;
      for (final f in files) {
        total += await f.length();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Vider tout le cache
  Future<void> clearCache() async {
    try {
      final dir = await _cacheDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
      }
    } catch (_) {}
  }
}
