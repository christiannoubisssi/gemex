import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/charges_modeles_provider.dart';

const _priorites = ['basse', 'normale', 'haute', 'urgente'];
const _prioriteLabels = {'basse': 'Basse', 'normale': 'Normale', 'haute': 'Haute', 'urgente': 'Urgente'};
const _prioriteColors = {
  'basse': Colors.grey,
  'normale': Color(0xFF1A8A9A),
  'haute': Colors.orange,
  'urgente': Colors.red,
};

const _moisLabels = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

class _LigneDraft {
  String id;
  TextEditingController designation;
  TextEditingController montant;
  TextEditingController notes;
  DateTime? dateEcheance;
  String priorite;

  _LigneDraft({required this.id})
      : designation = TextEditingController(),
        montant = TextEditingController(),
        notes = TextEditingController(),
        priorite = 'normale';

  void dispose() {
    designation.dispose();
    montant.dispose();
    notes.dispose();
  }

  Map<String, dynamic> toData() => {
        'id': id,
        'designation': designation.text.trim(),
        'montant': double.tryParse(montant.text.trim().replaceAll(' ', '').replaceAll(',', '.')) ?? 0.0,
        'date_echeance': dateEcheance,
        'priorite': priorite,
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
      };
}

class ChargesModelesFormScreen extends ConsumerStatefulWidget {
  final String? id;
  const ChargesModelesFormScreen({super.key, this.id});

  @override
  ConsumerState<ChargesModelesFormScreen> createState() => _State();
}

class _State extends ConsumerState<ChargesModelesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  late int _mois;
  late int _annee;
  final List<_LigneDraft> _lignes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
    _addLigne();
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    for (final l in _lignes) { l.dispose(); }
    super.dispose();
  }

  void _addLigne() {
    setState(() => _lignes.add(_LigneDraft(id: DateTime.now().millisecondsSinceEpoch.toString())));
  }

  void _removeLigne(int index) {
    setState(() {
      _lignes[index].dispose();
      _lignes.removeAt(index);
    });
  }

  Future<void> _pickDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lignes[index].dateEcheance ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _lignes[index].dateEcheance = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lignes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez au moins une ligne')),
      );
      return;
    }

    setState(() => _loading = true);
    final data = {
      'titre': _titreCtrl.text.trim(),
      'mois': _mois,
      'annee': _annee,
      'entreprise_id': 'local',
    };
    final lignes = _lignes.map((l) => l.toData()).toList();

    final id = await ref.read(chargesModeleNotifierProvider.notifier).create(data, lignes);
    if (mounted) {
      setState(() => _loading = false);
      if (id != null) {
        context.go('/comptabilite/charges-modeles/$id');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau modèle de charges'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Enregistrer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // En-tête du modèle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations générales',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Titre du modèle *',
                        hintText: 'Ex: Charges opérationnelles Avril 2025',
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Mois', isDense: true),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _mois,
                                isDense: true,
                                items: List.generate(12, (i) => i + 1)
                                    .map((m) => DropdownMenuItem(value: m, child: Text(_moisLabels[m])))
                                    .toList(),
                                onChanged: (v) => setState(() => _mois = v!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Année', isDense: true),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _annee,
                                isDense: true,
                                items: List.generate(5, (i) => DateTime.now().year - 1 + i)
                                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                                    .toList(),
                                onChanged: (v) => setState(() => _annee = v!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lignes
            Row(
              children: [
                const Text('Lignes de charges',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 15)),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ajouter'),
                  onPressed: _addLigne,
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._lignes.asMap().entries.map((e) => _LigneCard(
                  index: e.key,
                  ligne: e.value,
                  onRemove: _lignes.length > 1 ? () => _removeLigne(e.key) : null,
                  onPickDate: () => _pickDate(e.key),
                  onPrioriteChange: (p) => setState(() => _lignes[e.key].priorite = p),
                  onDateChange: (d) => setState(() => _lignes[e.key].dateEcheance = d),
                )),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _LigneCard extends StatelessWidget {
  final int index;
  final _LigneDraft ligne;
  final VoidCallback? onRemove;
  final VoidCallback onPickDate;
  final ValueChanged<String> onPrioriteChange;
  final ValueChanged<DateTime?> onDateChange;

  const _LigneCard({
    required this.index,
    required this.ligne,
    required this.onRemove,
    required this.onPickDate,
    required this.onPrioriteChange,
    required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.navy.withAlpha(20),
                  child: Text('${index + 1}',
                      style: const TextStyle(fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                // Priorité chip
                DropdownButton<String>(
                  value: ligne.priorite,
                  underline: const SizedBox(),
                  isDense: true,
                  items: _priorites
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 8, color: _prioriteColors[p] ?? Colors.grey),
                                const SizedBox(width: 4),
                                Text(_prioriteLabels[p] ?? p, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => v != null ? onPrioriteChange(v) : null,
                ),
                const SizedBox(width: 8),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                    onPressed: onRemove,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ligne.designation,
              decoration: const InputDecoration(
                labelText: 'Désignation *',
                isDense: true,
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ligne.montant,
                    decoration: const InputDecoration(
                      labelText: 'Montant (FCFA) *',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      if (double.tryParse(v.trim().replaceAll(' ', '').replaceAll(',', '.')) == null) {
                        return 'Invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: onPickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Échéance',
                        isDense: true,
                        suffixIcon: Icon(Icons.calendar_today, size: 16),
                      ),
                      child: Text(
                        ligne.dateEcheance != null
                            ? DateFormat('dd/MM/yyyy').format(ligne.dateEcheance!)
                            : '—',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: ligne.notes,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                isDense: true,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
