import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/audit_service.dart';

class AuditScreen extends ConsumerStatefulWidget {
  const AuditScreen({super.key});

  @override
  ConsumerState<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends ConsumerState<AuditScreen> {
  String? _filtreUser;
  String? _filtreType;
  String _filtreRecherche = '';
  _Periode _periode = _Periode.semaine;
  bool _pulling = false;

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogsStreamProvider);
    final isOnline  = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal d\'activité'),
        actions: [
          // Rafraîchir depuis Supabase
          if (isOnline)
            _pulling
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton(
                    icon: const Icon(Icons.cloud_download_outlined),
                    tooltip: 'Actualiser depuis le serveur',
                    onPressed: _pullFromServer,
                  ),
          // Export CSV
          logsAsync.maybeWhen(
            data: (logs) => IconButton(
              icon: const Icon(Icons.download_outlined),
              tooltip: 'Exporter CSV',
              onPressed: () => _exportCsv(logs),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(children: [
        // ── Barre de filtres ─────────────────────────────────────────────
        _FiltresBar(
          periode: _periode,
          filtreType: _filtreType,
          filtreRecherche: _filtreRecherche,
          onPeriode: (p) => setState(() => _periode = p),
          onType: (t) => setState(() => _filtreType = t),
          onRecherche: (s) => setState(() => _filtreRecherche = s),
        ),
        const Divider(height: 1),

        // ── Liste ────────────────────────────────────────────────────────
        Expanded(
          child: logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur : $e')),
            data: (allLogs) {
              final filtered = _applyFilters(allLogs);
              if (filtered.isEmpty) {
                return const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.search_off_outlined,
                        size: 52, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Aucune activité pour ce filtre.',
                        style: TextStyle(color: Colors.grey)),
                  ]),
                );
              }

              // Regrouper par utilisateur si on filtre par user
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final log = filtered[i];
                  final showSeparator = i == 0 ||
                      filtered[i - 1].userId != log.userId;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showSeparator) ...[
                        if (i != 0) const SizedBox(height: 8),
                        _UserChip(nom: log.userNom),
                        const SizedBox(height: 6),
                      ],
                      _AuditTile(log: log),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }

  List<AuditLog> _applyFilters(List<AuditLog> logs) {
    final cutoff = _periode.cutoff;
    return logs.where((l) {
      if (l.createdAt.isBefore(cutoff)) return false;
      if (_filtreUser != null && l.userId != _filtreUser) return false;
      if (_filtreType != null && !l.actionType.startsWith(_filtreType!)) {
        return false;
      }
      if (_filtreRecherche.isNotEmpty) {
        final q = _filtreRecherche.toLowerCase();
        if (!l.description.toLowerCase().contains(q) &&
            !(l.entityLabel?.toLowerCase().contains(q) ?? false) &&
            !l.userNom.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> _pullFromServer() async {
    setState(() => _pulling = true);
    try {
      final n = await ref.read(auditServiceProvider).pullFromSupabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$n activité(s) récupérée(s) depuis le serveur'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _pulling = false);
    }
  }

  Future<void> _exportCsv(List<AuditLog> logs) async {
    final filtered = _applyFilters(logs);
    final csv = ref.read(auditServiceProvider).exportToCsv(filtered);

    // Afficher dans un dialog pour copier (export fichier nécessite plugin extra)
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export CSV'),
        content: SizedBox(
          width: 500,
          height: 300,
          child: SingleChildScrollView(
            child: SelectableText(csv,
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// ── Enum période ─────────────────────────────────────────────────────────────

enum _Periode {
  aujourd_hui('Aujourd\'hui'),
  semaine('Cette semaine'),
  mois('Ce mois'),
  tout('Tout');

  final String label;
  const _Periode(this.label);

  DateTime get cutoff {
    final now = DateTime.now();
    switch (this) {
      case _Periode.aujourd_hui:
        return DateTime(now.year, now.month, now.day);
      case _Periode.semaine:
        return now.subtract(const Duration(days: 7));
      case _Periode.mois:
        return now.subtract(const Duration(days: 30));
      case _Periode.tout:
        return DateTime(2000);
    }
  }
}

// ── Barre de filtres ─────────────────────────────────────────────────────────

class _FiltresBar extends StatelessWidget {
  final _Periode periode;
  final String? filtreType;
  final String filtreRecherche;
  final ValueChanged<_Periode> onPeriode;
  final ValueChanged<String?> onType;
  final ValueChanged<String> onRecherche;

  const _FiltresBar({
    required this.periode,
    required this.filtreType,
    required this.filtreRecherche,
    required this.onPeriode,
    required this.onType,
    required this.onRecherche,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBg,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Chips de période
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _Periode.values.map((p) {
            final selected = p == periode;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(p.label),
                selected: selected,
                onSelected: (_) => onPeriode(p),
                selectedColor: AppColors.navy.withAlpha(30),
                labelStyle: TextStyle(
                  color: selected ? AppColors.navy : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            );
          }).toList()),
        ),
        const SizedBox(height: 8),
        // Filtre type + recherche
        Row(children: [
          // Filtre par type d'entité
          DropdownButton<String?>(
            value: filtreType,
            hint: const Text('Type', style: TextStyle(fontSize: 12)),
            isDense: true,
            items: [
              const DropdownMenuItem<String?>(
                  value: null, child: Text('Tous', style: TextStyle(fontSize: 12))),
              ...['dossier', 'client', 'devis', 'facture', 'document']
                  .map((t) => DropdownMenuItem<String?>(
                        value: t,
                        child: Text(
                          {'dossier': 'Dossiers', 'client': 'Clients',
                            'devis': 'Devis', 'facture': 'Factures',
                            'document': 'Documents'}[t] ?? t,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )),
            ],
            onChanged: onType,
          ),
          const SizedBox(width: 12),
          // Recherche libre
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Chercher utilisateur, référence…',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                style: const TextStyle(fontSize: 12),
                onChanged: onRecherche,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _UserChip extends StatelessWidget {
  final String nom;
  const _UserChip({required this.nom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.navy.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.person_outline, size: 14, color: AppColors.navy),
        const SizedBox(width: 4),
        Text(nom,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold,
                color: AppColors.navy)),
      ]),
    );
  }
}

class _AuditTile extends StatelessWidget {
  final AuditLog log;
  const _AuditTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final color  = AuditLabels.colorForAction(log.actionType);
    final icon   = AuditLabels.iconForAction(log.actionType);
    final label  = AuditLabels.forAction(log.actionType);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(20), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87),
                      children: [
                        TextSpan(
                            text: label,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: color)),
                        if (log.entityLabel != null) ...[
                          const TextSpan(text: '  '),
                          TextSpan(
                              text: log.entityLabel,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.teal,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ],
                    ),
                  ),
                ),
                Text(_formatDate(log.createdAt),
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ]),
              if (log.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(log.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              if (log.ancienneValeur != null && log.nouvelleValeur != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                      '${log.ancienneValeur} → ${log.nouvelleValeur}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.teal)),
                ),
            ]),
          ),
        ]),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now  = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours}h';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
