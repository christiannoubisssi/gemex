import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../features/auth/data/auth_provider.dart';
import '../../features/parametres/data/user_management_service.dart';
import '../network/connectivity_service.dart';

class _NavItemDef {
  final IconData icon;
  final String label;
  final String route;
  final Set<String> roles;
  const _NavItemDef({
    required this.icon,
    required this.label,
    required this.route,
    required this.roles,
  });
}

const _allNavDefs = [
  _NavItemDef(
    icon: Icons.dashboard_outlined,
    label: 'Tableau de bord',
    route: '/',
    roles: {'admin', 'expert', 'agent', 'comptable', 'rh'},
  ),
  _NavItemDef(
    icon: Icons.folder_outlined,
    label: 'Dossiers',
    route: '/dossiers',
    roles: {'admin', 'expert', 'agent', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.people_outlined,
    label: 'Clients',
    route: '/clients',
    roles: {'admin', 'expert', 'agent', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.description_outlined,
    label: 'Devis',
    route: '/devis',
    roles: {'admin', 'expert', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.receipt_long_outlined,
    label: 'Factures',
    route: '/factures',
    roles: {'admin', 'expert', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.account_balance_outlined,
    label: 'Comptabilité',
    route: '/comptabilite',
    roles: {'admin', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.people_alt_outlined,
    label: 'RH',
    route: '/rh',
    roles: {'admin', 'rh', 'comptable'},
  ),
  _NavItemDef(
    icon: Icons.settings_outlined,
    label: 'Paramètres',
    route: '/parametres',
    roles: {'admin'},
  ),
];

List<_NavItemDef> _itemsForRole(String role) =>
    _allNavDefs.where((item) => item.roles.contains(role)).toList();

int _selectedIndex(List<_NavItemDef> items, String path) {
  for (int i = 0; i < items.length; i++) {
    final route = items[i].route;
    if (route == '/') {
      if (path == '/' || path.isEmpty) return i;
    } else if (path.startsWith(route)) {
      return i;
    }
  }
  return 0;
}

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    final isWide = MediaQuery.of(context).size.width >= 1024;
    final profileAsync = ref.watch(currentProfileProvider);
    final role = profileAsync.valueOrNull?.role ?? 'agent';
    final items = _itemsForRole(role);
    final path = GoRouterState.of(context).uri.path;
    final selIdx = _selectedIndex(items, path).clamp(0, items.isEmpty ? 0 : items.length - 1);

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
      drawer: isWide ? null : _buildDrawer(context, items, profileAsync),
      body: Column(
        children: [
          if (!isOnline) const _OfflineBanner(),
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      _buildNavigationRail(context, items, selIdx, profileAsync),
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

  Widget _buildNavigationRail(
    BuildContext context,
    List<_NavItemDef> items,
    int selIdx,
    AsyncValue<UserProfile?> profileAsync,
  ) {
    return SizedBox(
      width: 200,
      child: NavigationRail(
        backgroundColor: AppColors.navy,
        extended: true,
        selectedIndex: selIdx,
        onDestinationSelected: (i) => context.go(items[i].route),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.anchor, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Gamis',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              profileAsync.when(
                data: (p) => p != null
                    ? _RoleBadge(role: p.role, nom: p.nom ?? p.email)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white38),
                ),
                error: (_, __) => const SizedBox.shrink(),
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
                title: const Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                onTap: _signOut,
              ),
            ),
          ),
        ),
        destinations: items
            .map((item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  label: Text(item.label),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    List<_NavItemDef> items,
    AsyncValue<UserProfile?> profileAsync,
  ) {
    return Drawer(
      child: Container(
        color: AppColors.navy,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.navy),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.anchor, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Gamis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  profileAsync.when(
                    data: (p) => p != null
                        ? _RoleBadge(role: p.role, nom: p.nom ?? p.email)
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white38),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            for (final item in items)
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
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!mounted) return;
    context.go('/login');
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  final String nom;
  const _RoleBadge({required this.role, required this.nom});

  static const _roleColors = {
    'admin': AppColors.primary,
    'expert': AppColors.emerald,
    'comptable': Color(0xFF6366F1), // Indigo
    'rh': Color(0xFFEC4899), // Pink
    'agent': Color(0xFF64748B), // Slate
  };

  static const _roleLabels = {
    'admin': 'Admin',
    'expert': 'Expert',
    'comptable': 'Comptable',
    'rh': 'RH',
    'agent': 'Agent',
  };

  @override
  Widget build(BuildContext context) {
    final color = _roleColors[role] ?? const Color(0xFF607D8B);
    final label = _roleLabels[role] ?? role;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nom,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withAlpha(140), width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
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
