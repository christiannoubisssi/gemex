import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../data/agent_stats_provider.dart';

/// Tableau de bord de suivi individuel des agents (admin only).
class AgentSuiviScreen extends ConsumerStatefulWidget {
  const AgentSuiviScreen({super.key});

  @override
  ConsumerState<AgentSuiviScreen> createState() => _AgentSuiviScreenState();
}

class _AgentSuiviScreenState extends ConsumerState<AgentSuiviScreen> {
  PeriodeFiltre _periode = PeriodeFiltre.mois;
  AgentPerf? _agentSelectionne;

  @override
  Widget build(BuildContext context) {
    final perfsAsync = ref.watch(agentPerfsProvider(_periode));
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des agents'),
        actions: [
          // Sélecteur de période
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<PeriodeFiltre>(
              value: _periode,
              underline: const SizedBox(),
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              items: PeriodeFiltre.values
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _periode = v;
                  _agentSelectionne = null;
                });
              },
            ),
          ),
        ],
      ),
      body: perfsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (perfs) {
          if (perfs.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.group_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('Aucun agent trouvé pour cette période.',
                    style: TextStyle(color: Colors.grey)),
              ]),
            );
          }

          // Sélectionner le premier agent par défaut
          final agent = _agentSelectionne ?? perfs.first;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Liste des agents ──
                SizedBox(
                  width: 280,
                  child: _AgentList(
                    perfs: perfs,
                    agentSelectionne: agent,
                    onSelect: (p) => setState(() => _agentSelectionne = p),
                  ),
                ),
                const VerticalDivider(width: 1),
                // ── Détail agent ──
                Expanded(
                  child: _AgentDetail(perf: agent, periode: _periode),
                ),
              ],
            );
          }

          // Mobile : liste + on tap → détail
          return _AgentList(
            perfs: perfs,
            agentSelectionne: null,
            onSelect: (p) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => _AgentDetailPage(perf: p, periode: _periode),
              ));
            },
          );
        },
      ),
    );
  }
}

// ── Liste des agents ──────────────────────────────────────────────────────────

class _AgentList extends StatelessWidget {
  final List<AgentPerf> perfs;
  final AgentPerf? agentSelectionne;
  final ValueChanged<AgentPerf> onSelect;

