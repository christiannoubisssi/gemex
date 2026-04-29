import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
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
  final _clientIdController = TextEditingController();
  final List<_LigneController> _lignes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _lignes.add(_LigneController());
  }

  @override
  void dispose() {
    _objetController.dispose();
    _clientIdController.dispose();
    for (final l in _lignes) { l.dispose(); }
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
          map[t.nom] = _TaxeTotal(nom: t.nom, taux: t.taux, montant: map[t.nom]!.montant + montant);
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
    if (_clientIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client requis')));
      return;
    }
    setState(() => _loading = true);
    final id = await ref.read(devisNotifierProvider.notifier).create(
      {
        'entreprise_id': 'default',
        'client_id': _clientIdController.text,
        'dossier_id': widget.dossierId,
        'objet': _objetController.text.isNotEmpty ? _objetController.text : null,
        'taux_tva': 0.0,
        'taux_tps': 0.0,
      },
      _lignes.map((l) => {
        'designation': l.designation,
        'quantite': l.quantite,
        'prix_unit': l.prixUnit,
        'unite': 'forfait',
        'taxes_json': l.taxes.isEmpty ? null : jsonEncode(l.taxes.map((t) => t.toJson()).toList()),
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
    final taxes = taxesAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau devis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Informations',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                const Divider(height: 16),
                TextField(
                  controller: _clientIdController,
                  decoration: const InputDecoration(labelText: 'ID Client (temporaire)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _objetController,
                  decoration: const InputDecoration(labelText: 'Objet du devis'),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Lignes',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Ajouter'),
                    onPressed: () => setState(() => _lignes.add(_LigneController())),
                  ),
                ]),
                const Divider(height: 16),
                ...List.generate(_lignes.length, (i) => _LigneWidget(
                  key: ValueKey(i),
                  ctrl: _lignes[i],
                  taxes: taxes,
                  onChanged: () => setState(() {}),
                  onDelete: _lignes.length > 1 ? () => setState(() => _lignes.removeAt(i)) : null,
                )),
                const Divider(height: 24),
                _TotalRow('Sous-total HT', _montantHt),
                if (taxes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Aucune taxe configurée — allez dans Comptabilité > Taxes pour en créer.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ..._taxeTotaux.values.map((t) =>
                    _TotalRow('${t.nom} (${t.taux.toStringAsFixed(t.taux % 1 == 0 ? 0 : 1)} %)', t.montant)),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total TTC',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
                    Text(FormatUtils.formatFcfa(_montantTtc),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
                  ]),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 80),
        ]),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Créer le devis'),
          ),
        ),
      ),
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
    final lineTaxTotal = widget.ctrl.taxes.fold<double>(
        0, (s, t) => s + widget.ctrl.montantHt * t.taux / 100);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: TextField(
              controller: widget.ctrl.desCtrl,
              decoration: const InputDecoration(labelText: 'Désignation', isDense: true),
              onChanged: (_) => widget.onChanged(),
            ),
          ),
          if (widget.onDelete != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: widget.onDelete,
            ),
          ],
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: widget.ctrl.qteCtrl,
              decoration: const InputDecoration(labelText: 'Qté', isDense: true),
              keyboardType: TextInputType.number,
              onChanged: (_) { widget.onChanged(); setState(() {}); },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: widget.ctrl.puCtrl,
              decoration: const InputDecoration(labelText: 'Prix unitaire (FCFA)', isDense: true),
              keyboardType: TextInputType.number,
              onChanged: (_) { widget.onChanged(); setState(() {}); },
            ),
          ),
          const SizedBox(width: 8),
          Text(FormatUtils.formatFcfa(widget.ctrl.montantHt),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
        if (widget.taxes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: widget.taxes.map((t) {
              final isOn = appliedIds.contains(t.id);
              return FilterChip(
                label: Text('${t.nom} ${t.taux.toStringAsFixed(t.taux % 1 == 0 ? 0 : 1)}%',
                    style: const TextStyle(fontSize: 11)),
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
          if (lineTaxTotal > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Taxes sur cette ligne : ${FormatUtils.formatFcfa(lineTaxTotal)}',
                style: const TextStyle(fontSize: 11, color: AppColors.teal),
                textAlign: TextAlign.right,
              ),
            ),
        ],
        const Divider(height: 16),
      ]),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  const _TotalRow(this.label, this.amount);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(FormatUtils.formatFcfa(amount)),
        ]),
      );
}
