import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
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
  double _tauxTva = 18.0;
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
    for (final l in _lignes) {
      l.dispose();
    }
    super.dispose();
  }

  double get _montantHt => _lignes.fold(0.0, (sum, l) => sum + l.total);
  double get _montantTva => _montantHt * _tauxTva / 100;
  double get _montantTtc => _montantHt + _montantTva;

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
        'taux_tva': _tauxTva,
        'taux_tps': 0.0,
      },
      _lignes.map((l) => {
        'designation': l.designation,
        'quantite': l.quantite,
        'prix_unit': l.prixUnit,
        'unite': 'forfait',
      }).toList(),
    );
    if (mounted) {
      setState(() => _loading = false);
      if (id != null) context.go('/devis/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau devis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Informations', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const Divider(height: 16),
            TextField(controller: _clientIdController, decoration: const InputDecoration(labelText: 'ID Client (temporaire)')),
            const SizedBox(height: 12),
            TextField(controller: _objetController, decoration: const InputDecoration(labelText: 'Objet du devis')),
            const SizedBox(height: 12),
            Row(children: [
              const Text('TVA : ', style: TextStyle(fontWeight: FontWeight.w500)),
              DropdownButton<double>(
                value: _tauxTva,
                items: [0, 5, 10, 18, 20]
                    .map((t) => DropdownMenuItem(value: t.toDouble(), child: Text('$t %')))
                    .toList(),
                onChanged: (v) => setState(() => _tauxTva = v!),
              ),
            ]),
          ]))),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Lignes', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
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
              onChanged: () => setState(() {}),
              onDelete: _lignes.length > 1 ? () => setState(() => _lignes.removeAt(i)) : null,
            )),
            const Divider(height: 24),
            _TotalRow('Sous-total HT', _montantHt),
            _TotalRow('TVA (${_tauxTva.toStringAsFixed(0)} %)', _montantTva),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.navy.withAlpha(10), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total TTC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy)),
                Text(FormatUtils.formatFcfa(_montantTtc), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navy)),
              ]),
            ),
          ]))),
          const SizedBox(height: 80),
        ]),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Créer le devis'),
          ),
        ),
      ),
    );
  }
}

class _LigneController {
  final _desCtrl = TextEditingController();
  final _qteCtrl = TextEditingController(text: '1');
  final _puCtrl = TextEditingController();

  String get designation => _desCtrl.text;
  double get quantite => double.tryParse(_qteCtrl.text) ?? 1;
  double get prixUnit => double.tryParse(_puCtrl.text) ?? 0;
  double get total => quantite * prixUnit;

  void dispose() { _desCtrl.dispose(); _qteCtrl.dispose(); _puCtrl.dispose(); }
}

class _LigneWidget extends StatelessWidget {
  final _LigneController ctrl;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;
  const _LigneWidget({super.key, required this.ctrl, required this.onChanged, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: TextField(
          controller: ctrl._desCtrl,
          decoration: const InputDecoration(labelText: 'Désignation', isDense: true),
          onChanged: (_) => onChanged(),
        )),
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.danger), onPressed: onDelete),
        ],
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: TextField(
          controller: ctrl._qteCtrl,
          decoration: const InputDecoration(labelText: 'Qté', isDense: true),
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
        )),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: TextField(
          controller: ctrl._puCtrl,
          decoration: const InputDecoration(labelText: 'Prix unitaire (FCFA)', isDense: true),
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
        )),
        const SizedBox(width: 8),
        Text(FormatUtils.formatFcfa(ctrl.total), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    ]));
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
