import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/features/driver_home/data/models/provider_profile_model.dart';
import 'package:project_gofull/features/driver_home/data/models/service_request_model.dart';

abstract class ProviderDataSource {
  Future<Map<String, dynamic>> login(String phone, String password);
  Future<void> logout();
  Future<ProviderProfileModel> getProfile();
  Future<bool> updateAvailability(bool isAvailable);
  Future<List<ServiceRequestModel>> getPendingRequests();
  Future<List<ServiceRequestModel>> getOrderHistory({int page = 1});
  Future<ServiceRequestModel> getRequestDetails(int requestId);
  Future<ServiceRequestModel> acceptRequest(int requestId);
  Future<void> rejectRequest(int requestId);
  Future<ServiceRequestModel> updateRequestStatus(int requestId, String status);
  Future<void> rateCustomer(int requestId, int rating, String? comment);
}

class ProviderRemoteDataSource implements ProviderDataSource {
  final ApiClient apiClient;

  ProviderRemoteDataSource(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await apiClient.dio.post(
      ApiConstants.login,
      data: {'phone': phone, 'password': password},
    );
    return response.data['data'];
  }

  @override
  Future<void> logout() async {
    await apiClient.dio.post(ApiConstants.logout);
    await ApiClient.clearAuth();
  }

  @override
  Future<ProviderProfileModel> getProfile() async {
    final response = await apiClient.dio.get(ApiConstants.providerProfile);
    return ProviderProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> updateAvailability(bool isAvailable) async {
    final response = await apiClient.dio.patch(
      ApiConstants.providerAvailability,
      data: {'is_available': isAvailable},
    );
    return response.data['data']['is_available'];
  }

  @override
  Future<List<ServiceRequestModel>> getPendingRequests() async {
    final response = await apiClient.dio.get(ApiConstants.providerRequests);
    final list = response.data['data']['data'] as List;
    return list.map((e) => ServiceRequestModel.fromJson(e)).toList();
  }

  @override
  Future<List<ServiceRequestModel>> getOrderHistory({int page = 1}) async {
    final response = await apiClient.dio.get(
      ApiConstants.providerRequestsHistory,
      queryParameters: {'page': page},
    );
    final list = response.data['data']['data'] as List;
    return list.map((e) => ServiceRequestModel.fromJson(e)).toList();
  }

  @override
  Future<ServiceRequestModel> getRequestDetails(int requestId) async {
    final response = await apiClient.dio.get(
      ApiConstants.providerRequestDetails(requestId),
    );
    return ServiceRequestModel.fromJson(response.data['data']);
  }

  @override
  Future<ServiceRequestModel> acceptRequest(int requestId) async {
    final response = await apiClient.dio.patch(
      ApiConstants.providerAcceptRequest(requestId),
    );
    return ServiceRequestModel.fromJson(response.data['data']);
  }

  @override
  Future<void> rejectRequest(int requestId) async {
    await apiClient.dio.patch(ApiConstants.providerRejectRequest(requestId));
  }

  @override
  Future<ServiceRequestModel> updateRequestStatus(
      int requestId, String status) async {
    final response = await apiClient.dio.patch(
      ApiConstants.providerUpdateStatus(requestId),
      data: {'status': status},
    );
    return ServiceRequestModel.fromJson(response.data['data']);
  }

  @override
  Future<void> rateCustomer(int requestId, int rating, String? comment) async {
    await apiClient.dio.post(
      ApiConstants.providerRateCustomer(requestId),
      data: {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
  }
}
