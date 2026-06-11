import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../dossiers/presentation/providers/dossier_provider.dart';
import '../../../dossiers/presentation/widgets/status_badge.dart';
import '../../../factures/presentation/providers/facture_provider.dart';
import '../providers/client_provider.dart';
import '../widgets/contact_form_dialog.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ClientDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ClientDetailScreen> createState() =>
      _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(clientDetailProvider(widget.id));

    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (client) {
        if (client == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Client')),
            body: const Center(child: Text('Client introuvable')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(client.nom),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/clients/${client.id}/edit'),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.person_outline, size: 18), text: 'Profil'),
                Tab(icon: Icon(Icons.folder_outlined, size: 18), text: 'Dossiers'),
                Tab(icon: Icon(Icons.receipt_outlined, size: 18), text: 'Factures'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/dossiers/new'),
            icon: const Icon(Icons.add),
            label: const Text('Nouveau dossier'),
            backgroundColor: AppColors.navy,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _ProfilTab(client: client),
              _DossiersTab(clientId: client.id),
              _FacturesTab(clientId: client.id),
            ],
          ),
        );
      },
    );
  }
}

// ── Onglet 1 : Profil ────────────────────────────────────────────────────────

class _ProfilTab extends StatelessWidget {
  final Client client;
  const _ProfilTab({required this.client});

  @override
  Widget build(BuildContext context) {
    final solde = client.totalFacture - client.totalPaye;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Avatar + nom
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.teal,
                  child: Text(
                    client.nom.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.nom,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(_typeLabel(client.typeClient),
                            style: const TextStyle(color: Colors.grey)),
                      ]),
                ),
              ]),
              if (solde > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.danger.withAlpha(50)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_outlined,
                        color: AppColors.danger, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Solde dû : ${FormatUtils.formatFcfa(solde)}',
                      style: const TextStyle(
                          color: AppColors.danger, fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Coordonnées
        if (client.email != null ||
            client.telephone != null ||
            client.adresse != null ||
            client.contactNom != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Coordonnées',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy)),
                    const Divider(height: 16),
                    if (client.contactNom != null)
                      _InfoRow(Icons.contact_page_outlined, client.contactNom!),
                    if (client.email != null)
                      _InfoRow(Icons.email_outlined, client.email!),
                    if (client.telephone != null)
                      _InfoRow(Icons.phone_outlined, client.telephone!),
                    if (client.adresse != null)
                      _InfoRow(
                          Icons.location_on_outlined,
                          [client.adresse, client.ville]
                              .whereType<String>()
                              .join(', ')),
                  ]),
            ),
          ),
        const SizedBox(height: 12),

        // Informations fiscales
        if (client.numeroTva != null || client.rccm != null || client.nif != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations fiscales',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy)),
                    const Divider(height: 16),
                    if (client.numeroTva != null)
                      _InfoRow(Icons.receipt_long_outlined, 'TVA : ${client.numeroTva}'),
                    if (client.rccm != null)
                      _InfoRow(Icons.badge_outlined, 'RCCM : ${client.rccm}'),
                    if (client.nif != null)
                      _InfoRow(Icons.fingerprint_outlined, 'NIF : ${client.nif}'),
                  ]),
            ),
          ),
        if (client.numeroTva != null || client.rccm != null || client.nif != null)
          const SizedBox(height: 12),

        // Contacts
        _ContactsCard(clientId: client.id),
        const SizedBox(height: 12),

        // Résumé financier
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Résumé financier',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const Divider(height: 16),
                  _FinanceRow(
                      'Total facturé', FormatUtils.formatFcfa(client.totalFacture)),
                  const SizedBox(height: 6),
                  _FinanceRow('Total payé',
                      FormatUtils.formatFcfa(client.totalPaye),
                      valueColor: AppColors.success),
                  if (solde > 0) ...[
                    const Divider(height: 16),
                    _FinanceRow(
                        'Solde restant dû', FormatUtils.formatFcfa(solde),
                        valueColor: AppColors.danger, bold: true),
                  ],
                ]),
          ),
        ),

        if (client.notes != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy)),
                    const Divider(height: 16),
                    Text(client.notes!,
                        style: const TextStyle(color: Colors.grey)),
                  ]),
            ),
          ),
        ],
        const SizedBox(height: 80),
      ]),
    );
  }

  String _typeLabel(String t) {
    const labels = {
      'entreprise': 'Entreprise',
      'particulier': 'Particulier',
      'assurance': 'Compagnie d\'assurance',
      'armateur': 'Armateur',
    };
    return labels[t] ?? t;
  }
}

