import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class RejectRequestUseCase extends UseCase<void, RejectRequestParams> {
  final ProviderRepository repository;
  RejectRequestUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(RejectRequestParams params) =>
      repository.rejectRequest(params.id);
}

class RejectRequestParams extends Equatable {
  final int id;
  const RejectRequestParams({required this.id});
  @override
  List<Object?> get props => [id];
}
