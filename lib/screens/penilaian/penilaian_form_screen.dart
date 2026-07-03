import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../config/colors.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../models/assessment.dart';
import '../../models/student.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/dropdown.dart';

class PenilaianFormScreen extends ConsumerStatefulWidget {
  final String? assessmentId;

  const PenilaianFormScreen({super.key, this.assessmentId});

  @override
  ConsumerState<PenilaianFormScreen> createState() => _PenilaianFormScreenState();
}

class _PenilaianFormScreenState extends ConsumerState<PenilaianFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedStudentId;
  String? _selectedAspect;
  String? _selectedSemester;
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  bool get isEditing => widget.assessmentId != null;

  // UC-003: Development aspects
  static const List<String> _aspects = [
    'Motorik Kasar',
    'Motorik Halus',
    'Bahasa',
    'Kognitif',
    'Sosial Emosional',
    'Seni',
    'Agama',
  ];

  static const List<String> _semesters = [
    'Ganjil 2024',
    'Genap 2024',
    'Ganjil 2025',
    'Genap 2025',
  ];

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadAssessment();
    }
  }

  void _loadAssessment() {
    final assessments = ref.read(assessmentProvider).assessments;
    final assessment = assessments.firstWhere(
      (a) => a.id == widget.assessmentId,
      orElse: () => Assessment(
        id: '', studentId: '', studentName: '', aspect: 'Motorik Kasar',
        score: 0, note: '', photoUrls: [], semester: '',
        teacherId: '', teacherName: '', date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    _selectedStudentId = assessment.studentId;
    _selectedAspect = assessment.aspect;
    _selectedSemester = assessment.semester;
    _scoreController.text = assessment.score.toString();
    _noteController.text = assessment.note;
    _date = assessment.date;
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _date = date);
    }
  }

  // UC-003 Main Flow: Step 7 - Save button pressed
  Future<void> _handleSubmit() async {
    // UC-003 Main Flow: Step 8 - System validates
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Data belum lengkap');
      return;
    }

    // UC-003 Alternative Flow: Score not selected
    if (_selectedStudentId == null) {
      _showErrorSnackBar('Siswa wajib dipilih');
      return;
    }

    // UC-003 Alternative Flow: Aspect not selected
    if (_selectedAspect == null) {
      _showErrorSnackBar('Aspek penilaian wajib dipilih');
      return;
    }

    // UC-003 Alternative Flow: Semester not selected
    if (_selectedSemester == null) {
      _showErrorSnackBar('Semester wajib dipilih');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authProvider);
      final students = ref.read(studentProvider).students;
      final student = students.firstWhere(
        (s) => s.id == _selectedStudentId,
        orElse: () => Student(
          id: '', nis: '', name: '', gender: 'Laki-laki',
          birthDate: DateTime.now(), className: '', parentName: '',
          parentPhone: '', createdAt: DateTime.now(),
        ),
      );

      if (isEditing) {
        // UC-003 Main Flow: Edit existing assessment
        final assessments = ref.read(assessmentProvider).assessments;
        final existing = assessments.firstWhere((a) => a.id == widget.assessmentId);
        final updated = existing.copyWith(
          aspect: _selectedAspect!,
          score: int.parse(_scoreController.text.trim()),
          note: _noteController.text.trim(),
          semester: _selectedSemester!,
          date: _date,
        );
        await ref.read(assessmentProvider.notifier).updateAssessment(updated);

        if (mounted) {
          _showSuccessSnackBar('Penilaian berhasil diperbarui');
          context.pop();
        }
      } else {
        // UC-003 Main Flow: Step 9 - System saves data
        final assessment = Assessment(
          id: const Uuid().v4(),
          studentId: _selectedStudentId!,
          studentName: student.name,
          aspect: _selectedAspect!,
          score: int.parse(_scoreController.text.trim()),
          note: _noteController.text.trim(),
          photoUrls: [],
          semester: _selectedSemester!,
          teacherId: authState.user?.id ?? '',
          teacherName: authState.user?.name ?? '',
          date: _date,
          createdAt: DateTime.now(),
        );
        await ref.read(assessmentProvider.notifier).addAssessment(assessment);

        // UC-003 Main Flow: Step 10 - History updated
        if (mounted) {
          _showSuccessSnackBar('Penilaian berhasil ditambahkan');
          context.pop();
        }
      }
    } catch (e) {
      // UC-003 Exception Flow: Database failed
      if (mounted) {
        _showErrorSnackBar('Gagal menyimpan data: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentProvider).students;

    return Scaffold(
      appBar: AppAppBar(
        title: isEditing ? 'Edit Penilaian' : 'Tambah Penilaian',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UC-003 Main Flow: Step 2 - Select student
              AppDropdown<String>(
                label: 'Pilih Siswa',
                value: _selectedStudentId,
                hint: 'Pilih siswa',
                items: students.map((s) {
                  return DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStudentId = value),
                prefixIcon: const Icon(Icons.person_outlined, color: AppColors.grey),
              ),
              const SizedBox(height: Spacing.lg),

              // UC-003 Main Flow: Step 3 - Select development aspect
              AppDropdown<String>(
                label: 'Aspek Penilaian',
                value: _selectedAspect,
                hint: 'Pilih aspek',
                items: _aspects.map((a) {
                  return DropdownMenuItem(value: a, child: Text(a));
                }).toList(),
                onChanged: (value) => setState(() => _selectedAspect = value),
                prefixIcon: const Icon(Icons.assessment_outlined, color: AppColors.grey),
              ),
              const SizedBox(height: Spacing.lg),

              // UC-003 Main Flow: Step 4 - Fill score
              AppTextField(
                label: 'Nilai',
                placeholder: 'Masukkan nilai (0-100)',
                controller: _scoreController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.score_outlined, color: AppColors.grey),
                validator: (value) {
                  // UC-003 Alternative Flow: Score not selected
                  if (value == null || value.trim().isEmpty) {
                    return 'Nilai wajib diisi';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.lg),

              // UC-003 Main Flow: Step 5 - Add note
              AppTextField(
                label: 'Catatan Guru',
                placeholder: 'Masukkan catatan perkembangan',
                controller: _noteController,
                maxLines: 3,
                prefixIcon: const Icon(Icons.note_outlined, color: AppColors.grey),
                validator: (value) {
                  // UC-003 Alternative Flow: Note empty
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.lg),

              // UC-003 Main Flow: Step 6 - Upload documentation (optional)
              AppDropdown<String>(
                label: 'Semester',
                value: _selectedSemester,
                hint: 'Pilih semester',
                items: _semesters.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s));
                }).toList(),
                onChanged: (value) => setState(() => _selectedSemester = value),
                prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.grey),
              ),
              const SizedBox(height: Spacing.lg),

              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: AppTextField(
                    label: 'Tanggal',
                    placeholder: '${_date.day}/${_date.month}/${_date.year}',
                    suffixIcon: const Icon(Icons.calendar_today, color: AppColors.grey),
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xxxl),

              // UC-003 Main Flow: Step 7 - Save button
              AppButton(
                text: isEditing ? 'Simpan Perubahan' : 'Simpan',
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
