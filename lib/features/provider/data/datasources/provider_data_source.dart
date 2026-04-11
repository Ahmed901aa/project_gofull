import 'package:dio/dio.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/features/provider/data/models/provider_profile_model.dart';
import 'package:project_gofull/features/requests/data/models/rating_model.dart';
import 'package:project_gofull/features/requests/data/models/service_request_model.dart';

abstract class ProviderDataSource {
  Future<ProviderProfileModel> getProfile();
  Future<bool> toggleAvailability(bool isAvailable);
  Future<List<ServiceRequestModel>> getPendingRequests({int page = 1});
  Future<List<ServiceRequestModel>> getHistory({int page = 1});
  Future<ServiceRequestModel> acceptRequest(int id);
  Future<void> rejectRequest(int id);
  Future<ServiceRequestModel> updateStatus(int id, String status);
  Future<RatingModel> rateDriver({required int requestId, required int rating, String? comment});
  Future<ServiceRequestModel?> getActiveRequest();
}

// ── Mock ───────────────────────────────────────────────────

class ProviderMockDataSource implements ProviderDataSource {
  @override
  Future<ProviderProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const ProviderProfileModel(
      id: 1, userId: 2, serviceType: 'towing',
      vehicleMake: 'تويوتا', vehicleModel: 'هايلكس', vehicleYear: 2020,
      vehiclePlate: 'أ ب م - 3541', vehicleColor: 'أبيض',
      isAvailable: true, verificationStatus: 'approved',
      averageRating: 4.8, totalRatings: 15, completedOrders: 42,
      userName: 'محمد حسن', userPhone: '218913456789',
    );
  }

  @override
  Future<bool> toggleAvailability(bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return isAvailable;
  }

  @override
  Future<List<ServiceRequestModel>> getPendingRequests({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const ServiceRequestModel(
        id: 5, driverId: 3, serviceType: 'towing', status: 'pending',
        driverLatitude: '32.8872', driverLongitude: '13.1913',
        driverAddress: 'طرابلس، شارع الجمهورية',
        plateNumber: 'ل ي ب - 1234', notes: 'السيارة لا تشتغل',
        createdAt: '2026-04-05T08:00:00Z',
      ),
    ];
  }

  @override
  Future<List<ServiceRequestModel>> getHistory({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const ServiceRequestModel(
        id: 3, driverId: 1, providerId: 2,
        serviceType: 'towing', status: 'completed',
        driverLatitude: '32.9000', driverLongitude: '13.2000',
        driverAddress: 'بنغازي', completedAt: '2026-04-03T16:00:00Z',
      ),
    ];
  }

  @override
  Future<ServiceRequestModel> acceptRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ServiceRequestModel(
      id: id, driverId: 3, providerId: 2,
      serviceType: 'towing', status: 'accepted',
      driverLatitude: '32.8872', driverLongitude: '13.1913',
      acceptedAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> rejectRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<ServiceRequestModel> updateStatus(int id, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ServiceRequestModel(
      id: id, driverId: 3, providerId: 2,
      serviceType: 'towing', status: status,
      driverLatitude: '32.8872', driverLongitude: '13.1913',
    );
  }

  @override
  Future<RatingModel> rateDriver({required int requestId, required int rating, String? comment}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return RatingModel(id: 1, requestId: requestId, rating: rating, comment: comment);
  }

  @override
  Future<ServiceRequestModel?> getActiveRequest() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return null;
  }
}

// ── Remote ─────────────────────────────────────────────────

class ProviderRemoteDataSource implements ProviderDataSource {
  final ApiClient apiClient;
  ProviderRemoteDataSource(this.apiClient);

  @override
  Future<ProviderProfileModel> getProfile() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.providerProfile);
      return ProviderProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحميل الملف الشخصي');
    }
  }

  @override
  Future<bool> toggleAvailability(bool isAvailable) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.providerAvailability,
        data: {'is_available': isAvailable},
      );
      return (response.data['data'] as Map<String, dynamic>)['is_available'] as bool;
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحديث الحالة');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getPendingRequests({int page = 1}) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.providerRequests, queryParameters: {'page': page});
      final data = response.data['data'] as Map<String, dynamic>;
      final list = data['data'] as List;
      return list.map((e) => ServiceRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحميل الطلبات');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getHistory({int page = 1}) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.providerHistory, queryParameters: {'page': page});
      final data = response.data['data'] as Map<String, dynamic>;
      final list = data['data'] as List;
      return list.map((e) => ServiceRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحميل السجل');
    }
  }

  @override
  Future<ServiceRequestModel> acceptRequest(int id) async {
    try {
      final response = await apiClient.dio.patch(ApiConstants.providerAcceptRequest(id));
      return ServiceRequestModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل قبول الطلب');
    }
  }

  @override
  Future<void> rejectRequest(int id) async {
    try {
      await apiClient.dio.patch(ApiConstants.providerRejectRequest(id));
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل رفض الطلب');
    }
  }

  @override
  Future<ServiceRequestModel> updateStatus(int id, String status) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.providerUpdateStatus(id),
        data: {'status': status},
      );
      return ServiceRequestModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحديث الحالة');
    }
  }

  @override
  Future<RatingModel> rateDriver({required int requestId, required int rating, String? comment}) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.providerRateDriver(requestId),
        data: {'rating': rating, if (comment != null) 'comment': comment},
      );
      return RatingModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل إرسال التقييم');
    }
  }

  @override
  Future<ServiceRequestModel?> getActiveRequest() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.providerActiveRequest);
      final data = response.data['data'];
      if (data == null) return null;
      return ServiceRequestModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException((e.response?.data as Map?)?['message'] as String? ?? 'فشل تحميل الطلب النشط');
    }
  }
}
