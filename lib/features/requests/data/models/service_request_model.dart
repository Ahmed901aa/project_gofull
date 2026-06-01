import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  const ServiceRequestModel({
    required super.id, required super.driverId, super.providerId,
    required super.serviceType, required super.status,
    required super.driverLatitude, required super.driverLongitude,
    super.driverAddress,
    super.destinationLatitude, super.destinationLongitude, super.destinationAddress,
    super.fuelType, super.fuelQuantity, super.plateNumber, super.carType,
    super.notes, super.acceptedAt, super.arrivedAt, super.completedAt,
    super.cancelledAt, super.cancelledBy, super.cancellationReason,
    super.createdAt, super.pricePerLiter, super.subtotal, super.serviceFee,
    super.total, super.paymentMethod, super.paymentStatus,
    super.providerInfo, super.driverInfo, super.ratingInfo,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as int,
      driverId: json['driver_id'] as int,
      providerId: json['provider_id'] as int?,
      serviceType: json['service_type'] as String,
      status: json['status'] as String,
      driverLatitude: (json['driver_latitude'] ?? '0').toString(),
      driverLongitude: (json['driver_longitude'] ?? '0').toString(),
      driverAddress: json['driver_address'] as String?,
      destinationLatitude: json['destination_latitude']?.toString(),
      destinationLongitude: json['destination_longitude']?.toString(),
      destinationAddress: json['destination_address'] as String?,
      fuelType: json['fuel_type'] as String?,
      fuelQuantity: json['fuel_quantity']?.toString(),
      plateNumber: json['plate_number'] as String?,
      carType: json['car_type'] as String?,
      notes: json['notes'] as String?,
      acceptedAt: json['accepted_at'] as String?,
      arrivedAt: json['arrived_at'] as String?,
      completedAt: json['completed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] as String?,
      pricePerLiter: json['price_per_liter']?.toString(),
      subtotal: json['subtotal']?.toString(),
      serviceFee: json['service_fee']?.toString(),
      total: json['total']?.toString(),
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      providerInfo: json['provider'] as Map<String, dynamic>?,
      driverInfo: json['driver'] as Map<String, dynamic>?,
      ratingInfo: json['rating'] as Map<String, dynamic>?,
    );
  }
}
