import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/save_overlay.dart';
import '../../../produits/presentation/providers/produit_provider.dart';
import '../../../parametres/data/parametres_service.dart';
import '../providers/charge_provider.dart';

/// Provider pour les catégories de charges (configurable via ParametresService)
final chargeCategoriesProvider = FutureProvider<List<String>>((ref) async {
  return ParametresService.getChargeCategories();
});

class ChargeFormScreen extends ConsumerStatefulWidget {
  final String? chargeId;
  const ChargeFormScreen({super.key, this.chargeId});

  @override
  ConsumerState<ChargeFormScreen> createState() => _ChargeFormScreenState();
}

class _ChargeFormScreenState extends ConsumerState<ChargeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _libelleCtrl = TextEditingController();
  final _montantCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _categorie = 'Loyer';
  DateTime _dateCharge = DateTime.now();
  String _recurrence = 'unique';
  bool _saving = false;

  @override
  void dispose() {
    _libelleCtrl.dispose();
    _montantCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateCharge,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dateCharge = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await ref.read(chargeNotifierProvider.notifier).addCharge(
          entrepriseId: 'default',
          categorie: _categorie,
          libelle: _libelleCtrl.text.trim(),
          montant: double.parse(
              _montantCtrl.text.replaceAll(' ', '').replaceAll(',', '.')),
          dateCharge: _dateCharge,
          notes:
              _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
          recurrence: _recurrence,
        );

    if (mounted) {
      final st = ref.read(chargeNotifierProvider);
      if (st.hasError) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${st.error}'),
            backgroundColor: AppColors.danger,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Charge enregistrée'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SaveOverlay(
      saving: _saving,
      label: 'Enregistrement de la charge…',
      child: Scaffold(
        appBar: AppBar(title: const Text('Nouvelle charge')),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Sélection rapide depuis le catalogue achat
                Consumer(
                  builder: (ctx, cRef, _) {
                    final produitsAsync = cRef.watch(produitsAchatProvider);
                    return produitsAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (produits) => produits.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Produit du catalogue (optionnel)',
                                  isDense: true,
                                  prefixIcon: Icon(Icons.inventory_2_outlined),
                                ),
                                hint: const Text('Saisie libre ou sélectionner…'),
                                items: produits.map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text('${p.code} — ${p.nom}'),
                                )).toList(),
                                onChanged: (id) {
                                  if (id == null) return;
                                  final p = produits.firstWhere((pr) => pr.id == id);
                                  setState(() {
                                    _libelleCtrl.text = p.nom;
                                    if (p.prixAchat > 0) {
                                      _montantCtrl.text = p.prixAchat.toString();
                                    }
                                    _categorie = p.categorie ?? _categorie;
                                  });
                                },
                              ),
                            ),
                    );
                  },
                ),
                Consumer(
                  builder: (ctx, cRef, _) {
                    final catAsync = cRef.watch(chargeCategoriesProvider);
                    final categories = catAsync.valueOrNull ??
                        ParametresService.defaultChargeCategories;
                    // Si la catégorie actuelle n'est pas dans la liste, l'ajouter
                    final effectiveList = categories.contains(_categorie)
                        ? categories
                        : [_categorie, ...categories];
                    return DropdownButtonFormField<String>(
                      value: _categorie,
                      decoration: const InputDecoration(
                        labelText: 'Catégorie',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: effectiveList
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _categorie = v ?? _categorie),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _libelleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Libellé *',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),
                // Montant et Date en 2 colonnes
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _montantCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Montant *',
                          suffixText: 'FCFA',
                          prefixIcon: Icon(Icons.monetization_on_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Champ requis';
                          final cleaned =
                              v.replaceAll(' ', '').replaceAll(',', '.');
                          if (double.tryParse(cleaned) == null) {
                            return 'Montant invalide';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                              DateFormat('dd/MM/yyyy').format(_dateCharge)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _recurrence,
                  decoration: const InputDecoration(
                    labelText: 'Récurrence',
                    prefixIcon: Icon(Icons.repeat_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'unique', child: Text('Unique')),
                    DropdownMenuItem(value: 'mensuel', child: Text('Mensuel')),
                    DropdownMenuItem(
                        value: 'trimestriel', child: Text('Trimestriel')),
                    DropdownMenuItem(value: 'annuel', child: Text('Annuel')),
                  ],
                  onChanged: (v) =>
                      setState(() => _recurrence = v ?? _recurrence),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
                    onPressed: _saving ? null : _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
