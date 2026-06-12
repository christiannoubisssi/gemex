/// Aperçu côté client du format des numéros de documents (devis/factures).
///
/// Miroir Dart de la fonction SQL `formater_numero` (database/schema.sql) :
/// le numéro définitif est toujours généré côté serveur par le trigger
/// Postgres, cette fonction ne sert qu'à afficher un exemple à l'utilisateur.
class NumeroFormatUtils {
  /// Jetons reconnus dans un gabarit de numérotation.
  static const List<String> tokens = [
    'PREFIXE',
    'AAAA',
    'MMAA',
    'ABREV',
    'INITIALES',
    'NNNN',
  ];

  /// Formate un numéro à partir d'un gabarit (ex: `PREFIXE-AAAA-NNNN`).
  /// Les segments dont la valeur résolue est vide (ABREV/INITIALES absents)
  /// sont supprimés du résultat.
  static String formater({
    required String format,
    required String prefixe,
    required int annee,
    required int sequence,
    String abrev = '',
    String initiales = '',
  }) {
    final segments = format.split('-');
    final result = <String>[];
    final regexSequence = RegExp(r'^N+$');

    for (final segment in segments) {
      String value;
      switch (segment) {
        case 'PREFIXE':
          value = prefixe;
          break;
        case 'AAAA':
          value = annee.toString();
          break;
        case 'MMAA':
          final mois = DateTime.now().month.toString().padLeft(2, '0');
          final aa = annee.toString().substring(annee.toString().length - 2);
          value = '$mois$aa';
          break;
        case 'ABREV':
          value = abrev;
          break;
        case 'INITIALES':
          value = initiales;
          break;
        default:
          if (regexSequence.hasMatch(segment)) {
            value = sequence.toString().padLeft(segment.length, '0');
          } else {
            value = segment;
          }
      }
      if (value.isNotEmpty) result.add(value);
    }
    return result.join('-');
  }
}
