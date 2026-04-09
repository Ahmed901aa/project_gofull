import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/services/token_storage.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'ar',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  // ── Interceptors ──────────────────────────────────────────

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    developer.log(
      '→ ${options.method} ${options.path}${options.queryParameters.isNotEmpty ? '?${options.queryParameters}' : ''}',
      name: 'HTTP',
    );
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    String preview = '';
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) {
        preview = 'id=${inner['id']} status=${inner['status']} '
            'driver=${(inner['driver'] as Map?)?['name']} '
            'provider=${((inner['provider'] as Map?)?['user'] as Map?)?['name']}';
      } else if (inner is Map? && data['message'] != null) {
        preview = data['message'].toString();
      }
    }
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path} $preview',
      name: 'HTTP',
    );
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ${error.response?.statusCode ?? 'NO_RESP'} ${error.requestOptions.method} ${error.requestOptions.path}: ${error.message}',
      name: 'HTTP',
      error: error.response?.data,
    );
    // 401 → token expired / invalid → clear session
    if (error.response?.statusCode == 401) {
      _tokenStorage.clearAll();
    }
    handler.next(error);
  }
}
