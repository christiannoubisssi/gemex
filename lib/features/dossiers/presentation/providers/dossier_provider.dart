import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/audit_service.dart';
import '../../data/repositories/dossier_repository.dart';

final dossiersProvider = FutureProvider.autoDispose.family<List<Dossier>, String?>(
  (ref, statut) async {
    return ref.read(dossierRepositoryProvider).getAll(statut: statut);
  },
);

final dossierSearchProvider = FutureProvider.autoDispose.family<List<Dossier>, String>(
  (ref, search) async {
    return ref.read(dossierRepositoryProvider).getAll(search: search);
  },
);

// StreamProvider réactif — se met à jour automatiquement quand Drift modifie le dossier
// (changement de statut, mise à jour du numéro après sync en_cours, etc.)
final dossierDetailProvider = StreamProvider.autoDispose.family<Dossier?, String>(
  (ref, id) => ref.read(dossierRepositoryProvider).watchById(id),
);

final dossiersUrgentsProvider = FutureProvider.autoDispose<List<Dossier>>(
  (ref) async {
    return ref.read(dossierRepositoryProvider).getUrgents();
  },
);

final dossiersByClientProvider = FutureProvider.autoDispose.family<List<Dossier>, String>(
  (ref, clientId) async =>
      ref.read(dossierRepositoryProvider).getAll(clientId: clientId),
);

final dossierStatsProvider = FutureProvider.autoDispose<Map<String, int>>(
  (ref) async {
    return ref.read(dossierRepositoryProvider).getStatsCounts();
  },
);

class DossierNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> create(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final safeData = toJsonSafe(data);
      AppLogger.i('DossierNotifier', 'Création dossier…');
      final id = await ref.read(dossierRepositoryProvider).create(safeData);
      state = const AsyncData(null);
      ref.invalidate(dossiersProvider);
      ref.invalidate(dossierStatsProvider);
      AppLogger.i('DossierNotifier', 'Dossier créé : $id');

      // Journal d'activité (fire-and-forget)
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.dossierCree,
        entityType: 'dossier',
        entityId: id,
        description: 'Création du dossier',
        metadata: {'nature': data['nature_sinistre']},
      );
      return id;
    } catch (e, s) {
      AppLogger.e('DossierNotifier', 'Erreur création dossier', error: e, stack: s);
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> updateDossier(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Récupérer le label avant mise à jour
      final dossier = await ref.read(dossierRepositoryProvider).getById(id);
      await ref.read(dossierRepositoryProvider).update(id, toJsonSafe(data));
      ref.invalidate(dossiersProvider);

      ref.read(auditServiceProvider).log(
        actionType: AuditActions.dossierModifie,
        entityType: 'dossier',
        entityId: id,
        entityLabel: dossier?.numero,
        description: 'Modification du dossier',
      );
    });
  }

  Future<void> changerStatut(String id, String statut, {String? motif}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dossier = await ref.read(dossierRepositoryProvider).getById(id);
      final ancienStatut = dossier?.statut;
      await ref.read(dossierRepositoryProvider).changerStatut(id, statut, motif: motif);
      ref.invalidate(dossiersProvider);
      ref.invalidate(dossierStatsProvider);

      final action = statut == 'annule'
          ? AuditActions.dossierAnnule
          : statut == 'clos'
              ? AuditActions.dossierClos
              : AuditActions.dossierStatutChange;

      ref.read(auditServiceProvider).log(
        actionType: action,
        entityType: 'dossier',
        entityId: id,
        entityLabel: dossier?.numero,
        description: motif != null
            ? 'Statut → $statut. Motif : $motif'
            : 'Statut → $statut',
        ancienneValeur: ancienStatut,
        nouvelleValeur: statut,
      );
    });
  }
}

final dossierNotifierProvider = AsyncNotifierProvider<DossierNotifier, void>(() {
  return DossierNotifier();
});
