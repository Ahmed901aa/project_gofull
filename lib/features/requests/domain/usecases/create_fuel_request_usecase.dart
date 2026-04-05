import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class CreateFuelRequestUseCase
    extends UseCase<ServiceRequestEntity, CreateFuelRequestParams> {
  final RequestRepository repository;
  CreateFuelRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceRequestEntity>> call(
          CreateFuelRequestParams params) =>
      repository.createFuelRequest(
        latitude: params.latitude,
        longitude: params.longitude,
        address: params.address,
        fuelType: params.fuelType,
        fuelQuantity: params.fuelQuantity,
        notes: params.notes,
      );
}

class CreateFuelRequestParams extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String fuelType;
  final double fuelQuantity;
  final String? notes;

  const CreateFuelRequestParams({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.fuelType,
    required this.fuelQuantity,
    this.notes,
  });

  @override
  List<Object?> get props => [latitude, longitude, fuelType, fuelQuantity];
}
