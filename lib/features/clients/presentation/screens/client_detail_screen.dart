import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/client_provider.dart';

class ClientDetailScreen extends ConsumerWidget {
  final String id;
  const ClientDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(clientDetailProvider(id));
    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Erreur : $e'))),
      data: (client) {
        if (client == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Client')),
            body: const Center(child: Text('Client introuvable')),
          );
        }
        final solde = client.totalFacture - client.totalPaye;
        return Scaffold(
          appBar: AppBar(
            title: Text(client.nom),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/clients/${client.id}/edit'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.teal,
                      child: Text(
                        client.nom.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(client.nom, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(client.typeClient, style: const TextStyle(color: Colors.grey)),
                    ])),
                  ]),
                  if (solde > 0) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.danger.withAlpha(50)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.warning_outlined, color: AppColors.danger, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Solde dû : ${FormatUtils.formatFcfa(solde)}',
                          style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                  ],
                ]))),
                const SizedBox(height: 12),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Coordonnées', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const Divider(height: 16),
                  if (client.email != null) _InfoRow(Icons.email_outlined, client.email!),
                  if (client.telephone != null) _InfoRow(Icons.phone_outlined, client.telephone!),
                  if (client.adresse != null)
                    _InfoRow(Icons.location_on_outlined, '${client.adresse}${client.ville != null ? ", ${client.ville}" : ""}'),
                ]))),
                const SizedBox(height: 12),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Résumé financier', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const Divider(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total facturé', style: TextStyle(color: Colors.grey)),
                    Text(FormatUtils.formatFcfa(client.totalFacture), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total payé', style: TextStyle(color: Colors.grey)),
                    Text(FormatUtils.formatFcfa(client.totalPaye), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
                  ]),
                ]))),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Nouveau dossier pour ce client'),
                  onPressed: () => context.push('/dossiers/new'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      Icon(icon, size: 18, color: AppColors.teal),
      const SizedBox(width: 12),
      Expanded(child: Text(text)),
    ]));
  }
}
