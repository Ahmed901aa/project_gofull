import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/app_config/data/datasources/app_config_data_source.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/app_config/domain/repositories/app_config_repository.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  final AppConfigDataSource dataSource;
  const AppConfigRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<FuelPriceEntity>>> getFuelPrices() async {
    try {
      final result = await dataSource.getFuelPrices();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getAppSettings() async {
    try {
      final result = await dataSource.getAppSettings();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ({List<BannerEntity> banners, ServiceRequestEntity? activeOrder})>> getHomeData() async {
    try {
      final result = await dataSource.getHomeData();
      return Right((banners: result.banners as List<BannerEntity>, activeOrder: result.activeOrder as ServiceRequestEntity?));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
