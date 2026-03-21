import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';
import 'package:project_gofull/features/home/domain/repositories/home_repository.dart';

class GetOffersUseCase extends UseCase<List<OfferEntity>, NoParams> {
  final HomeRepository repository;
  GetOffersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OfferEntity>>> call(NoParams params) =>
      repository.getOffers();
}
