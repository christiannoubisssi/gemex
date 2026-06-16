import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ParametresService {
  static const _prefixEntreprise = 'entreprise_';
  static const _prefixDocument = 'document_';
  static const _prefixFiscal = 'fiscal_';
  static const _prefixSecurite = 'securite_';
  static const _prefixNumerotation = 'numerotation_';
  static const _keyTypesMission = 'types_mission';

  static const defaultsTva = 18.0;
  static const defaultsTps = 0.0;
  static const defaultsDevise = 'XAF';
  static const defaultFormatDevis = 'PREFIXE-AAAA-NNNN';
  static const defaultFormatFacture = 'PREFIXE-AAAA-NNNN';
  static const defaultFormatDossier = 'AV-AAAA-NNNN';

  static SupabaseClient get _client => Supabase.instance.client;

  static final List<Map<String, String>> defaultTypesMission = [
    {'nom': 'Expertise maritime', 'abreviation': 'MAR'},
    {'nom': 'Expertise terrestre', 'abreviation': 'TER'},
    {'nom': 'Expertise incendie', 'abreviation': 'INC'},
    {'nom': 'Expertise dégâts des eaux', 'abreviation': 'DDE'},
    {'nom': 'Contre-expertise', 'abreviation': 'CEX'},
  ];

  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  static Future<String> getString(String key, {String defaultValue = ''}) async {
    final prefs = await _prefs;
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<double> getDouble(String key, {required double defaultValue}) async {
    final prefs = await _prefs;
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  // Entreprise
  static Future<Map<String, String>> getEntreprise() async {
    return {
      'nom': await getString('${_prefixEntreprise}nom'),
      'adresse': await getString('${_prefixEntreprise}adresse'),
      'telephone': await getString('${_prefixEntreprise}telephone'),
      'email': await getString('${_prefixEntreprise}email'),
      'rccm': await getString('${_prefixEntreprise}rccm'),
      'nif': await getString('${_prefixEntreprise}nif'),
    };
  }

  static Future<void> saveEntreprise(Map<String, String> data) async {
    for (final entry in data.entries) {
      await setString('$_prefixEntreprise${entry.key}', entry.value);
    }
  }

  // Logo entreprise (encodé en base64, utilisé pour l'app et les PDF générés)
  static const _keyLogoBase64 = '${_prefixEntreprise}logo_base64';

  static Future<String?> getLogoBase64() async {
    final value = await getString(_keyLogoBase64);
    return value.isEmpty ? null : value;
  }

  static Future<Uint8List?> getLogoBytes() async {
    final b64 = await getLogoBase64();
    if (b64 == null) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLogoBase64(String base64) async {
    await setString(_keyLogoBase64, base64);
  }

  static Future<void> removeLogo() async {
    final prefs = await _prefs;
    await prefs.remove(_keyLogoBase64);
  }

  // Fiscal
  static Future<Map<String, dynamic>> getFiscal() async {
    return {
      'tva_taux': await getDouble('${_prefixFiscal}tva_taux', defaultValue: defaultsTva),
      'tps_taux': await getDouble('${_prefixFiscal}tps_taux', defaultValue: defaultsTps),
      'devise': await getString('${_prefixFiscal}devise', defaultValue: defaultsDevise),
    };
  }

  static Future<void> saveFiscal(double tvaTaux, double tpsTaux, String devise) async {
    await setDouble('${_prefixFiscal}tva_taux', tvaTaux);
    await setDouble('${_prefixFiscal}tps_taux', tpsTaux);
    await setString('${_prefixFiscal}devise', devise);
  }

  // Document layout
  static Future<Map<String, String>> getDocumentLayout() async {
    return {
      'en_tete': await getString('${_prefixDocument}en_tete'),
      'pied_de_page': await getString('${_prefixDocument}pied_de_page'),
      'mentions_legales': await getString('${_prefixDocument}mentions_legales'),
    };
  }

  static Future<void> saveDocumentLayout(Map<String, String> data) async {
    for (final entry in data.entries) {
      await setString('$_prefixDocument${entry.key}', entry.value);
    }
  }

  // Types de mission — chaque type = {nom, abreviation (3 car. max, majuscules)}
  // Source de vérité : Supabase (table `types_mission`), nécessaire au trigger
  // de numérotation (jeton ABREV). Le cache local sert de secours hors-ligne.
  static Future<List<Map<String, String>>> getTypesMission() async {
    try {
      final rows = await _client
          .from('types_mission')
          .select('nom, abreviation')
          .eq('entreprise_id', 'default')
          .order('ordre');
      if (rows.isNotEmpty) {
        final types = rows
            .map<Map<String, String>>((r) => {
                  'nom': r['nom'] as String,
                  'abreviation': (r['abreviation'] as String?) ?? '',
                })
            .toList();
        await _cacheTypesMission(types);
        return types;
      }
    } catch (_) {
      // Hors-ligne ou erreur réseau : on retombe sur le cache local
    }
    return _getCachedTypesMission();
  }

  static Future<List<Map<String, String>>> _getCachedTypesMission() async {
    final prefs = await _prefs;
    final json = prefs.getString(_keyTypesMission);
    if (json == null) return List.from(defaultTypesMission);
    final raw = jsonDecode(json) as List;
    // Compatibilité avec l'ancien format (List<String>)
    return raw.map((e) {
      if (e is String) return {'nom': e, 'abreviation': ''};
      return Map<String, String>.from(e as Map);
    }).toList();
  }

  static Future<void> _cacheTypesMission(List<Map<String, String>> types) async {
    final prefs = await _prefs;
    await prefs.setString(_keyTypesMission, jsonEncode(types));
  }

  static Future<void> saveTypesMission(List<Map<String, String>> types) async {
    await _cacheTypesMission(types);
    // Push best-effort vers Supabase (remplace la liste complète)
    try {
      await _client.from('types_mission').delete().eq('entreprise_id', 'default');
      if (types.isNotEmpty) {
        await _client.from('types_mission').insert([
          for (var i = 0; i < types.length; i++)
            {
              'id': const Uuid().v4(),
              'entreprise_id': 'default',
              'nom': types[i]['nom'],
              'abreviation': types[i]['abreviation'],
              'ordre': i,
            },
        ]);
      }
    } catch (_) {
      // Hors-ligne : le cache local reste à jour, la sync se refera plus tard
    }
  }

  // Numérotation des devis/factures — gabarits configurables (ex: PREFIXE-AAAA-NNNN)
  // Source de vérité : Supabase (table `parametres_numerotation`), lue par le
  // trigger de numérotation. Le cache local sert de secours hors-ligne.
  static Future<Map<String, String>> getNumerotation() async {
    try {
      final row = await _client
          .from('parametres_numerotation')
          .select('format_devis, format_facture, format_dossier')
          .eq('entreprise_id', 'default')
          .maybeSingle();
      if (row != null) {
        final data = {
          'format_devis': row['format_devis'] as String? ?? defaultFormatDevis,
          'format_facture': row['format_facture'] as String? ?? defaultFormatFacture,
          'format_dossier': row['format_dossier'] as String? ?? defaultFormatDossier,
        };
        await _cacheNumerotation(data);
        return data;
      }
    } catch (_) {
      // Hors-ligne ou erreur réseau : on retombe sur le cache local
    }
    return _getCachedNumerotation();
  }

  static Future<Map<String, String>> _getCachedNumerotation() async {
    return {
      'format_devis': await getString('${_prefixNumerotation}format_devis', defaultValue: defaultFormatDevis),
      'format_facture': await getString('${_prefixNumerotation}format_facture', defaultValue: defaultFormatFacture),
      'format_dossier': await getString('${_prefixNumerotation}format_dossier', defaultValue: defaultFormatDossier),
    };
  }

  static Future<void> _cacheNumerotation(Map<String, String> data) async {
    await setString('${_prefixNumerotation}format_devis', data['format_devis']!);
    await setString('${_prefixNumerotation}format_facture', data['format_facture']!);
    await setString('${_prefixNumerotation}format_dossier', data['format_dossier']!);
  }

  static Future<void> saveNumerotation(
      String formatDevis, String formatFacture, String formatDossier) async {
    final data = {
      'format_devis': formatDevis,
      'format_facture': formatFacture,
      'format_dossier': formatDossier,
    };
    await _cacheNumerotation(data);
    try {
      await _client.from('parametres_numerotation').upsert({
        'entreprise_id': 'default',
        'format_devis': formatDevis,
        'format_facture': formatFacture,
        'format_dossier': formatDossier,
      });
    } catch (_) {
      // Hors-ligne : le cache local reste à jour, la sync se refera plus tard
    }
  }

  // Sécurité documents
  static Future<Map<String, dynamic>> getSecurite() async {
    return {
      'qr_actif': await getBool('${_prefixSecurite}qr_actif'),
      'signature_actif': await getBool('${_prefixSecurite}signature_actif'),
      'filigrane_actif': await getBool('${_prefixSecurite}filigrane_actif'),
      'filigrane_texte': await getString('${_prefixSecurite}filigrane_texte', defaultValue: 'ORIGINAL'),
      'signature_texte': await getString('${_prefixSecurite}signature_texte'),
      'hmac_secret': await _getOrCreateHmacSecret(),
    };
  }

  static Future<void> saveSecurite(Map<String, dynamic> data) async {
    if (data.containsKey('qr_actif')) await setBool('${_prefixSecurite}qr_actif', data['qr_actif'] as bool);
    if (data.containsKey('signature_actif')) await setBool('${_prefixSecurite}signature_actif', data['signature_actif'] as bool);
    if (data.containsKey('filigrane_actif')) await setBool('${_prefixSecurite}filigrane_actif', data['filigrane_actif'] as bool);
    if (data.containsKey('filigrane_texte')) await setString('${_prefixSecurite}filigrane_texte', data['filigrane_texte'] as String);
    if (data.containsKey('signature_texte')) await setString('${_prefixSecurite}signature_texte', data['signature_texte'] as String);
  }

  static Future<String> _getOrCreateHmacSecret() async {
    final existing = await getString('${_prefixSecurite}hmac_secret');
    if (existing.isNotEmpty) return existing;
    final secret = _generateSecret();
    await setString('${_prefixSecurite}hmac_secret', secret);
    return secret;
  }

  static Future<void> regenererHmacSecret() async {
    await setString('${_prefixSecurite}hmac_secret', _generateSecret());
  }

  static String _generateSecret() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
