import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
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
import '../../widgets/empty_state.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/chart_bar.dart';

class LaporanScreen extends ConsumerStatefulWidget {
  const LaporanScreen({super.key});

  @override
  ConsumerState<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends ConsumerState<LaporanScreen> {
  String? _selectedStudentId;
  String? _selectedSemester;
  bool _isGenerating = false;
  bool _reportGenerated = false;

  double _overallAverage = 0;
  Map<String, double> _aspectAverages = {};
  int _assessmentCount = 0;

  static const List<String> _semesters = [
    'Ganjil 2024',
    'Genap 2024',
    'Ganjil 2025',
    'Genap 2025',
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);
    final isOrangTua = authState.user?.role == UserRole.orangTua;

    List<Student> students = studentState.students;

    // UC-007: Orang Tua only sees their child
    if (isOrangTua) {
      final childId = authState.user?.childId;
      students = students.where((s) => s.id == childId).toList();
      _selectedStudentId ??= childId;
    }

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Laporan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UC-005 Main Flow: Step 2 - Select student
            AppDropdown<String>(
              label: 'Pilih Siswa',
              value: _selectedStudentId,
              hint: 'Pilih siswa',
              items: students.map<DropdownMenuItem<String>>((s) {
                return DropdownMenuItem(value: s.id, child: Text(s.name));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStudentId = value;
                  _reportGenerated = false;
                });
              },
              prefixIcon: const Icon(Icons.person_outlined, color: AppColors.grey),
            ),
            const SizedBox(height: Spacing.lg),

