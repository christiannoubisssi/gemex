import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/document_rapport_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/dossier_documents_service.dart';
import '../../data/repositories/document_rapport_repository.dart';
import '../providers/document_rapport_provider.dart';
import '../providers/dossier_provider.dart';

/// Formulaire de saisie d'un document professionnel (sections libres + pré-remplissage).
/// Route : /dossiers/:id/documents/:type
class DocumentRapportFormScreen extends ConsumerStatefulWidget {
  final String dossierId;
  final TypeDocumentMetier type;

  const DocumentRapportFormScreen({
    super.key,
    required this.dossierId,
    required this.type,
  });

  @override
  ConsumerState<DocumentRapportFormScreen> createState() =>
      _DocumentRapportFormScreenState();
}

class _DocumentRapportFormScreenState
    extends ConsumerState<DocumentRapportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Un contrôleur par section
  late final List<TextEditingController> _controllers;
  late final List<SectionDoc> _sections;

  bool _loading = true;
  bool _saving = false;
  bool _generatingPdf = false;
  String _statut = 'brouillon'; // 'brouillon' | 'finalise'

  @override
  void initState() {
    super.initState();
    _sections = DocumentRapportConstants.sections(widget.type);
    _controllers = List.generate(_sections.length, (_) => TextEditingController());
    _loadExistant();
  }

  /// Charge le contenu déjà sauvegardé (s'il existe) et pré-remplit
  Future<void> _loadExistant() async {
    final existing = await ref
        .read(documentRapportRepositoryProvider)
        .get(widget.dossierId, widget.type);

    if (existing != null) {
      // Contenu déjà saisi
      final contenu = Map<String, String>.from(
        (jsonDecode(existing.contenuJson) as Map).cast<String, String>(),
      );
      for (var i = 0; i < _sections.length; i++) {
        _controllers[i].text = contenu[_sections[i].cle] ?? '';
      }
      _statut = existing.statut;
    } else {
      // Première ouverture : pré-remplir depuis le dossier
      final dossier = await AppDatabase.instance.dossiersDao
          .getById(widget.dossierId);
      if (dossier != null) {
        final fills =
            DocumentRapportConstants.prefill(widget.type, dossier);
        for (var i = 0; i < _sections.length; i++) {
          final v = fills[_sections[i].cle];
          if (v != null) _controllers[i].text = v;
        }
      }
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, String> _buildContenu() {
    final map = <String, String>{};
    for (var i = 0; i < _sections.length; i++) {
      map[_sections[i].cle] = _controllers[i].text.trim();
    }
    return map;
  }

  Future<void> _sauvegarder(String statut) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await ref.read(documentRapportNotifierProvider.notifier).sauvegarder(
          dossierId: widget.dossierId,
          type: widget.type,
          contenu: _buildContenu(),
          statut: statut,
          entrepriseId: 'default',
        );

    setState(() {
      _saving = false;
      _statut = statut;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(statut == 'finalise'
              ? '${widget.type.label} finalisé ✓'
              : 'Brouillon sauvegardé ✓'),
          backgroundColor: statut == 'finalise'
              ? AppColors.success
              : AppColors.primary,
        ),
      );
    }
  }

  Future<void> _genererPdf() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _generatingPdf = true);
    try {
      // Sauvegarder d'abord
      await ref.read(documentRapportNotifierProvider.notifier).sauvegarder(
            dossierId: widget.dossierId,
            type: widget.type,
            contenu: _buildContenu(),
            statut: _statut,
            entrepriseId: 'default',
          );

      // Récupérer le dossier pour le bandeau PDF
      final dossier = await AppDatabase.instance.dossiersDao
          .getById(widget.dossierId);
      if (dossier == null) return;

      await DossierDocumentsService.previsualiser(
        type: widget.type,
        dossier: dossier,
        contenu: _buildContenu(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur PDF : $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.type.label)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Bandeau dossier en haut
    final dossierAsync = ref.watch(dossierDetailProvider(widget.dossierId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.label),
        actions: [
          // Statut badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: _StatutChip(statut: _statut),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Info dossier (bandeau haut) ───────────────────────────────
            dossierAsync.maybeWhen(
              data: (d) => d == null
                  ? const SizedBox()
                  : _DossierBandeau(dossier: d),
              orElse: () => const SizedBox(height: 4),
            ),

            // ── Sections saisissables ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _sections.length; i++)
                      _SectionField(
                        section: _sections[i],
                        controller: _controllers[i],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Barre d'actions persistante ───────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              // Sauvegarder brouillon
              Expanded(
                child: OutlinedButton.icon(
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Brouillon'),
                  onPressed: (_saving || _generatingPdf)
                      ? null
                      : () => _sauvegarder('brouillon'),
                ),
              ),
              const SizedBox(width: 8),
              // Finaliser
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Finaliser'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success),
                  onPressed: (_saving || _generatingPdf)
                      ? null
                      : () => _sauvegarder('finalise'),
                ),
              ),
              const SizedBox(width: 8),
              // Générer PDF
              Expanded(
                child: ElevatedButton.icon(
                  icon: _generatingPdf
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('PDF'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy),
                  onPressed: (_saving || _generatingPdf) ? null : _genererPdf,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets internes ─────────────────────────────────────────────────────────

class _DossierBandeau extends StatelessWidget {
  final Dossier dossier;
  const _DossierBandeau({required this.dossier});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy.withAlpha(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.folder_outlined, size: 16, color: AppColors.navy),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${dossier.numero ?? 'Dossier local'}  •  ${dossier.titre}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.navy,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (dossier.lieuSinistre != null) ...[
            const SizedBox(width: 8),
            Text(
              dossier.lieuSinistre!,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (dossier.dateSinistre != null) ...[
            const SizedBox(width: 8),
            Text(
              FormatUtils.formatDate(dossier.dateSinistre),
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionField extends StatelessWidget {
  final SectionDoc section;
  final TextEditingController controller;

  const _SectionField({
    required this.section,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: section.multiline ? null : 1,
            minLines: section.multiline ? 4 : 1,
            keyboardType: section.multiline
                ? TextInputType.multiline
                : TextInputType.text,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: section.placeholder.isEmpty ? null : section.placeholder,
              hintStyle: TextStyle(
                  color: AppColors.textMuted.withAlpha(160), fontSize: 12),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatutChip extends StatelessWidget {
  final String statut;
  const _StatutChip({required this.statut});

  @override
  Widget build(BuildContext context) {
    final bool finalise = statut == 'finalise';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (finalise ? AppColors.success : AppColors.warning).withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                (finalise ? AppColors.success : AppColors.warning).withAlpha(120)),
      ),
      child: Text(
        finalise ? 'Finalisé' : 'Brouillon',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: finalise ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }
}
