import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';
import '../../../../shared/services/dossier_documents_service.dart';
import '../../../clients/presentation/providers/client_provider.dart';
import '../../../devis/presentation/providers/devis_provider.dart';
import '../../../factures/presentation/providers/facture_provider.dart';
import '../providers/dossier_provider.dart';
import '../widgets/status_badge.dart';

class DossierDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const DossierDetailScreen({super.key, required this.id});

  @override
  ConsumerState<DossierDetailScreen> createState() => _DossierDetailScreenState();
}

class _DossierDetailScreenState extends ConsumerState<DossierDetailScreen>
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
    final async = ref.watch(dossierDetailProvider(widget.id));

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Dossier')),
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (dossier) {
        if (dossier == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Dossier')),
            body: const Center(child: Text('Dossier introuvable')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(dossier.numero ?? 'Dossier'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/dossiers/${dossier.id}/edit'),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline, size: 18), text: 'Résumé'),
                Tab(icon: Icon(Icons.description_outlined, size: 18), text: 'Documents'),
                Tab(icon: Icon(Icons.receipt_outlined, size: 18), text: 'Devis & Facture'),
              ],
            ),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ResumeTab(dossier: dossier),
                    _DocumentsTab(dossier: dossier),
                    _DevisFactureTab(dossier: dossier),
                  ],
                ),
              ),
              if (MediaQuery.of(context).size.width >= 800)
                Container(
                  width: 280,
                  decoration: const BoxDecoration(
                    color: AppColors.pageBg,
                    border: Border(left: BorderSide(color: AppColors.borderLight)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Actions Rapides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/dossiers/${dossier.id}/edit'),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Modifier le dossier'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.bar_chart_outlined),
                          label: const Text('Voir statistiques'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/dossiers/${dossier.id}/pieces-jointes'),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Gérer les pièces'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ── Onglet 1 : Résumé ────────────────────────────────────────────────────────

class _ResumeTab extends ConsumerWidget {
  final Dossier dossier;
  const _ResumeTab({required this.dossier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextStatut = AppConstants.nextStatut[dossier.statut];
    final peutAnnuler = dossier.statut != AppConstants.statutClos &&
        dossier.statut != AppConstants.statutAnnule;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // En-tête
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                StatusBadge(statut: dossier.statut),
                const SizedBox(width: 8),
                PrioriteBadge(priorite: dossier.priorite),
                if (dossier.numero != null && dossier.numero!.contains('LOCAL')) ...[
                  const SizedBox(width: 8),
                  const SyncBadge(),
                ],
              ]),
              const SizedBox(height: 12),
              Text(dossier.titre,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (dossier.description != null) ...[
                const SizedBox(height: 8),
                Text(dossier.description!, style: const TextStyle(color: Colors.grey)),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Workflow
        if (nextStatut != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: Text('Passer à : ${AppConstants.statutLabels[nextStatut]}'),
              onPressed: () => _confirmerChangementStatut(context, ref, dossier.id, nextStatut),
            ),
          ),
        if (peutAnnuler) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
              label: const Text('Annuler ce dossier',
                  style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger)),
              onPressed: () => _confirmerAnnulation(context, ref, dossier.id),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Client lié
        if (dossier.clientId != null)
          _ClientSection(clientId: dossier.clientId!),

        // Infos sinistre
        _Section(title: 'Informations sinistre', icon: Icons.info_outline, children: [
          _InfoRow('Date du sinistre', FormatUtils.formatDate(dossier.dateSinistre)),
          _InfoRow('Lieu', dossier.lieuSinistre),
          _InfoRow('Nature', dossier.natureSinistre),
          if (dossier.montantSinistre != null)
            _InfoRow('Montant déclaré', FormatUtils.formatFcfa(dossier.montantSinistre)),
        ]),

        // Assurance
        if (dossier.compagnieAssurance != null || dossier.numeroPolice != null)
          _Section(title: 'Assurance', icon: Icons.shield_outlined, children: [
            _InfoRow('Compagnie', dossier.compagnieAssurance),
            _InfoRow('N° police', dossier.numeroPolice),
            _InfoRow('Courtier', dossier.courtier),
          ]),

        // Dates clés
        _Section(title: 'Dates clés', icon: Icons.calendar_today_outlined, children: [
          _InfoRow('Ouverture', FormatUtils.formatDate(dossier.dateOuverture)),
          _InfoRow('Expertise', FormatUtils.formatDate(dossier.dateExpertise)),
          _InfoRow('Rapport', FormatUtils.formatDate(dossier.dateRapport)),
          _InfoRow('Clôture', FormatUtils.formatDate(dossier.dateCloture)),
          if (dossier.deadline != null)
            _InfoRow('Échéance', FormatUtils.formatDate(dossier.deadline),
                highlight: dossier.deadline!.isBefore(DateTime.now())),
        ]),

        // Notes internes
        if (dossier.notesInternes != null)
          _Section(title: 'Notes internes', icon: Icons.note_outlined, children: [
            Text(dossier.notesInternes!,
                style: const TextStyle(color: Colors.grey)),
          ]),

        // Pièces jointes
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.attach_file_outlined),
            label: const Text('Pièces jointes'),
            onPressed: () =>
                context.push('/dossiers/${dossier.id}/pieces-jointes'),
          ),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }

  Future<void> _confirmerChangementStatut(
      BuildContext context, WidgetRef ref, String id, String nouveauStatut) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer le changement'),
        content: Text(
            'Passer le dossier au statut "${AppConstants.statutLabels[nouveauStatut]}" ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmer')),
        ],
      ),
    );
    if (confirm != true) return;
    await ref
        .read(dossierNotifierProvider.notifier)
        .changerStatut(id, nouveauStatut);
  }

  Future<void> _confirmerAnnulation(
      BuildContext context, WidgetRef ref, String id) async {
    final motifController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Annuler le dossier'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Cette action est irréversible.'),
          const SizedBox(height: 16),
          TextField(
            controller: motifController,
            decoration: const InputDecoration(
                labelText: 'Motif d\'annulation (obligatoire)'),
            maxLines: 2,
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Retour')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Annuler le dossier'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(dossierNotifierProvider.notifier).changerStatut(
          id,
          AppConstants.statutAnnule,
          motif: motifController.text,
        );
  }
}

