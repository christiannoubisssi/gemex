import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/audit_service.dart';

// ── Enum période ──────────────────────────────────────────────────────────────

enum _Periode {
  aujourd_hui("Aujourd'hui"),
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

// ── Enum tri ──────────────────────────────────────────────────────────────────

enum _TriAudit {
  dateDesc('Date ↓ (récent)'),
  dateAsc('Date ↑ (ancien)'),
  utilisateur('Utilisateur A→Z'),
  type("Type d'action");

  final String label;
  const _TriAudit(this.label);
}

// ── Écran principal ───────────────────────────────────────────────────────────

class AuditScreen extends ConsumerStatefulWidget {
  const AuditScreen({super.key});

  @override
  ConsumerState<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends ConsumerState<AuditScreen> {
  String? _filtreUserId;
  String? _filtreType;
  String _filtreRecherche = '';
  _Periode _periode = _Periode.semaine;
  _TriAudit _tri = _TriAudit.dateDesc;
  bool _pulling = false;

  List<AuditLog> _appliquerFiltresEtTri(List<AuditLog> logs) {
    final cutoff = _periode.cutoff;
    var list = logs.where((l) {
      if (l.createdAt.isBefore(cutoff)) return false;
      if (_filtreUserId != null && l.userId != _filtreUserId) return false;
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

    switch (_tri) {
      case _TriAudit.dateAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case _TriAudit.utilisateur:
        list.sort((a, b) => a.userNom.compareTo(b.userNom));
      case _TriAudit.type:
        list.sort((a, b) => a.actionType.compareTo(b.actionType));
      case _TriAudit.dateDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  int get _filtresActifs =>
      (_filtreUserId != null ? 1 : 0) +
      (_filtreType != null ? 1 : 0) +
      (_filtreRecherche.isNotEmpty ? 1 : 0) +
      (_periode != _Periode.semaine ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogsStreamProvider);
    final isOnline = ref.watch(isOnlineProvider);

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
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2)),
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
          // Réinitialiser tous les filtres
          if (_filtresActifs > 0)
            IconButton(
              icon: Badge(
                label: Text('$_filtresActifs'),
                child: const Icon(Icons.filter_alt_off_outlined),
              ),
              tooltip: 'Réinitialiser les filtres',
              onPressed: _resetFiltres,
            ),
        ],
      ),
      body: Column(children: [
        // ── Barre de filtres ─────────────────────────────────────────────
        logsAsync.maybeWhen(
          data: (allLogs) {
            // Utilisateurs uniques présents dans les logs
            final utilisateurs = <String, String>{};
            for (final l in allLogs) {
              utilisateurs.putIfAbsent(l.userId, () => l.userNom);
            }
            return _FiltresBar(
              periode: _periode,
              tri: _tri,
              filtreUserId: _filtreUserId,
              filtreType: _filtreType,
              filtreRecherche: _filtreRecherche,
              utilisateurs: utilisateurs,
              onPeriode: (p) => setState(() => _periode = p),
              onTri: (t) => setState(() => _tri = t),
              onUser: (u) => setState(() => _filtreUserId = u),
              onType: (t) => setState(() => _filtreType = t),
              onRecherche: (s) => setState(() => _filtreRecherche = s),
            );
          },
          orElse: () => _FiltresBar(
            periode: _periode,
            tri: _tri,
            filtreUserId: _filtreUserId,
            filtreType: _filtreType,
            filtreRecherche: _filtreRecherche,
            utilisateurs: const {},
            onPeriode: (p) => setState(() => _periode = p),
            onTri: (t) => setState(() => _tri = t),
            onUser: (u) => setState(() => _filtreUserId = u),
            onType: (t) => setState(() => _filtreType = t),
            onRecherche: (s) => setState(() => _filtreRecherche = s),
          ),
        ),
        const Divider(height: 1),

        // ── Résumé des filtres actifs ─────────────────────────────────────
        if (_filtresActifs > 0) _FiltresActifsBanner(count: _filtresActifs),

        // ── Liste ────────────────────────────────────────────────────────
        Expanded(
          child: logsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur : $e')),
            data: (allLogs) {
              final filtered = _appliquerFiltresEtTri(allLogs);
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_outlined,
                            size: 52, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('Aucune activité pour ce filtre.',
                            style: TextStyle(color: Colors.grey)),
                        if (_filtresActifs > 0) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            icon: const Icon(Icons.filter_alt_off),
                            label: const Text('Réinitialiser'),
                            onPressed: _resetFiltres,
                          ),
                        ],
                      ]),
                );
              }

