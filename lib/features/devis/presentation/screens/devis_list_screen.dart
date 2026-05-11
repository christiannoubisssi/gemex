import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../providers/devis_provider.dart';

class DevisListScreen extends ConsumerWidget {
  const DevisListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devisAsync = ref.watch(devisAllProvider);
    final clientsMap = ref.watch(clientsMapProvider).valueOrNull ?? {};
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Devis')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/devis/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau devis'),
      ),
      body: devisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (devisList) {
          if (devisList.isEmpty) {
            return const _EmptyState();
          }
          final total = devisList.length;
          final enCours = devisList.where((d) => d.statut == AppConstants.devisBrouillon || d.statut == AppConstants.devisEnvoye).length;
          final acceptes = devisList.where((d) => d.statut == AppConstants.devisAccepte).length;

          return Column(
            children: [
              _KPISection(total: total, enCours: enCours, acceptes: acceptes),
              if (isWide) const _TableHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: devisList.length,
                  itemBuilder: (_, i) {
                    final d = devisList[i];
                    final clientNom = clientsMap[d.clientId] ?? '—';
                    return isWide
                        ? _TableRow(d: d, clientNom: clientNom)
                        : _Card(d: d, clientNom: clientNom);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Table header ─────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: const BoxDecoration(
          color: AppColors.tableHeaderBg,
          border: Border(
            top: BorderSide(color: AppColors.borderLight),
            bottom: BorderSide(color: AppColors.borderLight),
          ),
        ),
        child: const Row(children: [
          Expanded(flex: 2, child: _ColLabel('NUMÉRO')),
          Expanded(flex: 3, child: _ColLabel('CLIENT')),
          Expanded(flex: 2, child: _ColLabel('DATE CRÉATION')),
          Expanded(flex: 2, child: _ColLabel('MONTANT TTC')),
          Expanded(flex: 2, child: _ColLabel('STATUT')),
        ]),
      );
}

// ─── Table row (wide) ─────────────────────────────────────────────────────

class _TableRow extends StatelessWidget {
  final dynamic d;
  final String clientNom;
  const _TableRow({required this.d, required this.clientNom});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.push('/devis/${d.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF0F1F3))),
          ),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Text(d.numero ?? '—',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
            ),
            Expanded(
              flex: 3,
              child: Text(clientNom,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(FormatUtils.formatDate(d.dateEmission),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
            Expanded(
              flex: 2,
              child: Text(FormatUtils.formatFcfa(d.montantTtc),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatutChip(statut: d.statut),
              ),
            ),
          ]),
        ),
      );
}

// ─── Card (narrow) ────────────────────────────────────────────────────────
// ─── Shared widgets ───────────────────────────────────────────────────────

class _ColLabel extends StatelessWidget {
  final String text;
  const _ColLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 0.5));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: AppColors.textMuted),
            SizedBox(height: 16),
            Text('Aucun devis', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            SizedBox(height: 8),
            Text('Créez votre premier devis en appuyant sur +',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
          ],
        ),
      );
}

// ─── KPI Section ──────────────────────────────────────────────────────────

class _KPISection extends StatelessWidget {
  final int total;
  final int enCours;
  final int acceptes;

  const _KPISection({required this.total, required this.enCours, required this.acceptes});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(child: _KPICard(title: 'Total', count: total, color: AppColors.navy)),
          const SizedBox(width: 8),
          Expanded(child: _KPICard(title: 'En cours', count: enCours, color: AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(child: _KPICard(title: 'Acceptés', count: acceptes, color: AppColors.success)),
        ],
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _KPICard({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count.toString(), style: TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
class _Card extends StatelessWidget {
  final dynamic d;
  final String clientNom;
  const _Card({required this.d, required this.clientNom});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: InkWell(
          onTap: () => context.push('/devis/${d.id}'),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(d.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy)),
                const Spacer(),
                _StatutChip(statut: d.statut),
              ]),
              const SizedBox(height: 6),
              Text(clientNom,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(FormatUtils.formatDate(d.dateEmission),
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const Spacer(),
                Text(FormatUtils.formatFcfa(d.montantTtc),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
              ]),
            ]),
          ),
        ),
      );
}



class _StatutChip extends StatelessWidget {
  final String statut;
  const _StatutChip({required this.statut});

  Color get _color {
    switch (statut) {
      case 'accepte': return AppColors.success;
      case 'refuse': return AppColors.danger;
      case 'envoye': return AppColors.info;
      case 'expire': return AppColors.textMuted;
      default: return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(AppConstants.devisStatutLabels[statut] ?? statut,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
