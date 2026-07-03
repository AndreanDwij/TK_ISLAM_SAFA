import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../providers/auth_provider.dart';
import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../models/user.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/button.dart';
import '../../widgets/card.dart';
import '../../widgets/dialog.dart';

class SiswaDetailScreen extends ConsumerWidget {
  final String studentId;

  const SiswaDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final isGuru = authState.user?.role == UserRole.guru;

    final student = studentState.students.firstWhere(
      (s) => s.id == studentId,
      orElse: () => Student(
        id: '', nis: '', name: '', gender: 'Laki-laki',
        birthDate: DateTime.now(), className: '', parentName: '',
        parentPhone: '', createdAt: DateTime.now(),
      ),
    );

    final assessments = ref.read(assessmentProvider.notifier).getByStudent(studentId);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Detail Siswa',
        showBack: true,
        actions: isGuru
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.push('/siswa/edit/$studentId'),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      student.name.substring(0, 1).toUpperCase(),
                      style: AppTypography.h2.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(student.name, style: AppTypography.h4),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    'Kelas ${student.className}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // Biodata Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biodata', style: AppTypography.h5),
                  const SizedBox(height: Spacing.lg),
                  _InfoRow(label: 'NIS', value: student.nis),
                  _InfoRow(label: 'Jenis Kelamin', value: student.gender),
                  _InfoRow(
                    label: 'Tanggal Lahir',
                    value: DateFormat('dd MMMM yyyy').format(student.birthDate),
                  ),
                  _InfoRow(label: 'Nama Orang Tua', value: student.parentName),
                  _InfoRow(label: 'No. Telepon', value: student.parentPhone),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Assessment History Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Riwayat Penilaian', style: AppTypography.h5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${assessments.length} penilaian',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.lg),
                  if (assessments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.xxl),
                        child: Text(
                          'Belum ada penilaian',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...assessments.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.assessment,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.aspect, style: AppTypography.bodyMedium),
                                    Text(
                                      a.note,
                                      style: AppTypography.caption,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${a.score}',
                                style: AppTypography.h5.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),

            // Delete Button (Guru only)
            if (isGuru) ...[
              const SizedBox(height: Spacing.xxl),
              AppButton(
                text: 'Hapus Siswa',
                onPressed: () => _showDeleteDialog(context, ref, studentId),
                isDanger: true,
                icon: Icons.delete,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // UC-002: Delete flow
  void _showDeleteDialog(BuildContext context, WidgetRef ref, String studentId) {
    // Business Rule: Student with assessments cannot be deleted
    final hasAssessments = ref.read(assessmentProvider.notifier).hasAssessments(studentId);

    if (hasAssessments) {
      AppDialog.showError(
        context: context,
        message: 'Siswa memiliki data penilaian dan tidak dapat dihapus.',
      );
      return;
    }

    AppDialog.show(
      context: context,
      title: 'Hapus Siswa',
      message: 'Apakah Anda yakin ingin menghapus siswa ini? Data yang dihapus tidak dapat dikembalikan.',
      confirmText: 'Hapus',
      isDanger: true,
      onConfirm: () async {
        await ref.read(studentProvider.notifier).deleteStudent(studentId);
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('Siswa berhasil dihapus'),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
            ),
          );
        }
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.caption),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}
