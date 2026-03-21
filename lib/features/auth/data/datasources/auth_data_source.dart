import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<void> sendOtp(String phone);
  Future<UserModel> verifyOtp(String phone, String code);
}

class AuthMockDataSource implements AuthDataSource {
  @override
  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: always succeeds
  }

  @override
  Future<UserModel> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: any 5-digit code is valid
    return UserModel(id: 'mock-user-1', phone: phone, name: 'أحمد');
  }
}

class AuthRemoteDataSource implements AuthDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource(this.apiClient);

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await apiClient.dio.post(ApiConstants.login, data: {'phone': phone});
    } catch (_) {
      throw const ServerException('فشل إرسال رمز التحقق');
    }
  }

  @override
  Future<UserModel> verifyOtp(String phone, String code) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.verifyOtp,
        data: {'phone': phone, 'otp': code},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      throw const ServerException('رمز التحقق غير صحيح');
    }
  }
}
