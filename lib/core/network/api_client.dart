import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/network/server_locator.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/utils/session_expiry.dart';

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
    // Always use the server the locator currently considers reachable, so a
    // Wi‑Fi change is picked up without rebuilding the app.
    options.baseUrl = ServerLocator.instance.baseUrl;
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

  void _onError(DioException error, ErrorInterceptorHandler handler) async {
    // Connection-level failure (not an HTTP status) → the server probably
    // moved (new Wi‑Fi). Re-locate it and retry this request ONCE.
    final isConnError = error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.error is SocketException;
    final alreadyRetried = error.requestOptions.extra['_relocated'] == true;
    if (isConnError && !alreadyRetried) {
      // Compare the full base URL: the server may have moved host (Wi‑Fi
      // change) OR port (artisan serve auto-increments past busy ports).
      final before = ServerLocator.instance.baseUrl;
      await ServerLocator.instance.resolve();
      if (ServerLocator.instance.baseUrl != before) {
        try {
          final opts = error.requestOptions
            ..baseUrl = ServerLocator.instance.baseUrl
            ..extra['_relocated'] = true;
          final response = await dio.fetch(opts);
          return handler.resolve(response);
        } catch (_) {
          // fall through to normal error handling
        }
      }
    }
    developer.log(
      '❌ ${error.response?.statusCode ?? 'NO_RESP'} ${error.requestOptions.method} ${error.requestOptions.path}: ${error.message}',
      name: 'HTTP',
      error: error.response?.data,
    );
    // 401 → the session is gone (token revoked by a login elsewhere,
    // expired, or the account was suspended).
    if (error.response?.statusCode == 401) {
      // A 401 from /auth/login is just wrong credentials, not an expiry —
      // only a request that CARRIED a token can have had a session.
      final wasAuthenticated =
          error.requestOptions.headers.containsKey('Authorization');
      // A burst of parallel polls all 401 at once; the first one clears
      // the token, so the rest see no session and skip the redirect.
      final alreadyHandled = _tokenStorage.getToken() == null;
      _tokenStorage.clearAll();
      if (wasAuthenticated && !alreadyHandled) {
        handleSessionExpired();
      }
    }
    handler.next(error);
  }
}
