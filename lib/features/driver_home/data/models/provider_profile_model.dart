class ProviderProfileModel {
  final int id;
  final String name;
  final String phone;
  final String role;
  final String serviceType;
  final String vehicleMake;
  final String vehicleModel;
  final int vehicleYear;
  final String vehiclePlate;
  final String? vehicleColor;
  final bool isAvailable;
  final String verificationStatus;
  final double averageRating;
  final int totalRatings;
  final String? createdAt;
  final List<DocumentModel> documents;

  const ProviderProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.serviceType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehiclePlate,
    this.vehicleColor,
    required this.isAvailable,
    required this.verificationStatus,
    required this.averageRating,
    required this.totalRatings,
    this.createdAt,
    this.documents = const [],
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      serviceType: json['service_type'] ?? '',
      vehicleMake: json['vehicle_make'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      vehicleYear: json['vehicle_year'] ?? 0,
      vehiclePlate: json['vehicle_plate'] ?? '',
      vehicleColor: json['vehicle_color'],
      isAvailable: json['is_available'] ?? false,
      verificationStatus: json['verification_status'] ?? 'pending',
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      createdAt: json['created_at'],
      documents: (json['documents'] as List?)
              ?.map((d) => DocumentModel.fromJson(d))
              .toList() ??
          [],
    );
  }
}

class DocumentModel {
  final int id;
  final String type;
  final String path;

  const DocumentModel({
    required this.id,
    required this.type,
    required this.path,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      path: json['path'] ?? '',
    );
  }
}
