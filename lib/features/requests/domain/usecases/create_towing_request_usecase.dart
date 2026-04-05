import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class CreateTowingRequestUseCase
    extends UseCase<ServiceRequestEntity, CreateTowingRequestParams> {
  final RequestRepository repository;
  CreateTowingRequestUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceRequestEntity>> call(
          CreateTowingRequestParams params) =>
      repository.createTowingRequest(
        latitude: params.latitude,
        longitude: params.longitude,
        address: params.address,
        plateNumber: params.plateNumber,
        notes: params.notes,
      );
}

class CreateTowingRequestParams extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String plateNumber;
  final String? notes;

  const CreateTowingRequestParams({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.plateNumber,
    this.notes,
  });

  @override
  List<Object?> get props => [latitude, longitude, plateNumber];
}
