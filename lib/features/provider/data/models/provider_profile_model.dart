import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';

class ProviderProfileModel extends ProviderProfileEntity {
  const ProviderProfileModel({
    required super.id, required super.userId, required super.serviceType,
    required super.vehicleMake, required super.vehicleModel,
    required super.vehicleYear, required super.vehiclePlate,
    super.vehicleColor, super.isAvailable, super.verificationStatus,
    super.averageRating, super.totalRatings, super.completedOrders,
    super.userName, super.userPhone,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return ProviderProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int? ?? json['id'] as int,
      serviceType: json['service_type'] as String,
      vehicleMake: json['vehicle_make'] as String,
      vehicleModel: json['vehicle_model'] as String,
      vehicleYear: json['vehicle_year'] as int,
      vehiclePlate: json['vehicle_plate'] as String,
      vehicleColor: json['vehicle_color'] as String?,
      isAvailable: json['is_available'] as bool? ?? false,
      verificationStatus:
          (json['verification_status'] as String?) ?? 'pending',
      averageRating:
          (json['average_rating'] as num?)?.toDouble() ?? 0,
      totalRatings: json['total_ratings'] as int? ?? 0,
      completedOrders: json['completed_orders'] as int? ?? 0,
      userName: user?['name'] as String? ?? json['name'] as String?,
      userPhone: user?['phone'] as String? ?? json['phone'] as String?,
    );
  }
}
