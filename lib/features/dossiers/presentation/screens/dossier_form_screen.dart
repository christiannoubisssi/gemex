import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/dossier_repository.dart';
import '../providers/dossier_provider.dart';

class DossierFormScreen extends ConsumerStatefulWidget {
  final String? id;
  const DossierFormScreen({super.key, this.id});

  @override
  ConsumerState<DossierFormScreen> createState() => _DossierFormScreenState();
}

class _DossierFormScreenState extends ConsumerState<DossierFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Dossier? _existing;
  bool _loading = false;

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) _loadExisting();
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    _existing = await ref.read(dossierRepositoryProvider).getById(widget.id!);
    setState(() => _loading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    final values = _formKey.currentState!.value;

    setState(() => _loading = true);
    final notifier = ref.read(dossierNotifierProvider.notifier);

    if (isEditing) {
      await notifier.updateDossier(widget.id!, values);
    } else {
      final id = await notifier.create({'entreprise_id': 'default', ...values});
      if (mounted && id != null) context.go('/dossiers/$id');
    }

    if (mounted) {
      setState(() => _loading = false);
      final state = ref.read(dossierNotifierProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString()), backgroundColor: AppColors.danger),
        );
      } else if (isEditing) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _existing == null && isEditing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier le dossier' : 'Nouveau dossier')),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionCard(title: 'Informations principales', children: [
                FormBuilderTextField(
                  name: 'titre',
                  initialValue: _existing?.titre,
                  decoration: const InputDecoration(labelText: 'Titre du dossier *'),
                  validator: FormBuilderValidators.required(errorText: 'Titre requis'),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'description',
                  initialValue: _existing?.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'lieu_sinistre',
                  initialValue: _existing?.lieuSinistre,
                  decoration: const InputDecoration(labelText: 'Lieu du sinistre'),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'nature_sinistre',
                  initialValue: _existing?.natureSinistre,
                  decoration: const InputDecoration(labelText: 'Nature du sinistre'),
                ),
                const SizedBox(height: 12),
                FormBuilderDateTimePicker(
                  name: 'date_sinistre',
                  initialValue: _existing?.dateSinistre,
                  inputType: InputType.date,
                  decoration: const InputDecoration(labelText: 'Date du sinistre'),
                  format: DateFormat('dd/MM/yyyy'),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'montant_sinistre',
                  initialValue: _existing?.montantSinistre?.toString(),
                  decoration: const InputDecoration(labelText: 'Montant déclaré', suffixText: 'FCFA'),
                  keyboardType: TextInputType.number,
                ),
              ]),
              const SizedBox(height: 12),
              _SectionCard(title: 'Priorité', children: [
                FormBuilderDropdown<String>(
                  name: 'priorite',
                  initialValue: _existing?.priorite ?? AppConstants.prioriteNormale,
                  decoration: const InputDecoration(labelText: 'Priorité'),
                  items: AppConstants.priorites
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(AppConstants.prioriteLabels[p] ?? p),
                          ))
                      .toList(),
                ),
              ]),
              const SizedBox(height: 12),
              _SectionCard(title: 'Assurance', children: [
                FormBuilderTextField(
                  name: 'compagnie_assurance',
                  initialValue: _existing?.compagnieAssurance,
                  decoration: const InputDecoration(labelText: 'Compagnie d\'assurance'),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'numero_police',
                  initialValue: _existing?.numeroPolice,
                  decoration: const InputDecoration(labelText: 'N° de police'),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'courtier',
                  initialValue: _existing?.courtier,
                  decoration: const InputDecoration(labelText: 'Courtier'),
                ),
              ]),
              const SizedBox(height: 12),
              _SectionCard(title: 'Notes internes', children: [
                FormBuilderTextField(
                  name: 'notes_internes',
                  initialValue: _existing?.notesInternes,
                  decoration: const InputDecoration(labelText: 'Notes internes'),
                  maxLines: 4,
                ),
              ]),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(isEditing ? 'Enregistrer' : 'Créer le dossier'),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
