import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../models/user.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/filter_chip.dart';

class PenilaianListScreen extends ConsumerStatefulWidget {
  const PenilaianListScreen({super.key});

  @override
  ConsumerState<PenilaianListScreen> createState() => _PenilaianListScreenState();
}

class _PenilaianListScreenState extends ConsumerState<PenilaianListScreen> {
  String _searchQuery = '';
  String _selectedSemester = '';

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
      appBar: AppAppBar(
        title: 'Penilaian',
        actions: [
          if (isGuru)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/penilaian/tambah'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                AppSearchBar(
                  hintText: 'Cari penilaian...',
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: Spacing.md),
                if (semesters.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AppFilterChip(
                          label: 'Semua',
                          isSelected: _selectedSemester.isEmpty,
                          onTap: () => setState(() => _selectedSemester = ''),
                        ),
                        const SizedBox(width: Spacing.sm),
                        ...semesters.map((s) => Padding(
                              padding: const EdgeInsets.only(right: Spacing.sm),
                              child: AppFilterChip(
                                label: s,
                                isSelected: _selectedSemester == s,
                                onTap: () => setState(() => _selectedSemester = s),
                              ),
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
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
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    itemCount: assessments.length,
                    itemBuilder: (context, index) {
                      final assessment = assessments[index];
                      return AppCard(
                        onTap: isGuru
                            ? () => context.push('/penilaian/${assessment.id}')
                            : null,
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.assessment, color: AppColors.primary),
                            ),
                            const SizedBox(width: Spacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assessment.studentName,
                                    style: AppTypography.bodyLarge,
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    '${assessment.aspect} | ${assessment.semester}',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${assessment.score}',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
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
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
