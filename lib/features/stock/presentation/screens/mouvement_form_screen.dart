import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../produits/presentation/providers/produit_provider.dart';
import '../providers/stock_provider.dart';

class MouvementFormScreen extends ConsumerStatefulWidget {
  final String? produitId;
  const MouvementFormScreen({super.key, this.produitId});

  @override
  ConsumerState<MouvementFormScreen> createState() => _MouvementFormScreenState();
}

class _MouvementFormScreenState extends ConsumerState<MouvementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'entree';
  String? _produitId;
  final _qteCtrl = TextEditingController();
  final _prixCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _produitId = widget.produitId;
  }

  @override
  void dispose() {
    _qteCtrl.dispose();
    _prixCtrl.dispose();
    _refCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _produitId == null) return;
    setState(() => _saving = true);

    await ref.read(stockNotifierProvider.notifier).create({
      'entreprise_id': 'default',
      'produit_id': _produitId,
      'type': _type,
      'quantite': double.parse(_qteCtrl.text.trim()),
      'prix_unitaire': double.tryParse(_prixCtrl.text.trim()) ?? 0.0,
      'date_mouvement': DateTime.now(),
      'reference': _refCtrl.text.trim().isEmpty ? null : _refCtrl.text.trim(),
      'effectue_par': Supabase.instance.client.auth.currentUser?.id,
      'notes': _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_type == 'entree' ? 'Entrée enregistrée' : 'Sortie enregistrée')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produitsAsync = ref.watch(produitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau mouvement de stock')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type entrée / sortie
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'entree',
                    label: Text('Entrée'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: 'sortie',
                    label: Text('Sortie'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (v) => setState(() => _type = v.first),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return _type == 'entree' ? AppColors.success.withAlpha(30) : AppColors.danger.withAlpha(30);
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Produit
              produitsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (list) => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Produit *',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  value: _produitId,
                  items: list.map((p) => DropdownMenuItem(
                    value: p.id,
                    child: Text('${p.code} — ${p.nom}'),
                  )).toList(),
                  onChanged: (v) => setState(() => _produitId = v),
                  validator: (v) => v == null ? 'Sélectionnez un produit' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Quantité + prix
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qteCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Quantité *',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Requis';
                        if ((double.tryParse(v) ?? 0) <= 0) return '> 0';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _prixCtrl,
                      decoration: InputDecoration(
                        labelText: _type == 'entree' ? 'Coût unitaire' : 'Prix unitaire',
                        suffixText: 'FCFA',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Référence
              TextFormField(
                controller: _refCtrl,
                decoration: const InputDecoration(
                  labelText: 'Référence (n° bon, facture…)',
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Bouton
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  icon: _saving
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check),
                  label: Text(_type == 'entree' ? 'Enregistrer l\'entrée' : 'Enregistrer la sortie'),
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: _type == 'entree' ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
