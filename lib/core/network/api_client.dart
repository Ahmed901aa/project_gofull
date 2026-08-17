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
    // Compact preview: only show fields that actually exist in the payload,
    // so non-order endpoints (e.g. /home) don't log misleading "null"s.
    final parts = <String>[];
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) {
        if (inner['id'] != null) parts.add('id=${inner['id']}');
        if (inner['status'] != null) parts.add('status=${inner['status']}');
        final driverName = (inner['driver'] as Map?)?['name'];
        if (driverName != null) parts.add('driver=$driverName');
        final providerName =
            ((inner['provider'] as Map?)?['user'] as Map?)?['name'];
        if (providerName != null) parts.add('provider=$providerName');
        if (inner['active_order'] is Map) {
          final order = inner['active_order'] as Map;
          parts.add('activeOrder=#${order['id']}(${order['status']})');
        } else if (inner.containsKey('active_order')) {
          parts.add('activeOrder=none');
        }
        if (inner['banners'] is List) {
          parts.add('banners=${(inner['banners'] as List).length}');
        }
      } else if (inner is List) {
        parts.add('items=${inner.length}');
      } else if (data['message'] != null) {
        parts.add(data['message'].toString());
      }
    }
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.path}'
      '${parts.isEmpty ? '' : ' ${parts.join(' ')}'}',
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
