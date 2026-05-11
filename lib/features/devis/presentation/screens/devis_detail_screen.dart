import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/email_service.dart';
import '../../../../shared/services/pdf_service.dart';
import '../providers/devis_provider.dart';
import '../../../factures/presentation/providers/facture_provider.dart';

class DevisDetailScreen extends ConsumerWidget {
  final String id;
  const DevisDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(devisDetailProvider(id));
    final lignesAsync = ref.watch(devisLignesProvider(id));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (devis) {
        if (devis == null) {
          return Scaffold(appBar: AppBar(title: const Text('Devis')), body: const Center(child: Text('Introuvable')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(devis.numero ?? 'Devis'),
            actions: [
              if (devis.statut == 'brouillon')
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.push('/devis/${devis.id}/edit')),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    // En-tête
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.teal.withAlpha(100)),
                          ),
                          child: Text(
                            AppConstants.devisStatutLabels[devis.statut] ?? devis.statut,
                            style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      if (devis.objet != null)
                        Text(devis.objet!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        'Émis le ${FormatUtils.formatDate(devis.dateEmission)} · Valable jusqu\'au ${FormatUtils.formatDate(devis.dateValidite)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ]))),
                    const SizedBox(height: 12),
                    // Lignes
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Détail des prestations', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                      const Divider(height: 16),
                      lignesAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('$e'),
                        data: (lignes) => Column(children: [
                          ...lignes.map((l) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(children: [
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(l.designation, style: const TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                  '${l.quantite} ${l.unite} × ${FormatUtils.formatFcfa(l.prixUnit)}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ])),
                              Text(FormatUtils.formatFcfa(l.montantHt), style: const TextStyle(fontWeight: FontWeight.w600)),
                            ]),
                          )),
                          const Divider(),
                          _TotalRow('Sous-total HT', devis.montantHt),
                          if (devis.tauxTva > 0) _TotalRow('TVA (${devis.tauxTva.toStringAsFixed(0)} %)', devis.montantTva),
                          if (devis.tauxTps > 0) _TotalRow('TPS (${devis.tauxTps.toStringAsFixed(0)} %)', devis.montantTps),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.navy.withAlpha(10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('Total TTC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
                              Text(FormatUtils.formatFcfa(devis.montantTtc), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
                            ]),
                          ),
                        ]),
                      ),
                    ]))),
                    if (MediaQuery.of(context).size.width < 800) ...[
                      const SizedBox(height: 24),
                      _buildQuickActions(context, ref, devis, lignesAsync.value, true),
                    ]
                  ]),
                ),
              ),
              if (MediaQuery.of(context).size.width >= 800)
                Container(
                  width: 280,
                  decoration: const BoxDecoration(
                    color: AppColors.pageBg,
                    border: Border(left: BorderSide(color: AppColors.borderLight)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildQuickActions(context, ref, devis, lignesAsync.value, false),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, dynamic devis, List<DevisLigne>? lignes, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isMobile) ...[
          const Text('Actions Rapides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
        ],
        OutlinedButton.icon(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Aperçu / Imprimer PDF'),
          onPressed: lignes == null
              ? null
              : () async {
                  final pdf = await PdfService.genererDevis(
                    devis: devis,
                    lignes: lignes,
                  );
                  await Printing.layoutPdf(onLayout: (_) => pdf.save());
                },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.email_outlined),
          label: const Text('Envoyer par email'),
          onPressed: lignes == null
              ? null
              : () => _showEmailDialog(context, ref, devis, lignes),
        ),
        const SizedBox(height: 8),
        // Actions
        if (devis.statut == 'brouillon') ...[
          ElevatedButton.icon(
            icon: const Icon(Icons.send_outlined),
            label: const Text('Marquer comme envoyé'),
            onPressed: () => ref.read(devisNotifierProvider.notifier).updateStatut(devis.id, 'envoye'),
          ),
          const SizedBox(height: 8),
        ],
        if (devis.statut == 'envoye') ...[
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Marquer comme accepté'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => ref.read(devisNotifierProvider.notifier).updateStatut(devis.id, 'accepte'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.close, color: AppColors.danger),
            label: const Text('Marquer comme refusé', style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
            onPressed: () => ref.read(devisNotifierProvider.notifier).updateStatut(devis.id, 'refuse'),
          ),
          const SizedBox(height: 8),
        ],
        if (devis.statut == 'accepte')
          ElevatedButton.icon(
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('Convertir en facture'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmer la conversion'),
                  content: const Text('Voulez-vous transformer ce devis en facture ?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Convertir')),
                  ],
                ),
              );
              if (confirmed == true) {
                final factureId = await ref.read(factureNotifierProvider.notifier).createFromDevis(devis.id);
                if (factureId != null && context.mounted) {
                  context.go('/factures/$factureId');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facture générée avec succès !')));
                }
              }
            },
          ),
      ],
    );
  }

  Future<void> _showEmailDialog(
      BuildContext context, WidgetRef ref, Devi devis, List<DevisLigne> lignes) async {
    final emailCtrl = TextEditingController();
    bool sending = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Envoyer le devis par email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email du destinataire',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton.icon(
              icon: sending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: const Text('Envoyer'),
              onPressed: sending
                  ? null
                  : () async {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty) return;
                      setS(() => sending = true);
                      try {
                        await ref.read(emailServiceProvider).envoyerDevis(
                              devis: devis,
                              lignes: lignes,
                              destinataire: email,
                            );
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Devis envoyé !')),
                          );
                        }
                      } catch (e) {
                        setS(() => sending = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  const _TotalRow(this.label, this.amount);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(FormatUtils.formatFcfa(amount)),
    ]));
  }
}
