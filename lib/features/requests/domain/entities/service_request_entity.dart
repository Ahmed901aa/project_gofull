import 'package:equatable/equatable.dart';

class ServiceRequestEntity extends Equatable {
  final int id;
  final int driverId;
  final int? providerId;
  final String serviceType;
  final String status;
  final String driverLatitude;
  final String driverLongitude;
  final String? driverAddress;
  final String? fuelType;
  final String? fuelQuantity;
  final String? plateNumber;
  final String? notes;
  final String? acceptedAt;
  final String? arrivedAt;
  final String? completedAt;
  final String? cancelledAt;
  final String? cancelledBy;
  final String? cancellationReason;
  final String? createdAt;
  final Map<String, dynamic>? providerInfo;
  final Map<String, dynamic>? driverInfo;
  final Map<String, dynamic>? ratingInfo;

  const ServiceRequestEntity({
    required this.id,
    required this.driverId,
    this.providerId,
    required this.serviceType,
    required this.status,
    required this.driverLatitude,
    required this.driverLongitude,
    this.driverAddress,
    this.fuelType,
    this.fuelQuantity,
    this.plateNumber,
    this.notes,
    this.acceptedAt,
    this.arrivedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    this.createdAt,
    this.providerInfo,
    this.driverInfo,
    this.ratingInfo,
  });

  bool get isFuelDelivery => serviceType == 'fuel_delivery';
  bool get isTowing => serviceType == 'towing';
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isActive => !isCompleted && !isCancelled;
  bool get isRated => ratingInfo != null;

  @override
  List<Object?> get props => [id, status];
}
