class AdminModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String password;
  final String role;
  final String status;
  final String email;

  const AdminModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.password,
    required this.role,
    required this.status,
    required this.email,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    name: json['name'] as String,
    password: json['password'] as String,
    role: json['role'] as String,
    status: json['status'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toIso8601String(),
    'name': name,
    'password': password,
    'role': role,
    'status': status,
    'email': email,
  };
}