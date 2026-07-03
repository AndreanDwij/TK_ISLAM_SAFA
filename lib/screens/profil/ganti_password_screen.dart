import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';
import '../../utils/validators.dart';

class GantiPasswordScreen extends ConsumerStatefulWidget {
  const GantiPasswordScreen({super.key});

  @override
  ConsumerState<GantiPasswordScreen> createState() => _GantiPasswordScreenState();
}

class _GantiPasswordScreenState extends ConsumerState<GantiPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password baru tidak cocok'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authProvider).user;
      if (user != null) {
        if (_oldPasswordController.text != user.password) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password lama salah'),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        final updatedUser = user.copyWith(
          password: _newPasswordController.text,
        );
        await ref.read(authProvider.notifier).updateProfile(updatedUser);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah password: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Ganti Password',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Password Lama',
                placeholder: 'Masukkan password lama',
                controller: _oldPasswordController,
                obscureText: _obscureOld,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () => setState(() => _obscureOld = !_obscureOld),
                ),
                validator: (value) => Validators.password(value),
              ),
              const SizedBox(height: Spacing.lg),
              AppTextField(
                label: 'Password Baru',
                placeholder: 'Masukkan password baru',
                controller: _newPasswordController,
                obscureText: _obscureNew,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
                validator: (value) => Validators.password(value),
              ),
              const SizedBox(height: Spacing.lg),
              AppTextField(
                label: 'Konfirmasi Password',
                placeholder: 'Konfirmasi password baru',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (value) => Validators.password(value),
              ),
              const SizedBox(height: Spacing.xxxl),
              AppButton(
                text: 'Simpan',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
