import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  // Dépend du stream d'auth → recompute à chaque changement de session
  ref.watch(authStateProvider);
  return Supabase.instance.client.auth.currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.signOut();
    });
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
    });
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});
