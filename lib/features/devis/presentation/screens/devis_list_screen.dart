import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/devis_provider.dart';

class DevisListScreen extends ConsumerWidget {
  const DevisListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(devisListProvider({}));
    return Scaffold(
      appBar: AppBar(title: const Text('Devis')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/devis/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau devis'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (devisList) {
          if (devisList.isEmpty) return const Center(child: Text('Aucun devis'));
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: devisList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final d = devisList[i];
              final color = _statutColor(d.statut);
              return Card(
                child: ListTile(
                  onTap: () => context.push('/devis/${d.id}'),
                  leading: Container(width: 4, color: color),
                  title: Row(children: [
                    Text(
                      d.numero ?? '—',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppConstants.devisStatutLabels[d.statut] ?? d.statut,
                        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                  subtitle: Text(FormatUtils.formatDate(d.dateEmission)),
                  trailing: Text(
                    FormatUtils.formatFcfa(d.montantTtc),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _statutColor(String statut) {
    switch (statut) {
      case 'accepte': return AppColors.success;
      case 'refuse': return AppColors.danger;
      case 'envoye': return AppColors.info;
      case 'expire': return Colors.grey;
      default: return AppColors.warning;
    }
  }
}
