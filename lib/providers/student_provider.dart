import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../utils/storage.dart';

class StudentState {
  final List<Student> students;
  final bool isLoading;
  final String? error;

  StudentState({
    this.students = const [],
    this.isLoading = false,
    this.error,
  });

  StudentState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? error,
  }) {
    return StudentState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StudentNotifier extends StateNotifier<StudentState> {
  StudentNotifier() : super(StudentState()) {
    loadStudents();
  }

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true);
    final students = await StorageService.getStudents();
    state = StudentState(students: students);
  }

  Future<void> addStudent(Student student) async {
    final updated = [...state.students, student];
    await StorageService.saveStudents(updated);
    state = state.copyWith(students: updated);
  }

  Future<void> updateStudent(Student updatedStudent) async {
    final updated = state.students.map((s) {
      return s.id == updatedStudent.id ? updatedStudent : s;
    }).toList();
    await StorageService.saveStudents(updated);
    state = state.copyWith(students: updated);
  }

  Future<void> deleteStudent(String id) async {
    final updated = state.students.where((s) => s.id != id).toList();
    await StorageService.saveStudents(updated);
    state = state.copyWith(students: updated);
  }

  List<Student> searchStudents(String query) {
    if (query.isEmpty) return state.students;
    return state.students.where((s) {
      return s.name.toLowerCase().contains(query.toLowerCase()) ||
          s.nis.contains(query);
    }).toList();
  }

  List<Student> filterByClass(String className) {
    if (className.isEmpty) return state.students;
    return state.students.where((s) => s.className == className).toList();
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  return StudentNotifier();
});
