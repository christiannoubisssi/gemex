import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../stock/presentation/providers/stock_provider.dart';
import '../providers/produit_provider.dart';

class ProduitsListScreen extends ConsumerStatefulWidget {
  const ProduitsListScreen({super.key});

  @override
  ConsumerState<ProduitsListScreen> createState() => _ProduitsListScreenState();
}

class _ProduitsListScreenState extends ConsumerState<ProduitsListScreen> {
  String _filtre = 'actifs'; // 'actifs' | 'vente' | 'achat' | 'archives'
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final provider = _filtre == 'archives' ? produitsTousProvider : produitsProvider;
    final produitsAsync = ref.watch(provider);
    final stockAsync = ref.watch(stockQuantitesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Stock',
            onPressed: () => context.push('/stock'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nouveau produit'),
        onPressed: () => context.push('/produits/new'),
      ),
      body: Column(
        children: [
          // Filtres
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Rechercher…',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _search = v.toLowerCase()),
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'actifs', label: Text('Tous')),
                    ButtonSegment(value: 'vente', label: Text('Vente')),
                    ButtonSegment(value: 'achat', label: Text('Achat')),
                    ButtonSegment(value: 'archives', label: Text('Archivés')),
                  ],
                  selected: {_filtre},
                  onSelectionChanged: (v) => setState(() => _filtre = v.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Liste
          Expanded(
            child: produitsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (list) {
                var filtered = list.where((p) {
                  if (_filtre == 'vente' && !p.estVente) return false;
                  if (_filtre == 'achat' && !p.estAchat) return false;
                  if (_filtre == 'archives' && p.actif) return false;
                  if (_filtre != 'archives' && !p.actif) return false;
                  if (_search.isNotEmpty) {
                    return p.nom.toLowerCase().contains(_search) ||
                        p.code.toLowerCase().contains(_search);
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_outlined, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Aucun produit', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final stocks = stockAsync.valueOrNull ?? {};

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _ProduitCard(
                    produit: filtered[i],
                    stock: stocks[filtered[i].id] ?? 0,
                    onTap: () => context.push('/produits/${filtered[i].id}/edit'),
                    onToggle: () {
                      ref.read(produitNotifierProvider.notifier)
                          .toggleActif(filtered[i].id, !filtered[i].actif);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProduitCard extends StatelessWidget {
  final Produit produit;
  final double stock;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const _ProduitCard({
    required this.produit,
    required this.stock,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final alerte = produit.stockMin > 0 && stock < produit.stockMin;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: produit.actif ? AppColors.teal.withAlpha(30) : Colors.grey.shade100,
          child: Text(
            produit.code.split('-').last,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: produit.actif ? AppColors.teal : Colors.grey,
            ),
          ),
        ),
        title: Text(
          produit.nom,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: produit.actif ? null : TextDecoration.lineThrough,
            color: produit.actif ? null : Colors.grey,
          ),
        ),
        subtitle: Row(
          children: [
            Text(produit.code, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(width: 8),
            if (produit.estVente)
              _Badge(label: 'Vente', color: AppColors.teal),
            if (produit.estAchat) ...[
              const SizedBox(width: 4),
              _Badge(label: 'Achat', color: AppColors.primary),
            ],
            const Spacer(),
            if (alerte)
              const Icon(Icons.warning_amber, color: AppColors.danger, size: 16),
            Text(
              'Stock: ${FormatUtils.formatQuantite(stock)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: alerte ? AppColors.danger : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (produit.prixVente > 0)
              Text(
                FormatUtils.formatFcfa(produit.prixVente),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'archive') onToggle();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'archive',
                  child: Text(produit.actif ? 'Archiver' : 'Réactiver'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
