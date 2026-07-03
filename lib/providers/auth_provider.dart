import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
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
      final user = await StorageService.getSession();
      state = AuthState(user: user, isLoading: false, isInitialized: true);
    } catch (e) {
      state = AuthState(error: 'Gagal memuat sesi', isLoading: false, isInitialized: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Validasi input kosong
    if (email.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Email wajib diisi',
      );
      return false;
    }

    if (password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password wajib diisi',
      );
      return false;
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'Format email tidak valid',
      );
      return false;
    }

    // Validasi panjang password
    if (password.length < 8) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password minimal 8 karakter',
      );
      return false;
    }

    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Verifikasi akun
    final users = await _getUsers();
    final user = users.where(
      (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
    ).firstOrNull;

    if (user == null) {
      // Cek apakah email ada
      final emailExists = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
      if (!emailExists) {
        state = state.copyWith(
          isLoading: false,
          error: 'Email tidak ditemukan',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Password salah',
        );
      }
      return false;
    }

    // Simpan session
    try {
      await StorageService.saveSession(user);
      state = AuthState(user: user, isLoading: false, isInitialized: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal membuat sesi',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearSession();
    state = AuthState(isInitialized: true);
  }

  Future<void> updateProfile(User updatedUser) async {
    await StorageService.saveSession(updatedUser);
    state = state.copyWith(user: updatedUser);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<List<User>> _getUsers() async {
    return [
      User(
        id: '1',
        name: 'Ibu Sarah',
        email: 'guru@safa.com',
        password: 'password123',
        role: UserRole.guru,
      ),
      User(
        id: '2',
        name: 'Pak Budi',
        email: 'kepala@safa.com',
        password: 'password123',
        role: UserRole.kepalaSekolah,
      ),
      User(
        id: '3',
        name: 'Pak Ahmad',
        email: 'orangtua@safa.com',
        password: 'password123',
        role: UserRole.orangTua,
        childId: '1',
      ),
    ];
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
