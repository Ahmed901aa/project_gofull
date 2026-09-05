import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class CancelOrderUseCase extends UseCase<void, CancelOrderParams> {
  final ProviderRepository repository;
  CancelOrderUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(CancelOrderParams params) =>
      repository.cancelOrder(params.id, reason: params.reason);
}

class CancelOrderParams extends Equatable {
  final int id;
  final String? reason;
  const CancelOrderParams({required this.id, this.reason});
  @override
  List<Object?> get props => [id, reason];
}
