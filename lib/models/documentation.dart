import 'dart:convert';

class Documentation {
  final String id;
  final String studentId;
  final String studentName;
  final String photoUrl;
  final String description;
  final DateTime date;
  final DateTime createdAt;

  Documentation({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.photoUrl,
    required this.description,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'photoUrl': photoUrl,
      'description': description,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Documentation.fromMap(Map<String, dynamic> map) {
    return Documentation(
      id: map['id'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      photoUrl: map['photoUrl'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory Documentation.fromSupabase(Map<String, dynamic> map) {
    return Documentation(
      id: map['id'],
      studentId: map['student_id'],
      studentName: map['student_name'],
      photoUrl: map['photo_url'],
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'photo_url': photoUrl,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
    };
  }

  String toJson() => json.encode(toMap());

  factory Documentation.fromJson(String source) => Documentation.fromMap(json.decode(source));

  Documentation copyWith({
    String? photoUrl,
    String? description,
    DateTime? date,
  }) {
    return Documentation(
      id: id,
      studentId: studentId,
      studentName: studentName,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt,
    );
  }
}
