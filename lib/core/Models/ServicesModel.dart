class ServiceModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? description;
  final String? category;
  final String institutionId;
  final List<dynamic>? supportedDisabilities;
  final double? price;
  final bool isFree;
  final int? durationMinutes;
  final String? locationMode;
  final String? bookingType;
  final String? availabilityNotes;
  final bool isActive;

  const ServiceModel({
    required this.id,
    required this.createdAt,
    required this.name,
    this.description,
    this.category,
    required this.institutionId,
    this.supportedDisabilities,
    this.price,
    required this.isFree,
    this.durationMinutes,
    this.locationMode,
    this.bookingType,
    this.availabilityNotes,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      institutionId: json['institution_id'] as String? ?? '',
      supportedDisabilities: json['supported_disabilities'] as List<dynamic>?,
      price: (json['price'] as num?)?.toDouble(),
      isFree: json['is_free'] as bool? ?? false,
      durationMinutes: json['duration_minutes'] as int?,
      locationMode: json['location_mode'] as String?,
      bookingType: json['booking_type'] as String?,
      availabilityNotes: json['availability_notes'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toIso8601String(),
    'name': name,
    'description': description,
    'category': category,
    'institution_id': institutionId,
    'supported_disabilities': supportedDisabilities,
    'price': price,
    'is_free': isFree,
    'duration_minutes': durationMinutes,
    'location_mode': locationMode,
    'booking_type': bookingType,
    'availability_notes': availabilityNotes,
    'is_active': isActive,
  };

  ServiceModel copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? description,
    String? category,
    String? institutionId,
    List<dynamic>? supportedDisabilities,
    double? price,
    bool? isFree,
    int? durationMinutes,
    String? locationMode,
    String? bookingType,
    String? availabilityNotes,
    bool? isActive,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      institutionId: institutionId ?? this.institutionId,
      supportedDisabilities: supportedDisabilities ?? this.supportedDisabilities,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      locationMode: locationMode ?? this.locationMode,
      bookingType: bookingType ?? this.bookingType,
      availabilityNotes: availabilityNotes ?? this.availabilityNotes,
      isActive: isActive ?? this.isActive,
    );
  }
}