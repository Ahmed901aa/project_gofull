import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
  @override
  List<Object?> get props => [];
}

class LoadRequestsEvent extends RequestEvent {
  const LoadRequestsEvent();
}

class CreateFuelRequestEvent extends RequestEvent {
  final double latitude;
  final double longitude;
  final String? address;
  final String fuelType;
  final double fuelQuantity;
  final String? notes;

  const CreateFuelRequestEvent({
    required this.latitude, required this.longitude, this.address,
    required this.fuelType, required this.fuelQuantity, this.notes,
  });

  @override
  List<Object?> get props => [latitude, longitude, fuelType, fuelQuantity];
}

class CreateTowingRequestEvent extends RequestEvent {
  final double latitude;
  final double longitude;
  final String? address;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationAddress;
  final String plateNumber;
  final String? notes;

  const CreateTowingRequestEvent({
    required this.latitude, required this.longitude, this.address,
    this.destinationLatitude, this.destinationLongitude, this.destinationAddress,
    required this.plateNumber, this.notes,
  });

  @override
  List<Object?> get props => [latitude, longitude, plateNumber];
}

class LoadRequestDetailsEvent extends RequestEvent {
  final int id;
  const LoadRequestDetailsEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class CancelRequestEvent extends RequestEvent {
  final int id;
  const CancelRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class RateProviderEvent extends RequestEvent {
  final int requestId;
  final int rating;
  final String? comment;

  const RateProviderEvent({
    required this.requestId, required this.rating, this.comment,
  });

  @override
  List<Object?> get props => [requestId, rating, comment];
}
