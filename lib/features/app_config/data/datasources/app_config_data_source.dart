import 'package:dio/dio.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/features/app_config/data/models/banner_model.dart';
import 'package:project_gofull/features/app_config/data/models/fuel_price_model.dart';
import 'package:project_gofull/features/requests/data/models/service_request_model.dart';

/// All app-level configuration data fetched from backend.
abstract class AppConfigDataSource {
  Future<List<FuelPriceModel>> getFuelPrices();
  Future<Map<String, String>> getAppSettings();
  Future<({List<BannerModel> banners, ServiceRequestModel? activeOrder})> getHomeData();
}

// ── Remote ─────────────────────────────────────────────────

class AppConfigRemoteDataSource implements AppConfigDataSource {
  final ApiClient apiClient;
  AppConfigRemoteDataSource(this.apiClient);

  @override
  Future<List<FuelPriceModel>> getFuelPrices() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.fuelPrices);
      final list = response.data['data'] as List;
      return list
          .map((e) => FuelPriceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل تحميل أسعار الوقود');
    }
  }

  @override
  Future<Map<String, String>> getAppSettings() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.appSettings);
      final data = response.data['data'] as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, v.toString()));
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل تحميل إعدادات التطبيق');
    }
  }

  @override
  Future<({List<BannerModel> banners, ServiceRequestModel? activeOrder})>
      getHomeData() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.home);
      final data = response.data['data'] as Map<String, dynamic>;

      final bannersList = (data['banners'] as List?) ?? [];
      final banners = bannersList
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final activeOrderJson = data['active_order'] as Map<String, dynamic>?;
      final activeOrder = activeOrderJson != null
          ? ServiceRequestModel.fromJson(activeOrderJson)
          : null;

      return (banners: banners, activeOrder: activeOrder);
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل تحميل الصفحة الرئيسية');
    }
  }
}
