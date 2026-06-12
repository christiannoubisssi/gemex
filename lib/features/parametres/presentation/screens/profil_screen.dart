import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/text_formatters.dart';
import '../../../auth/data/auth_provider.dart';
import '../../data/user_management_service.dart';

class ProfilScreen extends ConsumerStatefulWidget {
  const ProfilScreen({super.key});
  @override
  ConsumerState<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends ConsumerState<ProfilScreen> {
  final _nomCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _initialesCtrl = TextEditingController();
  bool _saving = false;
  bool _savingInitiales = false;
  bool _changingPwd = false;
  bool _obscurePwd = true;
  bool _initialesLoaded = false;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _nomCtrl.text = user?.userMetadata?['full_name'] as String? ?? '';
    _telCtrl.text = user?.userMetadata?['phone'] as String? ?? '';
  }

  Future<void> _saveProfil() async {
    setState(() => _saving = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {
          'full_name': _nomCtrl.text.trim(),
          'phone': _telCtrl.text.trim(),
        }),
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profil mis à jour')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
    setState(() => _saving = false);
  }

  Future<void> _saveInitiales() async {
    setState(() => _savingInitiales = true);
    try {
      await ref
          .read(userManagementServiceProvider)
          .updateMyInitiales(_initialesCtrl.text.trim().toUpperCase());
      ref.invalidate(currentProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Initiales mises à jour')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
    setState(() => _savingInitiales = false);
  }

  Future<void> _changePassword() async {
    if (_pwdCtrl.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe : 8 caractères minimum')));
      return;
    }
    setState(() => _changingPwd = true);
    try {
      await Supabase.instance.client.auth
          .updateUser(UserAttributes(password: _pwdCtrl.text));
      _pwdCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Mot de passe modifié')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
    setState(() => _changingPwd = false);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _telCtrl.dispose();
    _pwdCtrl.dispose();
    _initialesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    if (profile != null && !_initialesLoaded) {
      _initialesCtrl.text = profile.initiales ?? '';
      _initialesLoaded = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.teal,
                    child: Text(
                      (user?.email?.substring(0, 1) ?? '?').toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(user?.email ?? '—',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Informations',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nomCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_outlined),
                label: const Text('Enregistrer le profil'),
                onPressed: _saving ? null : _saveProfil,
              ),
            ),
            const SizedBox(height: 32),
            const Text('Initiales',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 4),
            const Text(
              'Utilisées dans la numérotation des devis et factures.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: _initialesCtrl,
                    maxLength: 2,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      UpperCaseTextFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Initiales',
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ElevatedButton.icon(
                    icon: _savingInitiales
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
                    onPressed: _savingInitiales ? null : _saveInitiales,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Sécurité',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pwdCtrl,
              obscureText: _obscurePwd,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: const Icon(Icons.lock_outline),
                helperText: '8 caractères minimum',
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePwd ? Icons.visibility_off : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePwd = !_obscurePwd),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: _changingPwd
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.lock_reset_outlined),
                label: const Text('Changer le mot de passe'),
                onPressed: _changingPwd ? null : _changePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
