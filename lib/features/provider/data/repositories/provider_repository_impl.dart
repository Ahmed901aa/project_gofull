import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/provider/data/datasources/provider_data_source.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final ProviderDataSource dataSource;
  const ProviderRepositoryImpl(this.dataSource);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProviderProfileEntity>> getProfile() =>
      _guard(() => dataSource.getProfile());

  @override
  Future<Either<Failure, bool>> toggleAvailability(bool isAvailable) =>
      _guard(() => dataSource.toggleAvailability(isAvailable));

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getPendingRequests({int page = 1}) =>
      _guard(() => dataSource.getPendingRequests(page: page));

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getHistory({int page = 1}) =>
      _guard(() => dataSource.getHistory(page: page));

  @override
  Future<Either<Failure, ServiceRequestEntity>> acceptRequest(int id) =>
      _guard(() => dataSource.acceptRequest(id));

  @override
  Future<Either<Failure, void>> rejectRequest(int id) =>
      _guard(() => dataSource.rejectRequest(id));

  @override
  Future<Either<Failure, ServiceRequestEntity>> updateStatus(int id, String status) =>
      _guard(() => dataSource.updateStatus(id, status));

  @override
  Future<Either<Failure, RatingEntity>> rateDriver({
    required int requestId, required int rating, String? comment,
  }) =>
      _guard(() => dataSource.rateDriver(requestId: requestId, rating: rating, comment: comment));

  @override
  Future<Either<Failure, ServiceRequestEntity?>> getActiveRequest() =>
      _guard(() => dataSource.getActiveRequest());

  @override
  Future<Either<Failure, void>> cancelOrder(int id, {String? reason}) =>
      _guard(() => dataSource.cancelOrder(id, reason: reason));
}
