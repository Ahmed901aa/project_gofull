import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/requests/data/datasources/request_data_source.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestDataSource dataSource;
  const RequestRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getRequests(
      {int page = 1}) async {
    try {
      final result = await dataSource.getRequests(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestEntity>> createFuelRequest({
    required double latitude, required double longitude, String? address,
    required String fuelType, required double fuelQuantity, String? notes,
  }) async {
    try {
      final result = await dataSource.createFuelRequest(
        latitude: latitude, longitude: longitude, address: address,
        fuelType: fuelType, fuelQuantity: fuelQuantity, notes: notes,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خطأ غير مت��قع'));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestEntity>> createTowingRequest({
    required double latitude, required double longitude, String? address,
    required double destinationLatitude, required double destinationLongitude, String? destinationAddress,
    required String plateNumber, required String carType, String? notes,
  }) async {
    try {
      final result = await dataSource.createTowingRequest(
        latitude: latitude, longitude: longitude, address: address,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
        destinationAddress: destinationAddress,
        plateNumber: plateNumber, carType: carType, notes: notes,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خطأ غي�� متوقع'));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestEntity>> getRequestDetails(
      int id) async {
    try {
      final result = await dataSource.getRequestDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestEntity?>> getUnratedOrder() async {
    try {
      final result = await dataSource.getUnratedOrder();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> cancelRequest(int id) async {
    try {
      await dataSource.cancelRequest(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, RatingEntity>> rateProvider({
    required int requestId, required int rating, String? comment,
  }) async {
    try {
      final result = await dataSource.rateProvider(
        requestId: requestId, rating: rating, comment: comment,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('حدث خط�� غير متوقع'));
    }
  }
}
