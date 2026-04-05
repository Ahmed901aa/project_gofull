import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class AcceptRequestUseCase extends UseCase<ServiceRequestEntity, AcceptRequestParams> {
  final ProviderRepository repository;
  AcceptRequestUseCase(this.repository);
  @override
  Future<Either<Failure, ServiceRequestEntity>> call(AcceptRequestParams params) =>
      repository.acceptRequest(params.id);
}

class AcceptRequestParams extends Equatable {
  final int id;
  const AcceptRequestParams({required this.id});
  @override
  List<Object?> get props => [id];
}
