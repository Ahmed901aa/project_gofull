class ServiceRequestModel {
  final int id;
  final int driverId;
  final int? providerId;
  final String serviceType;
  final String status;
  final double driverLatitude;
  final double driverLongitude;
  final String? driverAddress;
  final String? notes;
  final String? fuelType;
  final double? fuelQuantity;
  final String? plateNumber;
  final String? acceptedAt;
  final String? arrivedAt;
  final String? completedAt;
  final String? cancelledAt;
  final String? cancelledBy;
  final String? cancellationReason;
  final String createdAt;
  final DriverInfo? driver;
  final RatingInfo? rating;

  const ServiceRequestModel({
    required this.id,
    required this.driverId,
    this.providerId,
    required this.serviceType,
    required this.status,
    required this.driverLatitude,
    required this.driverLongitude,
    this.driverAddress,
    this.notes,
    this.fuelType,
    this.fuelQuantity,
    this.plateNumber,
    this.acceptedAt,
    this.arrivedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    required this.createdAt,
    this.driver,
    this.rating,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      providerId: json['provider_id'],
      serviceType: json['service_type'] ?? '',
      status: json['status'] ?? '',
      driverLatitude: (json['driver_latitude'] ?? 0).toDouble(),
      driverLongitude: (json['driver_longitude'] ?? 0).toDouble(),
      driverAddress: json['driver_address'],
      notes: json['notes'],
      fuelType: json['fuel_type'],
      fuelQuantity: json['fuel_quantity'] != null
          ? (json['fuel_quantity']).toDouble()
          : null,
      plateNumber: json['plate_number'],
      acceptedAt: json['accepted_at'],
      arrivedAt: json['arrived_at'],
      completedAt: json['completed_at'],
      cancelledAt: json['cancelled_at'],
      cancelledBy: json['cancelled_by'],
      cancellationReason: json['cancellation_reason'],
      createdAt: json['created_at'] ?? '',
      driver: json['driver'] != null
          ? DriverInfo.fromJson(json['driver'])
          : null,
      rating: json['rating'] != null
          ? RatingInfo.fromJson(json['rating'])
          : null,
    );
  }

  bool get isTowing => serviceType == 'towing';
  bool get isFuel => serviceType == 'fuel_delivery';
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isRated => rating != null;
}

class DriverInfo {
  final int id;
  final String name;
  final String phone;

  const DriverInfo({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class RatingInfo {
  final int id;
  final int rating;
  final String? comment;

  const RatingInfo({
    required this.id,
    required this.rating,
    this.comment,
  });

  factory RatingInfo.fromJson(Map<String, dynamic> json) {
    return RatingInfo(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
    );
  }
}
