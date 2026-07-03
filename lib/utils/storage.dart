import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../models/assessment.dart';
import '../models/documentation.dart';

class StorageService {
  static const String _sessionKey = 'session';
  static const String _studentsKey = 'students';
  static const String _assessmentsKey = 'assessments';
  static const String _documentationKey = 'documentation';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_sessionKey)) {
      await _initDefaultData();
    }
  }

  static Future<void> _initDefaultData() async {
    final prefs = await SharedPreferences.getInstance();

    final defaultStudents = [
      Student(
        id: '1',
        nis: '2024001',
        name: 'Ahmad Rizki',
        gender: 'Laki-laki',
        birthDate: DateTime(2020, 5, 15),
        className: 'A',
        parentName: 'Pak Ahmad',
        parentPhone: '081234567890',
        photoUrl: null,
        createdAt: DateTime.now(),
      ),
      Student(
        id: '2',
        nis: '2024002',
        name: 'Siti Nurhaliza',
        gender: 'Perempuan',
        birthDate: DateTime(2020, 8, 20),
        className: 'A',
        parentName: 'Pak Budi',
        parentPhone: '081234567891',
        photoUrl: null,
        createdAt: DateTime.now(),
      ),
      Student(
        id: '3',
        nis: '2024003',
        name: 'Muhammad Fadil',
        gender: 'Laki-laki',
        birthDate: DateTime(2021, 3, 10),
        className: 'B',
        parentName: 'Pak Doni',
        parentPhone: '081234567892',
        photoUrl: null,
        createdAt: DateTime.now(),
      ),
    ];

    final defaultAssessments = [
      Assessment(
        id: '1',
        studentId: '1',
        studentName: 'Ahmad Rizki',
        aspect: 'Motorik Kasar',
        score: 85,
        note: 'Sudah sangat baik dalam berlari dan melompat',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '2',
        studentId: '1',
        studentName: 'Ahmad Rizki',
        aspect: 'Bahasa',
        score: 90,
        note: 'Mampu bercerita dengan lancar',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '3',
        studentId: '2',
        studentName: 'Siti Nurhaliza',
        aspect: 'Motorik Kasar',
        score: 78,
        note: 'Perlu latihan koordinasi lebih',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '4',
        studentId: '2',
        studentName: 'Siti Nurhaliza',
        aspect: 'Bahasa',
        score: 88,
        note: 'Sangat aktif dalam bercerita',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '5',
        studentId: '2',
        studentName: 'Siti Nurhaliza',
        aspect: 'Kognitif',
        score: 82,
        note: 'Kemampuan menghitung sudah baik',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '6',
        studentId: '3',
        studentName: 'Muhammad Fadil',
        aspect: 'Motorik Kasar',
        score: 75,
        note: 'Masih perlu bimbingan dalam motorik kasar',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
      Assessment(
        id: '7',
        studentId: '3',
        studentName: 'Muhammad Fadil',
        aspect: 'Sosial',
        score: 80,
        note: 'Cukup aktif dalam bermain kelompok',
        photoUrls: [],
        semester: 'Ganjil 2024',
        teacherId: '1',
        teacherName: 'Ibu Sarah',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    ];

    final defaultDocumentation = [
      Documentation(
        id: '1',
        studentId: '1',
        studentName: 'Ahmad Rizki',
        photoUrl: 'https://via.placeholder.com/300',
        description: 'Kegiatan bermain di taman',
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    ];

    await prefs.setString(_sessionKey, '');
    await prefs.setString(_studentsKey, json.encode(defaultStudents.map((s) => s.toMap()).toList()));
    await prefs.setString(_assessmentsKey, json.encode(defaultAssessments.map((a) => a.toMap()).toList()));
    await prefs.setString(_documentationKey, json.encode(defaultDocumentation.map((d) => d.toMap()).toList()));
  }

  static Future<void> saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, user.toJson());
  }

  static Future<User?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.getString(_sessionKey);
    if (session != null && session.isNotEmpty) {
      return User.fromJson(session);
    }
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, '');
  }

  static Future<void> saveStudents(List<Student> students) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentsKey, json.encode(students.map((s) => s.toMap()).toList()));
  }

  static Future<List<Student>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_studentsKey);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => Student.fromMap(item)).toList();
    }
    return [];
  }

  static Future<void> saveAssessments(List<Assessment> assessments) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_assessmentsKey, json.encode(assessments.map((a) => a.toMap()).toList()));
  }

  static Future<List<Assessment>> getAssessments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_assessmentsKey);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => Assessment.fromMap(item)).toList();
    }
    return [];
  }

  static Future<void> saveDocumentation(List<Documentation> documentation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_documentationKey, json.encode(documentation.map((d) => d.toMap()).toList()));
  }

  static Future<List<Documentation>> getDocumentation() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_documentationKey);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => Documentation.fromMap(item)).toList();
    }
    return [];
  }
}
