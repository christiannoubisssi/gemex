import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../providers/dossier_provider.dart';
import '../widgets/status_badge.dart';

// ── Options de tri ────────────────────────────────────────────────────────────

enum _TriPar {
  dateDesc('Date ↓ (récent)'),
  dateAsc('Date ↑ (ancien)'),
  client('Client A→Z'),
  statut('Statut'),
  createur('Créé par');

  final String label;
  const _TriPar(this.label);
}

// ─────────────────────────────────────────────────────────────────────────────

class DossiersListScreen extends ConsumerStatefulWidget {
  const DossiersListScreen({super.key});

  @override
  ConsumerState<DossiersListScreen> createState() => _DossiersListScreenState();
}

class _DossiersListScreenState extends ConsumerState<DossiersListScreen> {
  String? _filtreStatut;
  String? _filtreCreateur;
  final _searchController = TextEditingController();
  String _search = '';
  _TriPar _triPar = _TriPar.dateDesc;
  bool _grouperParCreateur = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtre + tri en mémoire (données locales SQLite → toujours rapide)
  List<Dossier> _appliquer(List<Dossier> all, Map<String, String> clientsMap) {
    var list = all.where((d) {
      if (_filtreStatut != null && d.statut != _filtreStatut) return false;
      if (_filtreCreateur != null &&
          (d.createdByNom ?? '') != _filtreCreateur) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        final nomClient =
            d.clientId != null ? (clientsMap[d.clientId!] ?? '') : '';
        if (!d.titre.toLowerCase().contains(q) &&
            !(d.numero?.toLowerCase().contains(q) ?? false) &&
            !nomClient.toLowerCase().contains(q) &&
            !(d.createdByNom?.toLowerCase().contains(q) ?? false)) return false;
      }
      return true;
    }).toList();

