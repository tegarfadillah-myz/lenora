// lib/models/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? nohp;
  final String? foto;
  final String? namaBelakang;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.nohp,
    this.foto,
    this.namaBelakang,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      nohp: json['nohp'],
      foto: json['foto'],
      namaBelakang: json['namabelakang'],
      role: json['role'] ?? 'user',
    );
  }
}
