import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../models/user.dart';
import '../../widgets/empty_state.dart';

class SiswaListScreen extends ConsumerStatefulWidget {
  const SiswaListScreen({super.key});

  @override
  ConsumerState<SiswaListScreen> createState() => _SiswaListScreenState();
}

class _SiswaListScreenState extends ConsumerState<SiswaListScreen> {
  String _searchQuery = '';
  String _selectedClass = '';

  final List<Color> _avatarColors = [
    AppColors.primary,
    AppColors.schoolBlue,
    AppColors.schoolPink,
    AppColors.schoolYellow,
    AppColors.purple,
    AppColors.teal,
    AppColors.orange,
  ];

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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
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
                          'Data Siswa',
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
                          onPressed: () => context.push('/siswa/tambah'),
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
                        hintText: 'Cari siswa...',
                        hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary.withValues(alpha: 0.8)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter chips
                  Row(
                    children: [
                      _buildFilterChip('Semua', _selectedClass.isEmpty, () {
                        setState(() => _selectedClass = '');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Kelas A', _selectedClass == 'A', () {
                        setState(() => _selectedClass = 'A');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Kelas B', _selectedClass == 'B', () {
                        setState(() => _selectedClass = 'B');
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Student List
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
                    padding: const EdgeInsets.all(Spacing.lg),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final color = _avatarColors[index % _avatarColors.length];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => context.push('/siswa/${student.id}'),
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
                                    child: Center(
                                      child: Text(
                                        student.name.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
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
                                                color: AppColors.lightGreenBg,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'Kelas ${student.className}',
                                                style: AppTypography.caption.copyWith(
                                                  color: AppColors.deepGreen,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'NIS: ${student.nis}',
                                              style: AppTypography.caption,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.greyLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: AppColors.grey,
                                      size: 20,
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
              onPressed: () => context.push('/siswa/tambah'),
              backgroundColor: AppColors.primary,
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
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
