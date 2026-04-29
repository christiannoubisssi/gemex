import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/charge_repository.dart';
import '../providers/charge_provider.dart';
import 'charge_form_screen.dart';

// ignore: constant_identifier_names
const _moisLabels = [
  '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
  'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
];

class ComptabiliteScreen extends ConsumerStatefulWidget {
  const ComptabiliteScreen({super.key});

  @override
  ConsumerState<ComptabiliteScreen> createState() => _ComptabiliteScreenState();
}

class _ComptabiliteScreenState extends ConsumerState<ComptabiliteScreen> {
  late int _mois;
  late int _annee;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
  }

  MoisAnnee get _period => (mois: _mois, annee: _annee);

  void _prevMois() {
    setState(() {
      if (_mois == 1) {
        _mois = 12;
        _annee--;
      } else {
        _mois--;
      }
    });
  }

  void _nextMois() {
    setState(() {
      if (_mois == 12) {
        _mois = 1;
        _annee++;
      } else {
        _mois++;
      }
    });
  }

  Future<void> _exportCsv() async {
    final charges =
        await ref.read(chargeRepositoryProvider).getAll(mois: _mois, annee: _annee);

    final buf = StringBuffer();
    buf.writeln('Date,Catégorie,Libellé,Montant');
    for (final c in charges) {
      final date = DateFormat('dd/MM/yyyy').format(c.dateCharge);
      buf.writeln('$date,${c.categorie},${c.libelle},${c.montant.toStringAsFixed(0)}');
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/charges_${_annee}_${_mois.toString().padLeft(2, '0')}.csv');
    await file.writeAsString(buf.toString());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export CSV : ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chargesAsync = ref.watch(chargesProvider(_period));
    final totalAsync = ref.watch(totalChargesProvider(_period));
    final catAsync = ref.watch(chargesParCategorieProvider(_period));

    final caFuture = AppDatabase.instance.facturesDao.getCaParMois(_mois, _annee);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comptabilité'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Exporter CSV',
            onPressed: _exportCsv,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Charge'),
        onPressed: () async {
          final added = await Navigator.of(context)
              .push<bool>(MaterialPageRoute(builder: (_) => const ChargeFormScreen()));
          if (added == true) {
            ref.invalidate(chargesProvider);
            ref.invalidate(totalChargesProvider);
            ref.invalidate(chargesParCategorieProvider);
          }
        },
      ),
      body: Column(
        children: [
          // Accès rapides
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _QuickCard(
                  icon: Icons.list_alt,
                  label: 'Modèles de charges',
                  onTap: () => context.push('/comptabilite/charges-modeles'),
                ),
                const SizedBox(width: 8),
                _QuickCard(
                  icon: Icons.percent,
                  label: 'Taxes & taux',
                  onTap: () => context.push('/comptabilite/taxes'),
                ),
              ],
            ),
          ),

          // Sélecteur de période
          _PeriodSelector(
            mois: _mois,
            annee: _annee,
            onPrev: _prevMois,
            onNext: _nextMois,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Cartes synthèse
                  FutureBuilder<double>(
                    future: caFuture,
                    builder: (context, caSnap) {
                      final ca = caSnap.data ?? 0;
                      return totalAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Erreur: $e'),
                        data: (charges) => _SummaryRow(ca: ca, charges: charges),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Graphique camembert
                  catAsync.when(
                    loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (catMap) => catMap.isEmpty
                        ? const SizedBox.shrink()
                        : _ChargesChart(data: catMap),
                  ),
                  const SizedBox(height: 16),

                  // Liste des charges
                  chargesAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Erreur: $e'),
                    data: (list) => list.isEmpty
                        ? const _EmptyCharges()
                        : _ChargesList(
                            charges: list,
                            onDelete: (id) async {
                              await ref.read(chargeNotifierProvider.notifier).deleteCharge(id);
                              ref.invalidate(chargesProvider);
                              ref.invalidate(totalChargesProvider);
                              ref.invalidate(chargesParCategorieProvider);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final int mois;
  final int annee;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _PeriodSelector(
      {required this.mois, required this.annee, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: onPrev,
          ),
          Text(
            '${_moisLabels[mois]} $annee',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double ca;
  final double charges;
  const _SummaryRow({required this.ca, required this.charges});

  @override
  Widget build(BuildContext context) {
    final resultat = ca - charges;
    return Row(
      children: [
        Expanded(child: _SummaryCard('Chiffre d\'affaires', ca, AppColors.teal)),
        const SizedBox(width: 8),
        Expanded(child: _SummaryCard('Charges', charges, AppColors.danger)),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            'Résultat',
            resultat,
            resultat >= 0 ? Colors.green.shade600 : AppColors.danger,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _SummaryCard(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              FormatUtils.formatFcfa(value),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

const _chartColors = [
  Color(0xFF1A8A9A),
  Color(0xFFF0A500),
  Color(0xFF0D2137),
  Color(0xFFE53935),
  Color(0xFF43A047),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
  Color(0xFFFF7043),
  Color(0xFF6D4C41),
  Color(0xFF546E7A),
];

class _ChargesChart extends StatelessWidget {
  final Map<String, double> data;
  const _ChargesChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final total = entries.fold<double>(0, (s, e) => s + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Charges par catégorie',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: entries.asMap().entries.map((e) {
                    final idx = e.key;
                    final cat = e.value;
                    final pct = total > 0 ? (cat.value / total * 100) : 0.0;
                    return PieChartSectionData(
                      value: cat.value,
                      color: _chartColors[idx % _chartColors.length],
                      title: '${pct.toStringAsFixed(0)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: entries.asMap().entries.map((e) {
                final color = _chartColors[e.key % _chartColors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, color: color),
                    const SizedBox(width: 4),
                    Text(e.value.key, style: const TextStyle(fontSize: 11)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChargesList extends StatelessWidget {
  final List<Charge> charges;
  final void Function(String) onDelete;
  const _ChargesList({required this.charges, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('Détail des charges',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
          ),
          ...charges.map((c) => ListTile(
                dense: true,
                title: Text(c.libelle),
                subtitle: Text('${c.categorie} · ${DateFormat('dd/MM').format(c.dateCharge)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(FormatUtils.formatFcfa(c.montant),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                      onPressed: () => onDelete(c.id),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _EmptyCharges extends StatelessWidget {
  const _EmptyCharges();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Text('Aucune charge ce mois-ci', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.navy.withAlpha(12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.navy.withAlpha(40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.navy),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.navy, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.navy),
          ],
        ),
      ),
    );
  }
}
