import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../providers/auth_provider.dart';
import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../../providers/documentation_provider.dart';
import '../../models/documentation.dart';
import '../../models/user.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/button.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/dialog.dart';

class DokumentasiScreen extends ConsumerStatefulWidget {
  const DokumentasiScreen({super.key});

  @override
  ConsumerState<DokumentasiScreen> createState() => _DokumentasiScreenState();
}

class _DokumentasiScreenState extends ConsumerState<DokumentasiScreen> {
  String _selectedStudentId = '';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final docState = ref.watch(documentationProvider);
    final isGuru = authState.user?.role == UserRole.guru;

    var docs = docState.documentations;

    if (_selectedStudentId.isNotEmpty) {
      docs = docs.where((d) => d.studentId == _selectedStudentId).toList();
    }

    return Scaffold(
      appBar: AppAppBar(
        title: 'Dokumentasi',
        actions: [
          if (isGuru)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showUploadDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AppFilterChip(
                    label: 'Semua',
                    isSelected: _selectedStudentId.isEmpty,
                    onTap: () => setState(() => _selectedStudentId = ''),
                  ),
                  const SizedBox(width: Spacing.sm),
                  ...studentState.students.map((s) => Padding(
                        padding: const EdgeInsets.only(right: Spacing.sm),
                        child: AppFilterChip(
                          label: s.name,
                          isSelected: _selectedStudentId == s.id,
                          onTap: () => setState(() => _selectedStudentId = s.id),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: docs.isEmpty
                ? const AppEmptyState(
                    message: 'Belum ada dokumentasi',
                    description: 'Upload dokumentasi perkembangan siswa',
                    icon: Icons.photo_library_outlined,
                    buttonText: 'Upload Dokumentasi',
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: Spacing.md,
                      mainAxisSpacing: Spacing.md,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // UC-004 Main Flow: Step 6 - Preview displayed
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.photo,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(Spacing.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // UC-004 Main Flow: Step 10 - Photo shows in gallery
                                  Text(
                                    doc.studentName,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    doc.description,
                                    style: AppTypography.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (isGuru) ...[
                                    const SizedBox(height: Spacing.sm),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        // UC-004 Acceptance Criteria: Photo can be deleted
                                        onTap: () => _showDeleteDialog(context, doc),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
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
              onPressed: () => _showUploadDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // UC-004 Main Flow: Step 3 - Add Photo button pressed
  void _showUploadDialog(BuildContext context) {
    final students = ref.read(studentProvider).students;
    String? selectedStudentId;
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: Spacing.lg,
            right: Spacing.lg,
            top: Spacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: AppRadius.chip,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text('Upload Dokumentasi', style: AppTypography.h5),
              const SizedBox(height: Spacing.xl),

              // UC-004 Main Flow: Step 2 - Select student
              DropdownButtonFormField<String>(
                initialValue: selectedStudentId,
                decoration: const InputDecoration(
                  labelText: 'Pilih Siswa',
                ),
                items: students.map((s) {
                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                }).toList(),
                onChanged: (value) => setModalState(() => selectedStudentId = value),
              ),
              const SizedBox(height: Spacing.lg),

              // UC-004 Main Flow: Step 7 - Add description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: Spacing.xl),

              // UC-004 Main Flow: Step 4 & Alternative Flow
              Row(
                children: [
                  // UC-004 Main Flow: Step 4 - Camera opens
                  Expanded(
                    child: AppButton(
                      text: 'Kamera',
                      onPressed: () {
                        Navigator.pop(context);
                        _handleCameraUpload(selectedStudentId, descriptionController.text);
                      },
                      isSecondary: true,
                      icon: Icons.camera_alt,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  // UC-004 Alternative Flow: Select from gallery
                  Expanded(
                    child: AppButton(
                      text: 'Galeri',
                      onPressed: () {
                        Navigator.pop(context);
                        _handleGalleryUpload(selectedStudentId, descriptionController.text);
                      },
                      icon: Icons.photo_library,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UC-004 Main Flow: Steps 4-5 - Camera flow
  Future<void> _handleCameraUpload(String? studentId, String description) async {
    // UC-004 Exception Flow: Camera denied
    // In prototype, we simulate the upload
    _saveDocumentation(studentId, description, 'camera');
  }

  // UC-004 Alternative Flow: Gallery flow
  Future<void> _handleGalleryUpload(String? studentId, String description) async {
    // UC-004 Exception Flow: Photo too large / Unsupported format
    // In prototype, we simulate the upload
    _saveDocumentation(studentId, description, 'gallery');
  }

  // UC-004 Main Flow: Steps 8-9 - Save
  Future<void> _saveDocumentation(String? studentId, String description, String source) async {
    if (studentId == null) {
      _showErrorSnackBar('Pilih siswa terlebih dahulu');
      return;
    }

    if (description.isEmpty) {
      _showErrorSnackBar('Deskripsi wajib diisi');
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 1));

      final students = ref.read(studentProvider).students;
      final student = students.firstWhere(
        (s) => s.id == studentId,
        orElse: () => Student(
          id: '', nis: '', name: '', gender: 'Laki-laki',
          birthDate: DateTime.now(), className: '', parentName: '',
          parentPhone: '', createdAt: DateTime.now(),
        ),
      );

      final doc = Documentation(
        id: const Uuid().v4(),
        studentId: studentId,
        studentName: student.name,
        photoUrl: 'https://via.placeholder.com/300',
        description: description,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await ref.read(documentationProvider.notifier).addDocumentation(doc);

      if (mounted) {
        Navigator.pop(context); // Close loading
        _showSuccessSnackBar('Dokumentasi berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        _showErrorSnackBar('Gagal mengunggah foto: $e');
      }
    }
  }

  // UC-004 Acceptance Criteria: Photo can be deleted
  void _showDeleteDialog(BuildContext context, Documentation doc) {
    AppDialog.show(
      context: context,
      title: 'Hapus Dokumentasi',
      message: 'Apakah Anda yakin ingin menghapus dokumentasi ini?',
      confirmText: 'Hapus',
      isDanger: true,
      onConfirm: () async {
        await ref.read(documentationProvider.notifier).deleteDocumentation(doc.id);
        if (mounted) {
          _showSuccessSnackBar('Dokumentasi berhasil dihapus');
        }
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      ),
    );
  }
}
