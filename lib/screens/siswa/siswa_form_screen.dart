import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../config/colors.dart';
import '../../config/spacing.dart';
import '../../config/radius.dart';
import '../../providers/student_provider.dart';
import '../../models/student.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/dropdown.dart';

class SiswaFormScreen extends ConsumerStatefulWidget {
  final String? studentId;

  const SiswaFormScreen({super.key, this.studentId});

  @override
  ConsumerState<SiswaFormScreen> createState() => _SiswaFormScreenState();
}

class _SiswaFormScreenState extends ConsumerState<SiswaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _nameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();

  String? _selectedGender;
  String? _selectedClass;
  DateTime? _birthDate;
  bool _isLoading = false;

  bool get isEditing => widget.studentId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadStudent();
    }
  }

  void _loadStudent() {
    final students = ref.read(studentProvider).students;
    final student = students.firstWhere(
      (s) => s.id == widget.studentId,
      orElse: () => Student(
        id: '', nis: '', name: '', gender: 'Laki-laki',
        birthDate: DateTime.now(), className: '', parentName: '',
        parentPhone: '', createdAt: DateTime.now(),
      ),
    );
    _nisController.text = student.nis;
    _nameController.text = student.name;
    _parentNameController.text = student.parentName;
    _parentPhoneController.text = student.parentPhone;
    _selectedGender = student.gender;
    _selectedClass = student.className;
    _birthDate = student.birthDate;
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2020),
      firstDate: DateTime(2015),
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
      setState(() => _birthDate = date);
    }
  }

  // UC-002 Main Flow: Step 7 - Save button pressed
  Future<void> _handleSubmit() async {
    // UC-002 Main Flow: Step 8 - System validates
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Data belum lengkap');
      return;
    }

    // UC-002 Alternative Flow: Data incomplete
    if (_selectedGender == null) {
      _showErrorSnackBar('Jenis kelamin wajib dipilih');
      return;
    }
    if (_selectedClass == null) {
      _showErrorSnackBar('Kelas wajib dipilih');
      return;
    }
    if (_birthDate == null) {
      _showErrorSnackBar('Tanggal lahir wajib diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        // UC-002 Main Flow: Edit existing student
        final students = ref.read(studentProvider).students;
        final existing = students.firstWhere((s) => s.id == widget.studentId);
        final updated = existing.copyWith(
          nis: _nisController.text.trim(),
          name: _nameController.text.trim(),
          gender: _selectedGender!,
          birthDate: _birthDate!,
          className: _selectedClass!,
          parentName: _parentNameController.text.trim(),
          parentPhone: _parentPhoneController.text.trim(),
        );
        await ref.read(studentProvider.notifier).updateStudent(updated);

        if (mounted) {
          _showSuccessSnackBar('Data siswa berhasil diperbarui');
          context.pop();
        }
      } else {
        // UC-002 Alternative Flow: NIS already used
        final nisList = ref.read(studentProvider).students.map((s) => s.nis).toList();
        if (nisList.contains(_nisController.text.trim())) {
          _showErrorSnackBar('NIS sudah digunakan');
          setState(() => _isLoading = false);
          return;
        }

        // UC-002 Main Flow: Step 9 - System saves data
        final student = Student(
          id: const Uuid().v4(),
          nis: _nisController.text.trim(),
          name: _nameController.text.trim(),
          gender: _selectedGender!,
          birthDate: _birthDate!,
          className: _selectedClass!,
          parentName: _parentNameController.text.trim(),
          parentPhone: _parentPhoneController.text.trim(),
          createdAt: DateTime.now(),
        );
        await ref.read(studentProvider.notifier).addStudent(student);

        // UC-002 Main Flow: Step 10 - List updated
        if (mounted) {
          _showSuccessSnackBar('Data siswa berhasil ditambahkan');
          context.pop();
        }
      }
    } catch (e) {
      // UC-002 Exception Flow: Server error
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
    return Scaffold(
      appBar: AppAppBar(
        title: isEditing ? 'Edit Siswa' : 'Tambah Siswa',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UC-002 Main Flow: Step 5 - Fill biodata
              AppTextField(
                label: 'NIS',
                placeholder: 'Masukkan NIS',
                controller: _nisController,
                prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.grey),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIS wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.lg),

              AppTextField(
                label: 'Nama Lengkap',
                placeholder: 'Masukkan nama lengkap',
                controller: _nameController,
                prefixIcon: const Icon(Icons.person_outlined, color: AppColors.grey),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.lg),

              AppDropdown<String>(
                label: 'Jenis Kelamin',
                value: _selectedGender,
                hint: 'Pilih jenis kelamin',
                items: const [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (value) => setState(() => _selectedGender = value),
                prefixIcon: const Icon(Icons.wc_outlined, color: AppColors.grey),
              ),
              const SizedBox(height: Spacing.lg),

              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: AppTextField(
                    label: 'Tanggal Lahir',
                    placeholder: _birthDate != null
                        ? DateFormat('dd MMMM yyyy').format(_birthDate!)
                        : 'Pilih tanggal lahir',
                    suffixIcon: const Icon(Icons.calendar_today, color: AppColors.grey),
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),

              AppDropdown<String>(
                label: 'Kelas',
                value: _selectedClass,
                hint: 'Pilih kelas',
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('Kelas A')),
                  DropdownMenuItem(value: 'B', child: Text('Kelas B')),
                ],
                onChanged: (value) => setState(() => _selectedClass = value),
                prefixIcon: const Icon(Icons.school_outlined, color: AppColors.grey),
              ),
              const SizedBox(height: Spacing.lg),

              AppTextField(
                label: 'Nama Orang Tua',
                placeholder: 'Masukkan nama orang tua',
                controller: _parentNameController,
                prefixIcon: const Icon(Icons.family_restroom_outlined, color: AppColors.grey),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama orang tua wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.lg),

              AppTextField(
                label: 'No. Telepon',
                placeholder: 'Masukkan nomor telepon',
                controller: _parentPhoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.grey),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.xxxl),

              // UC-002 Main Flow: Step 7 - Save button
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
