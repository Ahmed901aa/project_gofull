import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class GetActiveRequestUseCase extends UseCase<ServiceRequestEntity?, NoParams> {
  final ProviderRepository repository;
  GetActiveRequestUseCase(this.repository);
  @override
  Future<Either<Failure, ServiceRequestEntity?>> call(NoParams params) =>
      repository.getActiveRequest();
}
