import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/taxe_provider.dart';

class TaxesScreen extends ConsumerWidget {
  const TaxesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxesAsync = ref.watch(taxesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Taxes & taux')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle taxe'),
        onPressed: () => _showTaxeDialog(context, ref, null),
      ),
      body: taxesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (list) => list.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _TaxeCard(
                  taxe: list[i],
                  onEdit: () => _showTaxeDialog(context, ref, list[i]),
                  onToggle: (v) => ref.read(taxeNotifierProvider.notifier).toggleActif(list[i].id, v),
                  onDelete: () => _confirmDelete(context, ref, list[i]),
                ),
              ),
      ),
    );
  }

  Future<void> _showTaxeDialog(BuildContext context, WidgetRef ref, Taxe? taxe) async {
    await showDialog(
      context: context,
      builder: (_) => _TaxeDialog(taxe: taxe),
    );
    ref.invalidate(taxesProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Taxe taxe) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la taxe ?'),
        content: Text('La taxe "${taxe.nom}" sera supprimée définitivement.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(taxeNotifierProvider.notifier).deleteById(taxe.id);
    }
  }
}

class _TaxeCard extends StatelessWidget {
  final Taxe taxe;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _TaxeCard({
    required this.taxe,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: taxe.actif ? AppColors.teal.withAlpha(30) : Colors.grey.shade100,
          child: Text(
            '${taxe.taux.toStringAsFixed(taxe.taux % 1 == 0 ? 0 : 1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: taxe.actif ? AppColors.teal : Colors.grey,
            ),
          ),
        ),
        title: Text(
          taxe.nom,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: taxe.actif ? null : Colors.grey,
            decoration: taxe.actif ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: taxe.description != null && taxe.description!.isNotEmpty
            ? Text(taxe.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: taxe.actif,
              activeThumbColor: AppColors.teal,
              onChanged: onToggle,
            ),
            IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: onEdit),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxeDialog extends ConsumerStatefulWidget {
  final Taxe? taxe;
  const _TaxeDialog({this.taxe});

  @override
  ConsumerState<_TaxeDialog> createState() => _TaxeDialogState();
}

class _TaxeDialogState extends ConsumerState<_TaxeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _taux;
  late final TextEditingController _desc;

  @override
  void initState() {
    super.initState();
    _nom = TextEditingController(text: widget.taxe?.nom ?? '');
    _taux = TextEditingController(
        text: widget.taxe != null ? widget.taxe!.taux.toString() : '');
    _desc = TextEditingController(text: widget.taxe?.description ?? '');
  }

  @override
  void dispose() {
    _nom.dispose();
    _taux.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'nom': _nom.text.trim(),
      'taux': double.parse(_taux.text.trim().replaceAll(',', '.')),
      'description': _desc.text.trim().isEmpty ? null : _desc.text.trim(),
      'entreprise_id': 'local',
    };

    final notifier = ref.read(taxeNotifierProvider.notifier);
    if (widget.taxe == null) {
      await notifier.create(data);
    } else {
      await notifier.updateTaxe(widget.taxe!.id, data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taxe == null ? 'Nouvelle taxe' : 'Modifier la taxe'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nom,
              decoration: const InputDecoration(labelText: 'Nom de la taxe *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _taux,
              decoration: const InputDecoration(labelText: 'Taux (%) *', suffixText: '%'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requis';
                final n = double.tryParse(v.trim().replaceAll(',', '.'));
                if (n == null || n < 0) return 'Taux invalide';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Description (optionnel)'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(onPressed: _submit, child: const Text('Enregistrer')),
      ],
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
          Icon(Icons.percent, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Aucune taxe configurée', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text('Appuyez sur + pour en créer une', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
