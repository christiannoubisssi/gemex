import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/dashboard_provider.dart';
import '../../../dashboard/data/rapport_pdf_service.dart';
import '../../../parametres/data/user_management_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardStatsProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;

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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              _GreetingHeader(profileAsync: profileAsync),
              const SizedBox(height: 24),

              const _SectionTitle('Dossiers'),
              const SizedBox(height: 12),
              _KpiGrid(
                isWide: isWide,
                crossCount: 4,
                children: [
                  _KpiCard(label: 'Total', value: '${stats.totalDossiers}', icon: Icons.folder_outlined, iconColor: AppColors.navy),
                  _KpiCard(label: 'En cours', value: '${stats.dossiersEnCours}', icon: Icons.timelapse_outlined, iconColor: AppColors.teal),
                  _KpiCard(label: 'Nouveaux', value: '${stats.dossiersNouveaux}', icon: Icons.fiber_new_outlined, iconColor: AppColors.info),
                  _KpiCard(label: 'Clos', value: '${stats.dossiersClos}', icon: Icons.check_circle_outline, iconColor: AppColors.success),
                ],
              ),
              const SizedBox(height: 24),

              const _SectionTitle('Finances ce mois'),
              const SizedBox(height: 12),
              _KpiGrid(
                isWide: isWide,
                crossCount: 3,
                children: [
                  _KpiCard(
                    label: "Chiffre d'affaires",
                    value: FormatUtils.formatFcfaCompact(stats.caMois),
                    icon: Icons.trending_up_outlined,
                    iconColor: AppColors.success,
                  ),
                  _KpiCard(
                    label: 'Charges',
                    value: FormatUtils.formatFcfaCompact(stats.chargesMois),
                    icon: Icons.money_off_outlined,
                    iconColor: AppColors.danger,
                  ),
                  _KpiCard(
                    label: 'Résultat net',
                    value: FormatUtils.formatFcfaCompact(stats.resultatMois),
                    icon: stats.resultatMois >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    iconColor: stats.resultatMois >= 0 ? AppColors.success : AppColors.danger,
                    trendPositive: stats.resultatMois >= 0,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _KpiGrid(
                isWide: isWide,
                crossCount: 3,
                children: [
                  _KpiCard(
                    label: 'Créances',
                    value: FormatUtils.formatFcfaCompact(stats.totalCreances),
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.warning,
                  ),
                  _KpiCard(
                    label: 'Taux recouvrement',
                    value: '${stats.tauxRecouvrement.toStringAsFixed(0)} %',
                    icon: Icons.pie_chart_outline,
                    iconColor: stats.tauxRecouvrement >= 80 ? AppColors.success : AppColors.warning,
                  ),
                  _KpiCard(
                    label: 'Masse salariale',
                    value: FormatUtils.formatFcfaCompact(stats.masseSalarialeMois),
                    icon: Icons.people_outline,
                    iconColor: AppColors.slate,
                  ),
                ],
              ),

              if (stats.ca6Mois.any((v) => v > 0) || stats.charges6Mois.any((v) => v > 0)) ...[
                const SizedBox(height: 24),
                const _SectionTitle('CA vs Charges — 6 mois'),
                const SizedBox(height: 12),
                _CaChargesChart(ca: stats.ca6Mois, charges: stats.charges6Mois, labels: stats.labels6Mois),
              ],

              if (stats.totalDossiers > 0) ...[
                const SizedBox(height: 24),
                const _SectionTitle('Répartition dossiers'),
                const SizedBox(height: 12),
                _DossiersChart(counts: stats.dossierCounts),
              ],

              if (stats.pendingSyncCount > 0) ...[
                const SizedBox(height: 24),
                _SyncBanner(count: stats.pendingSyncCount),
              ],

              const SizedBox(height: 24),
              const _SectionTitle('Accès rapides'),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 6 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.05,
                children: [
                  _QuickAction(icon: Icons.folder_open_outlined, label: 'Nouveau\ndossier', onTap: () => context.push('/dossiers/new')),
                  _QuickAction(icon: Icons.person_add_outlined, label: 'Nouveau\nclient', onTap: () => context.push('/clients/new')),
                  _QuickAction(icon: Icons.description_outlined, label: 'Nouveau\ndevis', onTap: () => context.push('/devis/new')),
                  _QuickAction(icon: Icons.receipt_long_outlined, label: 'Factures', onTap: () => context.go('/factures')),
                  _QuickAction(icon: Icons.folder_outlined, label: 'Dossiers', onTap: () => context.go('/dossiers')),
                  _QuickAction(icon: Icons.people_outlined, label: 'Clients', onTap: () => context.go('/clients')),
                ],
              ),

              if (stats.dossiersUrgents.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionTitle('Dossiers urgents'),
                const SizedBox(height: 12),
                _ListCard(
                  borderColor: AppColors.warning.withAlpha(80),
                  children: stats.dossiersUrgents.map((d) => ListTile(
                    onTap: () => context.push('/dossiers/${d.id}'),
                    leading: _IconBox(
                      icon: Icons.priority_high,
                      color: d.priorite == 'urgente' ? AppColors.danger : AppColors.warning,
                    ),
                    title: Text(d.titre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(d.numero ?? '—', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
                  )).toList(),
                ),
              ],

              if (stats.facturesEnRetard.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionTitle('Factures en retard', color: AppColors.danger),
                const SizedBox(height: 12),
                _ListCard(
                  borderColor: AppColors.danger.withAlpha(60),
                  children: stats.facturesEnRetard.map((f) => ListTile(
                    onTap: () => context.push('/factures/${f.id}'),
                    leading: const _IconBox(icon: Icons.warning_outlined, color: AppColors.danger),
                    title: Text(f.numero ?? '—', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('Échéance : ${FormatUtils.formatDate(f.dateEcheance)}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    trailing: Text(FormatUtils.formatFcfa(f.montantRestant),
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 13)),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Greeting ─────────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  final AsyncValue<dynamic> profileAsync;
  const _GreetingHeader({required this.profileAsync});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final nom = profileAsync.valueOrNull?.nom;
    final email = profileAsync.valueOrNull?.email ?? '';
    final displayName = nom?.isNotEmpty == true ? nom!.split(' ').first : email.split('@').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 26, color: AppColors.textPrimary),
            children: [
              TextSpan(text: _greeting),
              TextSpan(
                text: ', $displayName !',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Vue d'ensemble de votre activité",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Section title ────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle(this.title, {this.color = AppColors.textPrimary});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: color, fontSize: 15, letterSpacing: 0.1)),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: AppColors.borderLight)),
        ],
      );
}

// ─── KPI grid (responsive) ────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final bool isWide;
  final int crossCount;
  final List<Widget> children;
  const _KpiGrid({required this.isWide, required this.crossCount, required this.children});

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        children: children
            .asMap()
            .entries
            .expand((e) => [
                  Expanded(child: e.value),
                  if (e.key < children.length - 1) const SizedBox(width: 12),
                ])
            .toList(),
      );
    }
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossCount == 4 ? 2 : crossCount,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.2,
      children: children,
    );
  }
}

// ─── KPI Card ─────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final bool? trendPositive;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.trendPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          if (trendPositive != null) ...[
            const SizedBox(height: 4),
            Row(children: [
              Icon(trendPositive! ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 11, color: trendPositive! ? AppColors.success : AppColors.danger),
              const SizedBox(width: 2),
              Text(
                trendPositive! ? 'Bénéficiaire' : 'Déficitaire',
                style: TextStyle(
                    fontSize: 11,
                    color: trendPositive! ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}

// ─── Reusable list card ───────────────────────────────────────────────────

class _ListCard extends StatelessWidget {
  final List<Widget> children;
  final Color borderColor;
  const _ListCard({required this.children, required this.borderColor});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: children.asMap().entries.map((e) {
            final isLast = e.key == children.length - 1;
            return Column(children: [
              e.value,
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ]);
          }).toList(),
        ),
      );
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      );
}

// ─── Sync banner ──────────────────────────────────────────────────────────

class _SyncBanner extends StatelessWidget {
  final int count;
  const _SyncBanner({required this.count});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warning.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.warning.withAlpha(80)),
        ),
        child: Row(children: [
          const Icon(Icons.sync_problem, color: AppColors.warning, size: 20),
          const SizedBox(width: 10),
          Text('$count élément(s) en attente de synchronisation',
              style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w500, fontSize: 13)),
        ]),
      );
}

