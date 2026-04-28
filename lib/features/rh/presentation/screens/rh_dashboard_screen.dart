import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/personnel_provider.dart';

class RhDashboardScreen extends ConsumerWidget {
  const RhDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personnelAsync = ref.watch(personnelListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ressources humaines')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          personnelAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => const SizedBox.shrink(),
            data: (list) => _StatsCard(count: list.length),
          ),
          const SizedBox(height: 16),
          const _SectionHeader('Gestion'),
          _NavTile(
            icon: Icons.people_outlined,
            title: 'Personnel',
            subtitle: 'Liste des employés actifs',
            onTap: () => context.push('/rh/personnel'),
          ),
          _NavTile(
            icon: Icons.beach_access_outlined,
            title: 'Congés',
            subtitle: 'Demandes et planning',
            onTap: () => context.push('/rh/conges'),
          ),
          const SizedBox(height: 8),
          const _SectionHeader('Paie'),
          _NavTile(
            icon: Icons.payments_outlined,
            title: 'Traitement de la paie',
            subtitle: 'Saisie, validation et paiement',
            onTap: () => context.push('/paie'),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int count;
  const _StatsCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.people, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('Employés actifs',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: AppColors.teal,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0),
        ),
      );
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _NavTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: AppColors.navy),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
