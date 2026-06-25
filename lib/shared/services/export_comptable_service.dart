import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/app_database.dart';

/// Service d'export CSV pour la comptabilité.
/// Chaque méthode retourne le chemin du fichier CSV généré.
class ExportComptableService {
  static final _dateFmt = DateFormat('dd/MM/yyyy');

  static Future<String> _writeCsv(String filename, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    return file.path;
  }

  /// Export des charges d'un mois donné
  static Future<String> exportCharges(int mois, int annee) async {
    final charges =
        await AppDatabase.instance.chargesDao.getAll(mois: mois, annee: annee);
    final buf = StringBuffer();
    buf.writeln('Date,Catégorie,Libellé,Montant,Récurrence,Notes');
    for (final c in charges) {
      final date = _dateFmt.format(c.dateCharge);
      final libelle = _esc(c.libelle);
      final notes = _esc(c.notes ?? '');
      buf.writeln(
          '$date,${_esc(c.categorie)},$libelle,${c.montant.toStringAsFixed(0)},${c.recurrence},$notes');
    }
    return _writeCsv(
        'charges_${annee}_${mois.toString().padLeft(2, '0')}.csv',
        buf.toString());
  }

  /// Export des ventes (factures émises/payées) d'un mois donné
  static Future<String> exportVentes(int mois, int annee) async {
    final db = AppDatabase.instance;
    final factures = await db.facturesDao.getAll();
    final pertinentes = factures.where((f) =>
        ['emise', 'partiellement_payee', 'payee'].contains(f.statut) &&
        f.dateEmission.month == mois &&
        f.dateEmission.year == annee);

    final buf = StringBuffer();
    buf.writeln(
        'Numéro,Date émission,Client ID,Montant HT,TVA,Montant TTC,Statut');
    for (final f in pertinentes) {
      buf.writeln(
          '${_esc(f.numero ?? '')},${_dateFmt.format(f.dateEmission)},${f.clientId},${f.montantHt.toStringAsFixed(0)},${f.montantTva.toStringAsFixed(0)},${f.montantTtc.toStringAsFixed(0)},${f.statut}');
    }
    return _writeCsv(
        'ventes_${annee}_${mois.toString().padLeft(2, '0')}.csv',
        buf.toString());
  }

  /// Export de la liste des clients
  static Future<String> exportClients() async {
    final clients = await AppDatabase.instance.clientsDao.getAll();
    final buf = StringBuffer();
    buf.writeln('Nom,Type,Email,Téléphone,Ville,Pays');
    for (final c in clients) {
      buf.writeln(
          '${_esc(c.nom)},${c.typeClient},${_esc(c.email ?? '')},${_esc(c.telephone ?? '')},${_esc(c.ville ?? '')},${_esc(c.pays)}');
    }
    return _writeCsv('clients.csv', buf.toString());
  }

  /// Export récapitulatif TVA annuel
  static Future<String> exportTva(int annee) async {
    final db = AppDatabase.instance;
    final buf = StringBuffer();
    buf.writeln('Mois,CA HT,TVA collectée,TPS collectée,Total TTC');

    for (int mois = 1; mois <= 12; mois++) {
      final factures = await db.facturesDao.getAll();
      final duMois = factures.where((f) =>
          ['emise', 'partiellement_payee', 'payee'].contains(f.statut) &&
          f.dateEmission.month == mois &&
          f.dateEmission.year == annee);
      final ht = duMois.fold<double>(0, (s, f) => s + f.montantHt);
      final tva = duMois.fold<double>(0, (s, f) => s + f.montantTva);
      final tps = duMois.fold<double>(0, (s, f) => s + f.montantTps);
      final ttc = duMois.fold<double>(0, (s, f) => s + f.montantTtc);
      buf.writeln(
          '$mois,${ht.toStringAsFixed(0)},${tva.toStringAsFixed(0)},${tps.toStringAsFixed(0)},${ttc.toStringAsFixed(0)}');
    }
    return _writeCsv('tva_$annee.csv', buf.toString());
  }

  /// Export des salaires d'un mois donné
  static Future<String> exportSalaires(int mois, int annee) async {
    final db = AppDatabase.instance;
    final salaires = await db.salairesDao.getByMoisAnnee(mois, annee);
    final buf = StringBuffer();
    buf.writeln(
        'Personnel ID,Salaire brut,CNPS,IRPP,Autres retenues,Salaire net,Statut');
    for (final s in salaires) {
      buf.writeln(
          '${s.personnelId},${s.salaireBrut.toStringAsFixed(0)},${s.cnps.toStringAsFixed(0)},${s.irpp.toStringAsFixed(0)},${s.autresRetenues.toStringAsFixed(0)},${s.salaireNet.toStringAsFixed(0)},${s.statut}');
    }
    return _writeCsv(
        'salaires_${annee}_${mois.toString().padLeft(2, '0')}.csv',
        buf.toString());
  }

  /// Export de la balance annuelle (produits - charges par mois)
  static Future<String> exportBalance(int annee) async {
    final db = AppDatabase.instance;
    final buf = StringBuffer();
    buf.writeln('Mois,Produits (CA HT),Charges,Résultat');

    for (int mois = 1; mois <= 12; mois++) {
      final ca = await db.facturesDao.getCaParMois(mois, annee);
      final charges = await db.chargesDao.getTotalParMois(mois, annee);
      buf.writeln(
          '$mois,${ca.toStringAsFixed(0)},${charges.toStringAsFixed(0)},${(ca - charges).toStringAsFixed(0)}');
    }
    return _writeCsv('balance_$annee.csv', buf.toString());
  }

  /// Échappe les virgules dans les champs CSV
  static String _esc(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
