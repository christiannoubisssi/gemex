import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_provider.dart';
import '../../data/user_management_service.dart';

// Hiérarchie de rôles — plus le score est élevé, plus le rôle est privilégié
const _kRoleScore = {
  'agent': 0,
  'rh': 1,
  'expert': 2,
  'comptable': 3,
  'admin': 4,
};

/// Rôles vers lesquels on peut promouvoir depuis un rôle donné
List<String> _promotionTargets(String currentRole) {
  final score = _kRoleScore[currentRole] ?? 0;
  return kRoles.where((r) => (_kRoleScore[r] ?? 0) > score).toList();
}

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
              const Text('Table profiles non configurée',
                  style: TextStyle(color: Colors.grey)),
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
                onEdit: isMe ? null : () => _showEditDialog(context, ref, u),
                onSetPassword: isMe
                    ? null
                    : () => _showPasswordDialog(context, ref, u),
                onPromote: isMe || _promotionTargets(u.role).isEmpty
                    ? null
                    : () => _showPromoteDialog(context, ref, u),
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

  // ─── Dialogue : Inviter un utilisateur ──────────────────────────────────

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
          content: SingleChildScrollView(
            child: Column(
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
                  value: role,
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
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
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
                              nom: nomCtrl.text.trim().isEmpty
                                  ? null
                                  : nomCtrl.text.trim(),
                            );
                        ref.invalidate(usersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Invitation envoyée à $email')),
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

  // ─── Dialogue : Modifier le profil ──────────────────────────────────────

  Future<void> _showEditDialog(
      BuildContext context, WidgetRef ref, UserProfile user) async {
    final nomCtrl = TextEditingController(text: user.nom ?? '');
    bool saving = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text('Modifier ${user.nom ?? user.email}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Enregistrer'),
              onPressed: saving
                  ? null
                  : () async {
                      final nom = nomCtrl.text.trim();
                      if (nom.isEmpty) return;
                      setS(() => saving = true);
                      try {
                        await ref
                            .read(userManagementServiceProvider)
                            .updateUserProfile(userId: user.id, nom: nom);
                        ref.invalidate(usersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profil mis à jour')),
                          );
                        }
                      } catch (e) {
                        setS(() => saving = false);
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

  // ─── Dialogue : Définir / changer le mot de passe ───────────────────────

  Future<void> _showPasswordDialog(
      BuildContext context, WidgetRef ref, UserProfile user) async {
    final pwCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscure = true;
    bool saving = false;
    String? error;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text('Mot de passe — ${user.nom ?? user.email}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pwCtrl,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe *',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setS(() => obscure = !obscure),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: obscure,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe *',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!,
                    style: const TextStyle(
                        color: AppColors.danger, fontSize: 12)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.key_outlined),
              label: const Text('Définir'),
              onPressed: saving
                  ? null
                  : () async {
                      final pw = pwCtrl.text;
                      if (pw.length < 8) {
                        setS(() => error =
                            'Le mot de passe doit contenir au moins 8 caractères');
                        return;
                      }
                      if (pw != confirmCtrl.text) {
                        setS(() =>
                            error = 'Les mots de passe ne correspondent pas');
                        return;
                      }
                      setS(() {
                        error = null;
                        saving = true;
                      });
                      try {
                        await ref
                            .read(userManagementServiceProvider)
                            .setPassword(userId: user.id, password: pw);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Mot de passe défini avec succès')),
                          );
                        }
                      } catch (e) {
                        setS(() {
                          error = e.toString();
                          saving = false;
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Dialogue : Promouvoir vers une fonction supérieure ─────────────────

  Future<void> _showPromoteDialog(
      BuildContext context, WidgetRef ref, UserProfile user) async {
    final targets = _promotionTargets(user.role);
    String selectedRole = targets.first;
    bool saving = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text('Promouvoir ${user.nom ?? user.email}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Rôle actuel : ',
                      style: TextStyle(fontSize: 13)),
                  _RoleBadge(role: user.role),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Nouveau rôle :',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              ...targets.map((r) => RadioListTile<String>(
                    value: r,
                    groupValue: selectedRole,
                    title: Row(
                      children: [
                        Text(kRoleLabels[r] ?? r,
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 8),
                        _RoleBadge(role: r),
                      ],
                    ),
                    onChanged: (v) => setS(() => selectedRole = v ?? selectedRole),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withAlpha(60)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: AppColors.warning),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ce changement modifie les accès de l\'utilisateur immédiatement.',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.arrow_upward),
              label: const Text('Promouvoir'),
              onPressed: saving
                  ? null
                  : () async {
                      setS(() => saving = true);
                      try {
                        await ref
                            .read(userManagementServiceProvider)
                            .updateUserProfile(
                                userId: user.id, role: selectedRole);
                        ref.invalidate(usersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${user.nom ?? user.email} → ${kRoleLabels[selectedRole] ?? selectedRole}')),
                          );
                        }
                      } catch (e) {
                        setS(() => saving = false);
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

// ─── Tuile utilisateur ────────────────────────────────────────────────────

class _UserTile extends StatelessWidget {
  final UserProfile user;
  final bool isMe;
  final VoidCallback? onEdit;
  final VoidCallback? onSetPassword;
  final VoidCallback? onPromote;
  final VoidCallback? onToggleActif;

  const _UserTile({
    required this.user,
    required this.isMe,
    this.onEdit,
    this.onSetPassword,
    this.onPromote,
    this.onToggleActif,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.actif ? AppColors.teal : Colors.grey,
        child: Text(
          (user.nom ?? user.email).substring(0, 1).toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
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
              child: const Text('moi',
                  style:
                      TextStyle(fontSize: 10, color: AppColors.teal)),
            ),
          if (!user.actif)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.danger.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Inactif',
                  style: TextStyle(
                      fontSize: 10,
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      subtitle: Text(user.email,
          style: const TextStyle(fontSize: 12)),
      trailing: isMe
          ? _RoleBadge(role: user.role)
          : PopupMenuButton<String>(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RoleBadge(role: user.role),
                  const Icon(Icons.more_vert,
                      size: 16, color: AppColors.textMuted),
                ],
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Modifier le profil'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'password',
                  child: ListTile(
                    leading: Icon(Icons.key_outlined),
                    title: Text('Définir le mot de passe'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                if (_promotionTargets(user.role).isNotEmpty)
                  const PopupMenuItem(
                    value: 'promote',
                    child: ListTile(
                      leading: Icon(Icons.arrow_upward,
                          color: AppColors.success),
                      title: Text('Promouvoir',
                          style: TextStyle(color: AppColors.success)),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'toggle',
                  child: ListTile(
                    leading: Icon(
                      user.actif
                          ? Icons.block_outlined
                          : Icons.check_circle_outline,
                      color: user.actif
                          ? AppColors.danger
                          : AppColors.success,
                    ),
                    title: Text(
                      user.actif ? 'Désactiver' : 'Réactiver',
                      style: TextStyle(
                          color: user.actif
                              ? AppColors.danger
                              : AppColors.success),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (v) {
                switch (v) {
                  case 'edit':
                    onEdit?.call();
                  case 'password':
                    onSetPassword?.call();
                  case 'promote':
                    onPromote?.call();
                  case 'toggle':
                    onToggleActif?.call();
                }
              },
            ),
    );
  }
}

// ─── Badge rôle ──────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  static const _colors = {
    'admin': AppColors.primary,
    'expert': AppColors.emerald,
    'comptable': Color(0xFF6366F1),
    'rh': Color(0xFFEC4899),
    'agent': Color(0xFF64748B),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[role] ?? AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        kRoleLabels[role] ?? role,
        style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
