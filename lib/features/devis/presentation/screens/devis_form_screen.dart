import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/save_overlay.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../../../dossiers/presentation/providers/dossier_provider.dart';
import '../../../taxes/presentation/providers/taxe_provider.dart';
import '../providers/devis_provider.dart';

class DevisFormScreen extends ConsumerStatefulWidget {
  final String? id;
  final String? dossierId;
  const DevisFormScreen({super.key, this.id, this.dossierId});

  @override
  ConsumerState<DevisFormScreen> createState() => _DevisFormScreenState();
}

class _DevisFormScreenState extends ConsumerState<DevisFormScreen> {
  final _objetController = TextEditingController();
  String? _selectedClientId;
  String? _selectedDossierId;
  final List<_LigneController> _lignes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _objetController.text = 'Prestation annuelle de services';
    _selectedDossierId = widget.dossierId;
    
    if (_selectedDossierId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final dossiers = await ref.read(dossiersProvider(null).future);
        final dossier = dossiers.where((d) => d.id == _selectedDossierId).firstOrNull;
        if (dossier != null && mounted) {
          setState(() => _selectedClientId = dossier.clientId);
        }
      });
    }
    
    // Exemple de données pour visualiser l'architecture
    final ligne1 = _LigneController();
    ligne1.desCtrl.text = 'Licence Cloud Entreprise';
    ligne1.qteCtrl.text = '12';
    ligne1.puCtrl.text = '150000';
    
    final ligne2 = _LigneController();
    ligne2.desCtrl.text = 'Installation et Configuration';
    ligne2.qteCtrl.text = '1';
    ligne2.puCtrl.text = '450000';

    _lignes.addAll([ligne1, ligne2]);
  }

  @override
  void dispose() {
    _objetController.dispose();
    for (final l in _lignes) {
      l.dispose();
    }
    super.dispose();
  }

  double get _montantHt => _lignes.fold(0.0, (sum, l) => sum + l.montantHt);

  // Aggregate taxes: {nom: {taux, montant}}
  Map<String, _TaxeTotal> get _taxeTotaux {
    final map = <String, _TaxeTotal>{};
    for (final l in _lignes) {
      for (final t in l.taxes) {
        final montant = l.montantHt * t.taux / 100;
        if (map.containsKey(t.nom)) {
          map[t.nom] = _TaxeTotal(
              nom: t.nom, taux: t.taux, montant: map[t.nom]!.montant + montant);
        } else {
          map[t.nom] = _TaxeTotal(nom: t.nom, taux: t.taux, montant: montant);
        }
      }
    }
    return map;
  }

  double get _totalTaxes => _taxeTotaux.values.fold(0.0, (s, t) => s + t.montant);
  double get _montantTtc => _montantHt + _totalTaxes;

  Future<void> _submit() async {
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Veuillez sélectionner un client')));
      return;
    }
    setState(() => _loading = true);
    final id = await ref.read(devisNotifierProvider.notifier).create(
      {
        'entreprise_id': 'default',
        'client_id': _selectedClientId,
        'dossier_id': _selectedDossierId,
        'objet': _objetController.text.isNotEmpty ? _objetController.text : null,
        'taux_tva': 0.0,
        'taux_tps': 0.0,
      },
      _lignes.map((l) => {
            'designation': l.designation,
            'quantite': l.quantite,
            'prix_unit': l.prixUnit,
            'unite': 'forfait',
            'taxes_json': l.taxes.isEmpty
                ? null
                : jsonEncode(l.taxes.map((t) => t.toJson()).toList()),
          }).toList(),
    );
    if (mounted) {
      setState(() => _loading = false);
      if (id != null) context.go('/devis/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final taxesAsync = ref.watch(taxesActivesProvider);
    final clientsAsync = ref.watch(clientsProvider(null));
    final dossiersAsync = ref.watch(dossiersProvider(null));
    final taxes = taxesAsync.valueOrNull ?? [];
    final isWide = MediaQuery.of(context).size.width >= 900;

    return SaveOverlay(
      saving: _loading,
      label: 'Création du devis…',
      child: Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        title: const Text('Nouveau devis'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Breadcrumbs & Titre
            Row(
              children: [
                Icon(Icons.home_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                const Text('/', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(width: 8),
                const Text('Devis', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(width: 8),
                const Text('/', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(width: 8),
                const Text('Nouveau Devis', style: TextStyle(color: AppColors.navy, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Création de Devis',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Text('Configurez les détails du devis pour votre client.',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (isWide)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: _loading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send),
                        label: const Text('Enregistrer & Envoyer'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Contenu principal
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildLeftColumn(taxes, clientsAsync, dossiersAsync)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildRightColumn()),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLeftColumn(taxes, clientsAsync, dossiersAsync),
                  const SizedBox(height: 24),
                  _buildRightColumn(),
                  const SizedBox(height: 24),
                  // Actions mobiles en bas
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send),
                    label: const Text('Enregistrer & Envoyer'),
                  ),
                ],
              ),
          ],
        ),
      ),
    ), // Scaffold
    ); // SaveOverlay
  }

  Widget _buildLeftColumn(List<Taxe> taxes, AsyncValue<List<Client>> clientsAsync, AsyncValue<List<Dossier>> dossiersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Carte Client & Date (Objet)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Client', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                        const SizedBox(height: 8),
                        clientsAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Erreur: $e'),
                          data: (clients) {
                            if (clients.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.pageBg,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.warning.withAlpha(80)),
                                ),
                                child: const Row(children: [
                                  Icon(Icons.warning_amber_outlined, size: 16, color: AppColors.warning),
                                  SizedBox(width: 8),
                                  Text('Aucun client — créez-en un d\'abord',
                                      style: TextStyle(fontSize: 12, color: AppColors.warning)),
                                ]),
                              );
                            }
                            return DropdownButtonFormField<String>(
                              value: _selectedClientId,
                              isExpanded: true,
                              hint: const Text('Sélectionner un client…', style: TextStyle(fontSize: 13)),
                              items: clients
                                  .map((c) => DropdownMenuItem<String>(value: c.id, child: Text(c.nom, overflow: TextOverflow.ellipsis)))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedClientId = v;
                                _selectedDossierId = null;
                              }),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.pageBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dossier lié', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                        const SizedBox(height: 8),
                        dossiersAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Erreur: $e'),
                          data: (dossiers) {
                            final filtered = _selectedClientId == null
                                ? dossiers
                                : dossiers.where((d) => d.clientId == _selectedClientId).toList();
                            return DropdownButtonFormField<String>(
                              key: ValueKey('dossier_$_selectedClientId'),
                              value: _selectedDossierId,
                              isExpanded: true,
                              hint: Text(
                                filtered.isEmpty
                                    ? (_selectedClientId == null ? 'Choisir un client d\'abord' : 'Aucun dossier pour ce client')
                                    : 'Sélectionner un dossier (optionnel)',
                                style: const TextStyle(fontSize: 13),
                              ),
                              items: [
                                const DropdownMenuItem<String>(value: null, child: Text('— Aucun dossier —', style: TextStyle(color: AppColors.textMuted))),
                                ...filtered.map((d) => DropdownMenuItem<String>(
                                      value: d.id,
                                      child: Text('${d.numero ?? '—'} · ${d.titre}', overflow: TextOverflow.ellipsis),
                                    )),
                              ],
                              onChanged: (v) => setState(() => _selectedDossierId = v),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.pageBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Objet / Notes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
              const SizedBox(height: 8),
              TextField(
                controller: _objetController,
                decoration: InputDecoration(
                  hintText: 'Ex: Prestation annuelle...',
                  filled: true,
                  fillColor: AppColors.pageBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Lignes du devis (Tableau)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lignes du devis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
                    TextButton.icon(
                      onPressed: () => setState(() => _lignes.add(_LigneController())),
                      icon: const Icon(Icons.add_circle),
                      label: const Text('Ajouter une ligne'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // En-têtes (si écran large)
              if (MediaQuery.of(context).size.width >= 600)
                Container(
                  color: AppColors.pageBg,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      const Expanded(flex: 3, child: Text('Désignation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))),
                      const SizedBox(width: 16),
                      const SizedBox(width: 80, child: Text('Quantité', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))),
                      const SizedBox(width: 16),
                      const SizedBox(width: 120, child: Text('Prix U. HT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))),
                      const SizedBox(width: 16),
                      const SizedBox(width: 120, child: Text('Total HT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted))),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              // Liste des lignes
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _lignes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => _LigneWidget(
                  key: ValueKey(_lignes[i]),
                  ctrl: _lignes[i],
                  taxes: taxes,
                  onChanged: () => setState(() {}),
                  onDelete: _lignes.length > 1 ? () => setState(() => _lignes.removeAt(i)) : null,
                ),
              ),
              const Divider(height: 1),
              // Footer "Add item"
              InkWell(
                onTap: () => setState(() => _lignes.add(_LigneController())),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: AppColors.pageBg.withAlpha(120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Text('Ajouter un nouvel item', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    final clientsAsync = ref.watch(clientsProvider(null));
    final clients = clientsAsync.valueOrNull ?? [];
    final selectedClient = clients.where((c) => c.id == _selectedClientId).firstOrNull;
    final clientStr = selectedClient?.nom ?? 'Client non défini';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Résumé financier (Dark Card)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A), // Dark Navy
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.blue.withAlpha(30), blurRadius: 20, offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Résumé financier', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total HT', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14)),
                  Text(FormatUtils.formatFcfa(_montantHt), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              ..._taxeTotaux.values.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${t.nom} (${t.taux.toStringAsFixed(t.taux % 1 == 0 ? 0 : 1)}%)', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14)),
                    Text(FormatUtils.formatFcfa(t.montant), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
              Divider(color: Colors.white.withAlpha(30), height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL TTC', style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  Text(FormatUtils.formatFcfa(_montantTtc), style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.greenAccent.withAlpha(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('Prêt pour création', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Aperçu Client
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.pageBg,
                    foregroundColor: AppColors.navy,
                    child: Text(clientStr.substring(0, 1).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clientStr, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                        const Text('Informations génériques', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.pageBg, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ENCOURS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          const Text('---', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.pageBg, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DERNIER DEVIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          const Text('---', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaxeApplied {
  final String id;
  final String nom;
  final double taux;
  _TaxeApplied({required this.id, required this.nom, required this.taux});
  Map<String, dynamic> toJson() => {'id': id, 'nom': nom, 'taux': taux};
}

class _TaxeTotal {
  final String nom;
  final double taux;
  final double montant;
  _TaxeTotal({required this.nom, required this.taux, required this.montant});
}

class _LigneController {
  final desCtrl = TextEditingController();
  final qteCtrl = TextEditingController(text: '1');
  final puCtrl = TextEditingController();
  List<_TaxeApplied> taxes = [];

  String get designation => desCtrl.text;
  double get quantite => double.tryParse(qteCtrl.text) ?? 1;
  double get prixUnit => double.tryParse(puCtrl.text) ?? 0;
  double get montantHt => quantite * prixUnit;

  void dispose() {
    desCtrl.dispose();
    qteCtrl.dispose();
    puCtrl.dispose();
  }
}

class _LigneWidget extends ConsumerStatefulWidget {
  final _LigneController ctrl;
  final List<Taxe> taxes;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;
  const _LigneWidget({
    super.key,
    required this.ctrl,
    required this.taxes,
    required this.onChanged,
    this.onDelete,
  });

  @override
  ConsumerState<_LigneWidget> createState() => _LigneWidgetState();
}

class _LigneWidgetState extends ConsumerState<_LigneWidget> {
  void _toggleTaxe(Taxe t, bool selected) {
    setState(() {
      if (selected) {
        widget.ctrl.taxes.add(_TaxeApplied(id: t.id, nom: t.nom, taux: t.taux));
      } else {
        widget.ctrl.taxes.removeWhere((a) => a.id == t.id);
      }
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final appliedIds = widget.ctrl.taxes.map((t) => t.id).toSet();
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: widget.ctrl.desCtrl,
                    decoration: const InputDecoration(hintText: 'Désignation de la ligne...', border: InputBorder.none, isDense: true),
                    onChanged: (_) => widget.onChanged(),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: widget.ctrl.qteCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.pageBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (_) { widget.onChanged(); setState(() {}); },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: widget.ctrl.puCtrl,
                    decoration: const InputDecoration(hintText: 'Prix unitaire', border: InputBorder.none, isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (_) { widget.onChanged(); setState(() {}); },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: Text(FormatUtils.formatFcfa(widget.ctrl.montantHt), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                ),
                SizedBox(
                  width: 40,
                  child: widget.onDelete != null
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
                          onPressed: widget.onDelete,
                          tooltip: 'Supprimer',
                        )
                      : const SizedBox(),
                ),
              ],
            )
          else
            Column(
              children: [
                TextField(
                  controller: widget.ctrl.desCtrl,
                  decoration: const InputDecoration(labelText: 'Désignation', isDense: true),
                  onChanged: (_) => widget.onChanged(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.ctrl.qteCtrl,
                        decoration: const InputDecoration(labelText: 'Qté', isDense: true),
                        keyboardType: TextInputType.number,
                        onChanged: (_) { widget.onChanged(); setState(() {}); },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: widget.ctrl.puCtrl,
                        decoration: const InputDecoration(labelText: 'Prix unitaire', isDense: true),
                        keyboardType: TextInputType.number,
                        onChanged: (_) { widget.onChanged(); setState(() {}); },
                      ),
                    ),
                    if (widget.onDelete != null)
                      IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.danger), onPressed: widget.onDelete),
                  ],
                ),
              ],
            ),
          if (widget.taxes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.taxes.map((t) {
                final isOn = appliedIds.contains(t.id);
                return FilterChip(
                  label: Text('${t.nom} ${t.taux.toStringAsFixed(t.taux % 1 == 0 ? 0 : 1)}%', style: const TextStyle(fontSize: 11)),
                  selected: isOn,
                  onSelected: (v) => _toggleTaxe(t, v),
                  selectedColor: AppColors.teal.withAlpha(40),
                  checkmarkColor: AppColors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
