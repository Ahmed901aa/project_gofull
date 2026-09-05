import 'package:dio/dio.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/features/notifications/data/models/notification_model.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSource implements NotificationDataSource {
  final ApiClient apiClient;
  NotificationRemoteDataSource(this.apiClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.notifications);
      final data = response.data['data'] as Map<String, dynamic>;
      final list = data['data'] as List;
      return list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'Failed to load notifications');
    }
  }
}
