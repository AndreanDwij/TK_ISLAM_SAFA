import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/school_logo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late AnimationController _floatingController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    ref.read(authProvider.notifier).clearError();
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/dashboard');
    } else {
      final error = ref.read(authProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(error)),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radiusMedium,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Base background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF0FDF4),
                  Color(0xFFECFDF5),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Floating decorative circles in background
          ...List.generate(6, (i) {
            final positions = [
              [0.85, 0.12, 40.0, 0.06],
              [0.1, 0.35, 25.0, 0.04],
              [0.9, 0.55, 30.0, 0.05],
              [0.15, 0.75, 20.0, 0.035],
              [0.7, 0.85, 35.0, 0.045],
              [0.45, 0.08, 18.0, 0.03],
            ];
            final pos = positions[i];
            final dx = pos[0];
            final dy = pos[1];
            final radius = pos[2];
            final alpha = pos[3];

            return Positioned(
              left: screenWidth * dx - radius,
              top: screenHeight * dy - radius,
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final offset = math.sin(
                        (_floatingController.value * math.pi * 2) +
                            (i * 1.1),
                      ) *
                      12;
                  return Transform.translate(
                    offset: Offset(offset, offset * 0.5),
                    child: child,
                  );
                },
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF16A34A).withValues(alpha: alpha),
                  ),
                ),
              ),
            );
          }),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header with curved bottom
                      ClipPath(
                        clipper: _WaveClipper(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 40,
                            bottom: 55,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF16A34A),
                                Color(0xFF0D9668),
                                Color(0xFF0891B2),
                              ],
                            ),
                          ),
                          child: FadeTransition(
                            opacity: _fadeIn,
                            child: Column(
                              children: [
                                // Decorative dots around logo
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Floating decorative rings
                                    AnimatedBuilder(
                                      animation: _floatingController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            math.sin(
                                                    _floatingController.value *
                                                        math.pi *
                                                        2) *
                                                6,
                                            math.cos(
                                                    _floatingController.value *
                                                        math.pi *
                                                        2) *
                                                4,
                                          ),
                                          child: Container(
                                            width: 310,
                                            height: 310,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    AnimatedBuilder(
                                      animation: _floatingController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            math.cos(
                                                    _floatingController.value *
                                                        math.pi *
                                                        2) *
                                                5,
                                            math.sin(
                                                    _floatingController.value *
                                                        math.pi *
                                                        2) *
                                                7,
                                          ),
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        width: 270,
                                        height: 270,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Logo
                                    const SchoolLogo(size: 260),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Selamat Datang',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.95),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Masuk untuk melanjutkan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white.withValues(alpha: 0.75),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Login form
                      SlideTransition(
                        position: _slideUp,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Form card
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF16A34A,
                                          ).withValues(alpha: 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.04,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Email
                                        AppTextField(
                                          label: 'Email',
                                          placeholder: 'Masukkan email',
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: AppColors.grey,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Email wajib diisi';
                                            }
                                            final emailRegex = RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                            );
                                            if (!emailRegex
                                                .hasMatch(value)) {
                                              return 'Format email tidak valid';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: Spacing.lg),

                                        // Password
                                        AppTextField(
                                          label: 'Password',
                                          placeholder: 'Masukkan password',
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            color: AppColors.grey,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons
                                                        .visibility_off_outlined
                                                  : Icons
                                                        .visibility_outlined,
                                              color: AppColors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Password wajib diisi';
                                            }
                                            if (value.length < 8) {
                                              return 'Password minimal 8 karakter';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: Spacing.sm),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: null,
                                            child: Text(
                                              'Lupa Password?',
                                              style:
                                                  AppTypography.bodySmall
                                                      .copyWith(
                                                        color:
                                                            AppColors.grey,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.xxl),

                                        // Login button
                                        AppButton(
                                          text: 'Login',
                                          onPressed: _handleLogin,
                                          isLoading: authState.isLoading,
                                          icon: Icons.login,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: Spacing.xxl),

                                  // Demo accounts info
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0FDF4),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF16A34A,
                                        ).withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(
                                                6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF16A34A,
                                                ).withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      8,
                                                    ),
                                              ),
                                              child: Icon(
                                                Icons.info_outline,
                                                size: 14,
                                                color: const Color(
                                                  0xFF16A34A,
                                                ).withValues(alpha: 0.8),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Akun Demo',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(
                                                  0xFF16A34A,
                                                ).withValues(alpha: 0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDemoAccount('Guru', 'guru@safa.com'),
                                        _buildDemoAccount(
                                          'Kepala Sekolah',
                                          'kepala@safa.com',
                                        ),
                                        _buildDemoAccount(
                                          'Orang Tua',
                                          'orangtua@safa.com',
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Password: password123',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Footer
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'v1.0.0 | TK Islam Safa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoAccount(String role, String email) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF16A34A).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$role: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 30);

    // Wavy curve at bottom
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height - 50,
      size.width * 0.6,
      size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height,
      size.width * 0.2,
      size.height - 20,
    );
    path.quadraticBezierTo(
      0,
      size.height - 35,
      0,
      size.height - 30,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
