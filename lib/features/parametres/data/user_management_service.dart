import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/data/auth_provider.dart';

final userManagementServiceProvider =
    Provider<UserManagementService>((ref) => UserManagementService());

class UserProfile {
  final String id;
  final String email;
  final String? nom;
  final String role;
  final bool actif;

  const UserProfile({
    required this.id,
    required this.email,
    this.nom,
    required this.role,
    required this.actif,
  });

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        email: m['email'] as String,
        nom: m['nom'] as String?,
        role: m['role'] as String? ?? 'agent',
        actif: m['actif'] as bool? ?? true,
      );
}

const kRoles = ['admin', 'expert', 'agent', 'comptable', 'rh'];

const kRoleLabels = {
  'admin': 'Administrateur',
  'expert': 'Expert',
  'agent': 'Agent',
  'comptable': 'Comptable',
  'rh': 'RH',
};

class UserManagementService {
  final _client = Supabase.instance.client;

  Future<List<UserProfile>> getAll() async {
    final data = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => UserProfile.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> inviter({
    required String email,
    required String role,
    String? nom,
  }) async {
    await _client.functions.invoke(
      'invite-user',
      body: {'email': email, 'role': role, if (nom != null) 'nom': nom},
    );
  }

  Future<void> updateUserProfile({
    required String userId,
    String? nom,
    String? role,
  }) async {
    await _client.functions.invoke(
      'update-user',
      body: {
        'userId': userId,
        if (nom != null) 'nom': nom,
        if (role != null) 'role': role,
      },
    );
  }

  Future<void> setPassword({
    required String userId,
    required String password,
  }) async {
    await _client.functions.invoke(
      'update-user',
      body: {'userId': userId, 'password': password},
    );
  }

  Future<void> updateRole(String userId, String newRole) async {
    await _client.from('profiles').update({'role': newRole}).eq('id', userId);
  }

  Future<void> toggleActif(String userId, bool actif) async {
    await _client.from('profiles').update({'actif': actif}).eq('id', userId);
  }
}

// Provider pour la liste des utilisateurs
final usersProvider = FutureProvider.autoDispose<List<UserProfile>>((ref) {
  return ref.read(userManagementServiceProvider).getAll();
});

// Profil de l'utilisateur connecté — avec cache SharedPreferences pour le mode offline
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  const cacheKey = 'current_profile_cache';
  try {
    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    final profile = UserProfile.fromMap(data);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      cacheKey,
      jsonEncode({
        'id': profile.id,
        'email': profile.email,
        'nom': profile.nom,
        'role': profile.role,
        'actif': profile.actif,
      }),
    );
    return profile;
  } catch (_) {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(cacheKey);
      if (raw != null) {
        return UserProfile.fromMap(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }
});

// Rôle courant — défaut 'agent' pendant le chargement
final currentRoleProvider = Provider<String>((ref) {
  return ref.watch(currentProfileProvider).valueOrNull?.role ?? 'agent';
});
