import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class ToggleAvailabilityUseCase extends UseCase<bool, ToggleAvailabilityParams> {
  final ProviderRepository repository;
  ToggleAvailabilityUseCase(this.repository);
  @override
  Future<Either<Failure, bool>> call(ToggleAvailabilityParams params) =>
      repository.toggleAvailability(params.isAvailable);
}

class ToggleAvailabilityParams extends Equatable {
  final bool isAvailable;
  const ToggleAvailabilityParams({required this.isAvailable});
  @override
  List<Object?> get props => [isAvailable];
}
