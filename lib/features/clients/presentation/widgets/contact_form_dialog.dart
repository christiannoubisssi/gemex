import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../database/app_database.dart';
import '../providers/client_provider.dart';

/// Dialogue de création/modification d'un contact secondaire d'un client.
class ContactFormDialog extends ConsumerStatefulWidget {
  final String clientId;
  final ClientContact? contact;
  const ContactFormDialog({super.key, required this.clientId, this.contact});

  @override
  ConsumerState<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends ConsumerState<ContactFormDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  bool get isEditing => widget.contact != null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    final values = _formKey.currentState!.value;
    setState(() => _saving = true);

    final notifier = ref.read(clientContactNotifierProvider.notifier);
    if (isEditing) {
      await notifier.updateContact(widget.clientId, widget.contact!.id, values);
    } else {
      await notifier.add(widget.clientId, values);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contact;
    return AlertDialog(
      title: Text(isEditing ? 'Modifier le contact' : 'Nouveau contact'),
      content: SizedBox(
        width: 400,
        child: FormBuilder(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FormBuilderTextField(
              name: 'nom',
              initialValue: c?.nom,
              decoration: const InputDecoration(labelText: 'Nom *'),
              validator: FormBuilderValidators.required(errorText: 'Nom requis'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'fonction',
              initialValue: c?.fonction,
              decoration: const InputDecoration(labelText: 'Fonction'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'telephone',
              initialValue: c?.telephone,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'email',
              initialValue: c?.email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(isEditing ? 'Enregistrer' : 'Ajouter'),
        ),
      ],
    );
  }
}
