import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../services/supabase_service.dart';

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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final students = await SupabaseService.getStudents();
      state = StudentState(students: students);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat data siswa');
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      final newStudent = await SupabaseService.addStudent(student);
      state = state.copyWith(students: [newStudent, ...state.students]);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menambah siswa');
    }
  }

  Future<void> updateStudent(Student updatedStudent) async {
    try {
      final updated = await SupabaseService.updateStudent(updatedStudent);
      final students = state.students.map((s) {
        return s.id == updated.id ? updated : s;
      }).toList();
      state = state.copyWith(students: students);
    } catch (e) {
      state = state.copyWith(error: 'Gagal memperbarui siswa');
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await SupabaseService.deleteStudent(id);
      final updated = state.students.where((s) => s.id != id).toList();
      state = state.copyWith(students: updated);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus siswa');
    }
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
