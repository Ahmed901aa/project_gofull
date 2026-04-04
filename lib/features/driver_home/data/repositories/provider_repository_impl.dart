import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/driver_home/data/datasources/provider_remote_data_source.dart';
import 'package:project_gofull/features/driver_home/data/models/provider_profile_model.dart';
import 'package:project_gofull/features/driver_home/data/models/service_request_model.dart';
import 'package:project_gofull/features/driver_home/domain/repositories/provider_repository.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final ProviderDataSource dataSource;

  ProviderRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      String phone, String password) async {
    return _call(() => dataSource.login(phone, password));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return _call(() => dataSource.logout());
  }

  @override
  Future<Either<Failure, ProviderProfileModel>> getProfile() async {
    return _call(() => dataSource.getProfile());
  }

  @override
  Future<Either<Failure, bool>> updateAvailability(bool isAvailable) async {
    return _call(() => dataSource.updateAvailability(isAvailable));
  }

  @override
  Future<Either<Failure, List<ServiceRequestModel>>>
      getPendingRequests() async {
    return _call(() => dataSource.getPendingRequests());
  }

  @override
  Future<Either<Failure, List<ServiceRequestModel>>> getOrderHistory(
      {int page = 1}) async {
    return _call(() => dataSource.getOrderHistory(page: page));
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> getRequestDetails(
      int requestId) async {
    return _call(() => dataSource.getRequestDetails(requestId));
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> acceptRequest(
      int requestId) async {
    return _call(() => dataSource.acceptRequest(requestId));
  }

  @override
  Future<Either<Failure, void>> rejectRequest(int requestId) async {
    return _call(() => dataSource.rejectRequest(requestId));
  }

  @override
  Future<Either<Failure, ServiceRequestModel>> updateRequestStatus(
      int requestId, String status) async {
    return _call(() => dataSource.updateRequestStatus(requestId, status));
  }

  @override
  Future<Either<Failure, void>> rateCustomer(
      int requestId, int rating, String? comment) async {
    return _call(() => dataSource.rateCustomer(requestId, rating, comment));
  }

  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      final result = await fn();
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'حدث خطأ في الاتصال بالسيرفر';
      return Left(ServerFailure(message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
