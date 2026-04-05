import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<ServiceRequestEntity>>> getRequests({int page = 1});
  Future<Either<Failure, ServiceRequestEntity>> createFuelRequest({
    required double latitude, required double longitude, String? address,
    required String fuelType, required double fuelQuantity, String? notes,
  });
  Future<Either<Failure, ServiceRequestEntity>> createTowingRequest({
    required double latitude, required double longitude, String? address,
    required String plateNumber, String? notes,
  });
  Future<Either<Failure, ServiceRequestEntity>> getRequestDetails(int id);
  Future<Either<Failure, void>> cancelRequest(int id);
  Future<Either<Failure, RatingEntity>> rateProvider({
    required int requestId, required int rating, String? comment,
  });
}
