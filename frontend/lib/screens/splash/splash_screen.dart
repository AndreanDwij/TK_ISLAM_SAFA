import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/school_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _mainController.forward();
    _init();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Base background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
          ),

          // Top-right accent glow
          Positioned(
            top: -size.height * 0.14,
            right: -size.width * 0.18,
            child: Container(
              width: size.width * 0.72,
              height: size.width * 0.72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom-left accent glow
          Positioned(
            bottom: -size.height * 0.08,
            left: -size.width * 0.13,
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating small circles
          ...List.generate(8, (i) {
            final positions = [
              [0.15, 0.12, 14.0, 0.06],
              [0.78, 0.18, 10.0, 0.05],
              [0.88, 0.45, 8.0, 0.04],
              [0.1, 0.65, 12.0, 0.05],
              [0.65, 0.78, 6.0, 0.03],
              [0.3, 0.88, 9.0, 0.04],
              [0.92, 0.72, 7.0, 0.035],
              [0.5, 0.08, 5.0, 0.025],
            ];
            final pos = positions[i];
            final dx = pos[0];
            final dy = pos[1];
            final radius = pos[2];
            final alpha = pos[3];

            return Positioned(
              left: size.width * dx,
              top: size.height * dy,
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final offset = math.sin(
                        (_floatingController.value * math.pi * 2) +
                            (i * 0.8),
                      ) *
                      15;
                  return Transform.translate(
                    offset: Offset(offset, offset * 0.6),
                    child: child,
                  );
                },
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: alpha),
                  ),
                ),
              ),
            );
          }),

          // Tiny floating dots
          ...List.generate(12, (i) {
            final positions = [
              [0.22, 0.25],
              [0.7, 0.1],
              [0.85, 0.35],
              [0.12, 0.5],
              [0.55, 0.7],
              [0.35, 0.92],
              [0.9, 0.6],
              [0.08, 0.82],
              [0.45, 0.15],
              [0.75, 0.88],
              [0.18, 0.38],
              [0.62, 0.55],
            ];
            final pos = positions[i];
            final dx = pos[0];
            final dy = pos[1];

            return Positioned(
              left: size.width * dx,
              top: size.height * dy,
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final offset = math.cos(
                        (_floatingController.value * math.pi * 2) +
                            (i * 0.5),
                      ) *
                      10;
                  return Transform.translate(
                    offset: Offset(offset * 0.7, offset),
                    child: child,
                  );
                },
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            );
          }),

          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 310,
                          height: 310,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: SchoolLogo(size: 240),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Sistem Informasi',
                              style: AppTypography.h5.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Penilaian & Administrasi',
                              style: AppTypography.h4.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary.withValues(
                                  alpha: 0.6 + _pulseController.value * 0.4,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
