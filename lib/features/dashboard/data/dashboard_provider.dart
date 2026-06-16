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

  // Phase 4 — nouvelles données
  final List<double> ca6Mois;
  final List<double> charges6Mois;
  final List<String> labels6Mois;
  final double tauxRecouvrement;
  final double masseSalarialeMois;

  const DashboardStats({
    required this.dossierCounts,
    required this.caMois,
    required this.totalCreances,
    required this.chargesMois,
    required this.dossiersUrgents,
    required this.facturesEnRetard,
    required this.pendingSyncCount,
    required this.ca6Mois,
    required this.charges6Mois,
    required this.labels6Mois,
    required this.tauxRecouvrement,
    required this.masseSalarialeMois,
  });

  int get totalDossiers => dossierCounts.values.fold(0, (a, b) => a + b);
  int get dossiersEnCours =>
      (dossierCounts['brouillon'] ?? 0) +
      (dossierCounts['en_instruction'] ?? 0) +
      (dossierCounts['en_cours'] ?? 0);
  int get dossiersNouveaux => dossierCounts['brouillon'] ?? 0;
  int get dossiersClos => dossierCounts['termine'] ?? 0;
  double get resultatMois => caMois - chargesMois;
}

const _moisCourts = [
  '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
  'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
];

final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final db = AppDatabase.instance;
  final now = DateTime.now();

  // Données de base en parallèle
  final results = await Future.wait([
    db.dossiersDao.getStatsCounts(),
    db.facturesDao.getCaParMois(now.month, now.year),
    db.facturesDao.getTotalCreances(),
    db.chargesDao.getTotalParMois(now.month, now.year),
    db.dossiersDao.getUrgents(),
    db.facturesDao.getEnRetard(),
    db.syncQueueDao.getPendingCount(),
    db.facturesDao.getTauxRecouvrement(),
    db.salairesDao.getMasseSalariale(now.month, now.year),
  ]);

  // 6 mois glissants CA + charges
  final ca6 = <double>[];
  final charges6 = <double>[];
  final labels6 = <String>[];

  for (int i = 5; i >= 0; i--) {
    int m = now.month - i;
    int y = now.year;
    while (m <= 0) { m += 12; y--; }
    ca6.add(await db.facturesDao.getCaParMois(m, y));
    charges6.add(await db.chargesDao.getTotalParMois(m, y));
    labels6.add(_moisCourts[m]);
  }

  return DashboardStats(
    dossierCounts: results[0] as Map<String, int>,
    caMois: results[1] as double,
    totalCreances: results[2] as double,
    chargesMois: results[3] as double,
    dossiersUrgents: results[4] as List<Dossier>,
    facturesEnRetard: results[5] as List<Facture>,
    pendingSyncCount: results[6] as int,
    tauxRecouvrement: results[7] as double,
    masseSalarialeMois: results[8] as double,
    ca6Mois: ca6,
    charges6Mois: charges6,
    labels6Mois: labels6,
  );
});
