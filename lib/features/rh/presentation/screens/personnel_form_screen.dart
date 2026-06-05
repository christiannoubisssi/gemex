import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/save_overlay.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/personnel_repository.dart';
import '../providers/personnel_provider.dart';

const _typesContrat = ['CDI', 'CDD', 'Stage', 'Consultant', 'Autre'];

class PersonnelFormScreen extends ConsumerStatefulWidget {
  final String? id;
  const PersonnelFormScreen({super.key, this.id});

  @override
  ConsumerState<PersonnelFormScreen> createState() => _PersonnelFormScreenState();
}

class _PersonnelFormScreenState extends ConsumerState<PersonnelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _posteCtrl = TextEditingController();
  final _departementCtrl = TextEditingController();
  final _salaireCtrl = TextEditingController();
  String _typeContrat = 'CDI';
  DateTime? _dateEmbauche;
  DateTime? _dateFinContrat;
  bool _saving = false;
  PersonnelData? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final p = await ref.read(personnelRepositoryProvider).getById(widget.id!);
    if (p != null && mounted) {
      setState(() {
        _existing = p;
        _nomCtrl.text = p.nom;
        _prenomCtrl.text = p.prenom ?? '';
        _posteCtrl.text = p.poste ?? '';
        _departementCtrl.text = p.departement ?? '';
        _salaireCtrl.text = p.salaireBase?.toStringAsFixed(0) ?? '';
        _typeContrat = p.typeContrat;
        _dateEmbauche = p.dateEmbauche;
        _dateFinContrat = p.dateFinContrat;
      });
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _posteCtrl.dispose();
    _departementCtrl.dispose();
    _salaireCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isEmbauche) async {
    final initial = isEmbauche ? (_dateEmbauche ?? DateTime.now()) : (_dateFinContrat ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        if (isEmbauche) {
          _dateEmbauche = picked;
        } else {
          _dateFinContrat = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final salaire = double.tryParse(_salaireCtrl.text.replaceAll(' ', ''));
    final notifier = ref.read(personnelNotifierProvider.notifier);

    if (_existing == null) {
      await notifier.addPersonnel(
        nom: _nomCtrl.text.trim(),
        prenom: _prenomCtrl.text.trim().isEmpty ? null : _prenomCtrl.text.trim(),
        poste: _posteCtrl.text.trim().isEmpty ? null : _posteCtrl.text.trim(),
        departement: _departementCtrl.text.trim().isEmpty ? null : _departementCtrl.text.trim(),
        typeContrat: _typeContrat,
        dateEmbauche: _dateEmbauche,
        dateFinContrat: _dateFinContrat,
        salaireBase: salaire,
      );
    } else {
      await notifier.updatePersonnel(PersonnelCompanion(
        id: Value(_existing!.id),
        nom: Value(_nomCtrl.text.trim()),
        prenom: Value(_prenomCtrl.text.trim().isEmpty ? null : _prenomCtrl.text.trim()),
        poste: Value(_posteCtrl.text.trim().isEmpty ? null : _posteCtrl.text.trim()),
        departement: Value(_departementCtrl.text.trim().isEmpty ? null : _departementCtrl.text.trim()),
        typeContrat: Value(_typeContrat),
        dateEmbauche: Value(_dateEmbauche),
        dateFinContrat: Value(_dateFinContrat),
        salaireBase: Value(salaire),
        syncStatus: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ));
    }

    if (mounted) {
      final st = ref.read(personnelNotifierProvider);
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
          SnackBar(
            content: Text(_existing == null
                ? '✓ Employé ajouté avec succès'
                : '✓ Employé mis à jour'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return SaveOverlay(
      saving: _saving,
      label: _existing == null ? 'Ajout de l\'employé…' : 'Mise à jour…',
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Nouvel employé' : 'Modifier employé'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prenomCtrl,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _nomCtrl,
                      decoration: const InputDecoration(labelText: 'Nom *'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _posteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Poste',
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departementCtrl,
                decoration: const InputDecoration(
                  labelText: 'Département',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _typeContrat,
                decoration: const InputDecoration(
                  labelText: 'Type de contrat',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                items: _typesContrat
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _typeContrat = v ?? _typeContrat),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaireCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Salaire de base',
                  suffixText: 'FCFA',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickDate(true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date d\'embauche',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(_dateEmbauche != null ? fmt.format(_dateEmbauche!) : '—'),
                ),
              ),
              if (_typeContrat == 'CDD' || _typeContrat == 'Stage') ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickDate(false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de fin de contrat',
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    child: Text(_dateFinContrat != null ? fmt.format(_dateFinContrat!) : '—'),
                  ),
                ),
              ],
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
    ), // SaveOverlay
    );
  }
}