    switch (_triPar) {
      case _TriPar.dateAsc:
        list.sort((a, b) => a.dateOuverture.compareTo(b.dateOuverture));
      case _TriPar.client:
        list.sort((a, b) {
          final ca = a.clientId != null ? (clientsMap[a.clientId!] ?? '') : '';
          final cb = b.clientId != null ? (clientsMap[b.clientId!] ?? '') : '';
          return ca.toLowerCase().compareTo(cb.toLowerCase());
        });
      case _TriPar.statut:
        list.sort((a, b) => a.statut.compareTo(b.statut));
      case _TriPar.createur:
        list.sort((a, b) =>
            (a.createdByNom ?? '').compareTo(b.createdByNom ?? ''));
      case _TriPar.dateDesc:
        list.sort((a, b) => b.dateOuverture.compareTo(a.dateOuverture));
    }
    return list;
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
          // Barre tri + filtre créateur + regroupement
          dossiersAsync.maybeWhen(
            data: (all) {
              // Liste des créateurs uniques présents dans les données chargées
              final createurs = all
                  .map((d) => d.createdByNom)
                  .whereType<String>()
                  .toSet()
                  .toList()
                ..sort();
              return _TriFiltreBar(
                triPar: _triPar,
                filtreCreateur: _filtreCreateur,
                createurs: createurs,
                grouperParCreateur: _grouperParCreateur,
                onTri: (t) => setState(() => _triPar = t),
                onCreateur: (c) => setState(() => _filtreCreateur = c),
                onGrouper: (v) => setState(() => _grouperParCreateur = v),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          // Table header (wide)
          if (isWide) const _TableHeader(),
          // Liste
          Expanded(
            child: dossiersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (all) {
                final filtered = _appliquer(all, clientsMap);
                if (filtered.isEmpty) {
                  return _EmptyState(
                      filtreActif: _filtreStatut != null ||
                          _filtreCreateur != null ||
                          _search.isNotEmpty);
                }

                if (_grouperParCreateur) {
                  // Regroupement par créateur
                  final groupes = <String, List<Dossier>>{};
                  for (final d in filtered) {
                    final key = d.createdByNom ?? 'Non renseigné';
                    groupes.putIfAbsent(key, () => []).add(d);
                  }
                  final keys = groupes.keys.toList()..sort();

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      for (final key in keys) ...[
                        _GroupHeader(label: key, count: groupes[key]!.length),
                        for (final d in groupes[key]!)
                          _buildRow(d, clientsMap, isWide),
                      ]
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      _buildRow(filtered[i], clientsMap, isWide),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(Dossier d, Map<String, String> clientsMap, bool isWide) {
    final clientNom =
        d.clientId != null ? (clientsMap[d.clientId!] ?? '—') : '—';
    return isWide
        ? _TableRow(d: d, clientNom: clientNom)
        : _Card(d: d, clientNom: clientNom);
  }
}

// ── Barre tri + filtre créateur ───────────────────────────────────────────────

class _TriFiltreBar extends StatelessWidget {
  final _TriPar triPar;
  final String? filtreCreateur;
  final List<String> createurs;
  final bool grouperParCreateur;
  final ValueChanged<_TriPar> onTri;
  final ValueChanged<String?> onCreateur;
  final ValueChanged<bool> onGrouper;

  const _TriFiltreBar({
    required this.triPar,
    required this.filtreCreateur,
    required this.createurs,
    required this.grouperParCreateur,
    required this.onTri,
    required this.onCreateur,
    required this.onGrouper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(children: [
        // ── Trier par ───────────────────────────────────────────────────
        const Icon(Icons.sort, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        DropdownButton<_TriPar>(
          value: triPar,
          isDense: true,
          underline: const SizedBox.shrink(),
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
          items: _TriPar.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
              .toList(),
          onChanged: (t) { if (t != null) onTri(t); },
        ),
        const SizedBox(width: 16),
        // ── Créé par ─────────────────────────────────────────────────────
        if (createurs.isNotEmpty) ...[
          const Icon(Icons.person_outline, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 6),
          DropdownButton<String?>(
            value: filtreCreateur,
            isDense: true,
            underline: const SizedBox.shrink(),
            hint: const Text('Tous les utilisateurs',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Tous',
                    style: TextStyle(fontSize: 12)),
              ),
              ...createurs.map((c) => DropdownMenuItem<String?>(
                    value: c,
                    child: Text(c, style: const TextStyle(fontSize: 12)),
                  )),
            ],
            onChanged: onCreateur,
          ),
          const SizedBox(width: 12),
        ],
        const Spacer(),
        // ── Regrouper par créateur ────────────────────────────────────────
        Tooltip(
          message: grouperParCreateur
              ? 'Désactiver le regroupement'
              : 'Regrouper par utilisateur',
          child: InkWell(
            onTap: () => onGrouper(!grouperParCreateur),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: grouperParCreateur
                    ? AppColors.navy.withAlpha(20)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: grouperParCreateur
                      ? AppColors.navy
                      : AppColors.borderLight,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  Icons.group_work_outlined,
                  size: 14,
                  color: grouperParCreateur
                      ? AppColors.navy
                      : AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Regrouper',
                  style: TextStyle(
                    fontSize: 11,
                    color: grouperParCreateur
                        ? AppColors.navy
                        : AppColors.textMuted,
                    fontWeight: grouperParCreateur
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Séparateur de groupe ──────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final String label;
  final int count;
  const _GroupHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: AppColors.pageBg,
        child: Row(children: [
          const Icon(Icons.person_outline,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.navy.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      );
}

// ─── Table header ─────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: const BoxDecoration(
          color: AppColors.tableHeaderBg,
          border:
              Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        child: const Row(children: [
          Expanded(flex: 2, child: _ColLabel('NUMÉRO')),
          Expanded(flex: 3, child: _ColLabel('TITRE')),
          Expanded(flex: 2, child: _ColLabel('CLIENT')),
          Expanded(flex: 2, child: _ColLabel('CRÉÉ PAR')),
          Expanded(flex: 2, child: _ColLabel('DATE OUVERTURE')),
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
            border: Border(
                bottom: BorderSide(color: Color(0xFFF0F1F3))),
          ),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Row(children: [
                Text(d.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.navy)),
                if (d.numero != null &&
                    (d.numero as String).contains('LOCAL')) ...[
                  const SizedBox(width: 6),
                  const SyncBadge(),
                ],
              ]),
            ),
            Expanded(
              flex: 3,
              child: Text(d.titre,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(clientNom,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(d.createdByNom ?? '—',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 2,
              child: Text(FormatUtils.formatDate(d.dateOuverture),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(d.numero ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.navy)),
                if (d.numero != null &&
                    (d.numero as String).contains('LOCAL')) ...[
                  const SizedBox(width: 6),
                  const SyncBadge(),
                ],
                const Spacer(),
                StatusBadge(statut: d.statut),
              ]),
              const SizedBox(height: 6),
              Text(d.titre,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(clientNom,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                PrioriteBadge(priorite: d.priorite),
                const Spacer(),
                if (d.createdByNom != null) ...[
                  const Icon(Icons.person_outline,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 3),
                  Text(d.createdByNom!,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(FormatUtils.formatDate(d.dateOuverture),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
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
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color:
                selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.borderLight,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
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
            Icon(
                filtreActif
                    ? Icons.search_off
                    : Icons.folder_open_outlined,
                size: 64,
                color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              filtreActif
                  ? 'Aucun dossier trouvé'
                  : "Aucun dossier pour l'instant",
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (!filtreActif)
              const Text(
                'Créez votre premier dossier en appuyant sur +',
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 14),
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
          final total =
              stats.values.fold(0, (sum, count) => sum + count);
          final enCours =
              (stats[AppConstants.statutBrouillon] ?? 0) +
                  (stats[AppConstants.statutEnInstruction] ?? 0) +
                  (stats[AppConstants.statutEnCours] ?? 0);
          final clos = stats[AppConstants.statutTermine] ?? 0;
          return Row(
            children: [
              Expanded(
                  child: _KPICard(
                      title: 'Total',
                      count: total,
                      color: AppColors.navy)),
              const SizedBox(width: 8),
              Expanded(
                  child: _KPICard(
                      title: 'En cours',
                      count: enCours,
                      color: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(
                  child: _KPICard(
                      title: 'Terminés',
                      count: clos,
                      color: AppColors.success)),
            ],
          );
        },
        loading: () => const SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator())),
        error: (_, __) => const SizedBox(),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _KPICard(
      {required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 22,
                  color: color,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
