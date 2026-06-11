import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/client_repository.dart';
import '../providers/client_provider.dart';

/// Dialogue de création rapide d'un client, utilisé depuis le sélecteur de
/// client (formulaire dossier). Retourne le [Client] créé via Navigator.pop.
class QuickClientDialog extends ConsumerStatefulWidget {
  const QuickClientDialog({super.key});

  @override
  ConsumerState<QuickClientDialog> createState() => _QuickClientDialogState();
}

class _QuickClientDialogState extends ConsumerState<QuickClientDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;
    final values = _formKey.currentState!.value;
    setState(() {
      _loading = true;
      _error = null;
    });
    final id = await ref
        .read(clientNotifierProvider.notifier)
        .create({'entreprise_id': 'default', ...values});
    if (id == null) {
      setState(() {
        _loading = false;
        _error = 'Erreur lors de la création du client.';
      });
      return;
    }
    final client = await ref.read(clientRepositoryProvider).getById(id);
    if (mounted) Navigator.pop(context, client);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau client'),
      content: SizedBox(
        width: 400,
        child: FormBuilder(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FormBuilderDropdown<String>(
              name: 'type_client',
              initialValue: AppConstants.clientEntreprise,
              decoration: const InputDecoration(labelText: 'Type de client'),
              items: AppConstants.typeClientLabels.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'nom',
              decoration: const InputDecoration(labelText: 'Nom / Raison sociale *'),
              validator: FormBuilderValidators.required(errorText: 'Nom requis'),
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'telephone',
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Créer'),
        ),
      ],
    );
  }
}