// ── Onglet 2 : Documents professionnels ──────────────────────────────────────

class _DocumentsTab extends StatelessWidget {
  final Dossier dossier;
  const _DocumentsTab({required this.dossier});

  static const _docs = [
    (
      type: TypeDocumentMetier.ordreMission,
      icon: Icons.assignment_outlined,
      color: AppColors.navy,
    ),
    (
      type: TypeDocumentMetier.lettreMission,
      icon: Icons.mail_outlined,
      color: AppColors.teal,
    ),
    (
      type: TypeDocumentMetier.ficheConstatation,
      icon: Icons.checklist_outlined,
      color: AppColors.gold,
    ),
    (
      type: TypeDocumentMetier.rapportPrelim,
      icon: Icons.article_outlined,
      color: AppColors.teal,
    ),
    (
      type: TypeDocumentMetier.rapportExpertise,
      icon: Icons.find_in_page_outlined,
      color: AppColors.navy,
    ),
    (
      type: TypeDocumentMetier.pvConstatation,
      icon: Icons.gavel_outlined,
      color: AppColors.danger,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _docs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final doc = _docs[i];
        return _DocumentCard(
          type: doc.type,
          icon: doc.icon,
          color: doc.color,
          dossier: dossier,
        );
      },
    );
  }
}

class _DocumentCard extends StatefulWidget {
  final TypeDocumentMetier type;
  final IconData icon;
  final Color color;
  final Dossier dossier;
  const _DocumentCard({
    required this.type,
    required this.icon,
    required this.color,
    required this.dossier,
  });

