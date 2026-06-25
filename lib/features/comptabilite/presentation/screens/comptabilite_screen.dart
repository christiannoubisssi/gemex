import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/export_comptable_service.dart';
import '../../../parametres/data/parametres_service.dart';
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

class _ComptabiliteScreenState extends ConsumerState<ComptabiliteScreen>
    with SingleTickerProviderStateMixin {
  late int _mois;
  late int _annee;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
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

  Future<void> _showExportMenu() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Exporter en CSV'),
        children: [
          _ExportOption(
            icon: Icons.receipt_long,
            label: 'Charges du mois',
            value: 'charges',
          ),
          _ExportOption(
            icon: Icons.trending_up,
            label: 'Ventes du mois',
            value: 'ventes',
          ),
          _ExportOption(
            icon: Icons.people,
            label: 'Clients',
            value: 'clients',
          ),
          _ExportOption(
            icon: Icons.account_balance,
            label: 'TVA annuelle',
            value: 'tva',
          ),
          _ExportOption(
            icon: Icons.payments,
            label: 'Salaires du mois',
            value: 'salaires',
          ),
          _ExportOption(
            icon: Icons.balance,
            label: 'Balance annuelle',
            value: 'balance',
          ),
        ],
      ),
    );
    if (choice == null || !mounted) return;

    try {
      String path;
      switch (choice) {
        case 'charges':
          path = await ExportComptableService.exportCharges(_mois, _annee);
        case 'ventes':
          path = await ExportComptableService.exportVentes(_mois, _annee);
        case 'clients':
          path = await ExportComptableService.exportClients();
        case 'tva':
          path = await ExportComptableService.exportTva(_annee);
        case 'salaires':
          path = await ExportComptableService.exportSalaires(_mois, _annee);
        case 'balance':
          path = await ExportComptableService.exportBalance(_annee);
        default:
          return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export CSV : $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur export : $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _generateRecurrentes() async {
    // Période source = mois précédent
    int moisSrc = _mois - 1;
    int anneeSrc = _annee;
    if (moisSrc == 0) {
      moisSrc = 12;
      anneeSrc--;
    }

    final count = await ref.read(chargeRepositoryProvider).generateRecurrentes(
      moisSource: moisSrc,
      anneeSource: anneeSrc,
      moisCible: _mois,
      anneeCible: _annee,
    );

    if (mounted) {
      ref.invalidate(chargesProvider);
      ref.invalidate(totalChargesProvider);
      ref.invalidate(chargesParCategorieProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(count > 0
              ? '$count charge(s) récurrente(s) générée(s)'
              : 'Aucune charge récurrente à générer'),
          backgroundColor: count > 0 ? AppColors.success : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chargesAsync = ref.watch(chargesProvider(_period));
    final totalAsync = ref.watch(totalChargesProvider(_period));
    final catAsync = ref.watch(chargesParCategorieProvider(_period));

    final caFuture =
        AppDatabase.instance.facturesDao.getCaParMois(_mois, _annee);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comptabilité'),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat_outlined),
            tooltip: 'Générer charges récurrentes',
            onPressed: _generateRecurrentes,
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Exporter CSV',
            onPressed: _showExportMenu,
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: 'Charges'),
            Tab(text: 'Produits / CA'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Charge'),
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const ChargeFormScreen()));
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
                const SizedBox(width: 8),
                _QuickCard(
                  icon: Icons.category_outlined,
                  label: 'Catégories',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const _CategoriesChargesScreen())),
                ),
                const SizedBox(width: 8),
                _QuickCard(
                  icon: Icons.menu_book_outlined,
                  label: 'Journal comptable',
                  onTap: () => context.push('/comptabilite/journal'),
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
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // --- Onglet Charges ---
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FutureBuilder<double>(
                        future: caFuture,
                        builder: (context, caSnap) {
                          final ca = caSnap.data ?? 0;
                          return totalAsync.when(
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Erreur: $e'),
                            data: (charges) =>
                                _SummaryRow(ca: ca, charges: charges),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      catAsync.when(
                        loading: () => const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator())),
                        error: (e, _) => const SizedBox.shrink(),
                        data: (catMap) => catMap.isEmpty
                            ? const SizedBox.shrink()
                            : _ChargesChart(data: catMap),
                      ),
                      const SizedBox(height: 16),
                      chargesAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Erreur: $e'),
                        data: (list) => list.isEmpty
                            ? const _EmptyCharges()
                            : _ChargesList(
                                charges: list,
                                onDelete: (id) async {
                                  await ref
                                      .read(chargeNotifierProvider.notifier)
                                      .deleteCharge(id);
                                  ref.invalidate(chargesProvider);
                                  ref.invalidate(totalChargesProvider);
                                  ref.invalidate(chargesParCategorieProvider);
                                },
                              ),
                      ),
                    ],
                  ),
                ),

                // --- Onglet Produits / CA ---
                _ProduitsCATab(mois: _mois, annee: _annee),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Onglet Produits / CA
// ═══════════════════════════════════════════════════════════════════════════

