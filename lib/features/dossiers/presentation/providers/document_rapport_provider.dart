import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/dossier_documents_service.dart';
import '../../data/repositories/document_rapport_repository.dart';

/// Stream de tous les documents d'un dossier (clé = dossierId)
final documentsRapportProvider =
    StreamProvider.autoDispose.family<List<DocumentsRapportData>, String>(
  (ref, dossierId) =>
      ref.read(documentRapportRepositoryProvider).watchByDossier(dossierId),
);

/// Statut par type pour un dossier (null = jamais renseigné)
final documentRapportStatutProvider =
    FutureProvider.autoDispose.family<DocumentsRapportData?, (String, TypeDocumentMetier)>(
  (ref, args) =>
      ref.read(documentRapportRepositoryProvider).get(args.$1, args.$2),
);

/// Notifier pour sauvegarder
class DocumentRapportNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> sauvegarder({
    required String dossierId,
    required TypeDocumentMetier type,
    required Map<String, String> contenu,
    required String statut,
    required String entrepriseId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(documentRapportRepositoryProvider).save(
              dossierId: dossierId,
              type: type,
              contenu: contenu,
              statut: statut,
              entrepriseId: entrepriseId,
            ));
  }
}

final documentRapportNotifierProvider =
    AsyncNotifierProvider<DocumentRapportNotifier, void>(
        DocumentRapportNotifier.new);
