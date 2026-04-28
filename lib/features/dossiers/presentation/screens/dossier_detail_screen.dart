import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/dossier_provider.dart';
import '../widgets/status_badge.dart';

class DossierDetailScreen extends ConsumerWidget {
  final String id;
  const DossierDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dossierDetailProvider(id));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Dossier')),
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (dossier) {
        if (dossier == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Dossier')),
            body: const Center(child: Text('Dossier introuvable')),
          );
        }

        final nextStatut = AppConstants.nextStatut[dossier.statut];
        final peutAnnuler = dossier.statut != AppConstants.statutClos &&
            dossier.statut != AppConstants.statutAnnule;

        return Scaffold(
          appBar: AppBar(
            title: Text(dossier.numero ?? 'Dossier'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/dossiers/${dossier.id}/edit'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StatusBadge(statut: dossier.statut),
                            const SizedBox(width: 8),
                            PrioriteBadge(priorite: dossier.priorite),
                            if (dossier.numero != null && dossier.numero!.contains('LOCAL')) ...[
                              const SizedBox(width: 8),
                              const SyncBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          dossier.titre,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (dossier.description != null) ...[
                          const SizedBox(height: 8),
                          Text(dossier.description!, style: const TextStyle(color: Colors.grey)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Bouton workflow
                if (nextStatut != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: Text('Passer à : ${AppConstants.statutLabels[nextStatut]}'),
                      onPressed: () => _confirmerChangementStatut(context, ref, dossier.id, nextStatut),
                    ),
                  ),
                if (peutAnnuler) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
                      label: const Text('Annuler ce dossier', style: TextStyle(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                      onPressed: () => _confirmerAnnulation(context, ref, dossier.id),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Informations sinistre
                _Section(
                  title: 'Informations sinistre',
                  icon: Icons.info_outline,
                  children: [
                    _InfoRow('Date du sinistre', FormatUtils.formatDate(dossier.dateSinistre)),
                    _InfoRow('Lieu', dossier.lieuSinistre),
                    _InfoRow('Nature', dossier.natureSinistre),
                    if (dossier.montantSinistre != null)
                      _InfoRow('Montant déclaré', FormatUtils.formatFcfa(dossier.montantSinistre)),
                  ],
                ),

                // Assurance
                if (dossier.compagnieAssurance != null || dossier.numeroPolice != null)
                  _Section(
                    title: 'Assurance',
                    icon: Icons.shield_outlined,
                    children: [
                      _InfoRow('Compagnie', dossier.compagnieAssurance),
                      _InfoRow('N° police', dossier.numeroPolice),
                      _InfoRow('Courtier', dossier.courtier),
                    ],
                  ),

                // Dates
                _Section(
                  title: 'Dates clés',
                  icon: Icons.calendar_today_outlined,
                  children: [
                    _InfoRow('Ouverture', FormatUtils.formatDate(dossier.dateOuverture)),
                    _InfoRow('Expertise', FormatUtils.formatDate(dossier.dateExpertise)),
                    _InfoRow('Rapport', FormatUtils.formatDate(dossier.dateRapport)),
                    _InfoRow('Clôture', FormatUtils.formatDate(dossier.dateCloture)),
                    if (dossier.deadline != null)
                      _InfoRow('Échéance', FormatUtils.formatDate(dossier.deadline),
                          highlight: dossier.deadline!.isBefore(DateTime.now())),
                  ],
                ),

                // Notes
                if (dossier.notesInternes != null)
                  _Section(
                    title: 'Notes internes',
                    icon: Icons.note_outlined,
                    children: [
                      Text(dossier.notesInternes!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),

                // Actions
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.description_outlined),
                        label: const Text('Devis'),
                        onPressed: () => context.push('/devis/new?dossierId=${dossier.id}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.receipt_outlined),
                        label: const Text('Facture'),
                        onPressed: () => context.push('/factures/new?dossierId=${dossier.id}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.attach_file_outlined),
                    label: const Text('Pièces jointes'),
                    onPressed: () => context.push('/dossiers/${dossier.id}/pieces-jointes'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmerChangementStatut(
      BuildContext context, WidgetRef ref, String id, String nouveauStatut) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer le changement'),
        content: Text(
            'Passer le dossier au statut "${AppConstants.statutLabels[nouveauStatut]}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true), child: const Text('Confirmer')),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(dossierNotifierProvider.notifier).changerStatut(id, nouveauStatut);
  }

  Future<void> _confirmerAnnulation(BuildContext context, WidgetRef ref, String id) async {
    final motifController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Annuler le dossier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cette action est irréversible.'),
            const SizedBox(height: 16),
            TextField(
              controller: motifController,
              decoration: const InputDecoration(labelText: 'Motif d\'annulation (obligatoire)'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Retour')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Annuler le dossier'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref
        .read(dossierNotifierProvider.notifier)
        .changerStatut(id, AppConstants.statutAnnule, motif: motifController.text);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _Section({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.teal),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              ],
            ),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool highlight;
  const _InfoRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    if (value == null || value == '—') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: highlight ? AppColors.danger : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
