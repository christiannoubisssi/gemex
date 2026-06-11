import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/charges_modeles_provider.dart';
import '../../../../shared/services/charges_modele_pdf_service.dart';
import '../../../parametres/data/parametres_provider.dart';

const _moisLabels = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

const _statutLabels = {
  'brouillon': 'Brouillon',
  'soumis': 'Soumis',
  'valide': 'Validé',
  'refuse': 'Refusé',
  'reporte': 'Reporté',
};

const _statutColors = {
  'brouillon': Colors.grey,
  'soumis': Color(0xFF1A8A9A),
  'valide': Colors.green,
  'refuse': Colors.red,
  'reporte': Colors.orange,
};

const _prioriteLabels = {'basse': 'Basse', 'normale': 'Normale', 'haute': 'Haute', 'urgente': 'Urgente'};
const _prioriteColors = {
  'basse': Colors.grey,
  'normale': Color(0xFF1A8A9A),
  'haute': Colors.orange,
  'urgente': Colors.red,
};

const _ligneStatutColors = {
  'pending': Colors.grey,
  'valide': Colors.green,
  'refuse': Colors.red,
  'reporte': Colors.orange,
};

class ChargesModeleDetailScreen extends ConsumerWidget {
  final String id;
  const ChargesModeleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeleAsync = ref.watch(chargesModeleDetailProvider(id));
    final lignesAsync = ref.watch(chargesModeleLignesProvider(id));

    return modeleAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
      data: (modele) {
        if (modele == null) {
          return const Scaffold(body: Center(child: Text('Modèle introuvable')));
        }
        return _DetailView(modele: modele, lignesAsync: lignesAsync);
      },
    );
  }
}

class _DetailView extends ConsumerWidget {
  final ChargesModele modele;
  final AsyncValue<List<ChargesModeleLine>> lignesAsync;

  const _DetailView({required this.modele, required this.lignesAsync});

