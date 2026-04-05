import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';

class RateDriverUseCase extends UseCase<RatingEntity, RateDriverParams> {
  final ProviderRepository repository;
  RateDriverUseCase(this.repository);
  @override
  Future<Either<Failure, RatingEntity>> call(RateDriverParams params) =>
      repository.rateDriver(requestId: params.requestId, rating: params.rating, comment: params.comment);
}

class RateDriverParams extends Equatable {
  final int requestId;
  final int rating;
  final String? comment;
  const RateDriverParams({required this.requestId, required this.rating, this.comment});
  @override
  List<Object?> get props => [requestId, rating, comment];
}
