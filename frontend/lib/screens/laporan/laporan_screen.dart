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
import '../../widgets/empty_state.dart';
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
    final childId = authState.user?.childId;

    if (isOrangTua && childId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFF59E0B)],
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
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Laporan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: AppEmptyState(
                message: 'Belum Terhubung dengan Siswa',
                description: 'Hubungi admin/guru untuk menghubungkan akun Orang Tua Anda dengan anak Anda di sistem.',
                icon: Icons.person_off_outlined,
              ),
            ),
          ],
        ),
      );
    }

    List<Student> students = studentState.students;

    if (isOrangTua) {
      students = students.where((s) => s.id == childId).toList();
      _selectedStudentId ??= childId;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF97316), Color(0xFFF59E0B)],
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
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Laporan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Dropdowns row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedStudentId,
                              hint: const Text('Pilih Siswa', style: TextStyle(color: Colors.white70)),
                              isExpanded: true,
                              dropdownColor: AppColors.surface,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                              items: students.map<DropdownMenuItem<String>>((s) {
                                return DropdownMenuItem(value: s.id, child: Text(s.name));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStudentId = value;
                                  _reportGenerated = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSemester,
                              hint: const Text('Semester', style: TextStyle(color: Colors.white70)),
                              isExpanded: true,
                              dropdownColor: AppColors.surface,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                              items: _semesters.map((s) {
                                return DropdownMenuItem(value: s, child: Text(s));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSemester = value;
                                  _reportGenerated = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateLaporan,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.auto_awesome, color: Colors.white),
                      label: Text(
                        _isGenerating ? 'Generating...' : 'Generate Laporan',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Report Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daftar Laporan', style: AppTypography.h5),
                  const SizedBox(height: Spacing.md),
                  _buildLaporanList(assessmentState, students),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateLaporan() async {
    if (_selectedStudentId == null || _selectedSemester == null) {
      _showErrorSnackBar('Pilih siswa dan semester terlebih dahulu');
      return;
    }

    setState(() => _isGenerating = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      final assessmentState = ref.read(assessmentProvider);
      final assessments = assessmentState.assessments.where((a) {
        return a.studentId == _selectedStudentId && a.semester == _selectedSemester;
      }).toList();

      if (assessments.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          _showErrorSnackBar('Belum ada penilaian untuk siswa ini pada semester ini');
        }
      } else {
        final Map<String, List<int>> aspectScores = {};
        for (final a in assessments) {
          aspectScores[a.aspect] = [...(aspectScores[a.aspect] ?? []), a.score];
        }

        final computedAverages = aspectScores.map(
          (key, scores) => MapEntry(key, scores.reduce((a, b) => a + b) / scores.length),
        );
        final overall = assessments.map((a) => a.score.toDouble()).reduce((a, b) => a + b) /
            assessments.length;

        if (mounted) {
          Navigator.pop(context);
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
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar('Gagal generate laporan: $e');
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _downloadPDF() async {
    if (_selectedStudentId == null || _selectedSemester == null) return;

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

      final pdf = pw.Document();
      final now = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
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

            pw.Text('DATA SISWA', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            _buildPdfInfoRow('Nama Siswa', student.name),
            _buildPdfInfoRow('NIS', student.nis),
            _buildPdfInfoRow('Jenis Kelamin', student.gender),
            _buildPdfInfoRow('Kelas', student.className),
            _buildPdfInfoRow('Orang Tua', student.parentName),
            _buildPdfInfoRow('No. HP Orang Tua', student.parentPhone),
            pw.SizedBox(height: 16),

            pw.Text('RINGKASAN PENILAIAN', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            _buildPdfInfoRow('Total Penilaian', '${assessments.length}'),
            _buildPdfInfoRow('Rata-rata Nilai', overall.toStringAsFixed(1)),
            pw.SizedBox(height: 16),

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

      final bytes = await pdf.save();
      final dir = await getExternalStorageDirectory();
      final downloadDir = Directory('${dir!.path}/../../../../Download');
      final resolvedDir = Directory(await downloadDir.resolveSymbolicLinks());
      if (!await resolvedDir.exists()) {
        await resolvedDir.create(recursive: true);
      }
      final fileName = 'Laporan_${student.name}_$_selectedSemester'.replaceAll(' ', '_');
      final file = File('${resolvedDir.path}/$fileName.pdf');
      await file.writeAsBytes(bytes);

      if (mounted) {
        Navigator.pop(context);
        _showSuccessSnackBar('PDF disimpan di folder Download: $fileName.pdf');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
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
          _buildDownloadButton(false),
        ],
      );
    }

    return Column(
      children: [
        _buildStudentCard(student, displayAverage, displayCount),
        const SizedBox(height: Spacing.lg),
        _buildAspectCard(displayAspectAverages),
        const SizedBox(height: Spacing.lg),
        _buildDownloadButton(true),
      ],
    );
  }

  Widget _buildDownloadButton(bool enabled) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [Color(0xFFF97316), Color(0xFFF59E0B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: enabled ? null : AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? _downloadPDF : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download,
                  color: enabled ? Colors.white : AppColors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Download PDF',
                  style: TextStyle(
                    color: enabled ? Colors.white : AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student, double averageScore, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(student.name, style: AppTypography.h5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedSemester!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Total Penilaian',
                  value: '$count',
                  color: AppColors.schoolBlue,
                  icon: Icons.analytics_outlined,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              Expanded(
                child: _StatItem(
                  label: 'Rata-rata Nilai',
                  value: averageScore.toStringAsFixed(1),
                  color: AppColors.orange,
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAspectCard(Map<String, double> aspectAverages) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.schoolYellow.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.schoolYellow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColors.yellowGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text('Detail Penilaian Per Aspek', style: AppTypography.h5),
            ],
          ),
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
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.h4.copyWith(color: color),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
