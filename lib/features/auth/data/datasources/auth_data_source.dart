import 'package:dio/dio.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login(String phone, String password);
  Future<UserModel> register(
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String role,
  );
  Future<void> logout();
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  );
}

// ── Mock ───────────────────────────────────────────────────

class AuthMockDataSource implements AuthDataSource {
  @override
  Future<UserModel> login(String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserModel(
      id: 1,
      phone: phone,
      name: 'أحمد',
      role: 'driver',
      token: 'mock-token-123',
    );
  }

  @override
  Future<UserModel> register(
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserModel(
      id: 2,
      phone: phone,
      name: name,
      role: role,
      token: 'mock-token-456',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'mock-new-token-789';
  }
}

// ── Remote ─────────────────────────────────────────────────

class AuthRemoteDataSource implements AuthDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRemoteDataSource({required this.apiClient, required this.tokenStorage});

  @override
  Future<UserModel> login(String phone, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {'phone': phone, 'password': password},
      );
      final user = UserModel.fromLoginResponse(
        response.data as Map<String, dynamic>,
      );
      // Persist token + user locally
      await tokenStorage.saveToken(user.token!);
      await tokenStorage.saveUser(UserModel(
        id: user.id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        status: user.status,
      ).toJson());
      return user;
    } on DioException catch (e) {
      final msg =
          (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
      throw ServerException(msg ?? 'فشل تسجيل الدخول');
    } catch (_) {
      throw const ServerException('فشل تسجيل الدخول');
    }
  }

  @override
  Future<UserModel> register(
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String role,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        },
      );
      final user = UserModel.fromLoginResponse(
        response.data as Map<String, dynamic>,
      );
      await tokenStorage.saveToken(user.token!);
      await tokenStorage.saveUser(UserModel(
        id: user.id,
        phone: user.phone,
        name: user.name,
        role: user.role,
        status: user.status,
      ).toJson());
      return user;
    } on DioException catch (e) {
      final msg =
          (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
      throw ServerException(msg ?? 'فشل إنشاء الحساب');
    } catch (_) {
      throw const ServerException('فشل إنشاء الحساب');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiConstants.logout);
    } catch (_) {
      // Ignore server errors — we clear locally regardless
    } finally {
      await tokenStorage.clearAll();
    }
  }

  @override
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final newToken = (data['data'] as Map<String, dynamic>)['token'] as String;
      await tokenStorage.saveToken(newToken);
      return newToken;
    } on DioException catch (e) {
      final msg =
          (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
      throw ServerException(msg ?? 'فشل تغيير كلمة المرور');
    } catch (_) {
      throw const ServerException('فشل تغيير كلمة المرور');
    }
  }
}
