import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/personnel_repository.dart';
import '../providers/personnel_provider.dart';

// ─── Statut helpers ────────────────────────────────────────────────────────────

/// Compute display statut from stored statut + dates.
/// Stored: programme | valide | refuse | demande (legacy) | approuve (legacy)
/// Display: programme | valide | en_cours | consomme | refuse
String computeStatut(Conge c) {
  final today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final s = c.statut;

  // Legacy mapping
  if (s == 'demande') return 'programme';
  if (s == 'approuve') {
    return _statutFromDates(c, today);
  }
  if (s == 'valide') return _statutFromDates(c, today);
  return s; // programme | refuse
}

String _statutFromDates(Conge c, DateTime today) {
  final debut =
      DateTime(c.dateDebut.year, c.dateDebut.month, c.dateDebut.day);
  final fin = DateTime(c.dateFin.year, c.dateFin.month, c.dateFin.day);
  if (today.isBefore(debut)) return 'valide';
  if (today.isAfter(fin)) return 'consomme';
  return 'en_cours';
}

const _statutLabels = {
  'programme': 'Programmé',
  'valide': 'Validé',
  'en_cours': 'En cours',
  'consomme': 'Consommé',
  'refuse': 'Refusé',
};

const _statutColors = {
  'programme': Color(0xFFF0A500),   // or orange
  'valide': Color(0xFF1A8A9A),      // teal
  'en_cours': Color(0xFF43A047),    // vert
  'consomme': Color(0xFF78909C),    // gris bleu
  'refuse': Color(0xFFE53935),      // rouge
};

Color statutColor(String s) => _statutColors[s] ?? Colors.grey;
String statutLabel(String s) => _statutLabels[s] ?? s;

// ─── Types de congé ────────────────────────────────────────────────────────────
const _types = [
  'conge_annuel', 'maladie', 'maternite', 'paternite', 'sans_solde', 'autre',
];
const _typeLabels = {
  'conge_annuel': 'Congé annuel',
  'maladie': 'Maladie',
  'maternite': 'Maternité',
  'paternite': 'Paternité',
  'sans_solde': 'Sans solde',
  'autre': 'Autre',
};

// ─── Onglets ───────────────────────────────────────────────────────────────────
const _tabs = [
  (icon: Icons.calendar_month, label: 'Calendrier'),
  (icon: Icons.schedule, label: 'Programmés'),
  (icon: Icons.check_circle_outline, label: 'Validés'),
  (icon: Icons.play_circle_outline, label: 'En cours'),
  (icon: Icons.task_alt, label: 'Consommés'),
  (icon: Icons.cancel_outlined, label: 'Refusés'),
];

// ─── Écran principal ───────────────────────────────────────────────────────────

class CongesScreen extends ConsumerStatefulWidget {
  const CongesScreen({super.key});

  @override
  ConsumerState<CongesScreen> createState() => _CongesScreenState();
}

class _CongesScreenState extends ConsumerState<CongesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late DateTime _moisCourant;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 6, vsync: this);
    final now = DateTime.now();
    _moisCourant = DateTime(now.year, now.month);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _prevMois() => setState(() {
        _moisCourant = DateTime(_moisCourant.year, _moisCourant.month - 1);
      });

  void _nextMois() => setState(() {
        _moisCourant = DateTime(_moisCourant.year, _moisCourant.month + 1);
      });

  void _ouvrirFormulaireConge({DateTime? dateInitiale}) async {
    final personnelAsync = ref.read(allPersonnelProvider);
    final personnel = personnelAsync.valueOrNull ?? [];
    if (personnel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun employé — ajoutez du personnel d\'abord')),
      );
      return;
    }
    await showDialog(
      context: context,
      builder: (_) => _CongeFormDialog(
        personnel: personnel,
        dateInitiale: dateInitiale,
      ),
    );
    ref.invalidate(congesAllProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congés'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _tabs.map((t) => Tab(icon: Icon(t.icon, size: 18), text: t.label)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nouveau congé'),
        onPressed: () => _ouvrirFormulaireConge(),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // ── Calendrier ──
          _CalendrierTab(
            mois: _moisCourant,
            onPrev: _prevMois,
            onNext: _nextMois,
            onJourTap: (date) => _ouvrirJour(date),
            onNouveauConge: (date) => _ouvrirFormulaireConge(dateInitiale: date),
          ),
          // ── Listes par statut ──
          const _ListeStatutTab(statut: 'programme'),
          const _ListeStatutTab(statut: 'valide'),
          const _ListeStatutTab(statut: 'en_cours'),
          const _ListeStatutTab(statut: 'consomme'),
          const _ListeStatutTab(statut: 'refuse'),
        ],
      ),
    );
  }

  Future<void> _ouvrirJour(DateTime date) async {
    // Charger les congés du jour
    final from = DateTime(date.year, date.month, date.day);
    final to = from;
    final conges = await ref
        .read(personnelRepositoryProvider)
        .getCongesForRange(from, to);

    if (!mounted) return;

    if (conges.isEmpty) {
      _ouvrirFormulaireConge(dateInitiale: date);
      return;
    }

    // Enrichir avec les données personnel
    final allPersonnel = ref.read(allPersonnelProvider).valueOrNull ?? [];
    final enrichis = conges.map((c) {
      final p = allPersonnel.firstWhere(
        (p) => p.id == c.personnelId,
        orElse: () => _personnelInconnu(c.personnelId),
      );
      return _CongeRiche(conge: c, personne: p);
    }).toList();

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JourSheet(
        date: date,
        conges: enrichis,
        onAjouter: () {
          Navigator.pop(context);
          _ouvrirFormulaireConge(dateInitiale: date);
        },
        onAction: (congeId, action) async {
          Navigator.pop(context);
          await _executerAction(congeId, action);
        },
      ),
    );
  }

  Future<void> _executerAction(String congeId, String action) async {
    final notifier = ref.read(personnelNotifierProvider.notifier);
    switch (action) {
      case 'valider':
        await notifier.validerConge(congeId, validePar: 'Gestionnaire');
      case 'refuser':
        await notifier.refuserConge(congeId);
      case 'supprimer':
        await notifier.deleteConge(congeId);
    }
    ref.invalidate(congesAllProvider);
  }
}

