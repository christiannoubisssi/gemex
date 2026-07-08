import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/text_formatters.dart';
import '../../data/parametres_service.dart';
import '../../data/parametres_provider.dart';

class TypesMissionScreen extends ConsumerStatefulWidget {
  const TypesMissionScreen({super.key});
  @override
  ConsumerState<TypesMissionScreen> createState() => _TypesMissionScreenState();
}

class _TypesMissionScreenState extends ConsumerState<TypesMissionScreen> {
  List<Map<String, String>> _types = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _types = await ParametresService.getTypesMission();
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    await ParametresService.saveTypesMission(_types);
    ref.invalidate(typesMissionProvider);
  }

  Future<void> _addOrEdit({Map<String, String>? existing, int? index}) async {
    final nomCtrl = TextEditingController(text: existing?['nom']);
    final abrevCtrl = TextEditingController(text: existing?['abreviation']);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Nouveau type' : 'Modifier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Libellé'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: abrevCtrl,
              maxLength: 3,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Abréviation',
                hintText: 'Ex : MAR',
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'nom': nomCtrl.text.trim(),
              'abreviation': abrevCtrl.text.trim().toUpperCase(),
            }),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
    if (result == null || result['nom']!.isEmpty) return;
    setState(() {
      if (index != null) {
        _types[index] = result;
      } else {
        _types.add(result);
      }
    });
    await _save();
  }

  Future<void> _delete(int index) async {
    final type = _types[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce type'),
        content: Text(
          'Supprimer "${type['nom']}" ?\n\n'
          'Les dossiers existants ne seront pas affectés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _types.removeAt(index));
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Types de mission')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(),
        child: const Icon(Icons.add),
      ),
      body: _types.isEmpty
          ? const Center(
              child: Text('Aucun type défini',
                  style: TextStyle(color: Colors.grey)))
          : ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: _types.length,
              onReorder: (oldIndex, newIndex) async {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _types.removeAt(oldIndex);
                  _types.insert(newIndex, item);
                });
                await _save();
              },
              itemBuilder: (_, i) {
                final type = _types[i];
                final abrev = type['abreviation'] ?? '';
                return ListTile(
                  key: ValueKey('${type['nom']}-$i'),
                  leading: const Icon(Icons.drag_handle, color: Colors.grey),
                  title: Text(type['nom'] ?? ''),
                  subtitle: abrev.isNotEmpty ? Text('Abréviation : $abrev') : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.teal),
                        onPressed: () =>
                            _addOrEdit(existing: type, index: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                        onPressed: () => _delete(i),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
