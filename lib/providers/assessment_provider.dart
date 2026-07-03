import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment.dart';
import '../utils/storage.dart';

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
    state = state.copyWith(isLoading: true);
    final assessments = await StorageService.getAssessments();
    state = AssessmentState(assessments: assessments);
  }

  Future<void> addAssessment(Assessment assessment) async {
    final updated = [...state.assessments, assessment];
    await StorageService.saveAssessments(updated);
    state = state.copyWith(assessments: updated);
  }

  Future<void> updateAssessment(Assessment updatedAssessment) async {
    final updated = state.assessments.map((a) {
      return a.id == updatedAssessment.id ? updatedAssessment : a;
    }).toList();
    await StorageService.saveAssessments(updated);
    state = state.copyWith(assessments: updated);
  }

  Future<void> deleteAssessment(String id) async {
    final updated = state.assessments.where((a) => a.id != id).toList();
    await StorageService.saveAssessments(updated);
    state = state.copyWith(assessments: updated);
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
