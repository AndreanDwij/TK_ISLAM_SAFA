import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../models/user.dart';
import '../../widgets/empty_state.dart';

class PenilaianListScreen extends ConsumerStatefulWidget {
  const PenilaianListScreen({super.key});

  @override
  ConsumerState<PenilaianListScreen> createState() => _PenilaianListScreenState();
}

class _PenilaianListScreenState extends ConsumerState<PenilaianListScreen> {
  String _searchQuery = '';
  String _selectedSemester = '';

  static const Map<String, Color> _aspectColors = {
    'Motorik Kasar': AppColors.primary,
    'Motorik Halus': AppColors.teal,
    'Bahasa': AppColors.schoolBlue,
    'Kognitif': AppColors.schoolYellow,
    'Sosial Emosional': AppColors.schoolPink,
    'Seni': AppColors.purple,
    'Agama': AppColors.deepGreen,
  };

  static const Map<String, IconData> _aspectIcons = {
    'Motorik Kasar': Icons.directions_run,
    'Motorik Halus': Icons.handshake,
    'Bahasa': Icons.record_voice_over,
    'Kognitif': Icons.psychology,
    'Sosial Emosional': Icons.favorite,
    'Seni': Icons.palette,
    'Agama': Icons.mosque,
  };

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final assessmentState = ref.watch(assessmentProvider);
    final isGuru = authState.user?.role == UserRole.guru;

    var assessments = assessmentState.assessments;

    if (_searchQuery.isNotEmpty) {
      assessments = assessments.where((a) {
        return a.studentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.aspect.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedSemester.isNotEmpty) {
      assessments = assessments.where((a) => a.semester == _selectedSemester).toList();
    }

    final semesters = assessmentState.assessments
        .map((a) => a.semester)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Penilaian',
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
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
                          onPressed: () => context.push('/penilaian/tambah'),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      cursorColor: AppColors.textPrimary,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari penilaian...',
                        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary.withOpacity(0.8)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  if (semesters.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Semua', _selectedSemester.isEmpty, () {
                            setState(() => _selectedSemester = '');
                          }),
                          const SizedBox(width: 8),
                          ...semesters.map((s) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildFilterChip(s, _selectedSemester == s, () {
                                  setState(() => _selectedSemester = s);
                                }),
                              )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Assessment List
          Expanded(
            child: assessments.isEmpty
                ? AppEmptyState(
                    message: 'Belum ada data penilaian',
                    description: 'Tambahkan penilaian baru untuk memulai',
                    icon: Icons.assessment_outlined,
                    buttonText: 'Tambah Penilaian',
                    onButtonPressed: isGuru ? () => context.push('/penilaian/tambah') : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(Spacing.lg),
                    itemCount: assessments.length,
                    itemBuilder: (context, index) {
                      final assessment = assessments[index];
                      final color = _aspectColors[assessment.aspect] ?? AppColors.primary;
                      final icon = _aspectIcons[assessment.aspect] ?? Icons.assessment;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: isGuru
                                ? () => context.push('/penilaian/${assessment.id}')
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [color, color.withValues(alpha: 0.7)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(icon, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          assessment.studentName,
                                          style: AppTypography.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                assessment.aspect,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: color,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              assessment.semester,
                                              style: AppTypography.caption,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [color, color.withValues(alpha: 0.8)],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${assessment.score}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: isGuru
          ? FloatingActionButton(
              onPressed: () => context.push('/penilaian/tambah'),
              backgroundColor: AppColors.purple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.purple : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
