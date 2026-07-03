import 'dart:convert';

class Assessment {
  final String id;
  final String studentId;
  final String studentName;
  final String aspect;
  final int score;
  final String note;
  final List<String> photoUrls;
  final String semester;
  final String teacherId;
  final String teacherName;
  final DateTime date;
  final DateTime createdAt;

  Assessment({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.aspect,
    required this.score,
    required this.note,
    required this.photoUrls,
    required this.semester,
    required this.teacherId,
    required this.teacherName,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'aspect': aspect,
      'score': score,
      'note': note,
      'photoUrls': photoUrls,
      'semester': semester,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      id: map['id'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      aspect: map['aspect'],
      score: map['score'],
      note: map['note'],
      photoUrls: List<String>.from(map['photoUrls']),
      semester: map['semester'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Assessment.fromJson(String source) => Assessment.fromMap(json.decode(source));

  Assessment copyWith({
    String? aspect,
    int? score,
    String? note,
    List<String>? photoUrls,
    String? semester,
    DateTime? date,
  }) {
    return Assessment(
      id: id,
      studentId: studentId,
      studentName: studentName,
      aspect: aspect ?? this.aspect,
      score: score ?? this.score,
      note: note ?? this.note,
      photoUrls: photoUrls ?? this.photoUrls,
      semester: semester ?? this.semester,
      teacherId: teacherId,
      teacherName: teacherName,
      date: date ?? this.date,
      createdAt: createdAt,
    );
  }
}
