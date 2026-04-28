import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          _SectionHeader('Mon compte'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Profil',
            subtitle: 'Nom, téléphone, mot de passe',
            onTap: () => context.push('/parametres/profil'),
          ),
          const Divider(height: 1),
          _SectionHeader('Entreprise'),
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
          const Divider(height: 1),
          _SectionHeader('Administration'),
          _SettingsTile(
            icon: Icons.people_outlined,
            title: 'Utilisateurs',
            subtitle: 'Gérer les accès et les rôles',
            onTap: () => context.push('/parametres/utilisateurs'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
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
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.navy),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
