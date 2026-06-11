import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class ParametresService {
  static const _prefixEntreprise = 'entreprise_';
  static const _prefixDocument = 'document_';
  static const _prefixFiscal = 'fiscal_';
  static const _prefixSecurite = 'securite_';
  static const _keyTypesMission = 'types_mission';

  static const defaultsTva = 18.0;
  static const defaultsTps = 0.0;
  static const defaultsDevise = 'XAF';

  static final List<String> defaultTypesMission = [
    'Expertise maritime',
    'Expertise terrestre',
    'Expertise incendie',
    'Expertise dégâts des eaux',
    'Contre-expertise',
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

  // Types de mission
  static Future<List<String>> getTypesMission() async {
    final prefs = await _prefs;
    final json = prefs.getString(_keyTypesMission);
    if (json == null) return List.from(defaultTypesMission);
    return List<String>.from(jsonDecode(json) as List);
  }

  static Future<void> saveTypesMission(List<String> types) async {
    final prefs = await _prefs;
    await prefs.setString(_keyTypesMission, jsonEncode(types));
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