  const _AgentList({
    required this.perfs,
    required this.agentSelectionne,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: perfs.length,
      itemBuilder: (_, i) {
        final p = perfs[i];
        final isSelected = agentSelectionne?.agentId == p.agentId;
        return ListTile(
          selected: isSelected,
          selectedTileColor: AppColors.teal.withAlpha(20),
          leading: CircleAvatar(
            backgroundColor: isSelected
                ? AppColors.teal
                : AppColors.navy.withAlpha(30),
            child: Text(
              (p.agentNom.isNotEmpty ? p.agentNom[0] : '?').toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.navy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(p.agentNom,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${p.dossiersOuverts} dossier${p.dossiersOuverts > 1 ? 's' : ''} · '
            '${p.dossiersTraites} traité${p.dossiersTraites > 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: _MiniBar(
            valeur: p.dossiersOuverts,
            max: perfs.map((x) => x.dossiersOuverts).reduce((a, b) => a > b ? a : b),
          ),
          onTap: () => onSelect(p),
        );
      },
    );
  }
}

class _MiniBar extends StatelessWidget {
  final int valeur;
  final int max;
  const _MiniBar({required this.valeur, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = max == 0 ? 0.0 : valeur / max;
    return SizedBox(
      width: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$valeur',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.navy)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppColors.borderLight,
              color: AppColors.teal,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Détail agent ──────────────────────────────────────────────────────────────

class _AgentDetailPage extends StatelessWidget {
  final AgentPerf perf;
  final PeriodeFiltre periode;
  const _AgentDetailPage({required this.perf, required this.periode});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(perf.agentNom)),
        body: _AgentDetail(perf: perf, periode: periode),
      );
}

class _AgentDetail extends StatelessWidget {
  final AgentPerf perf;
  final PeriodeFiltre periode;
  const _AgentDetail({required this.perf, required this.periode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── En-tête agent ──
          Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.navy.withAlpha(20),
              child: Text(
                (perf.agentNom.isNotEmpty ? perf.agentNom[0] : '?').toUpperCase(),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(perf.agentNom,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Période : ${periode.label}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // ── KPIs ──
          _KpiGrid(perf: perf),
          const SizedBox(height: 20),

          // ── Graphique en barres (statuts) ──
          _StatutBarChart(perf: perf),
          const SizedBox(height: 20),

          // ── Dossiers en cours ──
          _DossiersEnCoursList(perf: perf),
        ],
      ),
    );
  }
}

// ── Grille KPI ────────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final AgentPerf perf;
  const _KpiGrid({required this.perf});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KpiCard(
          label: 'Dossiers ouverts',
          value: '${perf.dossiersOuverts}',
          icon: Icons.folder_open_outlined,
          color: AppColors.navy,
        ),
        _KpiCard(
          label: 'En cours',
          value: '${perf.dossiersEnCours}',
          icon: Icons.pending_outlined,
          color: AppColors.gold,
        ),
        _KpiCard(
          label: 'Traités',
          value: '${perf.dossiersTraites}',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        ),
        _KpiCard(
          label: 'Durée moy.',
          value: perf.dossiersTraites == 0
              ? '—'
              : '${perf.dureeTraitementMoyJours.toStringAsFixed(0)}j',
          icon: Icons.timer_outlined,
          color: AppColors.teal,
        ),
        _KpiCard(
          label: 'Actions journal',
          value: '${perf.actionsTotal}',
          icon: Icons.history_outlined,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Graphique statuts ─────────────────────────────────────────────────────────

class _StatutBarChart extends StatelessWidget {
  final AgentPerf perf;
  const _StatutBarChart({required this.perf});

  @override
  Widget build(BuildContext context) {
    // Comptage par statut
    final counts = <String, int>{};
    for (final d in perf.dossiersList) {
      counts[d.statut] = (counts[d.statut] ?? 0) + 1;
    }

    if (counts.isEmpty) return const SizedBox.shrink();
    final max = counts.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Répartition par statut',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 16),
            ...AppConstants.statutLabels.entries.map((e) {
              final count = counts[e.key] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              final ratio = max == 0 ? 0.0 : count / max;
              final color = _statutColor(e.key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  SizedBox(
                    width: 100,
                    child: Text(e.value,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        backgroundColor: AppColors.borderLight,
                        color: color,
                        minHeight: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$count',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: color)),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _statutColor(String s) {
    switch (s) {
      case AppConstants.statutBrouillon: return Colors.grey;
      case AppConstants.statutEnInstruction: return AppColors.gold;
      case AppConstants.statutEnCours: return AppColors.teal;
      case AppConstants.statutTermine: return AppColors.success;
      case AppConstants.statutAnnule: return AppColors.danger;
      default: return AppColors.navy;
    }
  }
}

// ── Dossiers en cours ─────────────────────────────────────────────────────────

class _DossiersEnCoursList extends StatelessWidget {
  final AgentPerf perf;
  const _DossiersEnCoursList({required this.perf});

  @override
  Widget build(BuildContext context) {
    final enCours = perf.dossiersList
        .where((d) =>
            d.statut != AppConstants.statutTermine &&
            d.statut != AppConstants.statutAnnule)
        .toList();

    if (enCours.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: const [
            Icon(Icons.check_circle_outline, color: AppColors.success),
            SizedBox(width: 8),
            Text('Aucun dossier en cours.', style: TextStyle(color: Colors.grey)),
          ]),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dossiers en cours (${enCours.length})',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const Divider(height: 16),
            ...enCours.map((d) => _DossierTile(dossier: d)),
          ],
        ),
      ),
    );
  }
}

class _DossierTile extends StatelessWidget {
  final Dossier dossier;
  const _DossierTile({required this.dossier});

  @override
  Widget build(BuildContext context) {
    final ageJours = DateTime.now().difference(dossier.createdAt).inDays;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.teal.withAlpha(20),
        child: const Icon(Icons.folder_outlined, size: 16, color: AppColors.teal),
      ),
      title: Text(
        dossier.numero ?? dossier.titre,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      subtitle: Text(
        '${AppConstants.statutLabels[dossier.statut] ?? dossier.statut} · '
        '${FormatUtils.formatDate(dossier.createdAt)}',
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: ageJours > 30
              ? AppColors.danger.withAlpha(20)
              : AppColors.gold.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$ageJours j',
          style: TextStyle(
              fontSize: 11,
              color: ageJours > 30 ? AppColors.danger : AppColors.gold,
              fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () => context.push('/dossiers/${dossier.id}'),
    );
  }
}