              // Regroupement : par utilisateur si tri=utilisateur, sinon par date
              final grouperParUser = _tri == _TriAudit.utilisateur;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final log = filtered[i];
                  final showSeparator = grouperParUser
                      ? (i == 0 || filtered[i - 1].userId != log.userId)
                      : _showDateSeparator(filtered, i);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showSeparator && grouperParUser) ...[
                        if (i != 0) const SizedBox(height: 8),
                        _UserChip(nom: log.userNom),
                        const SizedBox(height: 6),
                      ],
                      if (showSeparator && !grouperParUser) ...[
                        if (i != 0) const SizedBox(height: 8),
                        _DateChip(date: log.createdAt),
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

  /// Affiche un séparateur de date quand le jour change dans la liste triée par date.
  bool _showDateSeparator(List<AuditLog> logs, int i) {
    if (i == 0) return true;
    final curr = logs[i].createdAt;
    final prev = logs[i - 1].createdAt;
    return curr.year != prev.year ||
        curr.month != prev.month ||
        curr.day != prev.day;
  }

  void _resetFiltres() => setState(() {
        _filtreUserId = null;
        _filtreType = null;
        _filtreRecherche = '';
        _periode = _Periode.semaine;
        _tri = _TriAudit.dateDesc;
      });

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
    final filtered = _appliquerFiltresEtTri(logs);
    final csv = ref.read(auditServiceProvider).exportToCsv(filtered);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Export CSV (${filtered.length} lignes)'),
        content: SizedBox(
          width: 500,
          height: 300,
          child: SingleChildScrollView(
            child: SelectableText(csv,
                style:
                    const TextStyle(fontSize: 11, fontFamily: 'monospace')),
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

// ── Barre de filtres ──────────────────────────────────────────────────────────

class _FiltresBar extends StatelessWidget {
  final _Periode periode;
  final _TriAudit tri;
  final String? filtreUserId;
  final String? filtreType;
  final String filtreRecherche;
  final Map<String, String> utilisateurs; // userId → userNom
  final ValueChanged<_Periode> onPeriode;
  final ValueChanged<_TriAudit> onTri;
  final ValueChanged<String?> onUser;
  final ValueChanged<String?> onType;
  final ValueChanged<String> onRecherche;

  const _FiltresBar({
    required this.periode,
    required this.tri,
    required this.filtreUserId,
    required this.filtreType,
    required this.filtreRecherche,
    required this.utilisateurs,
    required this.onPeriode,
    required this.onTri,
    required this.onUser,
    required this.onType,
    required this.onRecherche,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBg,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Ligne 1 : chips de période ─────────────────────────────────
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
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            );
          }).toList()),
        ),
        const SizedBox(height: 8),

        // ── Ligne 2 : tri + filtre utilisateur + filtre type ──────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            // Tri
            const Icon(Icons.sort, size: 15, color: AppColors.textMuted),
            const SizedBox(width: 4),
            DropdownButton<_TriAudit>(
              value: tri,
              isDense: true,
              underline: const SizedBox.shrink(),
              hint: const Text('Trier', style: TextStyle(fontSize: 12)),
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary),
              items: _TriAudit.values
                  .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.label,
                          style: const TextStyle(fontSize: 12))))
                  .toList(),
              onChanged: (t) { if (t != null) onTri(t); },
            ),
            const SizedBox(width: 16),

            // Filtre utilisateur
            if (utilisateurs.isNotEmpty) ...[
              const Icon(Icons.person_outline,
                  size: 15, color: AppColors.textMuted),
              const SizedBox(width: 4),
              DropdownButton<String?>(
                value: filtreUserId,
                isDense: true,
                underline: const SizedBox.shrink(),
                hint: const Text('Utilisateur',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textPrimary),
                items: [
                  const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tous',
                          style: TextStyle(fontSize: 12))),
                  ...utilisateurs.entries.map(
                    (e) => DropdownMenuItem<String?>(
                      value: e.key,
                      child: Text(e.value,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
                onChanged: onUser,
              ),
              const SizedBox(width: 16),
            ],

            // Filtre type d'entité
            const Icon(Icons.category_outlined,
                size: 15, color: AppColors.textMuted),
            const SizedBox(width: 4),
            DropdownButton<String?>(
              value: filtreType,
              isDense: true,
              underline: const SizedBox.shrink(),
              hint: const Text('Type',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary),
              items: [
                const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tous types',
                        style: TextStyle(fontSize: 12))),
                ...[
                  'dossier',
                  'client',
                  'devis',
                  'facture',
                  'document'
                ].map(
                  (t) => DropdownMenuItem<String?>(
                    value: t,
                    child: Text(
                      {
                            'dossier': 'Dossiers',
                            'client': 'Clients',
                            'devis': 'Devis',
                            'facture': 'Factures',
                            'document': 'Documents',
                          }[t] ??
                          t,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
              onChanged: onType,
            ),
          ]),
        ),
        const SizedBox(height: 8),

        // ── Ligne 3 : recherche libre ─────────────────────────────────
        SizedBox(
          height: 36,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Chercher un utilisateur, une référence…',
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: const Icon(Icons.search, size: 18),
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: Colors.grey.shade300),
              ),
            ),
            style: const TextStyle(fontSize: 12),
            controller: TextEditingController(text: filtreRecherche),
            onChanged: onRecherche,
          ),
        ),
      ]),
    );
  }
}