  Color get _statutColor => _statutColors[modele.statut] ?? Colors.grey;
  String get _statutLabel => _statutLabels[modele.statut] ?? modele.statut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chargesModeleNotifierProvider.notifier);
    final canSubmit = modele.statut == 'brouillon';
    final canValidate = modele.statut == 'soumis';

    return Scaffold(
      appBar: AppBar(
        title: Text(modele.titre, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Imprimer / PDF',
            onPressed: () async {
              final lignes = await AppDatabase.instance.chargesModelesDao.getLignes(modele.id);
              final logoBytes = await ref.read(logoBytesProvider.future);
              await Printing.layoutPdf(
                onLayout: (_) => ChargesModelePdfService.generate(modele, lignes, logoBytes: logoBytes),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête statut
            _StatutBanner(color: _statutColor, label: _statutLabel, modele: modele),
            const SizedBox(height: 16),

            // Lignes
            const _SectionTitle('Lignes de charges'),
            const SizedBox(height: 8),
            lignesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Erreur: $e'),
              data: (lignes) {
                if (lignes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aucune ligne', style: TextStyle(color: Colors.grey)),
                  );
                }
                final total = lignes.fold<double>(0, (s, l) => s + l.montant);
                return Column(
                  children: [
                    ...lignes.map((l) => _LigneTile(
                          ligne: l,
                          canValidate: canValidate,
                          modeleId: modele.id,
                          onStatut: (statut, motif) async {
                            await ref
                                .read(chargesModeleNotifierProvider.notifier)
                                .updateLigneStatut(l.id, statut, motif: motif, modeleId: modele.id);
                          },
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Total : ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          FormatUtils.formatFcfa(total),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Actions
            if (modele.statut == 'refuse' && modele.motifRefus != null) ...[
              const _SectionTitle('Motif de refus'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(modele.motifRefus!, style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            _ActionButtons(
              modele: modele,
              canSubmit: canSubmit,
              canValidate: canValidate,
              onSoumettre: () async {
                await notifier.soumettre(modele.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modèle soumis pour validation')),
                  );
                }
              },
              onValider: () async {
                await notifier.valider(modele.id, 'user', 'Valideur');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modèle validé'), backgroundColor: Colors.green),
                  );
                }
              },
              onRefuser: () => _showRefusDialog(context, ref),
              onReporter: () async {
                await notifier.reporter(modele.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modèle reporté'), backgroundColor: Colors.orange),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRefusDialog(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Refuser le modèle'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: 'Motif du refus *',
            hintText: 'Expliquez la raison du refus...',
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Refuser'),
          ),
        ],
      ),
    );

    if (ok == true && ctrl.text.trim().isNotEmpty) {
      await ref.read(chargesModeleNotifierProvider.notifier)
          .refuser(modele.id, ctrl.text.trim(), 'user', 'Valideur');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modèle refusé'), backgroundColor: Colors.red),
        );
      }
    }
    ctrl.dispose();
  }
}

class _StatutBanner extends StatelessWidget {
  final Color color;
  final String label;
  final ChargesModele modele;
  const _StatutBanner({required this.color, required this.label, required this.modele});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_moisLabels[modele.mois]} ${modele.annee}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
                ),
                if (modele.soumisParNom != null)
                  Text('Soumis par: ${modele.soumisParNom}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (modele.valideParNom != null)
                  Text('Validé par: ${modele.valideParNom}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LigneTile extends StatelessWidget {
  final ChargesModeleLine ligne;
  final bool canValidate;
  final String modeleId;
  final Future<void> Function(String statut, String? motif) onStatut;

  const _LigneTile({
    required this.ligne,
    required this.canValidate,
    required this.modeleId,
    required this.onStatut,
  });

  Color get _prioColor => _prioriteColors[ligne.priorite] ?? Colors.grey;
  Color get _ligneColor => _ligneStatutColors[ligne.statut] ?? Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(ligne.designation,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _prioColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _prioriteLabels[ligne.priorite] ?? ligne.priorite,
                          style: TextStyle(fontSize: 10, color: _prioColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(FormatUtils.formatFcfa(ligne.montant),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                      if (ligne.dateEcheance != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.calendar_today, size: 10, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Text(
                          DateFormat('dd/MM/yy').format(ligne.dateEcheance!),
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                  if (ligne.notes != null && ligne.notes!.isNotEmpty)
                    Text(ligne.notes!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  if (ligne.statut != 'pending')
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: _ligneColor),
                        const SizedBox(width: 4),
                        Text(
                          ligne.statut == 'valide'
                              ? 'Validée'
                              : ligne.statut == 'refuse'
                                  ? 'Refusée${ligne.motifRefus != null ? ": ${ligne.motifRefus}" : ""}'
                                  : 'Reportée',
                          style: TextStyle(fontSize: 11, color: _ligneColor),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (canValidate)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'valide', child: Text('Valider')),
                  const PopupMenuItem(value: 'refuse', child: Text('Refuser')),
                  const PopupMenuItem(value: 'reporte', child: Text('Reporter')),
                ],
                onSelected: (action) async {
                  if (action == 'refuse') {
                    final ctrl = TextEditingController();
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Motif du refus'),
                        content: TextField(controller: ctrl, autofocus: true),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Confirmer'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) await onStatut('refuse', ctrl.text.trim());
                    ctrl.dispose();
                  } else {
                    await onStatut(action, null);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ChargesModele modele;
  final bool canSubmit;
  final bool canValidate;
  final VoidCallback onSoumettre;
  final VoidCallback onValider;
  final VoidCallback onRefuser;
  final VoidCallback onReporter;

  const _ActionButtons({
    required this.modele,
    required this.canSubmit,
    required this.canValidate,
    required this.onSoumettre,
    required this.onValider,
    required this.onRefuser,
    required this.onReporter,
  });

  @override
  Widget build(BuildContext context) {
    if (!canSubmit && !canValidate) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        if (canSubmit)
          FilledButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Soumettre pour validation'),
            onPressed: onSoumettre,
          ),
        if (canValidate) ...[
          FilledButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Valider le modèle'),
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            onPressed: onValider,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.schedule),
                  label: const Text('Reporter'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                  onPressed: onReporter,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Refuser'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: onRefuser,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 15));
  }
}
