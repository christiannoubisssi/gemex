import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_provider.dart';
import '../../data/user_management_service.dart';

class UtilisateursScreen extends ConsumerWidget {
  const UtilisateursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Inviter'),
        onPressed: () => _showInviteDialog(context, ref),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('Table profiles non configurée', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('$e', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => ref.invalidate(usersProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Aucun utilisateur', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(
                    'Invitez des collaborateurs via le bouton +',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final u = users[i];
              final isMe = u.id == currentUser?.id;
              return _UserTile(
                user: u,
                isMe: isMe,
                onRoleChanged: isMe
                    ? null
                    : (newRole) async {
                        await ref
                            .read(userManagementServiceProvider)
                            .updateRole(u.id, newRole);
                        ref.invalidate(usersProvider);
                      },
                onToggleActif: isMe
                    ? null
                    : () async {
                        await ref
                            .read(userManagementServiceProvider)
                            .toggleActif(u.id, !u.actif);
                        ref.invalidate(usersProvider);
                      },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context, WidgetRef ref) async {
    final emailCtrl = TextEditingController();
    final nomCtrl = TextEditingController();
    String role = 'agent';
    bool sending = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Inviter un collaborateur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: kRoles
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(kRoleLabels[r] ?? r),
                        ))
                    .toList(),
                onChanged: (v) => setS(() => role = v ?? role),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              icon: sending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send),
              label: const Text('Inviter'),
              onPressed: sending
                  ? null
                  : () async {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty) return;
                      setS(() => sending = true);
                      try {
                        await ref.read(userManagementServiceProvider).inviter(
                              email: email,
                              role: role,
                              nom: nomCtrl.text.trim().isEmpty ? null : nomCtrl.text.trim(),
                            );
                        ref.invalidate(usersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invitation envoyée à $email')),
                          );
                        }
                      } catch (e) {
                        setS(() => sending = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur : $e'),
                              backgroundColor: AppColors.danger,
                            ),
                          );
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserProfile user;
  final bool isMe;
  final void Function(String)? onRoleChanged;
  final VoidCallback? onToggleActif;

  const _UserTile({
    required this.user,
    required this.isMe,
    this.onRoleChanged,
    this.onToggleActif,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.actif ? AppColors.teal : Colors.grey,
        child: Text(
          (user.nom ?? user.email).substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Row(
        children: [
          Expanded(child: Text(user.nom ?? user.email)),
          if (isMe)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.teal.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('moi', style: TextStyle(fontSize: 10, color: AppColors.teal)),
            ),
        ],
      ),
      subtitle: Text(user.email, style: const TextStyle(fontSize: 12)),
      trailing: isMe
          ? _RoleBadge(role: user.role)
          : PopupMenuButton<String>(
              child: _RoleBadge(role: user.role),
              itemBuilder: (_) => [
                ...kRoles.map((r) => PopupMenuItem(
                      value: 'role_$r',
                      child: Text(kRoleLabels[r] ?? r),
                    )),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(
                    user.actif ? 'Désactiver' : 'Réactiver',
                    style: TextStyle(
                        color: user.actif ? AppColors.danger : AppColors.success),
                  ),
                ),
              ],
              onSelected: (v) {
                if (v == 'toggle') {
                  onToggleActif?.call();
                } else if (v.startsWith('role_')) {
                  onRoleChanged?.call(v.substring(5));
                }
              },
            ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.navy.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy.withAlpha(40)),
      ),
      child: Text(
        kRoleLabels[role] ?? role,
        style: const TextStyle(
            fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.w600),
      ),
    );
  }
}
