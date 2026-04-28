import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ParametresService {
  static const _prefixEntreprise = 'entreprise_';
  static const _prefixDocument = 'document_';
  static const _prefixFiscal = 'fiscal_';
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
      await setString('${_prefixEntreprise}${entry.key}', entry.value);
    }
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
      await setString('${_prefixDocument}${entry.key}', entry.value);
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
}
