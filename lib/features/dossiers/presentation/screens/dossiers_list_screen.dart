import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../providers/dossier_provider.dart';
import '../widgets/status_badge.dart';

class DossiersListScreen extends ConsumerStatefulWidget {
  const DossiersListScreen({super.key});

  @override
  ConsumerState<DossiersListScreen> createState() => _DossiersListScreenState();
}

class _DossiersListScreenState extends ConsumerState<DossiersListScreen> {
  String? _filtreStatut;
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dossiersAsync = _search.isNotEmpty
        ? ref.watch(dossierSearchProvider(_search))
        : ref.watch(dossiersProvider(_filtreStatut));
    final clientsMap = ref.watch(clientsMapProvider).valueOrNull ?? {};
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Dossiers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dossiers/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau dossier'),
      ),
      body: Column(
        children: [
          const _KPISection(),
          // Barre de recherche
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un dossier…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          // Filtres par statut
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tous',
                    selected: _filtreStatut == null,
                    onTap: () => setState(() => _filtreStatut = null),
                  ),
                  const SizedBox(width: 8),
                  ...AppConstants.statutsDossier
                      .where((s) => s != AppConstants.statutAnnule)
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterChip(
                              label: AppConstants.statutLabels[s] ?? s,
                              selected: _filtreStatut == s,
                              onTap: () => setState(() => _filtreStatut = s),
                            ),
                          )),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Table header
          if (isWide) const _TableHeader(),
          // Liste
          Expanded(
            child: dossiersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (dossiers) {
                if (dossiers.isEmpty) {
                  return _EmptyState(filtreActif: _filtreStatut != null || _search.isNotEmpty);
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: dossiers.length,
                  itemBuilder: (_, i) {
                    final d = dossiers[i];
                    final clientNom = d.clientId != null ? (clientsMap[d.clientId!] ?? '—') : '—';
                    return isWide
                        ? _TableRow(d: d, clientNom: clientNom)
                        : _Card(d: d, clientNom: clientNom);
                  },
                );
              },
            ),
          ),
        ],
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
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        child: const Row(children: [
          Expanded(flex: 2, child: _ColLabel('NUMÉRO')),
          Expanded(flex: 3, child: _ColLabel('TITRE')),
          Expanded(flex: 2, child: _ColLabel('CLIENT')),
          Expanded(flex: 2, child: _ColLabel('DATE OUVERTURE')),
          Expanded(flex: 2, child: _ColLabel('DATE MISSION')),
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
        onTap: () => context.push('/dossiers/${d.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF0F1F3))),
          ),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Row(children: [
                Text(d.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                if (d.numero != null && (d.numero as String).contains('LOCAL')) ...[
                  const SizedBox(width: 6),
                  const SyncBadge(),
                ],
              ]),
            ),
            Expanded(
              flex: 3,
              child: Text(d.titre,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(clientNom,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(FormatUtils.formatDate(d.dateOuverture),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                d.dateExpertise != null ? FormatUtils.formatDate(d.dateExpertise!) : '—',
                style: TextStyle(
                    fontSize: 12,
                    color: d.dateExpertise != null ? AppColors.textMuted : AppColors.textMuted.withAlpha(120)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(statut: d.statut),
              ),
            ),
          ]),
        ),
      );
}

// ─── Card (narrow) ────────────────────────────────────────────────────────

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
          onTap: () => context.push('/dossiers/${d.id}'),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(d.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy)),
                if (d.numero != null && (d.numero as String).contains('LOCAL')) ...[
                  const SizedBox(width: 6),
                  const SyncBadge(),
                ],
                const Spacer(),
                StatusBadge(statut: d.statut),
              ]),
              const SizedBox(height: 6),
              Text(d.titre,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(clientNom,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(children: [
                PrioriteBadge(priorite: d.priorite),
                const Spacer(),
                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(FormatUtils.formatDate(d.dateOuverture),
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                if (d.dateExpertise != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.engineering_outlined, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(FormatUtils.formatDate(d.dateExpertise!),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ]),
            ]),
          ),
        ),
      );
}

// ─── Filter chip ──────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
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

class _EmptyState extends StatelessWidget {
  final bool filtreActif;
  const _EmptyState({required this.filtreActif});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(filtreActif ? Icons.search_off : Icons.folder_open_outlined,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              filtreActif ? 'Aucun dossier trouvé' : "Aucun dossier pour l'instant",
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (!filtreActif)
              const Text(
                'Créez votre premier dossier en appuyant sur +',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
          ],
        ),
      );
}

// ─── KPI Section ──────────────────────────────────────────────────────────

class _KPISection extends ConsumerWidget {
  const _KPISection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dossierStatsProvider);

    return Container(
      color: AppColors.pageBg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: statsAsync.when(
        data: (stats) {
          final total = stats.values.fold(0, (sum, count) => sum + count);
          final enCours = (stats[AppConstants.statutBrouillon] ?? 0) +
                          (stats[AppConstants.statutEnInstruction] ?? 0) +
                          (stats[AppConstants.statutEnCours] ?? 0);
          final clos = stats[AppConstants.statutTermine] ?? 0;
          return Row(
            children: [
              Expanded(child: _KPICard(title: 'Total', count: total, color: AppColors.navy)),
              const SizedBox(width: 8),
              Expanded(child: _KPICard(title: 'En cours', count: enCours, color: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: _KPICard(title: 'Terminés', count: clos, color: AppColors.success)),
            ],
          );
        },
        loading: () => const SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
        error: (_, __) => const SizedBox(),
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
