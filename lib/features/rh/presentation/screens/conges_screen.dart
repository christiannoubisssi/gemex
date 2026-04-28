import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/personnel_repository.dart';
import '../providers/personnel_provider.dart';

class CongesScreen extends ConsumerStatefulWidget {
  const CongesScreen({super.key});

  @override
  ConsumerState<CongesScreen> createState() => _CongesScreenState();
}

class _CongesScreenState extends ConsumerState<CongesScreen> {
  late int _mois;
  late int _annee;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
  }

  static const _moisLabels = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  void _prevMois() => setState(() {
        if (_mois == 1) { _mois = 12; _annee--; } else { _mois--; }
      });

  void _nextMois() => setState(() {
        if (_mois == 12) { _mois = 1; _annee++; } else { _mois++; }
      });

  @override
  Widget build(BuildContext context) {
    final allPersonnelAsync = ref.watch(allPersonnelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Congés')),
      body: Column(
        children: [
          // Sélecteur de mois
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

          Expanded(
            child: allPersonnelAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (personnel) => _CongesListeMois(
                personnel: personnel,
                mois: _mois,
                annee: _annee,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CongesListeMois extends ConsumerWidget {
  final List<PersonnelData> personnel;
  final int mois;
  final int annee;
  const _CongesListeMois(
      {required this.personnel, required this.mois, required this.annee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<_CongeAvecPersonnel>>(
      future: _charger(ref),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return const Center(
            child: Text('Aucun congé ce mois', style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _CongeRow(item: items[i]),
        );
      },
    );
  }

  Future<List<_CongeAvecPersonnel>> _charger(WidgetRef ref) async {
    final result = <_CongeAvecPersonnel>[];
    for (final p in personnel) {
      final conges = await ref.read(personnelRepositoryProvider).getCongesByPersonnel(p.id);
      for (final c in conges) {
        if (_estDansMois(c, mois, annee)) {
          result.add(_CongeAvecPersonnel(personne: p, conge: c));
        }
      }
    }
    result.sort((a, b) => a.conge.dateDebut.compareTo(b.conge.dateDebut));
    return result;
  }

  bool _estDansMois(Conge c, int mois, int annee) {
    final debut = DateTime(annee, mois, 1);
    final fin = DateTime(annee, mois + 1, 1);
    return c.dateDebut.isBefore(fin) && c.dateFin.isAfter(debut);
  }
}

class _CongeAvecPersonnel {
  final PersonnelData personne;
  final Conge conge;
  const _CongeAvecPersonnel({required this.personne, required this.conge});
}

class _CongeRow extends StatelessWidget {
  final _CongeAvecPersonnel item;
  const _CongeRow({required this.item});

  Color get _color {
    switch (item.conge.statut) {
      case 'approuve': return Colors.green;
      case 'refuse': return AppColors.danger;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM');
    final nomComplet =
        [item.personne.prenom, item.personne.nom].whereType<String>().join(' ');
    final duree = item.conge.dateFin.difference(item.conge.dateDebut).inDays + 1;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.teal,
        child: Text(
          item.personne.nom.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(nomComplet),
      subtitle: Text(
        '${fmt.format(item.conge.dateDebut)} → ${fmt.format(item.conge.dateFin)} · $duree j',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          item.conge.statut == 'approuve'
              ? 'Approuvé'
              : item.conge.statut == 'refuse'
                  ? 'Refusé'
                  : 'En attente',
          style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
