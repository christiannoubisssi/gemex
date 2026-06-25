import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/piece_jointe_repository.dart';

final piecesJointesProvider =
    StreamProvider.autoDispose.family<List<PiecesJointe>, String>(
  (ref, dossierId) {
    return ref
        .read(pieceJointeRepositoryProvider)
        .watchByDossier(dossierId);
  },
);

class PieceJointeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> add({
    required String dossierId,
    required String cheminLocal,
    required String nom,
    required String typeFichier,
    int? taille,
    double? latitude,
    double? longitude,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(pieceJointeRepositoryProvider).add(
            dossierId: dossierId,
            cheminLocal: cheminLocal,
            nom: nom,
            typeFichier: typeFichier,
            taille: taille,
            latitude: latitude,
            longitude: longitude,
            notes: notes,
          );
      state = const AsyncData(null);
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(pieceJointeRepositoryProvider).delete(id),
    );
  }

  /// Télécharge le fichier depuis Supabase et le met en cache local
  Future<String?> download(String pieceJointeId) async {
    return ref.read(pieceJointeRepositoryProvider).download(pieceJointeId);
  }
}

/// Taille du cache PJ en octets
final pjCacheSizeProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.read(pieceJointeRepositoryProvider).getCacheSize(),
);

final pieceJointeNotifierProvider =
    AsyncNotifierProvider<PieceJointeNotifier, void>(PieceJointeNotifier.new);
