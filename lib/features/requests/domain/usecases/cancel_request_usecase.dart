import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class CancelRequestUseCase extends UseCase<void, CancelRequestParams> {
  final RequestRepository repository;
  CancelRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelRequestParams params) =>
      repository.cancelRequest(params.id);
}

class CancelRequestParams extends Equatable {
  final int id;
  const CancelRequestParams({required this.id});

  @override
  List<Object?> get props => [id];
}
