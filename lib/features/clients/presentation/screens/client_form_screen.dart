import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/save_overlay.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/client_repository.dart';
import '../providers/client_provider.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final String? id;
  const ClientFormScreen({super.key, this.id});
  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Client? _existing;
  bool _loading = false;

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) _loadExisting();
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    _existing = await ref.read(clientRepositoryProvider).getById(widget.id!);
    setState(() => _loading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    final values = _formKey.currentState!.value;
    setState(() => _loading = true);
    final notifier = ref.read(clientNotifierProvider.notifier);
    if (isEditing) {
      await notifier.updateClient(widget.id!, values);
      if (mounted) context.pop();
    } else {
      final id = await notifier.create({'entreprise_id': 'default', ...values});
      if (mounted && id != null) context.go('/clients/$id');
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _existing == null && isEditing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SaveOverlay(
      saving: _loading && _existing != null || (_loading && !isEditing),
      label: isEditing ? 'Mise à jour du client…' : 'Création du client…',
      child: Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifier client' : 'Nouveau client')),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FormBuilderDropdown<String>(
              name: 'type_client',
              initialValue: _existing?.typeClient ?? AppConstants.clientEntreprise,
              decoration: const InputDecoration(labelText: 'Type de client'),
              items: AppConstants.typeClientLabels.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'nom',
              initialValue: _existing?.nom,
              decoration: const InputDecoration(labelText: 'Nom / Raison sociale *'),
              validator: FormBuilderValidators.required(errorText: 'Nom requis'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'contact_nom',
              initialValue: _existing?.contactNom,
              decoration: const InputDecoration(labelText: 'Contact principal'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'email',
              initialValue: _existing?.email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'telephone',
              initialValue: _existing?.telephone,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'adresse',
              initialValue: _existing?.adresse,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'ville',
              initialValue: _existing?.ville,
              decoration: const InputDecoration(labelText: 'Ville'),
            ),
            const SizedBox(height: 20),
            const Text('Informations fiscales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'numero_tva',
              initialValue: _existing?.numeroTva,
              decoration: const InputDecoration(labelText: 'N° TVA'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'rccm',
              initialValue: _existing?.rccm,
              decoration: const InputDecoration(labelText: 'N° RCCM'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'nif',
              initialValue: _existing?.nif,
              decoration: const InputDecoration(labelText: 'N° NIF'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'notes',
              initialValue: _existing?.notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 80),
          ]),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: Text(isEditing ? 'Enregistrer' : 'Créer le client'),
          ),
        ),
      ),
    ), // SaveOverlay
    );
  }
}
