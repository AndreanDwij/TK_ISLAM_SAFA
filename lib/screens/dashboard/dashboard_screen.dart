import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import 'guru_dashboard.dart';
import 'kepala_dashboard.dart';
import 'orang_tua_dashboard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    Widget dashboard;
    switch (user?.role) {
      case UserRole.guru:
        dashboard = const GuruDashboard();
        break;
      case UserRole.kepalaSekolah:
        dashboard = const KepalaDashboard();
        break;
      case UserRole.orangTua:
        dashboard = const OrangTuaDashboard();
        break;
      default:
        dashboard = const GuruDashboard();
    }

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Dashboard',
      ),
      body: dashboard,
    );
  }
}
