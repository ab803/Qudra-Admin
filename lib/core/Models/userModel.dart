class UserModel {
  final String id;
  final DateTime? createdAt;
  final String? fullName;
  final String? phone;
  final String email;
  final String? disabilityType;
  final String? responsiblePerson;
  final String? gender;
  final int? age;

  const UserModel({
    required this.id,
    this.createdAt,
    this.fullName,
    this.phone,
    required this.email,
    this.disabilityType,
    this.responsiblePerson,
    this.gender,
    this.age,
  });

  // Derived helpers used by the UI
  String get initials {
    if (fullName == null || fullName!.trim().isEmpty) return '?';
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String get displayName => fullName ?? email;

  String get demographics {
    final parts = <String>[];
    if (age != null) parts.add('${age} yrs');
    if (gender != null) parts.add(gender!);
    return parts.join(' • ');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      disabilityType: json['disability_type'] as String?,
      responsiblePerson: json['responsible_person'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'email': email,
    'disability_type': disabilityType,
    'responsible_person': responsiblePerson,
    'gender': gender,
    'age': age,
  };

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? disabilityType,
    String? responsiblePerson,
    String? gender,
    int? age,
  }) {
    return UserModel(
      id: id,
      createdAt: createdAt,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      disabilityType: disabilityType ?? this.disabilityType,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }
}