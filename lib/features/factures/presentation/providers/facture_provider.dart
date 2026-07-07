import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/audit_service.dart';
import '../../data/repositories/facture_repository.dart';

final facturesProvider = FutureProvider.autoDispose.family<List<Facture>, String?>(
  (ref, statut) async => ref.read(factureRepositoryProvider).getAll(statut: statut),
);

final facturesByDossierProvider = FutureProvider.autoDispose.family<List<Facture>, String>(
  (ref, dossierId) async =>
      ref.read(factureRepositoryProvider).getAll(dossierId: dossierId),
);

final facturesByClientProvider = FutureProvider.autoDispose.family<List<Facture>, String>(
  (ref, clientId) async =>
      ref.read(factureRepositoryProvider).getAll(clientId: clientId),
);

final factureDetailProvider = FutureProvider.autoDispose.family<Facture?, String>(
  (ref, id) async => ref.read(factureRepositoryProvider).getById(id),
);

final factureLignesProvider = FutureProvider.autoDispose.family<List<FacturesLigne>, String>(
  (ref, factureId) async => ref.read(factureRepositoryProvider).getLignes(factureId),
);

final facturesEnRetardProvider = FutureProvider.autoDispose<List<Facture>>(
  (ref) async => ref.read(factureRepositoryProvider).getEnRetard(),
);

final totalCreancesProvider = FutureProvider.autoDispose<double>(
  (ref) async => ref.read(factureRepositoryProvider).getTotalCreances(),
);

class FactureNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> createFromDevis(String devisId) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(factureRepositoryProvider).createFromDevis(devisId);
      state = const AsyncData(null);
      ref.invalidate(facturesProvider);
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.factureCree,
        entityType: 'facture',
        entityId: id,
        description: 'Facture créée depuis devis',
        metadata: {'devis_id': devisId},
      );
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<String?> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(factureRepositoryProvider).create(data, lignes);
      state = const AsyncData(null);
      ref.invalidate(facturesProvider);
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.factureCree,
        entityType: 'facture',
        entityId: id,
        description: 'Facture créée',
        metadata: {'dossier_id': data['dossier_id']},
      );
      return id;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> validerFacture(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final facture = await ref.read(factureRepositoryProvider).getById(id);
      await ref.read(factureRepositoryProvider).validerFacture(id);
      ref.invalidate(factureDetailProvider(id));
      ref.invalidate(facturesProvider);
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.factureModifie,
        entityType: 'facture',
        entityId: id,
        entityLabel: facture?.numero,
        description: 'Facture validée (brouillon → émise)',
      );
    });
  }

  Future<void> annulerFacture(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final facture = await ref.read(factureRepositoryProvider).getById(id);
      await ref.read(factureRepositoryProvider).annulerFacture(id);
      ref.invalidate(factureDetailProvider(id));
      ref.invalidate(facturesProvider);
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.factureAnnulee,
        entityType: 'facture',
        entityId: id,
        entityLabel: facture?.numero,
        description: 'Facture annulée',
      );
    });
  }

  Future<void> enregistrerPaiement(String id, double montant, String? mode, String? reference) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final facture = await ref.read(factureRepositoryProvider).getById(id);
      await ref.read(factureRepositoryProvider).enregistrerPaiement(id, montant, mode, reference);
      ref.invalidate(factureDetailProvider(id));
      ref.invalidate(facturesProvider);
      ref.invalidate(totalCreancesProvider);
      ref.read(auditServiceProvider).log(
        actionType: AuditActions.facturePaye,
        entityType: 'facture',
        entityId: id,
        entityLabel: facture?.numero,
        description: 'Paiement de $montant FCFA enregistré${mode != null ? ' ($mode)' : ''}',
        nouvelleValeur: montant.toStringAsFixed(0),
        metadata: {'mode': mode, 'reference': reference},
      );
    });
  }
}

final factureNotifierProvider = AsyncNotifierProvider<FactureNotifier, void>(() => FactureNotifier());
