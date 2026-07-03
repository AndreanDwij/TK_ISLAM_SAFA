import 'dart:convert';

enum UserRole { guru, kepalaSekolah, orangTua }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? photoUrl;
  final String? childId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.photoUrl,
    this.childId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.index,
      'photoUrl': photoUrl,
      'childId': childId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: UserRole.values[map['role']],
      photoUrl: map['photoUrl'],
      childId: map['childId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? photoUrl,
    String? childId,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      childId: childId ?? this.childId,
    );
  }
}
