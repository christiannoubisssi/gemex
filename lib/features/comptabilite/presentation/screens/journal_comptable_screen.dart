import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';

// ignore: constant_identifier_names
const _moisLabels = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

/// Écriture comptable simplifiée
class _Ecriture {
  final DateTime date;
  final String libelle;
  final double debit;
  final double credit;
  final String type; // 'facture_emise', 'paiement_recu', 'charge'

  const _Ecriture({
    required this.date,
    required this.libelle,
    required this.debit,
    required this.credit,
    required this.type,
  });
}

class JournalComptableScreen extends ConsumerStatefulWidget {
  const JournalComptableScreen({super.key});

  @override
  ConsumerState<JournalComptableScreen> createState() =>
      _JournalComptableScreenState();
}

class _JournalComptableScreenState
    extends ConsumerState<JournalComptableScreen> {
  late int _mois;
  late int _annee;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mois = now.month;
    _annee = now.year;
  }

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

  Future<List<_Ecriture>> _loadEcritures() async {
    final db = AppDatabase.instance;
    final ecritures = <_Ecriture>[];

    // 1. Factures émises → Débit Clients / Crédit Ventes
    final factures = await db.facturesDao.getAll();
    for (final f in factures) {
      if (f.dateEmission.month == _mois && f.dateEmission.year == _annee) {
        if (['emise', 'partiellement_payee', 'payee'].contains(f.statut)) {
          ecritures.add(_Ecriture(
            date: f.dateEmission,
            libelle: 'Facture ${f.numero ?? f.id.substring(0, 8)} — Émission',
            debit: f.montantTtc,
            credit: 0,
            type: 'facture_emise',
          ));
          ecritures.add(_Ecriture(
            date: f.dateEmission,
            libelle: 'Facture ${f.numero ?? f.id.substring(0, 8)} — Ventes',
            debit: 0,
            credit: f.montantTtc,
            type: 'facture_emise',
          ));
        }

        // 2. Paiements reçus → Débit Banque / Crédit Clients
        if (f.montantPaye > 0 && f.datePaiement != null) {
          if (f.datePaiement!.month == _mois &&
              f.datePaiement!.year == _annee) {
            ecritures.add(_Ecriture(
              date: f.datePaiement!,
              libelle:
                  'Paiement ${f.numero ?? f.id.substring(0, 8)} — Banque',
              debit: f.montantPaye,
              credit: 0,
              type: 'paiement_recu',
            ));
            ecritures.add(_Ecriture(
              date: f.datePaiement!,
              libelle:
                  'Paiement ${f.numero ?? f.id.substring(0, 8)} — Clients',
              debit: 0,
              credit: f.montantPaye,
              type: 'paiement_recu',
            ));
          }
        }
      }
    }

    // 3. Charges payées → Débit Charges / Crédit Banque
    final charges = await db.chargesDao.getAll(mois: _mois, annee: _annee);
    for (final c in charges) {
      ecritures.add(_Ecriture(
        date: c.dateCharge,
        libelle: '${c.categorie} — ${c.libelle}',
        debit: c.montant,
        credit: 0,
        type: 'charge',
      ));
      ecritures.add(_Ecriture(
        date: c.dateCharge,
        libelle: '${c.categorie} — ${c.libelle} (Banque)',
        debit: 0,
        credit: c.montant,
        type: 'charge',
      ));
    }

    // Tri chronologique
    ecritures.sort((a, b) => a.date.compareTo(b.date));
    return ecritures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal comptable')),
      body: Column(
        children: [
          // Sélecteur période
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _prevMois,
                ),
                Text(
                  '${_moisLabels[_mois]} $_annee',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,
                      color: Colors.white),
                  onPressed: _nextMois,
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<_Ecriture>>(
              future: _loadEcritures(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final ecritures = snap.data!;
                if (ecritures.isEmpty) {
                  return const Center(
                    child: Text('Aucun mouvement ce mois-ci',
                        style: TextStyle(color: Colors.grey)),
                  );
                }

                final totalDebit =
                    ecritures.fold<double>(0, (s, e) => s + e.debit);
                final totalCredit =
                    ecritures.fold<double>(0, (s, e) => s + e.credit);

                return Column(
                  children: [
                    // En-tête totaux
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.grey.shade100,
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 3,
                              child: Text('Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                            flex: 2,
                            child: Text(
                              FormatUtils.formatFcfa(totalDebit),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.danger),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              FormatUtils.formatFcfa(totalCredit),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // En-tête colonnes
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      color: AppColors.navy.withAlpha(20),
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text('Date / Libellé',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text('Débit',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text('Crédit',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12))),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemCount: ecritures.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, index) {
                          final e = ecritures[index];
                          return _EcritureTile(ecriture: e);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EcritureTile extends StatelessWidget {
  final _Ecriture ecriture;
  const _EcritureTile({required this.ecriture});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM').format(ecriture.date),
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  ecriture.libelle,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ecriture.debit > 0
                  ? FormatUtils.formatFcfa(ecriture.debit)
                  : '',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.danger),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ecriture.credit > 0
                  ? FormatUtils.formatFcfa(ecriture.credit)
                  : '',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teal),
            ),
          ),
        ],
      ),
    );
  }
}
