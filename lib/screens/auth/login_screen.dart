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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // UC-001 Main Flow: Step 7 - User presses Login button
  Future<void> _handleLogin() async {
    // Clear previous error
    ref.read(authProvider.notifier).clearError();

    // Trigger form validation
    if (!_formKey.currentState!.validate()) return;

    // UC-001 Main Flow: Step 8 - System validates
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    // UC-001 Main Flow: Step 10 - Dashboard displayed
    if (success) {
      context.go('/dashboard');
    } else {
      // UC-001 Alternative/Exception Flow - Error displayed
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xxxl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.radiusExtraLarge,
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 48,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // Title
                  Text(
                    'TK Islam Safa',
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Masuk ke akun Anda',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxxxl),

                  // UC-001 Main Flow: Step 5 - User fills email
                  AppTextField(
                    label: 'Email',
                    placeholder: 'Masukkan email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey),
                    validator: (value) {
                      // UC-001 Alternative Flow: Email empty
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      // UC-001 Alternative Flow: Invalid email format
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.lg),

                  // UC-001 Main Flow: Step 6 - User fills password
                  AppTextField(
                    label: 'Password',
                    placeholder: 'Masukkan password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      // UC-001 Alternative Flow: Password empty
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      // UC-001 Alternative Flow: Password less than 8 chars
                      if (value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.sm),

                  // Forgot Password (Nonaktif sesuai SRS)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: null,
                      child: Text(
                        'Lupa Password?',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // UC-001 Main Flow: Step 7 - Login button
                  AppButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                    isLoading: authState.isLoading,
                    icon: Icons.login,
                  ),
                  const SizedBox(height: Spacing.xxxl),

                  // Version
                  Text(
                    'v1.0.0',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
