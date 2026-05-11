import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../../core/utils/demo_data.dart';
import '../../../parametres/data/user_management_service.dart';

class ParametresScreen extends ConsumerWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final isAdmin = role == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader('Mon compte'),
            const SizedBox(height: 12),
            _SettingsGrid(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Profil',
                  subtitle: 'Nom, téléphone, mot de passe',
                  onTap: () => context.push('/parametres/profil'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Entreprise'),
            const SizedBox(height: 12),
            _SettingsGrid(
              children: [
                _SettingsTile(
                  icon: Icons.business_outlined,
                  title: 'Informations entreprise',
                  subtitle: 'Nom, adresse, RCCM, NIF',
                  onTap: () => context.push('/parametres/entreprise'),
                ),
                _SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mise en page documents',
                  subtitle: 'En-tête, pied de page, mentions légales',
                  onTap: () => context.push('/parametres/documents'),
                ),
                _SettingsTile(
                  icon: Icons.percent_outlined,
                  title: 'Fiscalité',
                  subtitle: 'TVA, TPS, devise',
                  onTap: () => context.push('/parametres/fiscalite'),
                ),
                _SettingsTile(
                  icon: Icons.category_outlined,
                  title: 'Types de mission',
                  subtitle: 'Configurer les catégories de dossiers',
                  onTap: () => context.push('/parametres/types-mission'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Administration & Sécurité'),
            const SizedBox(height: 12),
            _SettingsGrid(
              children: [
                _SettingsTile(
                  icon: Icons.people_outlined,
                  title: 'Utilisateurs',
                  subtitle: 'Gérer les accès et les rôles',
                  onTap: () => context.push('/parametres/utilisateurs'),
                ),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Sécurité des documents',
                  subtitle: 'QR d\'authenticité, signature, filigrane',
                  onTap: () => context.push('/parametres/securite'),
                ),
                _SettingsTile(
                  icon: Icons.qr_code_scanner_outlined,
                  title: 'Scanner QR',
                  subtitle: 'Vérifier l\'authenticité d\'un document',
                  onTap: () => context.push('/securite/scanner'),
                ),
              ],
            ),

            // ─── Section Données — visible uniquement pour les admins ─────
            if (isAdmin) ...[
              const SizedBox(height: 24),
              const _SectionHeader('Données de démonstration'),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.navy.withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.navy.withAlpha(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.admin_panel_settings_outlined,
                            size: 16, color: AppColors.navy.withAlpha(150)),
                        const SizedBox(width: 6),
                        Text(
                          'Accès administrateur uniquement',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.navy.withAlpha(150),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SettingsGrid(
                      children: [
                        _SettingsTile(
                          icon: Icons.dataset_outlined,
                          title: 'Générer les données démo',
                          subtitle: 'Clients, dossiers, devis, factures, RH et paie inter-connectés',
                          onTap: () => _handleSeedData(context),
                        ),
                        _SettingsTile(
                          icon: Icons.delete_sweep_outlined,
                          title: 'Supprimer toutes les données',
                          subtitle: 'Vider entièrement la base locale',
                          color: AppColors.danger,
                          onTap: () => _handleDeleteAll(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleSeedData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Générer les données démo ?'),
        content: const Text(
          'Génère un jeu de données complet :\n'
          '• 6 clients (assureurs, particulier, industriel)\n'
          '• 6 dossiers (tous statuts du workflow)\n'
          '• 5 devis (acceptés, envoyé, brouillon, refusé)\n'
          '• 3 factures (payée, envoyée, en retard)\n'
          '• 8 charges (opérationnelles + liées aux dossiers)\n'
          '• 4 employés avec salaires du mois en cours\n\n'
          'Les données existantes ne seront pas écrasées.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Générer'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DemoData.seedAll(AppDatabase.instance);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Données de démonstration générées avec succès'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erreur : $e'),
                backgroundColor: AppColors.danger),
          );
        }
      }
    }
  }

  Future<void> _handleDeleteAll(BuildContext context) async {
    // Double confirmation pour une action destructrice
    final step1 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer toutes les données ?'),
        content: const Text(
          'Cette action supprimera TOUTES les données locales :\n'
          'clients, dossiers, devis, factures, charges, personnel, salaires…\n\n'
          'Cette opération est irréversible.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
    if (step1 != true || !context.mounted) return;

    final step2 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            SizedBox(width: 8),
            Text('Dernière confirmation'),
          ],
        ),
        content: const Text('Confirmez-vous la suppression définitive de toutes les données ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Non, annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Oui, tout supprimer'),
          ),
        ],
      ),
    );
    if (step2 != true || !context.mounted) return;

    try {
      await DemoData.deleteAll(AppDatabase.instance);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Base de données vidée'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur : $e'),
              backgroundColor: AppColors.danger),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppColors.teal,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (color ?? AppColors.primary).withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color ?? AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGrid extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: children,
        );
      },
    );
  }
}
