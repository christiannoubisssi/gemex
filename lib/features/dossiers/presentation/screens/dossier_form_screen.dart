import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/save_overlay.dart';
import '../../../../database/app_database.dart';
import '../../../clients/data/repositories/client_repository.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../../../clients/presentation/widgets/quick_client_dialog.dart';
import '../../../parametres/data/parametres_provider.dart';
import '../../../parametres/data/user_management_service.dart';
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

  // Client sélectionné
  String? _clientId;
  Client? _clientSelectionne;
  bool _clientError = false;

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) _loadExisting();
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    _existing = await ref.read(dossierRepositoryProvider).getById(widget.id!);
    if (_existing?.clientId != null) {
      _clientId = _existing!.clientId;
      _clientSelectionne =
          await ref.read(clientRepositoryProvider).getById(_existing!.clientId!);
    }
    setState(() => _loading = false);
  }

  void _fillExample() {
    _formKey.currentState?.patchValue({
      'nature_sinistre': 'Dommages aux marchandises – conteneur endommagé',
      'description':
          'Expertise suite à avarie sur lot de marchandises importées. '
          'Conteneur présentant des traces d\'humidité et déformation structurelle.',
      'lieu_sinistre': 'Port d\'Owendo, Libreville, Gabon',
      'date_sinistre': DateTime(2026, 4, 15),
      'date_expertise': DateTime(2026, 4, 18),
      'priorite': 'haute',
      'notes_internes': 'Client prioritaire. Prévoir visite site dès que possible.',
    });
  }

  Future<void> _ouvrirSelecteurClient() async {
    final client = await showModalBottomSheet<Client>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClientSelectorSheet(clientActuelId: _clientId),
    );
    if (client != null) {
      setState(() {
        _clientId = client.id;
        _clientSelectionne = client;
        _clientError = false;
      });
      // Pré-remplir ref_client_1 depuis la référence du client si le champ est vide
      final refActuelle = _formKey.currentState?.fields['ref_client_1']?.value as String?;
      if ((refActuelle == null || refActuelle.isEmpty) &&
          client.reference != null &&
          client.reference!.isNotEmpty) {
        _formKey.currentState?.fields['ref_client_1']?.didChange(client.reference);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    // Validation client obligatoire
    if (_clientId == null) {
      setState(() => _clientError = true);
      return;
    }

    final values = _formKey.currentState!.value;
    setState(() => _loading = true);
    final notifier = ref.read(dossierNotifierProvider.notifier);

    if (isEditing) {
      await notifier.updateDossier(
          widget.id!, {'client_id': _clientId, ...values});
    } else {
      final id = await notifier
          .create({'entreprise_id': 'default', 'client_id': _clientId, ...values});
      if (mounted && id != null) context.go('/dossiers/$id');
    }

    if (mounted) {
      setState(() => _loading = false);
      final state = ref.read(dossierNotifierProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppColors.danger),
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

    return SaveOverlay(
      saving: _loading && (_existing != null || !isEditing),
      label: isEditing ? 'Mise à jour du dossier…' : 'Création du dossier…',
      child: Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le dossier' : 'Nouveau dossier'),
        actions: [
          if (!isEditing)
            TextButton.icon(
              onPressed: _fillExample,
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Exemple'),
              style: TextButton.styleFrom(foregroundColor: AppColors.gold),
            ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bandeau numéro automatique
              if (!isEditing)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.navy.withAlpha(40)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.navy),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Le numéro du dossier (AV-AAAA-XXXX) sera attribué automatiquement.',
                          style:
                              TextStyle(fontSize: 12, color: AppColors.navy),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Sélecteur client (obligatoire) ──────────────────────────
              _SectionCard(title: 'Client *', children: [
                _ClientSelector(
                  client: _clientSelectionne,
                  hasError: _clientError,
                  onTap: _ouvrirSelecteurClient,
                  onClear: isEditing
                      ? null
                      : () => setState(() {
                            _clientId = null;
                            _clientSelectionne = null;
                          }),
                ),
              ]),
              const SizedBox(height: 12),

              // ── Informations principales ─────────────────────────────────
              _SectionCard(title: 'Informations principales', children: [
                FormBuilderTextField(
                  name: 'nature_sinistre',
                  initialValue: _existing?.natureSinistre,
                  decoration: const InputDecoration(
                    labelText: 'Nature du sinistre *',
                    hintText: 'Ex : Dommages aux marchandises, Incendie…',
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Nature du sinistre requise'),
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
                  decoration: const InputDecoration(
                    labelText: 'Lieu du sinistre',
                    hintText: 'Ex : Port d\'Owendo, Libreville',
                  ),
                ),
                const SizedBox(height: 12),
                FormBuilderDateTimePicker(
                  name: 'date_sinistre',
                  initialValue: _existing?.dateSinistre,
                  inputType: InputType.date,
                  decoration:
                      const InputDecoration(labelText: 'Date de la requête'),
                  format: DateFormat('dd/MM/yyyy'),
                ),
                const SizedBox(height: 12),
                FormBuilderDateTimePicker(
                  name: 'date_expertise',
                  initialValue: _existing?.dateExpertise,
                  inputType: InputType.date,
                  decoration:
                      const InputDecoration(labelText: 'Date de l\'expertise'),
                  format: DateFormat('dd/MM/yyyy'),
                ),
              ]),
              const SizedBox(height: 12),

              _SectionCard(title: 'Priorité', children: [
                FormBuilderDropdown<String>(
                  name: 'priorite',
                  initialValue:
                      _existing?.priorite ?? AppConstants.prioriteNormale,
                  decoration: const InputDecoration(labelText: 'Priorité'),
                  items: AppConstants.priorites
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child:
                                Text(AppConstants.prioriteLabels[p] ?? p),
                          ))
                      .toList(),
                ),
              ]),
              const SizedBox(height: 12),

              // ── Mission ──────────────────────────────────────────────────
              _SectionCard(title: 'Mission', children: [
                Consumer(
                  builder: (context, ref, _) {
                    final typesAsync = ref.watch(typesMissionProvider);
                    return typesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Erreur : $e',
                          style: const TextStyle(color: AppColors.danger)),
                      data: (types) {
                        final current = _existing?.typeMissionId;
                        final connu = types.any((t) => t['nom'] == current);
                        return FormBuilderDropdown<String?>(
                          name: 'type_mission_id',
                          initialValue: current,
                          decoration:
                              const InputDecoration(labelText: 'Type de mission'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Non défini'),
                            ),
                            ...types.map((t) => DropdownMenuItem<String?>(
                                  value: t['nom'],
                                  child: Text(t['nom'] ?? ''),
                                )),
                            // Conserve l'ancienne valeur si le type a été renommé/supprimé
                            if (current != null && !connu)
                              DropdownMenuItem<String?>(
                                value: current,
                                child: Text('$current (ancien)'),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, _) {
                    final usersAsync = ref.watch(usersProvider);
                    return usersAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Erreur : $e',
                          style: const TextStyle(color: AppColors.danger)),
                      data: (users) {
                        final current = _existing?.expertId;
                        final actifs = users.where((u) => u.actif).toList();
                        final connu = actifs.any((u) => u.id == current);
                        final inactif = current != null && !connu
                            ? users.where((u) => u.id == current).firstOrNull
                            : null;
                        return FormBuilderDropdown<String?>(
                          name: 'expert_id',
                          initialValue: current,
                          decoration:
                              const InputDecoration(labelText: 'Agent en charge'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Non assigné'),
                            ),
                            ...actifs.map((u) => DropdownMenuItem<String?>(
                                  value: u.id,
                                  child: Text(u.nom ?? u.email),
                                )),
                            // Conserve l'agent actuel s'il est devenu inactif/introuvable
                            if (current != null && !connu)
                              DropdownMenuItem<String?>(
                                value: current,
                                child: Text(
                                    '${inactif?.nom ?? inactif?.email ?? current} (inactif)'),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]),
              const SizedBox(height: 12),

              // ── Références client ─────────────────────────────────────────
              // Champs texte libres — ref_client_1 pré-remplie depuis la fiche client
              _SectionCard(title: 'Références client', children: [
                const Text(
                  'Numéros de référence du client (police, dossier assureur, etc.)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'ref_client_1',
                  initialValue: _existing?.refClient1 ?? _clientSelectionne?.reference,
                  decoration: const InputDecoration(
                    labelText: 'Référence 1',
                    hintText: 'Ex : REF-2025-001',
                    prefixIcon: Icon(Icons.tag_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'ref_client_2',
                  initialValue: _existing?.refClient2,
                  decoration: const InputDecoration(
                    labelText: 'Référence 2',
                    hintText: 'Ex : N° police assurance',
                    prefixIcon: Icon(Icons.tag_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'ref_client_3',
                  initialValue: _existing?.refClient3,
                  decoration: const InputDecoration(
                    labelText: 'Référence 3',
                    hintText: 'Ex : N° connaissement',
                    prefixIcon: Icon(Icons.tag_outlined),
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              _SectionCard(title: 'Notes internes', children: [
                FormBuilderTextField(
                  name: 'notes_internes',
                  initialValue: _existing?.notesInternes,
                  decoration:
                      const InputDecoration(labelText: 'Notes internes'),
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
            child: Text(isEditing ? 'Enregistrer' : 'Créer le dossier'),
          ),
        ),
      ),
    ), // Scaffold
    ); // SaveOverlay
  }
}

// ── Widget sélecteur client ───────────────────────────────────────────────────

class _ClientSelector extends StatelessWidget {
  final Client? client;
  final bool hasError;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _ClientSelector({
    required this.client,
    required this.hasError,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? AppColors.danger : AppColors.navy.withAlpha(60);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(children: [
          Icon(Icons.person_outline,
              color: hasError ? AppColors.danger : AppColors.navy,
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: client == null
                ? Text(
                    'Sélectionner un client *',
                    style: TextStyle(
                      color: hasError
                          ? AppColors.danger
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client!.nom,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(
                        _typeLabel(client!.typeClient) +
                            (client!.ville != null
                                ? ' — ${client!.ville}'
                                : ''),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
          ),
          if (client != null && onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            )
          else
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey),
        ]),
      ),
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'entreprise':
        return 'Entreprise';
      case 'particulier':
        return 'Particulier';
      case 'assurance':
        return 'Assurance';
      case 'armateur':
        return 'Armateur';
      default:
        return t;
    }
  }
}

// ── Modal de sélection client ─────────────────────────────────────────────────

class _ClientSelectorSheet extends ConsumerStatefulWidget {
  final String? clientActuelId;
  const _ClientSelectorSheet({this.clientActuelId});

  @override
  ConsumerState<_ClientSelectorSheet> createState() =>
      _ClientSelectorSheetState();
}

class _ClientSelectorSheetState extends ConsumerState<_ClientSelectorSheet> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider(null));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(children: [
          // Poignée
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(children: [
              const Expanded(
                child: Text('Sélectionner un client',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy)),
              ),
              TextButton.icon(
                onPressed: () async {
                  final newClient = await showDialog<Client>(
                    context: context,
                    builder: (_) => const QuickClientDialog(),
                  );
                  if (newClient != null && context.mounted) {
                    ref.invalidate(clientsProvider);
                    Navigator.pop(context, newClient);
                  }
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nouveau'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.teal),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, email…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: clientsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Erreur : $e')),
              data: (clients) {
                final filtered = _search.isEmpty
                    ? clients
                    : clients
                        .where((c) =>
                            c.nom.toLowerCase().contains(_search) ||
                            (c.email?.toLowerCase().contains(_search) ??
                                false) ||
                            (c.telephone?.contains(_search) ?? false))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_search_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            _search.isEmpty
                                ? 'Aucun client enregistré.\nCreez d\'abord un client.'
                                : 'Aucun résultat pour "$_search"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ]),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final c = filtered[i];
                    final isSelected = c.id == widget.clientActuelId;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: AppColors.navy.withAlpha(15),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.navy.withAlpha(20),
                        child: Text(
                          c.nom.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(c.nom,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        [
                          _typeLabel(c.typeClient),
                          if (c.ville != null) c.ville,
                          if (c.email != null) c.email,
                        ].join(' — '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: AppColors.teal)
                          : null,
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'entreprise':
        return 'Entreprise';
      case 'particulier':
        return 'Particulier';
      case 'assurance':
        return 'Assurance';
      case 'armateur':
        return 'Armateur';
      default:
        return t;
    }
  }
}

// ── Widgets utilitaires ───────────────────────────────────────────────────────

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
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
