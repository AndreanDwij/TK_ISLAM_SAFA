import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/siswa/siswa_list_screen.dart';
import '../screens/siswa/siswa_detail_screen.dart';
import '../screens/siswa/siswa_form_screen.dart';
import '../screens/penilaian/penilaian_list_screen.dart';
import '../screens/penilaian/penilaian_form_screen.dart';
import '../screens/dokumentasi/dokumentasi_screen.dart';
import '../screens/laporan/laporan_screen.dart';
import '../screens/monitoring/monitoring_screen.dart';
import '../screens/profil/profil_screen.dart';
import '../screens/profil/edit_profil_screen.dart';
import '../screens/profil/ganti_password_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isLoggedIn;
      final location = state.matchedLocation;
      final isPublicRoute = location == '/login' || location == '/splash';

      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      if (isLoggedIn && isPublicRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/siswa',
        builder: (context, state) => const SiswaListScreen(),
      ),
      GoRoute(
        path: '/siswa/tambah',
        builder: (context, state) => const SiswaFormScreen(),
      ),
      GoRoute(
        path: '/siswa/:id',
        builder: (context, state) => SiswaDetailScreen(
          studentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/siswa/edit/:id',
        builder: (context, state) => SiswaFormScreen(
          studentId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/penilaian',
        builder: (context, state) => const PenilaianListScreen(),
      ),
      GoRoute(
        path: '/penilaian/tambah',
        builder: (context, state) => const PenilaianFormScreen(),
      ),
      GoRoute(
        path: '/penilaian/:id',
        builder: (context, state) => PenilaianFormScreen(
          assessmentId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/dokumentasi',
        builder: (context, state) => const DokumentasiScreen(),
      ),
      GoRoute(
        path: '/laporan',
        builder: (context, state) => const LaporanScreen(),
      ),
      GoRoute(
        path: '/monitoring',
        builder: (context, state) => const MonitoringScreen(),
      ),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/profil/edit',
        builder: (context, state) => const EditProfilScreen(),
      ),
      GoRoute(
        path: '/profil/password',
        builder: (context, state) => const GantiPasswordScreen(),
      ),
    ],
  );
});
