import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_logger.dart';
import '../theme/app_colors.dart';

/// Écran de consultation des logs en temps réel.
/// Accessible depuis Paramètres (admin uniquement en production).
class LogConsoleScreen extends ConsumerStatefulWidget {
  const LogConsoleScreen({super.key});

  @override
  ConsumerState<LogConsoleScreen> createState() => _LogConsoleScreenState();
}

class _LogConsoleScreenState extends ConsumerState<LogConsoleScreen> {
  LogLevel _minLevel = LogLevel.debug;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(logProvider);
    final filtered = logs
        .where((e) => e.level.index >= _minLevel.index)
        .toList()
        .reversed
        .toList(); // plus récent en premier

    return Scaffold(
      appBar: AppBar(
        title: Text('Logs (${filtered.length})'),
        actions: [
          // Filtre niveau
          DropdownButton<LogLevel>(
            value: _minLevel,
            underline: const SizedBox(),
            dropdownColor: AppColors.navy,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            items: LogLevel.values
                .map((l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.name.toUpperCase()),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _minLevel = v ?? _minLevel),
          ),
          const SizedBox(width: 8),
          // Copier tous les logs
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: 'Copier',
            onPressed: () {
              final text = filtered.map((e) => e.toString()).join('\n');
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs copiés')),
              );
            },
          ),
          // Effacer
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Effacer',
            onPressed: () => ref.read(logProvider.notifier).clear(),
          ),
        ],
      ),
      body: filtered.isEmpty
          ? const Center(
              child: Text('Aucun log', style: TextStyle(color: Colors.grey)),
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _LogTile(entry: filtered[i]),
            ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry entry;
  const _LogTile({required this.entry});

  static const _colors = {
    LogLevel.debug:   Color(0xFF78909C),
    LogLevel.info:    Color(0xFF42A5F5),
    LogLevel.warning: Color(0xFFFFA726),
    LogLevel.error:   Color(0xFFEF5350),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[entry.level] ?? Colors.grey;
    final time =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:'
        '${entry.timestamp.minute.toString().padLeft(2, '0')}:'
        '${entry.timestamp.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicateur de couleur
          Container(
            width: 4,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête : heure + tag
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontFamily: 'monospace'),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.tag,
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Message
                Text(
                  entry.message,
                  style: const TextStyle(fontSize: 12),
                ),
                // Erreur si présente
                if (entry.error != null)
                  Text(
                    entry.error.toString(),
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontFamily: 'monospace'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
