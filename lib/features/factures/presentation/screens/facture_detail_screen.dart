import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/email_service.dart';
import '../../../../shared/services/pdf_service.dart';
import '../providers/facture_provider.dart';

class FactureDetailScreen extends ConsumerWidget {
  final String id;
  const FactureDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(factureDetailProvider(id));
    final lignesAsync = ref.watch(factureLignesProvider(id));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (facture) {
        if (facture == null) {
          return Scaffold(appBar: AppBar(title: const Text('Facture')), body: const Center(child: Text('Introuvable')));
        }
        final enRetard = facture.statut != 'payee' &&
            facture.statut != 'annulee' &&
            facture.dateEcheance.isBefore(DateTime.now());
        return Scaffold(
          appBar: AppBar(title: Text(facture.numero ?? 'Facture')),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Émise le ${FormatUtils.formatDate(facture.dateEmission)}', style: const TextStyle(color: Colors.grey)),
                      Row(children: [
                        Text(
                          'Échéance : ${FormatUtils.formatDate(facture.dateEcheance)}',
                          style: TextStyle(color: enRetard ? AppColors.danger : Colors.grey),
                        ),
                        if (enRetard) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.warning_outlined, color: AppColors.danger, size: 16),
                        ],
                      ]),
                    ]))),
                    const SizedBox(height: 12),
                    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Lignes', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
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
                          _Row('HT', facture.montantHt),
                          if (facture.tauxTva > 0)
                            _Row('TVA ${facture.tauxTva.toStringAsFixed(0)} %', facture.montantTva),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.navy.withAlpha(10), borderRadius: BorderRadius.circular(8)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('Total TTC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
                              Text(FormatUtils.formatFcfa(facture.montantTtc), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
                            ]),
                          ),
                        ]),
                      ),
                    ]))),
                    const SizedBox(height: 12),
                    if (facture.montantPaye > 0)
                      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Paiements', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                        const Divider(height: 16),
                        _Row('Payé', facture.montantPaye, color: AppColors.success),
                        _Row('Restant', facture.montantRestant, color: facture.montantRestant > 0 ? AppColors.danger : AppColors.success),
                      ]))),
                    if (MediaQuery.of(context).size.width < 800) ...[
                      const SizedBox(height: 24),
                      _buildQuickActions(context, ref, facture, lignesAsync.value, enRetard, true),
                    ],
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
                    child: _buildQuickActions(context, ref, facture, lignesAsync.value, enRetard, false),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, dynamic facture, List<FacturesLigne>? lignes, bool enRetard, bool isMobile) {
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
                  final pdf = await PdfService.genererFacture(
                    facture: facture,
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
              : () => _showEmailDialog(context, ref, facture, lignes),
        ),
        if (enRetard) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.notification_important_outlined, color: AppColors.warning),
            label: const Text('Envoyer une relance', style: TextStyle(color: AppColors.warning)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.warning)),
            onPressed: () => _showRelanceDialog(context, ref, facture),
          ),
        ],
        const SizedBox(height: 8),
        if (facture.statut != 'payee' && facture.statut != 'annulee')
          ElevatedButton.icon(
            icon: const Icon(Icons.payment),
            label: const Text('Enregistrer un paiement'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => _showPaiementDialog(context, ref),
          ),
      ],
    );
  }

  Future<void> _showEmailDialog(
      BuildContext context, WidgetRef ref, Facture facture, List<FacturesLigne> lignes) async {
    final emailCtrl = TextEditingController();
    bool sending = false;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Envoyer la facture par email'),
          content: TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email du destinataire',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
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
                        await ref.read(emailServiceProvider).envoyerFacture(
                              facture: facture,
                              lignes: lignes,
                              destinataire: email,
                            );
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Facture envoyée !')),
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

  Future<void> _showRelanceDialog(BuildContext context, WidgetRef ref, Facture facture) async {
    final emailCtrl = TextEditingController();
    bool sending = false;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Envoyer une relance'),
          content: TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email du destinataire',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton.icon(
              icon: sending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.notification_important_outlined),
              label: const Text('Relancer'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
              onPressed: sending
                  ? null
                  : () async {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty) return;
                      setS(() => sending = true);
                      try {
                        await ref.read(emailServiceProvider).envoyerRelance(
                              facture: facture,
                              destinataire: email,
                            );
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Relance envoyée !')),
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

  Future<void> _showPaiementDialog(BuildContext context, WidgetRef ref) async {
    final montantCtrl = TextEditingController();
    String? mode;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enregistrer un paiement'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: montantCtrl,
            decoration: const InputDecoration(labelText: 'Montant reçu (FCFA)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Mode de paiement'),
            items: const [
              DropdownMenuItem(value: 'virement', child: Text('Virement')),
              DropdownMenuItem(value: 'mobile_money', child: Text('Mobile Money')),
              DropdownMenuItem(value: 'especes', child: Text('Espèces')),
            ],
            onChanged: (v) => mode = v,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final montant = double.tryParse(montantCtrl.text);
              if (montant != null && montant > 0) {
                ref.read(factureNotifierProvider.notifier).enregistrerPaiement(id, montant, mode, null);
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final double amount;
  final Color? color;
  const _Row(this.label, this.amount, {this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(FormatUtils.formatFcfa(amount), style: TextStyle(fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}
