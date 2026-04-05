import 'package:equatable/equatable.dart';

class ProviderProfileEntity extends Equatable {
  final int id;
  final int userId;
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
  final String? userName;
  final String? userPhone;

  const ProviderProfileEntity({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehiclePlate,
    this.vehicleColor,
    this.isAvailable = false,
    this.verificationStatus = 'pending',
    this.averageRating = 0,
    this.totalRatings = 0,
    this.userName,
    this.userPhone,
  });

  bool get isFuelProvider => serviceType == 'fuel_delivery';
  bool get isTowingProvider => serviceType == 'towing';
  bool get isApproved => verificationStatus == 'approved';

  @override
  List<Object?> get props => [id, userId, isAvailable, verificationStatus];
}
