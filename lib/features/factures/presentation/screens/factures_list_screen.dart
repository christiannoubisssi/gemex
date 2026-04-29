import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../providers/facture_provider.dart';

class FacturesListScreen extends ConsumerStatefulWidget {
  const FacturesListScreen({super.key});

  @override
  ConsumerState<FacturesListScreen> createState() => _FacturesListScreenState();
}

class _FacturesListScreenState extends ConsumerState<FacturesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _tabs = [null, 'emise', 'partiellement_payee', 'payee', 'annulee'];
  static const _tabLabels = ['Toutes', 'Émises', 'Part. payées', 'Payées', 'Annulées'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsMap = ref.watch(clientsMapProvider).valueOrNull ?? {};
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((statut) {
          final async = ref.watch(facturesProvider(statut));
          return async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (factures) {
              if (factures.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textMuted),
                      SizedBox(height: 16),
                      Text('Aucune facture',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  if (isWide) const _TableHeader(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 40),
                      itemCount: factures.length,
                      itemBuilder: (_, i) {
                        final f = factures[i];
                        final clientNom = clientsMap[f.clientId] ?? '—';
                        final enRetard = f.statut != 'payee' &&
                            f.statut != 'annulee' &&
                            f.dateEcheance.isBefore(DateTime.now());
                        return isWide
                            ? _TableRow(f: f, clientNom: clientNom, enRetard: enRetard)
                            : _Card(f: f, clientNom: clientNom, enRetard: enRetard);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
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
          Expanded(flex: 2, child: _ColLabel('DATE ÉMISSION')),
          Expanded(flex: 2, child: _ColLabel('ÉCHÉANCE')),
          Expanded(flex: 2, child: _ColLabel('MONTANT TTC')),
          Expanded(flex: 2, child: _ColLabel('STATUT')),
        ]),
      );
}

// ─── Table row (wide) ─────────────────────────────────────────────────────

class _TableRow extends StatelessWidget {
  final dynamic f;
  final String clientNom;
  final bool enRetard;
  const _TableRow({required this.f, required this.clientNom, required this.enRetard});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.push('/factures/${f.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: enRetard ? AppColors.danger.withAlpha(5) : Colors.white,
            border: const Border(bottom: BorderSide(color: Color(0xFFF0F1F3))),
          ),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Row(children: [
                Text(f.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                if (enRetard) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ]),
            ),
            Expanded(
              flex: 3,
              child: Text(clientNom,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(FormatUtils.formatDate(f.dateEmission),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                FormatUtils.formatDate(f.dateEcheance),
                style: TextStyle(
                    fontSize: 12,
                    color: enRetard ? AppColors.danger : AppColors.textMuted,
                    fontWeight: enRetard ? FontWeight.w600 : FontWeight.normal),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(FormatUtils.formatFcfa(f.montantTtc),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  if (f.montantRestant > 0)
                    Text('Reste : ${FormatUtils.formatFcfa(f.montantRestant)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.danger)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatutChip(statut: f.statut),
              ),
            ),
          ]),
        ),
      );
}

// ─── Card (narrow) ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final dynamic f;
  final String clientNom;
  final bool enRetard;
  const _Card({required this.f, required this.clientNom, required this.enRetard});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enRetard ? AppColors.danger.withAlpha(80) : AppColors.borderLight,
          ),
        ),
        child: InkWell(
          onTap: () => context.push('/factures/${f.id}'),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(f.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy)),
                if (enRetard) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.danger, borderRadius: BorderRadius.circular(4)),
                    child: const Text('En retard',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
                const Spacer(),
                _StatutChip(statut: f.statut),
              ]),
              const SizedBox(height: 6),
              Text(clientNom,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(FormatUtils.formatDate(f.dateEmission),
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(width: 8),
                Icon(Icons.event_outlined, size: 12,
                    color: enRetard ? AppColors.danger : AppColors.textMuted),
                const SizedBox(width: 4),
                Text(FormatUtils.formatDate(f.dateEcheance),
                    style: TextStyle(
                        fontSize: 12,
                        color: enRetard ? AppColors.danger : AppColors.textMuted,
                        fontWeight: enRetard ? FontWeight.w600 : FontWeight.normal)),
                const Spacer(),
                Text(FormatUtils.formatFcfa(f.montantTtc),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
              ]),
            ]),
          ),
        ),
      );
}

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

class _StatutChip extends StatelessWidget {
  final String statut;
  const _StatutChip({required this.statut});

  Color get _color {
    switch (statut) {
      case 'payee': return AppColors.success;
      case 'partiellement_payee': return AppColors.teal;
      case 'emise': return AppColors.info;
      case 'annulee': return AppColors.textMuted;
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
      child: Text(AppConstants.factureStatutLabels[statut] ?? statut,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
