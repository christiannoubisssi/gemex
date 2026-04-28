import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/personnel_provider.dart';

class PersonnelDetailScreen extends ConsumerWidget {
  final String id;
  const PersonnelDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personnelDetailProvider(id));
    final congesAsync = ref.watch(congesPersonnelProvider(id));

    return personAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Erreur : $e'))),
      data: (person) {
        if (person == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Introuvable')));
        }
        final nomComplet = [person.prenom, person.nom].whereType<String>().join(' ');
        return Scaffold(
          appBar: AppBar(
            title: Text(nomComplet),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/rh/personnel/${person.id}/edit'),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'toggle') {
                    await ref
                        .read(personnelNotifierProvider.notifier)
                        .toggleActif(person.id, !person.actif);
                    ref.invalidate(personnelDetailProvider(id));
                    ref.invalidate(personnelListProvider);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(person.actif ? 'Désactiver' : 'Réactiver'),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fiche identité
                _InfoCard(
                  title: 'Informations',
                  icon: Icons.person_outline,
                  rows: [
                    _Row('Poste', person.poste),
                    _Row('Département', person.departement),
                    _Row('Contrat', person.typeContrat),
                    _Row('Embauche', person.dateEmbauche != null
                        ? DateFormat('dd/MM/yyyy').format(person.dateEmbauche!)
                        : null),
                    if (person.dateFinContrat != null)
                      _Row('Fin contrat', DateFormat('dd/MM/yyyy').format(person.dateFinContrat!)),
                    _Row('Salaire base', person.salaireBase != null
                        ? FormatUtils.formatFcfa(person.salaireBase)
                        : null),
                  ],
                ),
                const SizedBox(height: 12),

                // Congés
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.beach_access_outlined, size: 18, color: AppColors.teal),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('Congés',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Demande'),
                              onPressed: () => _showCongeDialog(context, ref, person.id),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        congesAsync.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Erreur : $e'),
                          data: (list) => list.isEmpty
                              ? const Text('Aucun congé enregistré',
                                  style: TextStyle(color: Colors.grey, fontSize: 13))
                              : Column(
                                  children: list.map((c) => _CongeTile(
                                        conge: c,
                                        onApprouver: () async {
                                          await ref
                                              .read(personnelNotifierProvider.notifier)
                                              .approuverConge(c.id);
                                          ref.invalidate(congesPersonnelProvider(id));
                                        },
                                        onRefuser: () async {
                                          await ref
                                              .read(personnelNotifierProvider.notifier)
                                              .refuserConge(c.id);
                                          ref.invalidate(congesPersonnelProvider(id));
                                        },
                                        onDelete: () async {
                                          await ref
                                              .read(personnelNotifierProvider.notifier)
                                              .deleteConge(c.id);
                                          ref.invalidate(congesPersonnelProvider(id));
                                        },
                                      )).toList(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCongeDialog(BuildContext context, WidgetRef ref, String personnelId) async {
    DateTime? debut = DateTime.now();
    DateTime? fin = DateTime.now().add(const Duration(days: 7));
    String type = 'conge_annuel';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Demande de congé'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'conge_annuel', child: Text('Congé annuel')),
                  DropdownMenuItem(value: 'maladie', child: Text('Maladie')),
                  DropdownMenuItem(value: 'autre', child: Text('Autre')),
                ],
                onChanged: (v) => setS(() => type = v ?? type),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Du : ${DateFormat('dd/MM/yyyy').format(debut!)}'),
                trailing: const Icon(Icons.calendar_today_outlined, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                    context: ctx,
                    initialDate: debut!,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (p != null) setS(() => debut = p);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Au : ${DateFormat('dd/MM/yyyy').format(fin!)}'),
                trailing: const Icon(Icons.calendar_today_outlined, size: 18),
                onTap: () async {
                  final p = await showDatePicker(
                    context: ctx,
                    initialDate: fin!,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (p != null) setS(() => fin = p);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                await ref.read(personnelNotifierProvider.notifier).addConge(
                      personnelId: personnelId,
                      dateDebut: debut!,
                      dateFin: fin!,
                      type: type,
                    );
                ref.invalidate(congesPersonnelProvider(personnelId));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Row> rows;
  const _InfoCard({required this.title, required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) {
    final visible = rows.where((r) => r.value != null).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 18, color: AppColors.teal),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            ]),
            const Divider(height: 16),
            ...visible.map((r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    SizedBox(
                        width: 120,
                        child: Text(r.label,
                            style: const TextStyle(color: Colors.grey, fontSize: 13))),
                    Expanded(
                        child: Text(r.value!,
                            style: const TextStyle(fontWeight: FontWeight.w500))),
                  ]),
                )),
          ],
        ),
      ),
    );
  }
}

class _Row {
  final String label;
  final String? value;
  const _Row(this.label, this.value);
}

class _CongeTile extends StatelessWidget {
  final Conge conge;
  final VoidCallback onApprouver;
  final VoidCallback onRefuser;
  final VoidCallback onDelete;
  const _CongeTile(
      {required this.conge,
      required this.onApprouver,
      required this.onRefuser,
      required this.onDelete});

  Color get _statusColor {
    switch (conge.statut) {
      case 'approuve':
        return Colors.green;
      case 'refuse':
        return AppColors.danger;
      default:
        return Colors.orange;
    }
  }

  String get _statusLabel {
    switch (conge.statut) {
      case 'approuve':
        return 'Approuvé';
      case 'refuse':
        return 'Refusé';
      default:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yy');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fmt.format(conge.dateDebut)} → ${fmt.format(conge.dateFin)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(conge.type.replaceAll('_', ' '),
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_statusLabel,
                style: TextStyle(fontSize: 11, color: _statusColor, fontWeight: FontWeight.w600)),
          ),
          if (conge.statut == 'demande') ...[
            IconButton(
              icon: const Icon(Icons.check, size: 18, color: Colors.green),
              onPressed: onApprouver,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.red),
              onPressed: onRefuser,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
