import 'dart:convert';

enum Gender { lakiLaki, perempuan }

class Student {
  final String id;
  final String nis;
  final String name;
  final String gender;
  final DateTime birthDate;
  final String className;
  final String parentName;
  final String parentPhone;
  final String? photoUrl;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.nis,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.className,
    required this.parentName,
    required this.parentPhone,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nis': nis,
      'name': name,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'className': className,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nis: map['nis'],
      name: map['name'],
      gender: map['gender'],
      birthDate: DateTime.parse(map['birthDate']),
      className: map['className'],
      parentName: map['parentName'],
      parentPhone: map['parentPhone'],
      photoUrl: map['photoUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));

  Student copyWith({
    String? nis,
    String? name,
    String? gender,
    DateTime? birthDate,
    String? className,
    String? parentName,
    String? parentPhone,
    String? photoUrl,
  }) {
    return Student(
      id: id,
      nis: nis ?? this.nis,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      className: className ?? this.className,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}
