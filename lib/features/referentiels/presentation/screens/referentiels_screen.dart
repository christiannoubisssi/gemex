import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/referentiel_provider.dart';

class ReferentielsScreen extends ConsumerWidget {
  const ReferentielsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Postes & Départements'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Postes'),
              Tab(text: 'Départements'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ReferentielList(type: 'poste'),
            _ReferentielList(type: 'departement'),
          ],
        ),
      ),
    );
  }
}

class _ReferentielList extends ConsumerWidget {
  final String type;
  const _ReferentielList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        type == 'poste' ? postesProvider : departementsProvider;
    final asyncList = ref.watch(provider);
    final label = type == 'poste' ? 'poste' : 'département';

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_$type',
        onPressed: () => _showAddEditDialog(context, ref, label: label),
        child: const Icon(Icons.add),
      ),
      body: asyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                'Aucun $label enregistré',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final item = list[index];
              return _ReferentielTile(
                item: item,
                type: type,
                label: label,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddEditDialog(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    Referentiel? existing,
  }) async {
    final ctrl = TextEditingController(text: existing?.nom ?? '');
    final isEdit = existing != null;
    final title = isEdit ? 'Modifier le $label' : 'Nouveau $label';

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nom du $label',
            hintText: 'Ex : ${type == "poste" ? "Expert maritime" : "Direction technique"}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            child: Text(isEdit ? 'Modifier' : 'Ajouter'),
          ),
        ],
      ),
    );

    if (ok == true && ctrl.text.trim().isNotEmpty) {
      final notifier = ref.read(referentielNotifierProvider.notifier);
      if (isEdit) {
        await notifier.updateNom(existing.id, ctrl.text.trim());
      } else {
        await notifier.add(type: type, nom: ctrl.text.trim());
      }
    }
    ctrl.dispose();
  }
}

class _ReferentielTile extends ConsumerWidget {
  final Referentiel item;
  final String type;
  final String label;
  const _ReferentielTile({
    required this.item,
    required this.type,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        type == 'poste' ? Icons.work_outline : Icons.business_outlined,
        color: AppColors.navy,
      ),
      title: Text(item.nom),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () {
              // Réutilise le dialogue d'ajout en mode édition
              final parentWidget =
                  context.findAncestorWidgetOfExactType<_ReferentielList>();
              if (parentWidget != null) {
                _showEditDialog(context, ref);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 18, color: Colors.grey),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: item.nom);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modifier le $label'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: 'Nom du $label'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );

    if (ok == true && ctrl.text.trim().isNotEmpty) {
      await ref
          .read(referentielNotifierProvider.notifier)
          .updateNom(item.id, ctrl.text.trim());
    }
    ctrl.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer « ${item.nom} » ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await ref
          .read(referentielNotifierProvider.notifier)
          .deleteById(item.id);
    }
  }
}
