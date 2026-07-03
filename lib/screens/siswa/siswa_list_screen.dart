import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../models/user.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/filter_chip.dart';

class SiswaListScreen extends ConsumerStatefulWidget {
  const SiswaListScreen({super.key});

  @override
  ConsumerState<SiswaListScreen> createState() => _SiswaListScreenState();
}

class _SiswaListScreenState extends ConsumerState<SiswaListScreen> {
  String _searchQuery = '';
  String _selectedClass = '';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final isGuru = authState.user?.role == UserRole.guru;

    var students = studentState.students;

    if (_searchQuery.isNotEmpty) {
      students = students.where((s) {
        return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.nis.contains(_searchQuery);
      }).toList();
    }

    if (_selectedClass.isNotEmpty) {
      students = students.where((s) => s.className == _selectedClass).toList();
    }

    return Scaffold(
      appBar: AppAppBar(
        title: 'Data Siswa',
        actions: [
          if (isGuru)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/siswa/tambah'),
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
                  hintText: 'Cari siswa...',
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: Spacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterChip(
                        label: 'Semua',
                        isSelected: _selectedClass.isEmpty,
                        onTap: () => setState(() => _selectedClass = ''),
                      ),
                      const SizedBox(width: Spacing.sm),
                      AppFilterChip(
                        label: 'Kelas A',
                        isSelected: _selectedClass == 'A',
                        onTap: () => setState(() => _selectedClass = 'A'),
                      ),
                      const SizedBox(width: Spacing.sm),
                      AppFilterChip(
                        label: 'Kelas B',
                        isSelected: _selectedClass == 'B',
                        onTap: () => setState(() => _selectedClass = 'B'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? AppEmptyState(
                    message: 'Belum ada data siswa',
                    description: 'Tambahkan siswa baru untuk memulai',
                    icon: Icons.people_outline,
                    buttonText: 'Tambah Siswa',
                    onButtonPressed: isGuru ? () => context.push('/siswa/tambah') : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return AppCard(
                        onTap: () => context.push('/siswa/${student.id}'),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              child: Text(
                                student.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(student.name, style: AppTypography.bodyLarge),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    'NIS: ${student.nis} | Kelas ${student.className}',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.grey),
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
              onPressed: () => context.push('/siswa/tambah'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
