import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class GetProfileUseCase extends UseCase<ProviderProfileEntity, NoParams> {
  final ProviderRepository repository;
  GetProfileUseCase(this.repository);
  @override
  Future<Either<Failure, ProviderProfileEntity>> call(NoParams params) =>
      repository.getProfile();
}
