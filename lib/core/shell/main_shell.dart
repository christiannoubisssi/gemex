import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../features/auth/data/auth_provider.dart';
import '../network/connectivity_service.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Tableau de bord', route: '/'),
    _NavItem(icon: Icons.folder_outlined, label: 'Dossiers', route: '/dossiers'),
    _NavItem(icon: Icons.people_outlined, label: 'Clients', route: '/clients'),
    _NavItem(icon: Icons.description_outlined, label: 'Devis', route: '/devis'),
    _NavItem(icon: Icons.receipt_long_outlined, label: 'Factures', route: '/factures'),
    _NavItem(icon: Icons.account_balance_outlined, label: 'Comptabilité', route: '/comptabilite'),
    _NavItem(icon: Icons.people_alt_outlined, label: 'RH', route: '/rh'),
    _NavItem(icon: Icons.settings_outlined, label: 'Paramètres', route: '/parametres'),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
              title: const Text('AvarieApp'),
              actions: [
                if (!isOnline)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.cloud_off, color: Colors.orange),
                  ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => context.push('/profil'),
                ),
              ],
            ),
      drawer: isWide ? null : _buildDrawer(context),
      body: Column(
        children: [
          if (!isOnline) const _OfflineBanner(),
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      _buildNavigationRail(context),
                      const VerticalDivider(width: 1),
                      Expanded(child: widget.child),
                    ],
                  )
                : widget.child,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return SizedBox(
      width: 200,
      child: NavigationRail(
        backgroundColor: AppColors.navy,
        extended: true,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          context.go(_navItems[i].route);
        },
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.anchor, size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'AvarieApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white54),
                title: const Text('Déconnexion', style: TextStyle(color: Colors.white54, fontSize: 13)),
                onTap: () => _signOut(),
              ),
            ),
          ),
        ),
        destinations: _navItems
            .map((item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  label: Text(item.label),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.navy),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.anchor, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AvarieApp',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          for (final item in _navItems)
            ListTile(
              leading: Icon(item.icon, color: Colors.white70),
              title: Text(item.label, style: const TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context);
                context.go(item.route);
              },
            ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white54),
            title: const Text('Déconnexion', style: TextStyle(color: Colors.white54)),
            onTap: () => _signOut(),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!mounted) return;
    context.go('/login');
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.label, required this.route});
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF0A500),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Mode hors ligne — Les données seront synchronisées à la reconnexion',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
