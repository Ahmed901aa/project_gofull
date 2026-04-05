import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

abstract class AppConfigRepository {
  Future<Either<Failure, List<FuelPriceEntity>>> getFuelPrices();
  Future<Either<Failure, Map<String, String>>> getAppSettings();
  Future<Either<Failure, ({List<BannerEntity> banners, ServiceRequestEntity? activeOrder})>> getHomeData();
}
