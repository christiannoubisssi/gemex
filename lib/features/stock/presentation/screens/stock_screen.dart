import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../produits/presentation/providers/produit_provider.dart';
import '../providers/stock_provider.dart';
import 'mouvement_form_screen.dart';

class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produitsAsync = ref.watch(produitsProvider);
    final stockAsync = ref.watch(stockQuantitesProvider);
    final mouvementsAsync = ref.watch(stockMouvementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestion du stock')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Mouvement'),
        onPressed: () => _showMouvementDialog(context),
      ),
      body: produitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (produits) {
          final stocks = stockAsync.valueOrNull ?? {};
          // Filtrer les produits suivis en stock (ceux qui ont des mouvements ou stockMin > 0)
          final produitsStock = produits.where((p) =>
              stocks.containsKey(p.id) || p.stockMin > 0).toList();

          return Column(
            children: [
              // Résumé
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Produits en stock',
                      value: '${produitsStock.length}',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: 'Alertes stock bas',
                      value: '${produitsStock.where((p) => p.stockMin > 0 && (stocks[p.id] ?? 0) < p.stockMin).length}',
                      icon: Icons.warning_amber,
                      color: AppColors.danger,
                    ),
                  ],
                ),
              ),
              // Tableau
              Expanded(
                child: produitsStock.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('Aucun mouvement de stock', style: TextStyle(color: Colors.grey)),
                            Text('Ajoutez un mouvement via le bouton +', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                        itemCount: produitsStock.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final p = produitsStock[i];
                          final qty = stocks[p.id] ?? 0;
                          final alerte = p.stockMin > 0 && qty < p.stockMin;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: alerte
                                  ? AppColors.danger.withAlpha(25)
                                  : AppColors.teal.withAlpha(25),
                              child: Icon(
                                alerte ? Icons.warning_amber : Icons.inventory_2_outlined,
                                color: alerte ? AppColors.danger : AppColors.teal,
                                size: 20,
                              ),
                            ),
                            title: Text(p.nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('${p.code} · ${p.unite}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  FormatUtils.formatQuantite(qty),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: alerte ? AppColors.danger : AppColors.navy,
                                  ),
                                ),
                                if (p.stockMin > 0)
                                  Text(
                                    'Min: ${FormatUtils.formatQuantite(p.stockMin)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: alerte ? AppColors.danger : Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () => _showHistorique(context, ref, p),
                          );
                        },
                      ),
              ),
              // Derniers mouvements
              if (mouvementsAsync.valueOrNull?.isNotEmpty == true) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Derniers mouvements', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${mouvementsAsync.value!.length} total',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (mouvementsAsync.value!.length).clamp(0, 5),
                    itemBuilder: (_, i) {
                      final m = mouvementsAsync.value![i];
                      final isEntree = m.type == 'entree';
                      final produit = produits.where((p) => p.id == m.produitId).firstOrNull;
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isEntree ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isEntree ? AppColors.success : AppColors.danger,
                          size: 18,
                        ),
                        title: Text(produit?.nom ?? m.produitId, style: const TextStyle(fontSize: 13)),
                        subtitle: Text(FormatUtils.formatDate(m.dateMouvement),
                            style: const TextStyle(fontSize: 11)),
                        trailing: Text(
                          '${isEntree ? '+' : '-'}${FormatUtils.formatQuantite(m.quantite)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isEntree ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showMouvementDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: MouvementFormScreen(),
      ),
    );
  }

  void _showHistorique(BuildContext context, WidgetRef ref, Produit produit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.7,
        child: _HistoriqueSheet(produit: produit),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoriqueSheet extends ConsumerWidget {
  final Produit produit;
  const _HistoriqueSheet({required this.produit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mouvementsAsync = ref.watch(stockMouvementsProduitProvider(produit.id));
    return Scaffold(
      appBar: AppBar(title: Text('Historique — ${produit.nom}')),
      body: mouvementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('Aucun mouvement'))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final m = list[i];
                  final isEntree = m.type == 'entree';
                  return ListTile(
                    leading: Icon(
                      isEntree ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isEntree ? AppColors.success : AppColors.danger,
                    ),
                    title: Text('${isEntree ? 'Entrée' : 'Sortie'} · ${FormatUtils.formatQuantite(m.quantite)} ${produit.unite}'),
                    subtitle: Text(
                      '${FormatUtils.formatDate(m.dateMouvement)}${m.reference != null ? ' · ${m.reference}' : ''}',
                    ),
                    trailing: m.prixUnitaire > 0
                        ? Text(FormatUtils.formatFcfa(m.prixUnitaire * m.quantite))
                        : null,
                  );
                },
              ),
      ),
    );
  }
}
