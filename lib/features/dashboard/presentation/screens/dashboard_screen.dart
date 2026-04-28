import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardStatsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dashboardStatsProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (stats) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardStatsProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // KPIs dossiers
              const Text('Dossiers', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _KpiCard(label: 'Total', value: '${stats.totalDossiers}', icon: Icons.folder_outlined, color: AppColors.navy)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'En cours', value: '${stats.dossiersEnCours}', icon: Icons.timelapse, color: AppColors.teal)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Nouveaux', value: '${stats.dossiersNouveaux}', icon: Icons.fiber_new_outlined, color: AppColors.info)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Clos', value: '${stats.dossiersClos}', icon: Icons.check_circle_outline, color: AppColors.success)),
              ]),
              const SizedBox(height: 16),
              // KPIs financiers
              const Text('Finances', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _KpiCard(label: 'CA ce mois', value: FormatUtils.formatFcfaCompact(stats.caMois), icon: Icons.trending_up, color: AppColors.success)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Créances', value: FormatUtils.formatFcfaCompact(stats.totalCreances), icon: Icons.account_balance_wallet_outlined, color: AppColors.warning)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Charges', value: FormatUtils.formatFcfaCompact(stats.chargesMois), icon: Icons.money_off_outlined, color: AppColors.danger)),
              ]),
              if (stats.pendingSyncCount > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning.withAlpha(100)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.sync_problem, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${stats.pendingSyncCount} élément(s) en attente de synchronisation',
                      style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
              ],
              // Accès rapides
              const SizedBox(height: 16),
              const Text('Accès rapides', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16)),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.2,
                children: [
                  _QuickAction(icon: Icons.folder_open_outlined, label: 'Nouveau dossier', onTap: () => context.push('/dossiers/new')),
                  _QuickAction(icon: Icons.person_add_outlined, label: 'Nouveau client', onTap: () => context.push('/clients/new')),
                  _QuickAction(icon: Icons.description_outlined, label: 'Nouveau devis', onTap: () => context.push('/devis/new')),
                  _QuickAction(icon: Icons.receipt_long_outlined, label: 'Factures', onTap: () => context.go('/factures')),
                  _QuickAction(icon: Icons.folder_outlined, label: 'Dossiers', onTap: () => context.go('/dossiers')),
                  _QuickAction(icon: Icons.people_outlined, label: 'Clients', onTap: () => context.go('/clients')),
                ],
              ),
              // Dossiers urgents
              if (stats.dossiersUrgents.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Dossiers urgents', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16)),
                const SizedBox(height: 8),
                ...stats.dossiersUrgents.map((d) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => context.push('/dossiers/${d.id}'),
                    leading: Icon(Icons.priority_high, color: d.priorite == 'urgente' ? AppColors.danger : AppColors.warning),
                    title: Text(d.titre, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(d.numero ?? '—'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                )),
              ],
              // Factures en retard
              if (stats.facturesEnRetard.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Factures en retard', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger, fontSize: 16)),
                const SizedBox(height: 8),
                ...stats.facturesEnRetard.map((f) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => context.push('/factures/${f.id}'),
                    leading: const Icon(Icons.warning_outlined, color: AppColors.danger),
                    title: Text(f.numero ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Échéance : ${FormatUtils.formatDate(f.dateEcheance)}'),
                    trailing: Text(FormatUtils.formatFcfa(f.montantRestant), style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                  ),
                )),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color.withAlpha(180), fontSize: 11)),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8)],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppColors.navy, size: 28),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.navy), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
