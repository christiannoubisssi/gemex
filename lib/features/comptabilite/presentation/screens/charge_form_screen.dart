import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/charge_provider.dart';

const _categories = [
  'Loyer',
  'Salaires',
  'Fournitures',
  'Transport',
  'Téléphone',
  'Internet',
  'Sous-traitance',
  'Assurance',
  'Impôts et taxes',
  'Autre',
];

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
  String _categorie = _categories.first;
  DateTime _dateCharge = DateTime.now();
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
          montant: double.parse(_montantCtrl.text.replaceAll(' ', '').replaceAll(',', '.')),
          dateCharge: _dateCharge,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );

    if (mounted) {
      final notifier = ref.read(chargeNotifierProvider);
      if (notifier.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${notifier.error}'),
            backgroundColor: AppColors.danger,
          ),
        );
      } else {
        Navigator.of(context).pop(true);
      }
    }
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle charge')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _categorie,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categorie = v ?? _categorie),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _libelleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Libellé *',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montantCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Montant *',
                  suffixText: 'FCFA',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Champ requis';
                  final cleaned = v.replaceAll(' ', '').replaceAll(',', '.');
                  if (double.tryParse(cleaned) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_dateCharge)),
                ),
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
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save_outlined),
                  label: const Text('Enregistrer'),
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
