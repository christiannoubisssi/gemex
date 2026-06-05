/// Utilitaires de sérialisation JSON pour les repositories.
///
/// `jsonEncode` ne sait pas encoder `DateTime` ni d'autres types complexes.
/// Cette fonction nettoie récursivement un Map avant tout appel à `jsonEncode`
/// ou avant un insert/update Supabase.

/// Convertit un Map en version sérialisable JSON :
/// - `DateTime`             → ISO 8601 string (ex: "2026-06-05T10:30:00.000")
/// - `Map<String, dynamic>` → récursion
/// - `List`                 → récursion sur chaque élément
/// - `null`, `String`, `num`, `bool` → inchangés
/// - autres types           → `.toString()` (fallback sûr)
Map<String, dynamic> toJsonSafe(Map<String, dynamic> data) {
  return data.map((key, value) => MapEntry(key, _sanitize(value)));
}

dynamic _sanitize(dynamic value) {
  if (value == null || value is String || value is num || value is bool) {
    return value;
  }
  if (value is DateTime) {
    return value.toIso8601String();
  }
  if (value is Map<String, dynamic>) {
    return toJsonSafe(value);
  }
  if (value is List) {
    return value.map(_sanitize).toList();
  }
  // Fallback : convertit en string pour éviter un crash runtime
  return value.toString();
}
