import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/driver_home/data/models/provider_profile_model.dart';
import 'package:project_gofull/features/driver_home/data/models/service_request_model.dart';

abstract class ProviderRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(String phone, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, ProviderProfileModel>> getProfile();
  Future<Either<Failure, bool>> updateAvailability(bool isAvailable);
  Future<Either<Failure, List<ServiceRequestModel>>> getPendingRequests();
  Future<Either<Failure, List<ServiceRequestModel>>> getOrderHistory({int page = 1});
  Future<Either<Failure, ServiceRequestModel>> getRequestDetails(int requestId);
  Future<Either<Failure, ServiceRequestModel>> acceptRequest(int requestId);
  Future<Either<Failure, void>> rejectRequest(int requestId);
  Future<Either<Failure, ServiceRequestModel>> updateRequestStatus(int requestId, String status);
  Future<Either<Failure, void>> rateCustomer(int requestId, int rating, String? comment);
}
