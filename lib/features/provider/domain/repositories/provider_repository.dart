import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';

abstract class ProviderRepository {
  Future<Either<Failure, ProviderProfileEntity>> getProfile();
  Future<Either<Failure, bool>> toggleAvailability(bool isAvailable);
  Future<Either<Failure, List<ServiceRequestEntity>>> getPendingRequests({int page = 1});
  Future<Either<Failure, List<ServiceRequestEntity>>> getHistory({int page = 1});
  Future<Either<Failure, ServiceRequestEntity>> acceptRequest(int id);
  Future<Either<Failure, void>> rejectRequest(int id);
  Future<Either<Failure, ServiceRequestEntity>> updateStatus(int id, String status);
  Future<Either<Failure, RatingEntity>> rateDriver({required int requestId, required int rating, String? comment});
  Future<Either<Failure, ServiceRequestEntity?>> getActiveRequest();
  Future<Either<Failure, void>> cancelOrder(int id, {String? reason});
}