// ── Bannière filtres actifs ───────────────────────────────────────────────────

class _FiltresActifsBanner extends StatelessWidget {
  final int count;
  const _FiltresActifsBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.teal.withAlpha(15),
      child: Text(
        '$count filtre${count > 1 ? 's' : ''} actif${count > 1 ? 's' : ''} — appuyez sur ✕ pour réinitialiser',
        style: const TextStyle(
            fontSize: 11,
            color: AppColors.teal,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ── Séparateurs ───────────────────────────────────────────────────────────────

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
        const Icon(Icons.person_outline,
            size: 14, color: AppColors.navy),
        const SizedBox(width: 4),
        Text(nom,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.navy)),
      ]),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  const _DateChip({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday =
        DateTime(now.year, now.month, now.day - 1);
    final d = DateTime(date.year, date.month, date.day);
    String label;
    if (d == today) {
      label = "Aujourd'hui";
    } else if (d == yesterday) {
      label = 'Hier';
    } else {
      label =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.calendar_today_outlined,
            size: 13, color: Colors.grey),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey)),
      ]),
    );
  }
}

// ── Tile d'un événement ───────────────────────────────────────────────────────

class _AuditTile extends StatelessWidget {
  final AuditLog log;
  const _AuditTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final color = AuditLabels.colorForAction(log.actionType);
    final icon  = AuditLabels.iconForAction(log.actionType);
    final label = AuditLabels.forAction(log.actionType);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            width: 32,
            height: 32,
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
                                fontWeight: FontWeight.w600,
                                color: color)),
                        if (log.entityLabel != null) ...[
                          const TextSpan(text: '  '),
                          TextSpan(
                              text: log.entityLabel,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.teal,
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
              // Utilisateur
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(log.userNom,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
              if (log.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(log.description,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                ),
              if (log.ancienneValeur != null &&
                  log.nouvelleValeur != null)
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
