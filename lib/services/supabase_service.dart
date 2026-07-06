import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app;
import '../models/student.dart';
import '../models/assessment.dart';
import '../models/documentation.dart';

class SupabaseService {
  static SupabaseClient get _client => Supabase.instance.client;

  // ==================== AUTH ====================

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required int role,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentAuthUser => _client.auth.currentUser;

  static Session? get currentSession => _client.auth.currentSession;

  // ==================== PROFILES ====================

  static Future<app.User?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return app.User.fromSupabase(data);
  }

  static Future<void> updateProfile(app.User user) async {
    await _client
        .from('profiles')
        .update(user.toSupabase())
        .eq('id', user.id);
  }

  // ==================== STUDENTS ====================

  static Future<List<Student>> getStudents() async {
    final data = await _client
        .from('students')
        .select()
        .order('created_at', ascending: false);
    return data.map((item) => Student.fromSupabase(item)).toList();
  }

  static Future<Student> addStudent(Student student) async {
    final data = await _client
        .from('students')
        .insert(student.toSupabase())
        .select()
        .single();
    return Student.fromSupabase(data);
  }

  static Future<Student> updateStudent(Student student) async {
    final data = await _client
        .from('students')
        .update(student.toSupabase())
        .eq('id', student.id)
        .select()
        .single();
    return Student.fromSupabase(data);
  }

  static Future<void> deleteStudent(String id) async {
    await _client.from('students').delete().eq('id', id);
  }

  // ==================== ASSESSMENTS ====================

  static Future<List<Assessment>> getAssessments() async {
    final data = await _client
        .from('assessments')
        .select()
        .order('created_at', ascending: false);
    return data.map((item) => Assessment.fromSupabase(item)).toList();
  }

  static Future<Assessment> addAssessment(Assessment assessment) async {
    final data = await _client
        .from('assessments')
        .insert(assessment.toSupabase())
        .select()
        .single();
    return Assessment.fromSupabase(data);
  }

  static Future<Assessment> updateAssessment(Assessment assessment) async {
    final data = await _client
        .from('assessments')
        .update(assessment.toSupabase())
        .eq('id', assessment.id)
        .select()
        .single();
    return Assessment.fromSupabase(data);
  }

  static Future<void> deleteAssessment(String id) async {
    await _client.from('assessments').delete().eq('id', id);
  }

  // ==================== DOCUMENTATION ====================

  static Future<List<Documentation>> getDocumentation() async {
    final data = await _client
        .from('documentation')
        .select()
        .order('created_at', ascending: false);
    return data.map((item) => Documentation.fromSupabase(item)).toList();
  }

  static Future<Documentation> addDocumentation(Documentation doc) async {
    final data = await _client
        .from('documentation')
        .insert(doc.toSupabase())
        .select()
        .single();
    return Documentation.fromSupabase(data);
  }

  static Future<void> deleteDocumentation(String id) async {
    await _client.from('documentation').delete().eq('id', id);
  }

  // ==================== STORAGE (Photos) ====================

  static Future<String> uploadPhoto({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await _client.storage.from(bucket).upload(
      path,
      file,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
    );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  static Future<void> deletePhoto({
    required String bucket,
    required String path,
  }) async {
    await _client.storage.from(bucket).remove([path]);
  }
}