            // UC-005 Main Flow: Step 3 - Select semester
            AppDropdown<String>(
              label: 'Pilih Semester',
              value: _selectedSemester,
              hint: 'Pilih semester',
              items: _semesters.map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value;
                  _reportGenerated = false;
                });
              },
              prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.grey),
            ),
            const SizedBox(height: Spacing.xl),

            // UC-005 Main Flow: Step 4 - Generate button
            AppButton(
              text: _isGenerating ? 'Generating...' : 'Generate Laporan',
              onPressed: _isGenerating ? null : _generateLaporan,
              isLoading: _isGenerating,
              icon: Icons.description,
            ),
            const SizedBox(height: Spacing.xxl),

            // Report Preview
            Text('Daftar Laporan', style: AppTypography.h5),
            const SizedBox(height: Spacing.md),
            _buildLaporanList(assessmentState, students),
          ],
        ),
      ),
    );
  }

  // UC-005 Main Flow: Steps 4-7 - Generate report
  Future<void> _generateLaporan() async {
    if (_selectedStudentId == null || _selectedSemester == null) {
      _showErrorSnackBar('Pilih siswa dan semester terlebih dahulu');
      return;
    }

    setState(() => _isGenerating = true);

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      // Simulate system fetching data and creating report
      await Future.delayed(const Duration(seconds: 2));

      final assessmentState = ref.read(assessmentProvider);
      final assessments = assessmentState.assessments.where((a) {
        return a.studentId == _selectedStudentId && a.semester == _selectedSemester;
      }).toList();

      if (assessments.isEmpty) {
        // UC-005 Alternative Flow: No assessments
        if (mounted) {
          Navigator.pop(context); // Close loading
          _showErrorSnackBar('Belum ada penilaian untuk siswa ini pada semester ini');
        }
      } else {
        // Compute per-aspect averages
        final Map<String, List<int>> aspectScores = {};
        for (final a in assessments) {
          aspectScores[a.aspect] = [...(aspectScores[a.aspect] ?? []), a.score];
        }

        final computedAverages = aspectScores.map(
          (key, scores) => MapEntry(key, scores.reduce((a, b) => a + b) / scores.length),
        );
        final overall = assessments.map((a) => a.score.toDouble()).reduce((a, b) => a + b) /
            assessments.length;

        // UC-005 Main Flow: Step 7 - Preview displayed
        if (mounted) {
          Navigator.pop(context); // Close loading
          setState(() {
            _isGenerating = false;
            _reportGenerated = true;
            _assessmentCount = assessments.length;
            _overallAverage = overall;
            _aspectAverages = computedAverages;
          });
          _showSuccessSnackBar('Laporan berhasil di-generate');
        }
      }
    } catch (e) {
      // UC-005 Exception Flow: Generate failed
      if (mounted) {
        Navigator.pop(context); // Close loading
        _showErrorSnackBar('Gagal generate laporan: $e');
        setState(() => _isGenerating = false);
      }
    }
  }

  // UC-005 Main Flow: Step 8 - Download PDF
  Future<void> _downloadPDF() async {
    if (_selectedStudentId == null || _selectedSemester == null) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final assessmentState = ref.read(assessmentProvider);
      final studentState = ref.read(studentProvider);
      final assessments = assessmentState.assessments.where((a) {
        return a.studentId == _selectedStudentId && a.semester == _selectedSemester;
      }).toList();

      final student = studentState.students.firstWhere(
        (s) => s.id == _selectedStudentId,
        orElse: () => Student(
          id: '', nis: '', name: '', gender: 'Laki-laki',
          birthDate: DateTime.now(), className: '', parentName: '',
          parentPhone: '', createdAt: DateTime.now(),
        ),
      );

      // Compute per-aspect averages
      final Map<String, List<int>> aspectScores = {};
      for (final a in assessments) {
        aspectScores[a.aspect] = [...(aspectScores[a.aspect] ?? []), a.score];
      }
      final aspectAverages = aspectScores.map(
        (key, scores) => MapEntry(key, scores.reduce((a, b) => a + b) / scores.length),
      );
      final overall = assessments.isNotEmpty
          ? assessments.map((a) => a.score.toDouble()).reduce((a, b) => a + b) / assessments.length
          : 0.0;

      // Generate PDF
      final pdf = pw.Document();
      final now = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            // Header
            pw.Center(
              child: pw.Text(
                'TK ISLAM SAFA',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#16A34A'),
                ),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                'Laporan Perkembangan Siswa',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                'Semester: $_selectedSemester',
                style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                'Dicetak: $now',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
              ),
            ),
            pw.Divider(height: 20, color: PdfColor.fromHex('#16A34A')),

            // Student Info
            pw.Text('DATA SISWA', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            _buildPdfInfoRow('Nama Siswa', student.name),
            _buildPdfInfoRow('NIS', student.nis),
            _buildPdfInfoRow('Jenis Kelamin', student.gender),
            _buildPdfInfoRow('Kelas', student.className),
            _buildPdfInfoRow('Orang Tua', student.parentName),
            _buildPdfInfoRow('No. HP Orang Tua', student.parentPhone),
            pw.SizedBox(height: 16),

            // Summary
            pw.Text('RINGKASAN PENILAIAN', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            _buildPdfInfoRow('Total Penilaian', '${assessments.length}'),
            _buildPdfInfoRow('Rata-rata Nilai', overall.toStringAsFixed(1)),
            pw.SizedBox(height: 16),

            // Per-Aspect Averages
            pw.Text('DETAIL NILAI PER ASPEK', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F0FDF4')),
                  children: [
                    _buildPdfTableHeader('Aspek Penilaian'),
                    _buildPdfTableHeader('Rata-rata Nilai'),
                    _buildPdfTableHeader('Keterangan'),
                  ],
                ),
                ...aspectAverages.entries.map((entry) {
                  return pw.TableRow(
                    children: [
                      _buildPdfTableCell(entry.key),
                      _buildPdfTableCell(entry.value.toStringAsFixed(1)),
                      _buildPdfTableCell(_getScoreDescription(entry.value)),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 16),

            // Detailed Assessments
            pw.Text('DETAIL PENILAIAN', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            ...assessments.map((a) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(a.aspect, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text('Nilai: ${a.score}', style: const pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Penilaian oleh: ${a.teacherName}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                    pw.SizedBox(height: 2),
                    pw.Text('Catatan: ${a.note}', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 24),

            // Signature
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Mengetahui,', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 30),
                    pw.Text('Kepala Sekolah', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 2),
                    pw.Container(
                      width: 120,
                      height: 1,
                      color: PdfColors.grey400,
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Guru Penilaian', style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 30),
                    pw.Text(_getAuthUserName(), style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 2),
                    pw.Container(
                      width: 120,
                      height: 1,
                      color: PdfColors.grey400,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      // Save PDF
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'Laporan_${student.name}_$_selectedSemester'.replaceAll(' ', '_');
      final file = File('${dir.path}/$fileName.pdf');
      await file.writeAsBytes(bytes);

      if (mounted) {
        Navigator.pop(context); // Close loading
        _showSuccessSnackBar('PDF berhasil disimpan: ${file.path}');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        _showErrorSnackBar('PDF gagal dibuat: $e');
      }
    }
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          ),
          pw.Expanded(child: pw.Text(': $value', style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.Widget _buildPdfTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  String _getScoreDescription(double score) {
    if (score >= 85) return 'Sangat Baik';
    if (score >= 70) return 'Baik';
    if (score >= 55) return 'Cukup';
    return 'Perlu Perbaikan';
  }

  String _getAuthUserName() {
    final authState = ref.read(authProvider);
    return authState.user?.name ?? '-';
  }

  Widget _buildLaporanList(AssessmentState assessmentState, List<Student> students) {
    if (_selectedStudentId == null || _selectedSemester == null) {
      return const AppEmptyState(
        message: 'Pilih siswa dan semester',
        description: 'Untuk melihat laporan perkembangan',
        icon: Icons.description_outlined,
      );
    }

    final assessments = assessmentState.assessments.where((a) {
      return a.studentId == _selectedStudentId && a.semester == _selectedSemester;
    }).toList();

    if (assessments.isEmpty) {
      // UC-005 Alternative Flow: No assessments
      return const AppEmptyState(
        message: 'Belum ada penilaian',
        description: 'Untuk siswa ini pada semester ini',
        icon: Icons.description_outlined,
      );
    }

    final student = students.firstWhere(
      (s) => s.id == _selectedStudentId,
      orElse: () => Student(
        id: '', nis: '', name: '', gender: 'Laki-laki',
        birthDate: DateTime.now(), className: '', parentName: '',
        parentPhone: '', createdAt: DateTime.now(),
      ),
    );

    final displayAverage = _reportGenerated ? _overallAverage : 0.0;
    final displayCount = _reportGenerated ? _assessmentCount : assessments.length;
    final displayAspectAverages = _reportGenerated ? _aspectAverages : <String, double>{};

    if (!_reportGenerated) {
      // Compute on-the-fly for live preview before generation
      final Map<String, List<int>> aspectScores = {};
      for (final a in assessments) {
        aspectScores[a.aspect] = [...(aspectScores[a.aspect] ?? []), a.score];
      }
      final Map<String, double> liveAverages = aspectScores.map(
        (key, scores) => MapEntry(key, scores.reduce((a, b) => a + b) / scores.length),
      );
      final liveOverall = assessments.map((a) => a.score.toDouble()).reduce((a, b) => a + b) /
          assessments.length;

      return Column(
        children: [
          _buildStudentCard(student, liveOverall, assessments.length),
          const SizedBox(height: Spacing.lg),
          _buildAspectCard(liveAverages),
          const SizedBox(height: Spacing.lg),
          AppButton(
            text: 'Download PDF',
            onPressed: null,
            isSecondary: true,
            icon: Icons.download,
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildStudentCard(student, displayAverage, displayCount),
        const SizedBox(height: Spacing.lg),
        _buildAspectCard(displayAspectAverages),
        const SizedBox(height: Spacing.lg),
        AppButton(
          text: 'Download PDF',
          onPressed: _reportGenerated ? _downloadPDF : null,
          isSecondary: true,
          icon: Icons.download,
        ),
      ],
    );
  }

  Widget _buildStudentCard(Student student, double averageScore, int count) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(student.name, style: AppTypography.h5),
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
                  _selectedSemester!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              _StatItem(
                label: 'Total Penilaian',
                value: '$count',
              ),
              const SizedBox(width: Spacing.xxl),
              _StatItem(
                label: 'Rata-rata Nilai',
                value: averageScore.toStringAsFixed(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAspectCard(Map<String, double> aspectAverages) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Penilaian Per Aspek', style: AppTypography.h5),
          const SizedBox(height: Spacing.lg),
          ...aspectAverages.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: AppChartBar(
                label: entry.key,
                value: entry.value,
                color: _getColorForAspect(entry.key),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getColorForAspect(String aspect) {
    switch (aspect) {
      case 'Motorik Kasar':
        return AppColors.primary;
      case 'Motorik Halus':
        return AppColors.secondary;
      case 'Bahasa':
        return AppColors.info;
      case 'Kognitif':
        return AppColors.warning;
      case 'Sosial Emosional':
        return AppColors.error;
      case 'Seni':
        return Colors.purple;
      case 'Agama':
        return Colors.teal;
      default:
        return AppColors.grey;
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
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.h4.copyWith(color: AppColors.primary)),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