PersonnelData _personnelInconnu(String id) => PersonnelData(
      id: id,
      entrepriseId: '',
      nom: 'Inconnu',
      prenom: null,
      poste: null,
      departement: null,
      typeContrat: 'CDI',
      dateEmbauche: null,
      dateFinContrat: null,
      salaireBase: null,
      actif: true,
      syncStatus: 'synced',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

// ─── Calendrier ────────────────────────────────────────────────────────────────

class _CalendrierTab extends ConsumerWidget {
  final DateTime mois;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onJourTap;
  final ValueChanged<DateTime> onNouveauConge;

  const _CalendrierTab({
    required this.mois,
    required this.onPrev,
    required this.onNext,
    required this.onJourTap,
    required this.onNouveauConge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debut = DateTime(mois.year, mois.month, 1);
    final fin = DateTime(mois.year, mois.month + 1, 0, 23, 59, 59);

    return FutureBuilder<List<Conge>>(
      future: ref.read(personnelRepositoryProvider).getCongesForRange(debut, fin),
      builder: (context, snap) {
        final conges = snap.data ?? [];
        return Column(
          children: [
            _EnteteCalendrier(mois: mois, onPrev: onPrev, onNext: onNext),
            _JoursEntete(),
            Expanded(
              child: _GrilleCalendrier(
                mois: mois,
                conges: conges,
                onJourTap: onJourTap,
              ),
            ),
            _LegendeCouleurs(),
          ],
        );
      },
    );
  }
}

class _EnteteCalendrier extends StatelessWidget {
  final DateTime mois;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _EnteteCalendrier({required this.mois, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy', 'fr_FR').format(mois);
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
            label[0].toUpperCase() + label.substring(1),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

class _JoursEntete extends StatelessWidget {
  static const _jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy.withAlpha(15),
      child: Row(
        children: _jours
            .map((j) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    child: Text(j,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy.withAlpha(180))),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _GrilleCalendrier extends StatelessWidget {
  final DateTime mois;
  final List<Conge> conges;
  final ValueChanged<DateTime> onJourTap;

  const _GrilleCalendrier({
    required this.mois,
    required this.conges,
    required this.onJourTap,
  });

  @override
  Widget build(BuildContext context) {
    final premier = DateTime(mois.year, mois.month, 1);
    // ISO weekday: Lundi=1, Dimanche=7 → offset 0-6
    final offset = premier.weekday - 1;
    final nbJours = DateTime(mois.year, mois.month + 1, 0).day;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Construire la grille: semaines × 7 jours
    final totalCases = offset + nbJours;
    final nbSemaines = (totalCases / 7).ceil();

    return SingleChildScrollView(
      child: Column(
        children: List.generate(nbSemaines, (semaine) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(7, (col) {
                final idx = semaine * 7 + col;
                final jour = idx - offset + 1;
                if (jour < 1 || jour > nbJours) {
                  return const Expanded(child: SizedBox());
                }
                final date = DateTime(mois.year, mois.month, jour);
                final isToday = date.isAtSameMomentAs(todayDate);
                final congesJour = conges.where((c) {
                  final d =
                      DateTime(c.dateDebut.year, c.dateDebut.month, c.dateDebut.day);
                  final f =
                      DateTime(c.dateFin.year, c.dateFin.month, c.dateFin.day);
                  return !date.isBefore(d) && !date.isAfter(f);
                }).toList();
                final isWeekend = col >= 5;

                return Expanded(
                  child: _CelluleJour(
                    jour: jour,
                    date: date,
                    isToday: isToday,
                    isWeekend: isWeekend,
                    conges: congesJour,
                    onTap: () => onJourTap(date),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _CelluleJour extends StatelessWidget {
  final int jour;
  final DateTime date;
  final bool isToday;
  final bool isWeekend;
  final List<Conge> conges;
  final VoidCallback onTap;

  const _CelluleJour({
    required this.jour,
    required this.date,
    required this.isToday,
    required this.isWeekend,
    required this.conges,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Couleur de fond de la cellule
    Color? bg;
    if (isToday) bg = AppColors.teal.withAlpha(20);
    if (isWeekend) bg = Colors.grey.shade100;
    if (isToday && isWeekend) bg = AppColors.teal.withAlpha(15);

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            right: BorderSide(color: Colors.grey.shade200),
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Numéro du jour
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
              child: isToday
                  ? Center(
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text('$jour',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    )
                  : Text('$jour',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isWeekend ? Colors.grey : null)),
            ),
            // Indicateurs de congés
            ...conges.take(3).map((c) {
              final s = computeStatut(c);
              final color = statutColor(s);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
            if (conges.length > 3)
              Center(
                child: Text('+${conges.length - 3}',
                    style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendeCouleurs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: _statutColors.entries.map((e) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: e.value, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Text(statutLabel(e.key), style: const TextStyle(fontSize: 11)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Liste filtrée par statut ──────────────────────────────────────────────────

class _ListeStatutTab extends ConsumerWidget {
  final String statut;
  const _ListeStatutTab({required this.statut});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(congesAllProvider);

    return allAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (all) {
        final filtered =
            all.where((c) => computeStatut(c) == statut).toList()
              ..sort((a, b) => a.dateDebut.compareTo(b.dateDebut));
        if (filtered.isEmpty) {
          return _EmptyStatut(statut: statut);
        }
        final allPersonnel = ref.watch(allPersonnelProvider).valueOrNull ?? [];
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final c = filtered[i];
            final p = allPersonnel.firstWhere(
              (p) => p.id == c.personnelId,
              orElse: () => _personnelInconnu(c.personnelId),
            );
            return _CongeCard(
              conge: c,
              personne: p,
              statut: statut,
              onValider: statut == 'programme'
                  ? () => ref
                      .read(personnelNotifierProvider.notifier)
                      .validerConge(c.id)
                  : null,
              onRefuser: (statut == 'programme' || statut == 'valide')
                  ? () => ref
                      .read(personnelNotifierProvider.notifier)
                      .refuserConge(c.id)
                  : null,
              onSupprimer: () => ref
                  .read(personnelNotifierProvider.notifier)
                  .deleteConge(c.id),
            );
          },
        );
      },
    );
  }
}

// ─── Carte congé ───────────────────────────────────────────────────────────────

class _CongeRiche {
  final Conge conge;
  final PersonnelData personne;
  const _CongeRiche({required this.conge, required this.personne});
}

class _CongeCard extends StatelessWidget {
  final Conge conge;
  final PersonnelData personne;
  final String statut;
  final VoidCallback? onValider;
  final VoidCallback? onRefuser;
  final VoidCallback onSupprimer;

  const _CongeCard({
    required this.conge,
    required this.personne,
    required this.statut,
    required this.onValider,
    required this.onRefuser,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    final nomComplet =
        [personne.prenom, personne.nom].whereType<String>().join(' ');
    final duree =
        conge.dateFin.difference(conge.dateDebut).inDays + 1;
    final color = statutColor(statut);
    final typeLabel =
        _typeLabels[conge.type] ?? conge.type;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.teal.withAlpha(30),
                  child: Text(
                    personne.nom.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.teal),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nomComplet,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(typeLabel,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                _StatutBadge(statut: statut),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${fmt.format(conge.dateDebut)} → ${fmt.format(conge.dateFin)}',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$duree j',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
            if (conge.motif != null && conge.motif!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(conge.motif!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
            if (onValider != null || onRefuser != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onRefuser != null)
                    TextButton.icon(
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Refuser'),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)),
                      onPressed: onRefuser,
                    ),
                  if (onValider != null) ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Valider'),
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6)),
                      onPressed: onValider,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    final color = statutColor(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        statutLabel(statut),
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── Feuille de bas de page — détail d'un jour ────────────────────────────────

class _JourSheet extends StatelessWidget {
  final DateTime date;
  final List<_CongeRiche> conges;
  final VoidCallback onAjouter;
  final void Function(String congeId, String action) onAction;

  const _JourSheet({
    required this.date,
    required this.conges,
    required this.onAjouter,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    final label = fmt.format(date);
    final titre = label[0].toUpperCase() + label.substring(1);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Poignée
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // En-tête
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(titre,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.navy)),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Ajouter'),
                    onPressed: onAjouter,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Liste des congés du jour
            Expanded(
              child: ListView.separated(
                controller: ctrl,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: conges.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final item = conges[i];
                  final s = computeStatut(item.conge);
                  final nomComplet = [item.personne.prenom, item.personne.nom]
                      .whereType<String>()
                      .join(' ');
                  final duree =
                      item.conge.dateFin.difference(item.conge.dateDebut).inDays + 1;
                  final color = statutColor(s);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withAlpha(30),
                        child: Text(
                          item.personne.nom.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(nomComplet,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${_typeLabels[item.conge.type] ?? item.conge.type} · $duree j',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StatutBadge(statut: s),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 18),
                            itemBuilder: (_) => [
                              if (s == 'programme')
                                const PopupMenuItem(
                                    value: 'valider', child: Text('Valider')),
                              if (s == 'programme' || s == 'valide')
                                const PopupMenuItem(
                                    value: 'refuser', child: Text('Refuser')),
                              const PopupMenuItem(
                                  value: 'supprimer',
                                  child: Text('Supprimer',
                                      style: TextStyle(color: Colors.red))),
                            ],
                            onSelected: (action) =>
                                onAction(item.conge.id, action),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Formulaire de création d'un congé ────────────────────────────────────────

class _CongeFormDialog extends ConsumerStatefulWidget {
  final List<PersonnelData> personnel;
  final DateTime? dateInitiale;
  const _CongeFormDialog({required this.personnel, this.dateInitiale});

  @override
  ConsumerState<_CongeFormDialog> createState() => _CongeFormDialogState();
}

class _CongeFormDialogState extends ConsumerState<_CongeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _motif;
  PersonnelData? _employe;
  DateTime? _debut;
  DateTime? _fin;
  String _type = 'conge_annuel';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _motif = TextEditingController();
    _debut = widget.dateInitiale;
    _fin = widget.dateInitiale;
    if (widget.personnel.isNotEmpty) _employe = widget.personnel.first;
  }

  @override
  void dispose() {
    _motif.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDebut}) async {
    final init = isDebut ? (_debut ?? DateTime.now()) : (_fin ?? _debut ?? DateTime.now());
    final first = isDebut ? DateTime(2020) : (_debut ?? DateTime(2020));
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: first,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDebut) {
          _debut = picked;
          if (_fin != null && _fin!.isBefore(picked)) _fin = picked;
        } else {
          _fin = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_employe == null) return;
    if (_debut == null || _fin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez les dates')),
      );
      return;
    }

    setState(() => _loading = true);
    await ref.read(personnelNotifierProvider.notifier).addConge(
          personnelId: _employe!.id,
          dateDebut: _debut!,
          dateFin: _fin!,
          type: _type,
          motif: _motif.text.trim().isEmpty ? null : _motif.text.trim(),
        );

    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    final duree = _debut != null && _fin != null
        ? _fin!.difference(_debut!).inDays + 1
        : 0;

    return AlertDialog(
      title: const Text('Programmer un congé'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sélection employé
              DropdownButtonFormField<PersonnelData>(
                initialValue: _employe,
                decoration: const InputDecoration(
                    labelText: 'Employé *', isDense: true),
                items: widget.personnel.map((p) {
                  final nom = [p.prenom, p.nom]
                      .whereType<String>()
                      .join(' ');
                  return DropdownMenuItem(value: p, child: Text(nom));
                }).toList(),
                onChanged: (v) => setState(() => _employe = v),
                validator: (v) => v == null ? 'Requis' : null,
              ),
              const SizedBox(height: 12),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isDebut: true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: 'Début *', isDense: true),
                        child: Text(
                          _debut != null ? fmt.format(_debut!) : '—',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isDebut: false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: 'Fin *', isDense: true),
                        child: Text(
                          _fin != null ? fmt.format(_fin!) : '—',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (duree > 0) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$duree jour${duree > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 12, color: AppColors.teal),
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Type
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                    labelText: 'Type de congé', isDense: true),
                items: _types
                    .map((t) => DropdownMenuItem(
                        value: t, child: Text(_typeLabels[t] ?? t)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 12),

              // Motif
              TextFormField(
                controller: _motif,
                decoration: const InputDecoration(
                    labelText: 'Motif (optionnel)', isDense: true),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Programmer'),
        ),
      ],
    );
  }
}

// ─── État vide ─────────────────────────────────────────────────────────────────

class _EmptyStatut extends StatelessWidget {
  final String statut;
  const _EmptyStatut({required this.statut});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Aucun congé "${statutLabel(statut)}"',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
