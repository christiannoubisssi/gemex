import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../rh/presentation/providers/personnel_provider.dart' show allPersonnelProvider;
import '../providers/salaire_provider.dart';

class PaieScreen extends ConsumerStatefulWidget {
  const PaieScreen({super.key});

  @override
  ConsumerState<PaieScreen> createState() => _PaieScreenState();
}

class _PaieScreenState extends ConsumerState<PaieScreen> {
  late int _mois;
  late int _annee;

  static const _moisLabels = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
  }

  MoisAnnee get _period => (mois: _mois, annee: _annee);

  void _prevMois() => setState(() {
        if (_mois == 1) { _mois = 12; _annee--; } else { _mois--; }
      });

  void _nextMois() => setState(() {
        if (_mois == 12) { _mois = 1; _annee++; } else { _mois++; }
      });

  Future<void> _initierMois() async {
    await ref.read(paieNotifierProvider.notifier).initierMois(_mois, _annee);
    ref.invalidate(salairesProvider(_period));
    ref.invalidate(masseSalarialeProvider(_period));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fiches de paie initialisées')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final salairesAsync = ref.watch(salairesProvider(_period));
    final masseAsync = ref.watch(masseSalarialeProvider(_period));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traitement de la paie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_outlined),
            tooltip: 'Initialiser le mois',
            onPressed: _initierMois,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sélecteur de période
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _prevMois,
                ),
                Text(
                  '${_moisLabels[_mois]} $_annee',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _nextMois,
                ),
              ],
            ),
          ),

          // Carte masse salariale
          masseAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (masse) => masse == 0
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Masse salariale nette',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(FormatUtils.formatFcfa(masse),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: AppColors.teal, fontSize: 16)),
                      ],
                    ),
                  ),
          ),

          Expanded(
            child: salairesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Aucune fiche ce mois',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.playlist_add_outlined),
                          label: const Text('Initialiser le mois'),
                          onPressed: _initierMois,
                        ),
                      ],
                    ),
                  );
                }
                final personnelAsync = ref.watch(allPersonnelProvider);
                final personnelMap = {
                  for (final p in personnelAsync.valueOrNull ?? <PersonnelData>[])
                    p.id: [p.prenom, p.nom].whereType<String>().join(' ')
                };
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _SalaireTile(
                    salaire: list[i],
                    nomPersonnel: personnelMap[list[i].personnelId] ?? list[i].personnelId,
                    onValider: () async {
                      await ref.read(paieNotifierProvider.notifier).valider(list[i].id);
                      ref.invalidate(salairesProvider(_period));
                    },
                    onPayer: () async {
                      await ref.read(paieNotifierProvider.notifier).marquerPaye(list[i].id);
                      ref.invalidate(salairesProvider(_period));
                      ref.invalidate(masseSalarialeProvider(_period));
                    },
                    onEditer: () => _showEditDialog(context, ref, list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, Salaire s) async {
    final brutCtrl = TextEditingController(text: s.salaireBrut.toStringAsFixed(0));
    final cnpsCtrl = TextEditingController(text: s.cnps.toStringAsFixed(0));
    final irppCtrl = TextEditingController(text: s.irpp.toStringAsFixed(0));
    final autresCtrl = TextEditingController(text: s.autresRetenues.toStringAsFixed(0));

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifier la fiche de paie'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NumField(ctrl: brutCtrl, label: 'Salaire brut'),
              const SizedBox(height: 8),
              _NumField(ctrl: cnpsCtrl, label: 'CNPS'),
              const SizedBox(height: 8),
              _NumField(ctrl: irppCtrl, label: 'IRPP'),
              const SizedBox(height: 8),
              _NumField(ctrl: autresCtrl, label: 'Autres retenues'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final brut = double.tryParse(brutCtrl.text) ?? s.salaireBrut;
              final cnps = double.tryParse(cnpsCtrl.text) ?? s.cnps;
              final irpp = double.tryParse(irppCtrl.text) ?? s.irpp;
              final autres = double.tryParse(autresCtrl.text) ?? s.autresRetenues;
              await ref.read(paieNotifierProvider.notifier).updateSalaire(
                    id: s.id,
                    salaireBrut: brut,
                    cnps: cnps,
                    irpp: irpp,
                    autresRetenues: autres,
                  );
              ref.invalidate(salairesProvider(_period));
              ref.invalidate(masseSalarialeProvider(_period));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

class _SalaireTile extends StatelessWidget {
  final Salaire salaire;
  final String nomPersonnel;
  final VoidCallback onValider;
  final VoidCallback onPayer;
  final VoidCallback onEditer;
  const _SalaireTile(
      {required this.salaire,
      required this.nomPersonnel,
      required this.onValider,
      required this.onPayer,
      required this.onEditer});

  Color get _statusColor {
    switch (salaire.statut) {
      case 'paye': return Colors.green;
      case 'valide': return AppColors.teal;
      default: return Colors.orange;
    }
  }

  String get _statusLabel {
    switch (salaire.statut) {
      case 'paye': return 'Payé';
      case 'valide': return 'Validé';
      default: return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nomPersonnel,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Brut : ${FormatUtils.formatFcfa(salaire.salaireBrut)}  ·  Net : ${FormatUtils.formatFcfa(salaire.salaireNet)}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_statusLabel,
                style: TextStyle(
                    fontSize: 11, color: _statusColor, fontWeight: FontWeight.w600)),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEditer();
              if (v == 'valider') onValider();
              if (v == 'payer') onPayer();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Modifier')),
              if (salaire.statut == 'en_attente')
                const PopupMenuItem(value: 'valider', child: Text('Valider')),
              if (salaire.statut == 'valide')
                const PopupMenuItem(value: 'payer', child: Text('Marquer payé')),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  const _NumField({required this.ctrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: 'FCFA'),
    );
  }
}
