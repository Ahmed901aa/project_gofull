import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<OfferEntity>>> getOffers();
}
