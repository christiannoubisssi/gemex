import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';

class DashboardStats {
  final Map<String, int> dossierCounts;
  final double caMois;
  final double totalCreances;
  final double chargesMois;
  final List<Dossier> dossiersUrgents;
  final List<Facture> facturesEnRetard;
  final int pendingSyncCount;

  const DashboardStats({
    required this.dossierCounts,
    required this.caMois,
    required this.totalCreances,
    required this.chargesMois,
    required this.dossiersUrgents,
    required this.facturesEnRetard,
    required this.pendingSyncCount,
  });

  int get totalDossiers => dossierCounts.values.fold(0, (a, b) => a + b);
  int get dossiersEnCours =>
      (dossierCounts['nouveau'] ?? 0) +
      (dossierCounts['en_instruction'] ?? 0) +
      (dossierCounts['expertise_en_cours'] ?? 0) +
      (dossierCounts['rapport_redige'] ?? 0);
  int get dossiersNouveaux => dossierCounts['nouveau'] ?? 0;
  int get dossiersClos => dossierCounts['clos'] ?? 0;
}

final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final db = AppDatabase.instance;
  final now = DateTime.now();

  final results = await Future.wait([
    db.dossiersDao.getStatsCounts(),
    db.facturesDao.getCaParMois(now.month, now.year),
    db.facturesDao.getTotalCreances(),
    db.chargesDao.getTotalParMois(now.month, now.year),
    db.dossiersDao.getUrgents(),
    db.facturesDao.getEnRetard(),
    db.syncQueueDao.getPendingCount(),
  ]);

  return DashboardStats(
    dossierCounts: results[0] as Map<String, int>,
    caMois: results[1] as double,
    totalCreances: results[2] as double,
    chargesMois: results[3] as double,
    dossiersUrgents: results[4] as List<Dossier>,
    facturesEnRetard: results[5] as List<Facture>,
    pendingSyncCount: results[6] as int,
  );
});
