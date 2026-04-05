import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class UpdateStatusUseCase extends UseCase<ServiceRequestEntity, UpdateStatusParams> {
  final ProviderRepository repository;
  UpdateStatusUseCase(this.repository);
  @override
  Future<Either<Failure, ServiceRequestEntity>> call(UpdateStatusParams params) =>
      repository.updateStatus(params.id, params.status);
}

class UpdateStatusParams extends Equatable {
  final int id;
  final String status;
  const UpdateStatusParams({required this.id, required this.status});
  @override
  List<Object?> get props => [id, status];
}
