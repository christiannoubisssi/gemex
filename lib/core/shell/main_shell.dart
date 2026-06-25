import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../features/auth/data/auth_provider.dart';
import '../../features/parametres/data/parametres_provider.dart';
import '../../features/parametres/data/user_management_service.dart';
import '../../shared/services/sync_service.dart';
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
    icon: Icons.inventory_2_outlined,
    label: 'Produits',
    route: '/produits',
    roles: {'admin', 'comptable', 'expert'},
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
  SyncService? _syncService;

  @override
  void initState() {
    super.initState();
    // Démarrer le SyncService dès que l'utilisateur est connecté.
    // start() écoute isOnlineProvider et gère lui-même la connectivité.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncService = ref.read(syncServiceProvider);
      _syncService!.start();
    });
  }

  @override
  void dispose() {
    _syncService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    final isWide = MediaQuery.of(context).size.width >= 1024;
    final profileAsync = ref.watch(currentProfileProvider);
    final role = profileAsync.valueOrNull?.role ?? 'agent';
    final items = _itemsForRole(role);
    final path = GoRouterState.of(context).uri.path;
    final selIdx = _selectedIndex(items, path).clamp(0, items.isEmpty ? 0 : items.length - 1);

    final syncStatus = ref.watch(syncStatusProvider);

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
              title: const Text('AvarieApp'),
              actions: [
                // Indicateur de synchronisation
                _SyncIndicator(status: syncStatus, isOnline: isOnline),
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
                      _buildNavigationRail(context, items, selIdx, profileAsync, syncStatus, isOnline),
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

  /// Logo de l'entreprise (ou icône par défaut si non configuré)
  Widget _logoBox(double size, {required double iconSize}) {
    final logoBytes = ref.watch(logoBytesProvider).valueOrNull;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: logoBytes != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(logoBytes, fit: BoxFit.contain),
            )
          : Icon(Icons.anchor, size: iconSize, color: Colors.white),
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    List<_NavItemDef> items,
    int selIdx,
    AsyncValue<UserProfile?> profileAsync,
    SyncStatus syncStatus,
    bool isOnline,
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
                  _logoBox(36, iconSize: 20),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicateur de sync dans la sidebar
                  _SyncSidebarTile(status: syncStatus, isOnline: isOnline),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white54),
                    title: const Text(
                      'Déconnexion',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    onTap: _signOut,
                  ),
                ],
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
                      _logoBox(40, iconSize: 24),
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

/// Indicateur de sync dans la sidebar (mode wide).
class _SyncSidebarTile extends StatelessWidget {
  final SyncStatus status;
  final bool isOnline;
  const _SyncSidebarTile({required this.status, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const ListTile(
        leading: Icon(Icons.cloud_off, color: Colors.orange, size: 20),
        title: Text('Hors ligne',
            style: TextStyle(color: Colors.orange, fontSize: 12)),
        dense: true,
      );
    }
    if (status == SyncStatus.syncing) {
      return const ListTile(
        leading: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white38),
        ),
        title: Text('Synchronisation…',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        dense: true,
      );
    }
    if (status == SyncStatus.error) {
      return const ListTile(
        leading: Icon(Icons.sync_problem, color: Colors.redAccent, size: 20),
        title: Text('Erreur de sync',
            style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        dense: true,
      );
    }
    return const SizedBox.shrink();
  }
}

/// Icône dans l'AppBar indiquant l'état de la synchronisation.
class _SyncIndicator extends StatelessWidget {
  final SyncStatus status;
  final bool isOnline;
  const _SyncIndicator({required this.status, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Tooltip(
          message: 'Hors ligne',
          child: Icon(Icons.cloud_off, color: Colors.orange),
        ),
      );
    }
    switch (status) {
      case SyncStatus.syncing:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Tooltip(
            message: 'Synchronisation en cours…',
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        );
      case SyncStatus.error:
        return const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Erreur de synchronisation',
            child: Icon(Icons.sync_problem, color: Colors.redAccent),
          ),
        );
      case SyncStatus.idle:
      case SyncStatus.offline:
        return const SizedBox.shrink();
    }
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