  @override
  State<_DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<_DocumentCard> {
  bool _generating = false;

  Future<void> _generer() async {
    setState(() => _generating = true);
    try {
      await DossierDocumentsService.previsualiser(
        type: widget.type,
        dossier: widget.dossier,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur génération PDF : $e'),
              backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.color.withAlpha(25),
          child: Icon(widget.icon, color: widget.color, size: 22),
        ),
        title: Text(
          widget.type.label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          widget.type.description,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: _generating
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton.icon(
                onPressed: _generer,
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                label: const Text('Générer'),
                style: TextButton.styleFrom(foregroundColor: AppColors.navy),
              ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

// ── Onglet 3 : Devis & Facture ───────────────────────────────────────────────

class _DevisFactureTab extends ConsumerWidget {
  final Dossier dossier;
  const _DevisFactureTab({required this.dossier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devisAsync =
        ref.watch(devisListProvider({'dossierId': dossier.id}));
    final facturesAsync =
        ref.watch(facturesByDossierProvider(dossier.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── Section Devis ────────────────────────────────────────────────
        _SectionHeader(
          title: 'Devis',
          icon: Icons.description_outlined,
          action: TextButton.icon(
            onPressed: () =>
                context.push('/devis/new?dossierId=${dossier.id}'),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Nouveau devis'),
          ),
        ),
        devisAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur : $e',
              style: const TextStyle(color: AppColors.danger)),
          data: (liste) => liste.isEmpty
              ? _EmptyCard(
                  message: 'Aucun devis pour ce dossier.',
                  action: 'Créer un devis',
                  onTap: () =>
                      context.push('/devis/new?dossierId=${dossier.id}'),
                )
              : Column(
                  children: liste
                      .map((d) => _DevisCard(devis: d))
                      .toList(),
                ),
        ),

        const SizedBox(height: 24),

        // ── Section Factures ─────────────────────────────────────────────
        const _SectionHeader(
          title: 'Factures',
          icon: Icons.receipt_outlined,
        ),
        facturesAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur : $e',
              style: const TextStyle(color: AppColors.danger)),
          data: (liste) => liste.isEmpty
              ? const _EmptyCard(
                  message:
                      'Aucune facture. Les factures sont générées depuis un devis.',
                )
              : Column(
                  children: liste
                      .map((f) => _FactureCard(facture: f))
                      .toList(),
                ),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? action;
  const _SectionHeader(
      {required this.title, required this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.teal),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.navy)),
        const Spacer(),
        if (action != null) action!,
      ]),
    );
  }
}

class _DevisCard extends ConsumerWidget {
  final Devi devis;
  const _DevisCard({required this.devis});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statut = devis.statut;
    final couleur = _devisStatutCouleur(statut);
    final label = _devisStatutLabel(statut);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.teal.withAlpha(25),
          child:
              const Icon(Icons.description_outlined, color: AppColors.teal),
        ),
        title: Text(devis.numero ?? 'DEV-LOCAL',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (devis.objet != null)
                Text(devis.objet!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
              Text(
                  '${FormatUtils.formatFcfa(devis.montantTtc)} TTC — ${FormatUtils.formatDate(devis.dateEmission)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
        trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: couleur.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: couleur,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            ]),
        onTap: () => context.push('/devis/${devis.id}'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Color _devisStatutCouleur(String s) {
    switch (s) {
      case 'accepte':
        return Colors.green;
      case 'refuse':
        return AppColors.danger;
      case 'envoye':
        return AppColors.teal;
      default:
        return Colors.orange;
    }
  }

  String _devisStatutLabel(String s) {
    switch (s) {
      case 'brouillon':
        return 'Brouillon';
      case 'envoye':
        return 'Envoyé';
      case 'accepte':
        return 'Accepté';
      case 'refuse':
        return 'Refusé';
      default:
        return s;
    }
  }
}

class _FactureCard extends StatelessWidget {
  final Facture facture;
  const _FactureCard({required this.facture});

  @override
  Widget build(BuildContext context) {
    final statut = facture.statut;
    final couleur = _factureStatutCouleur(statut);
    final label = _factureStatutLabel(statut);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.gold.withAlpha(25),
          child: const Icon(Icons.receipt_outlined, color: AppColors.gold),
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
                  '${FormatUtils.formatFcfa(facture.montantTtc)} TTC — échéance ${FormatUtils.formatDate(facture.dateEcheance)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
        trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: couleur.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: couleur,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            ]),
        onTap: () => context.push('/factures/${facture.id}'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Color _factureStatutCouleur(String s) {
    switch (s) {
      case 'payee':
        return Colors.green;
      case 'en_retard':
        return AppColors.danger;
      case 'envoyee':
        return AppColors.teal;
      case 'annulee':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _factureStatutLabel(String s) {
    switch (s) {
      case 'brouillon':
        return 'Brouillon';
      case 'envoyee':
        return 'Envoyée';
      case 'payee':
        return 'Payée';
      case 'en_retard':
        return 'En retard';
      case 'annulee':
        return 'Annulée';
      default:
        return s;
    }
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final String? action;
  final VoidCallback? onTap;
  const _EmptyCard({required this.message, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text(message,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center),
          if (action != null && onTap != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onTap, child: Text(action!)),
          ],
        ]),
      ),
    );
  }
}

// ── Widgets partagés ─────────────────────────────────────────────────────────

class _ClientSection extends ConsumerWidget {
  final String clientId;
  const _ClientSection({required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(clientDetailProvider(clientId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (client) {
        if (client == null) return const SizedBox.shrink();
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.teal.withAlpha(25),
              child: Text(
                client.nom.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                    color: AppColors.teal, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(client.nom,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              [
                _typeLabel(client.typeClient),
                if (client.ville != null) client.ville!,
                if (client.telephone != null) client.telephone!,
              ].join(' — '),
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => context.push('/clients/${client.id}'),
          ),
        );
      },
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'entreprise': return 'Entreprise';
      case 'particulier': return 'Particulier';
      case 'assurance': return 'Assurance';
      case 'armateur': return 'Armateur';
      default: return t;
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _Section(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 18, color: AppColors.teal),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
          ]),
          const Divider(height: 16),
          ...children,
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool highlight;
  const _InfoRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    if (value == null || value == '—') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Text(value!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: highlight ? AppColors.danger : null,
              )),
        ),
      ]),
    );
  }
}
