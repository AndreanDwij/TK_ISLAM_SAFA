import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';
import '../utils/storage.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isInitialized,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  bool get isLoggedIn => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final authUser = SupabaseService.currentAuthUser;
      if (authUser != null) {
        final profile = await SupabaseService.getProfile(authUser.id);
        if (profile != null) {
          state = AuthState(user: profile, isLoading: false, isInitialized: true);
          return;
        }
      }
      final localUser = await StorageService.getSession();
      state = AuthState(user: localUser, isLoading: false, isInitialized: true);
    } catch (e) {
      state = AuthState(error: 'Gagal memuat sesi', isLoading: false, isInitialized: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    if (email.trim().isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Email wajib diisi');
      return false;
    }

    if (password.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Password wajib diisi');
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      state = state.copyWith(isLoading: false, error: 'Format email tidak valid');
      return false;
    }

    if (password.length < 8) {
      state = state.copyWith(isLoading: false, error: 'Password minimal 8 karakter');
      return false;
    }

    try {
      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profile = await SupabaseService.getProfile(response.user!.id);
        if (profile != null) {
          await StorageService.saveSession(profile);
          state = AuthState(user: profile, isLoading: false, isInitialized: true);
          return true;
        }
      }

      state = state.copyWith(isLoading: false, error: 'Gagal memuat profil');
      return false;
    } catch (e) {
      String errorMessage = 'Login gagal';
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('invalid login credentials') ||
          errorStr.contains('invalid_credentials')) {
        errorMessage = 'Email atau password salah';
      } else if (errorStr.contains('email not confirmed')) {
        errorMessage = 'Email belum dikonfirmasi';
      } else if (errorStr.contains('too many requests')) {
        errorMessage = 'Terlalu banyak percobaan, coba lagi nanti';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await SupabaseService.signOut();
    } catch (_) {}
    await StorageService.clearSession();
    state = AuthState(isInitialized: true);
  }

  Future<void> updateProfile(User updatedUser) async {
    try {
      await SupabaseService.updateProfile(updatedUser);
      await StorageService.saveSession(updatedUser);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      state = state.copyWith(error: 'Gagal memperbarui profil');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
