import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/school_logo.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final UserRole _selectedRole = UserRole.orangTua;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    ref.read(authProvider.notifier).clearError();
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('Password dan konfirmasi password tidak sama')),
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
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text('Akun berhasil dibuat! Silakan login.'),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusMedium,
          ),
        ),
      );
      context.go('/login');
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
                            top: 30,
                            bottom: 50,
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
                                // Back button
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: IconButton(
                                      onPressed: () => context.go('/login'),
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                // Decorative rings around logo
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
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
                                            width: 200,
                                            height: 200,
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
                                    // Logo
                                    const SchoolLogo(size: 150),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Buat Akun Baru',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.95),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Daftar untuk mengakses aplikasi',
                                  style: TextStyle(
                                    fontSize: 13,
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

                      // Register form
                      SlideTransition(
                        position: _slideUp,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
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
                                        // Nama Lengkap
                                        AppTextField(
                                          label: 'Nama Lengkap',
                                          placeholder: 'Masukkan nama lengkap',
                                          controller: _nameController,
                                          keyboardType: TextInputType.name,
                                          prefixIcon: const Icon(
                                            Icons.person_outlined,
                                            color: AppColors.grey,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Nama wajib diisi';
                                            }
                                            if (value.trim().length < 3) {
                                              return 'Nama minimal 3 karakter';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: Spacing.lg),

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
                                        const SizedBox(height: Spacing.lg),

                                        // Confirm Password
                                        AppTextField(
                                          label: 'Konfirmasi Password',
                                          placeholder: 'Ulangi password',
                                          controller: _confirmPasswordController,
                                          obscureText: _obscureConfirmPassword,
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            color: AppColors.grey,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureConfirmPassword
                                                  ? Icons
                                                        .visibility_off_outlined
                                                  : Icons
                                                        .visibility_outlined,
                                              color: AppColors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword =
                                                    !_obscureConfirmPassword;
                                              });
                                            },
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Konfirmasi password wajib diisi';
                                            }
                                            if (value !=
                                                _passwordController.text) {
                                              return 'Password tidak sama';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: Spacing.xxl),

                                        // Register button
                                        AppButton(
                                          text: 'Daftar',
                                          onPressed: _handleRegister,
                                          isLoading: authState.isLoading,
                                          icon: Icons.person_add_outlined,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: Spacing.xl),

                                  // Login link
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sudah punya akun? ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go('/login'),
                                          child: const Text(
                                            'Masuk di sini',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
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
