import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class GetHistoryUseCase extends UseCase<List<ServiceRequestEntity>, NoParams> {
  final ProviderRepository repository;
  GetHistoryUseCase(this.repository);
  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> call(NoParams params) =>
      repository.getHistory();
}