class _ProduitsCATab extends StatelessWidget {
  final int mois;
  final int annee;
  const _ProduitsCATab({required this.mois, required this.annee});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CaData>(
      future: _loadData(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Chiffre d\'affaires du mois',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy)),
                      const SizedBox(height: 8),
                      Text(
                        FormatUtils.formatFcfa(data.totalCa),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal),
                      ),
                      Text(
                        '${data.nbFactures} facture(s) émise(s)/payée(s)',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (data.caParClient.isNotEmpty) ...[
                const Text('Ventilation par client',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                        fontSize: 15)),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: data.caParClient.entries.map((e) {
                      return ListTile(
                        dense: true,
                        title: Text(e.key),
                        trailing: Text(
                          FormatUtils.formatFcfa(e.value),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('Aucune facture payée ce mois-ci',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<_CaData> _loadData() async {
    final db = AppDatabase.instance;
    final factures = await db.facturesDao.getAll();
    final pertinentes = factures
        .where((f) =>
            ['emise', 'partiellement_payee', 'payee'].contains(f.statut) &&
            f.dateEmission.month == mois &&
            f.dateEmission.year == annee)
        .toList();

    final totalCa =
        pertinentes.fold<double>(0, (s, f) => s + f.montantHt);

    // Ventilation par client
    final caParClient = <String, double>{};
    for (final f in pertinentes) {
      final client =
          await db.clientsDao.getById(f.clientId);
      final nom = client?.nom ?? 'Client inconnu';
      caParClient[nom] = (caParClient[nom] ?? 0) + f.montantHt;
    }

    return _CaData(
      totalCa: totalCa,
      nbFactures: pertinentes.length,
      caParClient: caParClient,
    );
  }
}

class _CaData {
  final double totalCa;
  final int nbFactures;
  final Map<String, double> caParClient;
  const _CaData({
    required this.totalCa,
    required this.nbFactures,
    required this.caParClient,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// Écran de gestion des catégories de charges (Lot 3)
// ═══════════════════════════════════════════════════════════════════════════

class _CategoriesChargesScreen extends StatefulWidget {
  const _CategoriesChargesScreen();

  @override
  State<_CategoriesChargesScreen> createState() =>
      _CategoriesChargesScreenState();
}

class _CategoriesChargesScreenState extends State<_CategoriesChargesScreen> {
  List<String> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await ParametresService.getChargeCategories();
    if (mounted) setState(() { _categories = cats; _loading = false; });
  }

  Future<void> _save() async {
    await ParametresService.saveChargeCategories(_categories);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Catégories enregistrées'),
            backgroundColor: AppColors.success),
      );
    }
  }

  Future<void> _addCategory() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouvelle catégorie'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration:
              const InputDecoration(hintText: 'Ex : Carburant'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) Navigator.pop(context, true);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      setState(() => _categories.add(ctrl.text.trim()));
      await _save();
    }
    ctrl.dispose();
  }

  Future<void> _editCategory(int index) async {
    final ctrl = TextEditingController(text: _categories[index]);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier la catégorie'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) Navigator.pop(context, true);
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      setState(() => _categories[index] = ctrl.text.trim());
      await _save();
    }
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catégories de charges')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _categories.removeAt(oldIndex);
                  _categories.insert(newIndex, item);
                });
                _save();
              },
              itemBuilder: (_, index) {
                return ListTile(
                  key: ValueKey('cat_$index'),
                  leading: const Icon(Icons.drag_handle),
                  title: Text(_categories[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _editCategory(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 18, color: Colors.grey),
                        onPressed: () {
                          setState(() => _categories.removeAt(index));
                          _save();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Widgets communs (inchangés ou légèrement adaptés)
// ═══════════════════════════════════════════════════════════════════════════

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ExportOption({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context, value),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.navy),
          const SizedBox(width: 12),
          Text(label),
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
      {required this.mois,
      required this.annee,
      required this.onPrev,
      required this.onNext});

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
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
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
        Expanded(
            child:
                _SummaryCard('Chiffre d\'affaires', ca, AppColors.teal)),
        const SizedBox(width: 8),
        Expanded(
            child: _SummaryCard('Charges', charges, AppColors.danger)),
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
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: entries.asMap().entries.map((e) {
                    final idx = e.key;
                    final cat = e.value;
                    final pct =
                        total > 0 ? (cat.value / total * 100) : 0.0;
                    return PieChartSectionData(
                      value: cat.value,
                      color: _chartColors[idx % _chartColors.length],
                      title: '${pct.toStringAsFixed(0)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                final color =
                    _chartColors[e.key % _chartColors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, color: color),
                    const SizedBox(width: 4),
                    Text(e.value.key,
                        style: const TextStyle(fontSize: 11)),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
          ),
          ...charges.map((c) => ListTile(
                dense: true,
                title: Text(c.libelle),
                subtitle: Text(
                    '${c.categorie} · ${DateFormat('dd/MM').format(c.dateCharge)}'
                    '${c.recurrence != 'unique' ? ' · ${c.recurrence}' : ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(FormatUtils.formatFcfa(c.montant),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.grey),
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
        child: Text('Aucune charge ce mois-ci',
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    fontSize: 13,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.navy),
          ],
        ),
      ),
    );
  }
}
