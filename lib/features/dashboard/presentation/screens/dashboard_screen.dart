import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/dashboard_provider.dart';
import '../../../dashboard/data/rapport_pdf_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardStatsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          if (async.valueOrNull != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              tooltip: 'Rapport mensuel PDF',
              onPressed: () async {
                final pdf = await RapportPdfService.generer(async.value!);
                await Printing.layoutPdf(onLayout: (_) => pdf.save());
              },
            ),
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
              const _SectionTitle('Dossiers'),
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
              const _SectionTitle('Finances ce mois'),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _KpiCard(label: 'CA', value: FormatUtils.formatFcfaCompact(stats.caMois), icon: Icons.trending_up, color: AppColors.success)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Charges', value: FormatUtils.formatFcfaCompact(stats.chargesMois), icon: Icons.money_off_outlined, color: AppColors.danger)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(
                  label: 'Résultat',
                  value: FormatUtils.formatFcfaCompact(stats.resultatMois),
                  icon: stats.resultatMois >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: stats.resultatMois >= 0 ? AppColors.success : AppColors.danger,
                )),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _KpiCard(label: 'Créances', value: FormatUtils.formatFcfaCompact(stats.totalCreances), icon: Icons.account_balance_wallet_outlined, color: AppColors.warning)),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(
                  label: 'Recouvrement',
                  value: '${stats.tauxRecouvrement.toStringAsFixed(0)} %',
                  icon: Icons.pie_chart_outline,
                  color: stats.tauxRecouvrement >= 80 ? AppColors.success : AppColors.warning,
                )),
                const SizedBox(width: 8),
                Expanded(child: _KpiCard(label: 'Masse salariale', value: FormatUtils.formatFcfaCompact(stats.masseSalarialeMois), icon: Icons.people_outline, color: AppColors.navy)),
              ]),
              const SizedBox(height: 16),

              // BarChart CA vs Charges 6 mois
              if (stats.ca6Mois.any((v) => v > 0) || stats.charges6Mois.any((v) => v > 0)) ...[
                const _SectionTitle('CA vs Charges — 6 mois'),
                const SizedBox(height: 8),
                _CaChargesChart(
                  ca: stats.ca6Mois,
                  charges: stats.charges6Mois,
                  labels: stats.labels6Mois,
                ),
                const SizedBox(height: 16),
              ],

              // PieChart dossiers par statut
              if (stats.totalDossiers > 0) ...[
                const _SectionTitle('Répartition dossiers'),
                const SizedBox(height: 8),
                _DossiersChart(counts: stats.dossierCounts),
                const SizedBox(height: 16),
              ],

              // Bannière sync
              if (stats.pendingSyncCount > 0) ...[
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
                    Text('${stats.pendingSyncCount} élément(s) en attente de synchronisation',
                        style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // Accès rapides
              const _SectionTitle('Accès rapides'),
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
                const _SectionTitle('Dossiers urgents'),
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
                const _SectionTitle('Factures en retard', color: AppColors.danger),
                const SizedBox(height: 8),
                ...stats.facturesEnRetard.map((f) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => context.push('/factures/${f.id}'),
                    leading: const Icon(Icons.warning_outlined, color: AppColors.danger),
                    title: Text(f.numero ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Échéance : ${FormatUtils.formatDate(f.dateEcheance)}'),
                    trailing: Text(FormatUtils.formatFcfa(f.montantRestant),
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
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

// ─── Graphique CA vs Charges ───────────────────────────────────────────────

class _CaChargesChart extends StatelessWidget {
  final List<double> ca;
  final List<double> charges;
  final List<String> labels;
  const _CaChargesChart({required this.ca, required this.charges, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxY = [...ca, ...charges].fold<double>(0, (m, v) => v > m ? v : m);
    final yInterval = maxY > 0 ? (maxY / 4).ceilToDouble() : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY > 0 ? maxY * 1.2 : 1.0,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                        FormatUtils.formatFcfaCompact(rod.toY),
                        const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: yInterval,
                        reservedSize: 48,
                        getTitlesWidget: (v, _) => Text(
                          FormatUtils.formatFcfaCompact(v),
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                          return Text(labels[i], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(ca.length, (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(toY: ca[i], color: AppColors.teal, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                      BarChartRodData(toY: charges[i], color: AppColors.danger.withAlpha(180), width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                    ],
                  )),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _Legend(color: AppColors.teal, label: 'CA'),
              SizedBox(width: 16),
              _Legend(color: AppColors.danger, label: 'Charges'),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(fontSize: 12)),
  ]);
}

// ─── Donut dossiers par statut ─────────────────────────────────────────────

const _statutColors = {
  'nouveau': Color(0xFF1A8A9A),
  'en_instruction': Color(0xFFF0A500),
  'expertise_en_cours': Color(0xFF0D2137),
  'rapport_redige': Color(0xFF8E24AA),
  'clos': Color(0xFF43A047),
  'annule': Color(0xFFE53935),
};

const _statutLabels = {
  'nouveau': 'Nouveau',
  'en_instruction': 'En instruction',
  'expertise_en_cours': 'Expertise',
  'rapport_redige': 'Rapport rédigé',
  'clos': 'Clos',
  'annule': 'Annulé',
};

class _DossiersChart extends StatelessWidget {
  final Map<String, int> counts;
  const _DossiersChart({required this.counts});

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.where((e) => e.value > 0).toList();
    if (entries.isEmpty) return const SizedBox.shrink();
    final total = entries.fold<int>(0, (s, e) => s + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: PieChart(
                PieChartData(
                  sections: entries.map((e) {
                    final color = _statutColors[e.key] ?? Colors.grey;
                    final pct = total > 0 ? e.value / total * 100 : 0.0;
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      color: color,
                      title: '${pct.toStringAsFixed(0)}%',
                      radius: 45,
                      titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(
                      color: _statutColors[e.key] ?? Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    )),
                    const SizedBox(width: 6),
                    Expanded(child: Text(_statutLabels[e.key] ?? e.key, style: const TextStyle(fontSize: 12))),
                    Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets communs ───────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle(this.title, {this.color = AppColors.navy});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
      );
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color.withAlpha(180), fontSize: 10)),
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
          Icon(icon, color: AppColors.navy, size: 26),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.navy), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
