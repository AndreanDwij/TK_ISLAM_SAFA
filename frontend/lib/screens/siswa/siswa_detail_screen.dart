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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF16A34A), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Detail Siswa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isGuru)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 22),
                          onPressed: () => context.push('/siswa/edit/$studentId'),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Avatar
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        student.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Kelas ${student.className}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Biodata Card
                  _buildSectionTitle('Biodata', AppColors.schoolBlue),
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.schoolBlue.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.schoolBlue.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(label: 'NIS', value: student.nis, icon: Icons.badge_outlined, color: AppColors.schoolBlue),
                        _buildDivider(),
                        _InfoRow(label: 'Jenis Kelamin', value: student.gender, icon: Icons.person_outlined, color: AppColors.purple),
                        _buildDivider(),
                        _InfoRow(
                          label: 'Tanggal Lahir',
                          value: DateFormat('dd MMMM yyyy').format(student.birthDate),
                          icon: Icons.cake_outlined,
                          color: AppColors.schoolPink,
                        ),
                        _buildDivider(),
                        _InfoRow(label: 'Nama Orang Tua', value: student.parentName, icon: Icons.family_restroom_outlined, color: AppColors.orange),
                        _buildDivider(),
                        _InfoRow(label: 'No. Telepon', value: student.parentPhone, icon: Icons.phone_outlined, color: AppColors.teal),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Assessment History
                  _buildSectionTitle('Riwayat Penilaian', AppColors.schoolYellow),
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.schoolYellow.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.schoolYellow.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${assessments.length} penilaian',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.yellowGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${assessments.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),
                        if (assessments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.assessment_outlined, size: 48, color: AppColors.grey.withValues(alpha: 0.5)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Belum ada penilaian',
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...assessments.asMap().entries.map((entry) {
                            final i = entry.key;
                            final a = entry.value;
                            final aspectColors = [
                              AppColors.primary, AppColors.schoolBlue, AppColors.schoolPink,
                              AppColors.purple, AppColors.teal, AppColors.orange, AppColors.schoolYellow,
                            ];
                            final c = aspectColors[i % aspectColors.length];
                            return Container(
                              margin: EdgeInsets.only(bottom: i < assessments.length - 1 ? 10 : 0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(color: c, width: 3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [c, c.withValues(alpha: 0.7)],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.assessment,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.aspect,
                                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          a.note,
                                          style: AppTypography.caption,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: c.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${a.score}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: c,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),

                  // Delete Button
                  if (isGuru) ...[
                    const SizedBox(height: Spacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showDeleteDialog(context, ref, studentId),
                        icon: const Icon(Icons.delete_outline, color: Colors.white),
                        label: const Text('Hapus Siswa', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.5)]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Divider(height: 1, color: AppColors.border),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String studentId) {
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
  final IconData icon;
  final Color color;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.caption),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
