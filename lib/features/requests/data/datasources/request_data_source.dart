import 'package:dio/dio.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/features/requests/data/models/rating_model.dart';
import 'package:project_gofull/features/requests/data/models/service_request_model.dart';

abstract class RequestDataSource {
  Future<List<ServiceRequestModel>> getRequests({int page = 1});
  Future<ServiceRequestModel> createFuelRequest({
    required double latitude, required double longitude, String? address,
    required String fuelType, required double fuelQuantity, String? notes,
  });
  Future<ServiceRequestModel> createTowingRequest({
    required double latitude, required double longitude, String? address,
    required double destinationLatitude, required double destinationLongitude, String? destinationAddress,
    required String plateNumber, required String carType, String? notes,
  });
  Future<ServiceRequestModel> getRequestDetails(int id);
  Future<ServiceRequestModel?> getUnratedOrder();
  Future<void> cancelRequest(int id);
  Future<RatingModel> rateProvider({
    required int requestId, required int rating, String? comment,
  });
}

// ── Mock ─────────────��─────────────────────────────────────

class RequestMockDataSource implements RequestDataSource {
  @override
  Future<List<ServiceRequestModel>> getRequests({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const ServiceRequestModel(
        id: 1, driverId: 1, providerId: 2,
        serviceType: 'fuel_delivery', status: 'completed',
        driverLatitude: '32.8872', driverLongitude: '13.1913',
        driverAddress: 'طرابلس، ليبيا', fuelType: 'diesel', fuelQuantity: '20',
        createdAt: '2026-04-01T10:00:00Z',
      ),
      const ServiceRequestModel(
        id: 2, driverId: 1, serviceType: 'towing', status: 'pending',
        driverLatitude: '32.9000', driverLongitude: '13.2000',
        driverAddress: 'بنغازي، ليبيا', plateNumber: 'أ ب م - 3541',
        createdAt: '2026-04-02T14:00:00Z',
      ),
    ];
  }

  @override
  Future<ServiceRequestModel> createFuelRequest({
    required double latitude, required double longitude, String? address,
    required String fuelType, required double fuelQuantity, String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ServiceRequestModel(
      id: 10, driverId: 1, serviceType: 'fuel_delivery', status: 'pending',
      driverLatitude: latitude.toString(), driverLongitude: longitude.toString(),
      driverAddress: address, fuelType: fuelType,
      fuelQuantity: fuelQuantity.toString(), notes: notes,
    );
  }

  @override
  Future<ServiceRequestModel> createTowingRequest({
    required double latitude, required double longitude, String? address,
    required double destinationLatitude, required double destinationLongitude, String? destinationAddress,
    required String plateNumber, required String carType, String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ServiceRequestModel(
      id: 11, driverId: 1, serviceType: 'towing', status: 'pending',
      driverLatitude: latitude.toString(), driverLongitude: longitude.toString(),
      driverAddress: address,
      destinationLatitude: destinationLatitude.toString(),
      destinationLongitude: destinationLongitude.toString(),
      destinationAddress: destinationAddress,
      plateNumber: plateNumber, notes: notes,
    );
  }

  @override
  Future<ServiceRequestModel> getRequestDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const ServiceRequestModel(
      id: 1, driverId: 1, providerId: 2,
      serviceType: 'fuel_delivery', status: 'completed',
      driverLatitude: '32.8872', driverLongitude: '13.1913',
      driverAddress: 'طرابلس، ليبيا',
    );
  }

  @override
  Future<ServiceRequestModel?> getUnratedOrder() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }

  @override
  Future<void> cancelRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<RatingModel> rateProvider({
    required int requestId, required int rating, String? comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return RatingModel(
      id: 1, requestId: requestId, rating: rating, comment: comment,
    );
  }
}

// ── Remote ─────────────────────────────────────────────────

class RequestRemoteDataSource implements RequestDataSource {
  final ApiClient apiClient;
  RequestRemoteDataSource(this.apiClient);

  @override
  Future<List<ServiceRequestModel>> getRequests({int page = 1}) async {
    try {
      final response = await apiClient.dio
          .get(ApiConstants.driverRequests, queryParameters: {'page': page});
      final data = response.data['data'] as Map<String, dynamic>;
      final list = data['data'] as List;
      return list
          .map((e) => ServiceRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل تحميل الطلبات');
    }
  }

  @override
  Future<ServiceRequestModel> createFuelRequest({
    required double latitude, required double longitude, String? address,
    required String fuelType, required double fuelQuantity, String? notes,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.driverFuelRequest,
        data: {
          'driver_latitude': latitude,
          'driver_longitude': longitude,
          'driver_address': address,
          'fuel_type': fuelType,
          'fuel_quantity': fuelQuantity,
          if (notes != null) 'notes': notes,
        },
      );
      return ServiceRequestModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل إنشاء طلب الوقود');
    }
  }

  @override
  Future<ServiceRequestModel> createTowingRequest({
    required double latitude, required double longitude, String? address,
    required double destinationLatitude, required double destinationLongitude, String? destinationAddress,
    required String plateNumber, required String carType, String? notes,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.driverTowingRequest,
        data: {
          'driver_latitude': latitude,
          'driver_longitude': longitude,
          'driver_address': address,
          'destination_latitude': destinationLatitude,
          'destination_longitude': destinationLongitude,
          if (destinationAddress != null) 'destination_address': destinationAddress,
          'plate_number': plateNumber,
          'car_type': carType,
          if (notes != null) 'notes': notes,
        },
      );
      return ServiceRequestModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل إنشاء طلب السحب');
    }
  }

  @override
  Future<ServiceRequestModel> getRequestDetails(int id) async {
    try {
      final response =
          await apiClient.dio.get(ApiConstants.driverRequestDetails(id));
      return ServiceRequestModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل تحميل تفاصيل الطلب');
    }
  }

  @override
  Future<ServiceRequestModel?> getUnratedOrder() async {
    try {
      final response =
          await apiClient.dio.get(ApiConstants.driverUnratedRequest);
      final data = response.data['data'];
      if (data == null) return null;
      return ServiceRequestModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (_) {
      return null;
    }
  }

  @override
  Future<void> cancelRequest(int id) async {
    try {
      await apiClient.dio.patch(ApiConstants.driverCancelRequest(id));
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل إلغاء الطلب');
    }
  }

  @override
  Future<RatingModel> rateProvider({
    required int requestId, required int rating, String? comment,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.driverRateProvider(requestId),
        data: {'rating': rating, if (comment != null) 'comment': comment},
      );
      return RatingModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'فشل إرسال التقييم');
    }
  }
}
