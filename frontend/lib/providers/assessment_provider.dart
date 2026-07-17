import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment.dart';
import '../services/supabase_service.dart';

class AssessmentState {
  final List<Assessment> assessments;
  final bool isLoading;
  final String? error;

  AssessmentState({
    this.assessments = const [],
    this.isLoading = false,
    this.error,
  });

  AssessmentState copyWith({
    List<Assessment>? assessments,
    bool? isLoading,
    String? error,
  }) {
    return AssessmentState(
      assessments: assessments ?? this.assessments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AssessmentNotifier extends StateNotifier<AssessmentState> {
  AssessmentNotifier() : super(AssessmentState()) {
    loadAssessments();
  }

  Future<void> loadAssessments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final assessments = await SupabaseService.getAssessments();
      state = AssessmentState(assessments: assessments);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat penilaian');
    }
  }

  Future<void> addAssessment(Assessment assessment) async {
    try {
      final newAssessment = await SupabaseService.addAssessment(assessment);
      state = state.copyWith(assessments: [newAssessment, ...state.assessments]);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menambah penilaian');
    }
  }

  Future<void> updateAssessment(Assessment updatedAssessment) async {
    try {
      final updated = await SupabaseService.updateAssessment(updatedAssessment);
      final assessments = state.assessments.map((a) {
        return a.id == updated.id ? updated : a;
      }).toList();
      state = state.copyWith(assessments: assessments);
    } catch (e) {
      state = state.copyWith(error: 'Gagal memperbarui penilaian');
    }
  }

  Future<void> deleteAssessment(String id) async {
    try {
      await SupabaseService.deleteAssessment(id);
      final updated = state.assessments.where((a) => a.id != id).toList();
      state = state.copyWith(assessments: updated);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus penilaian');
    }
  }

  List<Assessment> getByStudent(String studentId) {
    return state.assessments.where((a) => a.studentId == studentId).toList();
  }

  List<Assessment> getBySemester(String semester) {
    return state.assessments.where((a) => a.semester == semester).toList();
  }

  List<Assessment> getByTeacher(String teacherId) {
    return state.assessments.where((a) => a.teacherId == teacherId).toList();
  }

  bool hasAssessments(String studentId) {
    return state.assessments.any((a) => a.studentId == studentId);
  }
}

final assessmentProvider = StateNotifierProvider<AssessmentNotifier, AssessmentState>((ref) {
  return AssessmentNotifier();
});
