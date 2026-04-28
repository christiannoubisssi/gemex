import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Dossiers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dossiers/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau dossier'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(label: 'Tous', selected: _filtreStatut == null, onTap: () => setState(() => _filtreStatut = null)),
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
          // Liste
          Expanded(
            child: dossiersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (dossiers) {
                if (dossiers.isEmpty) {
                  return _EmptyState(filtreActif: _filtreStatut != null || _search.isNotEmpty);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: dossiers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final d = dossiers[i];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.push('/dossiers/${d.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Numéro + badge local
                                  Text(
                                    d.numero ?? '—',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  if (d.numero != null && d.numero!.contains('LOCAL')) ...[
                                    const SizedBox(width: 6),
                                    const SyncBadge(),
                                  ],
                                  const Spacer(),
                                  StatusBadge(statut: d.statut),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                d.titre,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (d.lieuSinistre != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(d.lieuSinistre!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  PrioriteBadge(priorite: d.priorite),
                                  const Spacer(),
                                  Text(
                                    FormatUtils.formatDate(d.dateOuverture),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.navy : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool filtreActif;
  const _EmptyState({required this.filtreActif});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(filtreActif ? Icons.search_off : Icons.folder_open_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            filtreActif ? 'Aucun dossier trouvé' : 'Aucun dossier pour l\'instant',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (!filtreActif)
            Text(
              'Créez votre premier dossier en appuyant sur +',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