// ─── Quick action ─────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.navy.withAlpha(10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.navy, size: 22),
              ),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3),
                  textAlign: TextAlign.center),
            ]),
          ),
        ),
      );
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
      child: Column(children: [
        SizedBox(
          height: 200,
          child: BarChart(BarChartData(
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
                  reservedSize: 52,
                  getTitlesWidget: (v, _) => Text(FormatUtils.formatFcfaCompact(v),
                      style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                    return Text(labels[i],
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary));
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  const FlLine(color: AppColors.borderLight, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(
              ca.length,
              (i) => BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                    toY: ca[i],
                    color: AppColors.teal,
                    width: 10,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                BarChartRodData(
                    toY: charges[i],
                    color: AppColors.danger.withAlpha(180),
                    width: 10,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
              ]),
            ),
          )),
        ),
        const SizedBox(height: 10),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _Legend(color: AppColors.teal, label: 'CA'),
          SizedBox(width: 20),
          _Legend(color: AppColors.danger, label: 'Charges'),
        ]),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]);
}

// ─── Donut dossiers par statut ─────────────────────────────────────────────

const _statutColors = {
  'nouveau': AppColors.statutNouveau,
  'en_instruction': AppColors.statutEnInstruction,
  'expertise_en_cours': AppColors.statutExpertise,
  'rapport_redige': AppColors.statutRapport,
  'clos': AppColors.statutClos,
  'annule': AppColors.statutAnnule,
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        SizedBox(
          width: 130,
          height: 130,
          child: PieChart(PieChartData(
            sections: entries.map((e) {
              final color = _statutColors[e.key] ?? Colors.grey;
              final pct = total > 0 ? e.value / total * 100 : 0.0;
              return PieChartSectionData(
                value: e.value.toDouble(),
                color: color,
                title: '${pct.toStringAsFixed(0)}%',
                radius: 50,
                titleStyle: const TextStyle(
                    fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList(),
            sectionsSpace: 2,
            centerSpaceRadius: 24,
          )),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: _statutColors[e.key] ?? Colors.grey,
                                borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_statutLabels[e.key] ?? e.key,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textSecondary))),
                        Text('${e.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.textPrimary)),
                      ]),
                    ))
                .toList(),
          ),
        ),
      ]),
    );
  }
}