// ── Carte Contacts ───────────────────────────────────────────────────────────

class _ContactsCard extends ConsumerWidget {
  final String clientId;
  const _ContactsCard({required this.clientId});

  Future<void> _ouvrirFormulaire(BuildContext context, {ClientContact? contact}) {
    return showDialog(
      context: context,
      builder: (_) => ContactFormDialog(clientId: clientId, contact: contact),
    );
  }

  Future<void> _confirmerSuppression(BuildContext context, WidgetRef ref, ClientContact contact) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le contact'),
        content: Text('Voulez-vous vraiment supprimer "${contact.nom}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirme == true) {
      await ref.read(clientContactNotifierProvider.notifier).delete(clientId, contact.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(clientContactsProvider(clientId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(
                child: Text('Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              ),
              TextButton.icon(
                onPressed: () => _ouvrirFormulaire(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Ajouter'),
                style: TextButton.styleFrom(foregroundColor: AppColors.teal),
              ),
            ]),
            const Divider(height: 16),
            contactsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Erreur : $e'),
              data: (contacts) {
                if (contacts.isEmpty) {
                  return const Text('Aucun contact enregistré.',
                      style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: contacts
                      .map((c) => _ContactTile(
                            contact: c,
                            onEdit: () => _ouvrirFormulaire(context, contact: c),
                            onDelete: () => _confirmerSuppression(context, ref, c),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final ClientContact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ContactTile({required this.contact, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.person_outline, size: 18, color: AppColors.teal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(contact.nom, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (contact.fonction != null)
              Text(contact.fonction!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (contact.telephone != null)
              Text(contact.telephone!, style: const TextStyle(fontSize: 12)),
            if (contact.email != null)
              Text(contact.email!, style: const TextStyle(fontSize: 12)),
          ]),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: onEdit,
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
          onPressed: onDelete,
          visualDensity: VisualDensity.compact,
        ),
      ]),
    );
  }
}

// ── Onglet 2 : Dossiers ──────────────────────────────────────────────────────

class _DossiersTab extends ConsumerStatefulWidget {
  final String clientId;
  const _DossiersTab({required this.clientId});

  @override
  ConsumerState<_DossiersTab> createState() => _DossiersTabState();
}

class _DossiersTabState extends ConsumerState<_DossiersTab> {
  bool _enCoursOnly = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(dossiersByClientProvider(widget.clientId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (tous) {
        final enCours = tous
            .where((d) =>
                d.statut != AppConstants.statutClos &&
                d.statut != AppConstants.statutAnnule)
            .toList();
        final affiches = _enCoursOnly ? enCours : tous;

        return Column(children: [
          // Filtres
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(children: [
              _CountChip(
                label: 'Tous',
                count: tous.length,
                selected: !_enCoursOnly,
                onTap: () => setState(() => _enCoursOnly = false),
              ),
              const SizedBox(width: 8),
              _CountChip(
                label: 'En cours',
                count: enCours.length,
                selected: _enCoursOnly,
                color: AppColors.teal,
                onTap: () => setState(() => _enCoursOnly = true),
              ),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: affiches.isEmpty
                ? _EmptyState(
                    icon: Icons.folder_open_outlined,
                    message: _enCoursOnly
                        ? 'Aucun dossier en cours pour ce client.'
                        : 'Aucun dossier pour ce client.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: affiches.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, i) => _DossierTile(dossier: affiches[i]),
                  ),
          ),
        ]);
      },
    );
  }
}

class _DossierTile extends StatelessWidget {
  final Dossier dossier;
  const _DossierTile({required this.dossier});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.navy.withAlpha(15),
          child: const Icon(Icons.folder_outlined,
              color: AppColors.navy, size: 20),
        ),
        title: Text(dossier.numero ?? 'LOCAL',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dossier.natureSinistre != null)
                Text(dossier.natureSinistre!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
              Text(FormatUtils.formatDate(dossier.dateOuverture),
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
        trailing: StatusBadge(statut: dossier.statut),
        onTap: () => context.push('/dossiers/${dossier.id}'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// ── Onglet 3 : Factures ──────────────────────────────────────────────────────

class _FacturesTab extends ConsumerWidget {
  final String clientId;
  const _FacturesTab({required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(facturesByClientProvider(clientId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (factures) {
        if (factures.isEmpty) {
          return const _EmptyState(
            icon: Icons.receipt_long_outlined,
            message: 'Aucune facture pour ce client.',
          );
        }

        final payees = factures.where((f) => f.statut == 'payee').toList();
        final impayees = factures
            .where((f) => f.statut != 'payee' && f.statut != 'annulee')
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            // Résumé montants
            _FactureSummaryRow(payees: payees, impayees: impayees),
            const SizedBox(height: 20),

            // Impayées
            if (impayees.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.warning_amber_outlined,
                label: 'Impayées (${impayees.length})',
                color: AppColors.danger,
              ),
              const SizedBox(height: 8),
              ...impayees.map((f) => _FactureTile(facture: f)),
              const SizedBox(height: 16),
            ],

            // Payées
            if (payees.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.check_circle_outline,
                label: 'Payées (${payees.length})',
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              ...payees.map((f) => _FactureTile(facture: f)),
            ],
            const SizedBox(height: 80),
          ]),
        );
      },
    );
  }
}

class _FactureSummaryRow extends StatelessWidget {
  final List<Facture> payees;
  final List<Facture> impayees;
  const _FactureSummaryRow(
      {required this.payees, required this.impayees});

  @override
  Widget build(BuildContext context) {
    final totalPaye =
        payees.fold<double>(0, (s, f) => s + f.montantPaye);
    final totalDu =
        impayees.fold<double>(0, (s, f) => s + f.montantRestant);

    return Row(children: [
      Expanded(
        child: _SummaryCard(
          label: 'Encaissé',
          amount: totalPaye,
          color: Colors.green,
          icon: Icons.check_circle_outline,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _SummaryCard(
          label: 'À encaisser',
          amount: totalDu,
          color: impayees.isEmpty ? Colors.grey : AppColors.danger,
          icon: Icons.pending_outlined,
        ),
      ),
    ]);
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  const _SummaryCard(
      {required this.label,
      required this.amount,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        Text(
          FormatUtils.formatFcfa(amount),
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ]),
    );
  }
}

class _FactureTile extends StatelessWidget {
  final Facture facture;
  const _FactureTile({required this.facture});

  @override
  Widget build(BuildContext context) {
    final isPaye = facture.statut == 'payee';
    final isEnRetard = !isPaye &&
        facture.dateEcheance.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPaye
              ? Colors.green.withAlpha(25)
              : AppColors.gold.withAlpha(25),
          child: Icon(
            isPaye
                ? Icons.check_circle_outline
                : Icons.receipt_outlined,
            color: isPaye ? Colors.green : AppColors.gold,
            size: 20,
          ),
        ),
        title: Text(facture.numero ?? 'FAC-LOCAL',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (facture.objet != null)
                Text(facture.objet!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
              Text(
                isPaye
                    ? 'Payée le ${FormatUtils.formatDate(facture.datePaiement)}'
                    : 'Échéance : ${FormatUtils.formatDate(facture.dateEcheance)}',
                style: TextStyle(
                    fontSize: 11,
                    color: isEnRetard ? AppColors.danger : Colors.grey),
              ),
            ]),
        trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                FormatUtils.formatFcfa(facture.montantTtc),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (!isPaye && facture.montantPaye > 0)
                Text(
                  'Reste : ${FormatUtils.formatFcfa(facture.montantRestant)}',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.danger),
                ),
            ]),
        onTap: () => context.push('/factures/${facture.id}'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// ── Widgets utilitaires ──────────────────────────────────────────────────────

class _CountChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _CountChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.color = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: selected ? color : Colors.grey.shade300),
        ),
        child: Text(
          '$label  $count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 6),
      Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13, color: color)),
    ]);
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 52, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.teal),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const _FinanceRow(this.label, this.value,
      {this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  color: valueColor)),
        ]);
  }
}
