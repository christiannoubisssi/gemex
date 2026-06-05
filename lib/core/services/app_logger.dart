import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Niveau de sévérité d'un log.
enum LogLevel { debug, info, warning, error }

/// Entrée de log unique.
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.error,
    this.stackTrace,
  });

  String get levelLabel => switch (level) {
        LogLevel.debug   => '🔍 DEBUG',
        LogLevel.info    => 'ℹ️  INFO ',
        LogLevel.warning => '⚠️  WARN ',
        LogLevel.error   => '🔴 ERROR',
      };

  @override
  String toString() =>
      '[${timestamp.toIso8601String()}] $levelLabel [$tag] $message'
      '${error != null ? '\n  ↳ $error' : ''}'
      '${stackTrace != null && level == LogLevel.error ? '\n$stackTrace' : ''}';
}

/// Logger global de l'application.
///
/// Usage :
/// ```dart
/// AppLogger.i('DossierRepo', 'Dossier créé : $id');
/// AppLogger.e('SyncService', 'Erreur sync', error: e, stack: s);
/// ```
class AppLogger {
  AppLogger._();

  /// Nombre maximum d'entrées conservées en mémoire.
  static const int _maxEntries = 500;

  static final List<LogEntry> _entries = [];
  static final List<void Function(LogEntry)> _listeners = [];

  // ─── API publique ──────────────────────────────────────────────────────

  static void d(String tag, String message) =>
      _log(LogLevel.debug, tag, message);

  static void i(String tag, String message) =>
      _log(LogLevel.info, tag, message);

  static void w(String tag, String message, {Object? error}) =>
      _log(LogLevel.warning, tag, message, error: error);

  static void e(String tag, String message,
          {Object? error, StackTrace? stack}) =>
      _log(LogLevel.error, tag, message, error: error, stackTrace: stack);

  // ─── Accès aux entrées ─────────────────────────────────────────────────

  /// Toutes les entrées (plus récent en dernier).
  static List<LogEntry> get entries => List.unmodifiable(_entries);

  /// Filtre par niveau minimum.
  static List<LogEntry> filter(LogLevel minLevel) =>
      _entries.where((e) => e.level.index >= minLevel.index).toList();

  /// Efface le buffer.
  static void clear() => _entries.clear();

  /// S'abonner aux nouvelles entrées (pour la LogConsoleScreen).
  static void addListener(void Function(LogEntry) fn) => _listeners.add(fn);
  static void removeListener(void Function(LogEntry) fn) =>
      _listeners.remove(fn);

  // ─── Implémentation ────────────────────────────────────────────────────

  static void _log(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    _entries.add(entry);
    if (_entries.length > _maxEntries) _entries.removeAt(0);

    // Sortie console (debug uniquement pour ne pas polluer le build release)
    if (kDebugMode || level.index >= LogLevel.warning.index) {
      debugPrint(entry.toString());
    }

    for (final listener in _listeners) {
      listener(entry);
    }
  }
}

// ─── Provider Riverpod ────────────────────────────────────────────────────

/// Notifier qui expose les logs comme état Riverpod (pour la LogConsoleScreen).
class LogNotifier extends Notifier<List<LogEntry>> {
  @override
  List<LogEntry> build() {
    final entries = AppLogger.entries;
    // Écouter les nouveaux logs
    AppLogger.addListener(_onEntry);
    ref.onDispose(() => AppLogger.removeListener(_onEntry));
    return entries;
  }

  void _onEntry(LogEntry entry) {
    state = AppLogger.entries;
  }

  void clear() {
    AppLogger.clear();
    state = [];
  }
}

final logProvider = NotifierProvider<LogNotifier, List<LogEntry>>(
  LogNotifier.new,
);
