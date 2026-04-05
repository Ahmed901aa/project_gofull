import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class RateProviderUseCase extends UseCase<RatingEntity, RateProviderParams> {
  final RequestRepository repository;
  RateProviderUseCase(this.repository);

  @override
  Future<Either<Failure, RatingEntity>> call(RateProviderParams params) =>
      repository.rateProvider(
        requestId: params.requestId,
        rating: params.rating,
        comment: params.comment,
      );
}

class RateProviderParams extends Equatable {
  final int requestId;
  final int rating;
  final String? comment;

  const RateProviderParams({
    required this.requestId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [requestId, rating, comment];
}
