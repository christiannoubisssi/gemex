import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/parametres_service.dart';
import '../../data/parametres_provider.dart';

class TypesMissionScreen extends ConsumerStatefulWidget {
  const TypesMissionScreen({super.key});
  @override
  ConsumerState<TypesMissionScreen> createState() => _TypesMissionScreenState();
}

class _TypesMissionScreenState extends ConsumerState<TypesMissionScreen> {
  List<String> _types = [];
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

  Future<void> _addOrEdit({String? existing, int? index}) async {
    final ctrl = TextEditingController(text: existing);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Nouveau type' : 'Modifier'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Libellé'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
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
              itemBuilder: (_, i) => ListTile(
                key: ValueKey(_types[i]),
                leading: const Icon(Icons.drag_handle, color: Colors.grey),
                title: Text(_types[i]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.teal),
                      onPressed: () =>
                          _addOrEdit(existing: _types[i], index: i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                      onPressed: () => _delete(i),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
