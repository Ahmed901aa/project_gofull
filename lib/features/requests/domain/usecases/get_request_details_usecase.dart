import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class GetRequestDetailsUseCase
    extends UseCase<ServiceRequestEntity, GetRequestDetailsParams> {
  final RequestRepository repository;
  GetRequestDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceRequestEntity>> call(
          GetRequestDetailsParams params) =>
      repository.getRequestDetails(params.id);
}

class GetRequestDetailsParams extends Equatable {
  final int id;
  const GetRequestDetailsParams({required this.id});

  @override
  List<Object?> get props => [id];
}
