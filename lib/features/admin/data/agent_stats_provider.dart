import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../parametres/data/user_management_service.dart';

/// Performances consolidées d'un agent sur une période.
class AgentPerf {
  final String agentId;
  final String agentNom;
  final int dossiersOuverts;
  final int dossiersTraites;  // statuts terminé ou clos
  final int dossiersEnCours;
  final double dureeTraitementMoyJours;
  final int actionsTotal;
  final List<Dossier> dossiersList;

  const AgentPerf({
    required this.agentId,
    required this.agentNom,
    required this.dossiersOuverts,
    required this.dossiersTraites,
    required this.dossiersEnCours,
    required this.dureeTraitementMoyJours,
    required this.actionsTotal,
    required this.dossiersList,
  });
}

/// Filtre de période pour les stats agents.
enum PeriodeFiltre {
  tout,
  annee,
  trimestre,
  mois;

  String get label {
    switch (this) {
      case PeriodeFiltre.tout:      return 'Tout';
      case PeriodeFiltre.annee:     return 'Cette année';
      case PeriodeFiltre.trimestre: return 'Ce trimestre';
      case PeriodeFiltre.mois:      return 'Ce mois';
    }
  }
}

DateTime _debutPeriode(PeriodeFiltre p) {
  final now = DateTime.now();
  switch (p) {
    case PeriodeFiltre.tout:
      return DateTime(2000);
    case PeriodeFiltre.annee:
      return DateTime(now.year, 1, 1);
    case PeriodeFiltre.trimestre:
      final trimestre = ((now.month - 1) ~/ 3);
      return DateTime(now.year, trimestre * 3 + 1, 1);
    case PeriodeFiltre.mois:
      return DateTime(now.year, now.month, 1);
  }
}

final agentPerfsProvider = FutureProvider.autoDispose.family<List<AgentPerf>, PeriodeFiltre>(
  (ref, periode) async {
    final db = AppDatabase.instance;
    final debut = _debutPeriode(periode);

    // Tous les dossiers dans la période (filtré en mémoire)
    final allDossiers = await db.dossiersDao.getAll();
    final dossiersPeriode = allDossiers
        .where((d) => d.createdAt.isAfter(debut))
        .toList();

    // Tous les agents connus dans les dossiers (createdByNom non null)
    final agentsConnus = <String, String>{};  // id → nom
    for (final d in dossiersPeriode) {
      if (d.createdById != null && d.createdByNom != null) {
        agentsConnus[d.createdById!] = d.createdByNom!;
      }
    }

    // Compléter avec les utilisateurs enregistrés (agents/experts)
    try {
      final users = await ref.read(userManagementServiceProvider).getAll();
      for (final u in users) {
        if (!agentsConnus.containsKey(u.id)) {
          agentsConnus[u.id] = u.nom ?? u.email;
        }
      }
    } catch (_) {}

    if (agentsConnus.isEmpty) return [];

    // Logs d'audit pour compter les actions par agent
    final logsListRaw = await db.auditLogsDao.getAll();

    final perfs = <AgentPerf>[];
    for (final entry in agentsConnus.entries) {
      final agentId  = entry.key;
      final agentNom = entry.value;

      final dossiers = dossiersPeriode
          .where((d) => d.createdById == agentId || d.createdByNom == agentNom)
          .toList();

      final traites = dossiers
          .where((d) =>
              d.statut == AppConstants.statutTermine ||
              d.statut == AppConstants.statutAnnule)
          .toList();

      final enCours = dossiers
          .where((d) =>
              d.statut != AppConstants.statutTermine &&
              d.statut != AppConstants.statutAnnule)
          .length;

      // Durée moyenne de traitement (date_ouverture → date_cloture)
      double dureesMoy = 0;
      if (traites.isNotEmpty) {
        double total = 0;
        int count = 0;
        for (final d in traites) {
          final fin = d.dateCloture ?? d.updatedAt;
          total += fin.difference(d.dateOuverture).inDays.toDouble();
          count++;
        }
        dureesMoy = count > 0 ? total / count : 0;
      }

      // Actions audit dans la période
      final logsAgent = logsListRaw
          .where((l) =>
              (l.userId == agentId || l.userNom == agentNom) &&
              l.createdAt.isAfter(debut))
          .length;

      perfs.add(AgentPerf(
        agentId: agentId,
        agentNom: agentNom,
        dossiersOuverts:  dossiers.length,
        dossiersTraites:  traites.length,
        dossiersEnCours:  enCours,
        dureeTraitementMoyJours: dureesMoy,
        actionsTotal:     logsAgent,
        dossiersList:     dossiers,
      ));
    }

    // Tri par nombre de dossiers décroissant
    perfs.sort((a, b) => b.dossiersOuverts.compareTo(a.dossiersOuverts));
    return perfs;
  },
);
