import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/charges_modeles_provider.dart';

const _statuts = ['tous', 'brouillon', 'soumis', 'valide', 'refuse', 'reporte'];

const _statutLabels = {
  'brouillon': 'Brouillon',
  'soumis': 'Soumis',
  'valide': 'Validé',
  'refuse': 'Refusé',
  'reporte': 'Reporté',
};

const _statutColors = {
  'brouillon': Colors.grey,
  'soumis': Color(0xFF1A8A9A),
  'valide': Colors.green,
  'refuse': Colors.red,
  'reporte': Colors.orange,
};

const _moisLabels = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

class ChargesModelesListScreen extends ConsumerStatefulWidget {
  const ChargesModelesListScreen({super.key});

  @override
  ConsumerState<ChargesModelesListScreen> createState() => _State();
}

class _State extends ConsumerState<ChargesModelesListScreen> {
  String _filtre = 'tous';

  @override
  Widget build(BuildContext context) {
    final statut = _filtre == 'tous' ? null : _filtre;
    final listAsync = ref.watch(chargesModelesProvider(statut));

    return Scaffold(
      appBar: AppBar(title: const Text('Modèles de charges')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nouveau modèle'),
        onPressed: () => context.push('/comptabilite/charges-modeles/new'),
      ),
      body: Column(
        children: [
          _FiltreBar(selected: _filtre, onSelect: (s) => setState(() => _filtre = s)),
          Expanded(
            child: listAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (list) => list.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _ModeleCard(
                        modele: list[i],
                        onTap: () => context.push('/comptabilite/charges-modeles/${list[i].id}'),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltreBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _FiltreBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: _statuts.map((s) {
          final label = s == 'tous' ? 'Tous' : (_statutLabels[s] ?? s);
          final isSelected = selected == s;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onSelect(s),
              selectedColor: AppColors.teal.withAlpha(40),
              checkmarkColor: AppColors.teal,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeleCard extends StatelessWidget {
  final ChargesModele modele;
  final VoidCallback onTap;
  const _ModeleCard({required this.modele, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _statutColors[modele.statut] ?? Colors.grey;
    final label = _statutLabels[modele.statut] ?? modele.statut;
    final periode = '${_moisLabels[modele.mois]} ${modele.annee}';

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(Icons.list_alt, color: color, size: 20),
        ),
        title: Text(modele.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(periode, style: const TextStyle(fontSize: 12)),
            if (modele.soumisParNom != null)
              Text('Par: ${modele.soumisParNom}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withAlpha(80)),
              ),
              child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(modele.createdAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        isThreeLine: modele.soumisParNom != null,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.list_alt, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Aucun modèle de charges', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text('Appuyez sur + pour en créer un', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
