import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:cartsync/shared/providers/app_config_providers.dart';
import 'package:cartsync/utils/navigator_key.dart';
import 'package:cartsync/utils/secure_storage_service.dart' show StorageService;

const String _baseUrl = 'http://195.201.17.91';

class AuthInterceptor extends Interceptor {
  final _log = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await StorageService.instance.readData('token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    _log.d('[DIO REQ] ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.d('[DIO RES] ${response.statusCode} ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e('[DIO ERR] ${err.response?.statusCode} ${err.requestOptions.path}: ${err.message}');
    handler.next(err);
  }
}

/// Intercepts 401/403 responses to auto-logout the user, and logs connection
/// errors so callers can surface them appropriately.
class AuthErrorInterceptor extends Interceptor {
  final Future<void> Function() onUnauthorized;
  final _log = Logger();

  bool _isLoggingOut = false;

  AuthErrorInterceptor({required this.onUnauthorized});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // Invalid / expired token – auto-logout
    if ((statusCode == 401 || statusCode == 403) && !_isLoggingOut) {
      _isLoggingOut = true;
      _log.w('[AUTH] Token invalid or expired ($statusCode) – logging out');
      await onUnauthorized();
      _isLoggingOut = false;
      handler.reject(err);
      return;
    }

    // Connection / timeout errors – log and propagate
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      _log.w('[NET] Connection error (${err.type}): ${err.message}');
    }

    handler.next(err);
  }
}

Dio createDio({required Future<void> Function() onUnauthorized}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(AuthErrorInterceptor(onUnauthorized: onUnauthorized));
  return dio;
}

final dioProvider = Provider<Dio>((ref) {
  Future<void> logout() async {
    await ref.read(clearSessionProvider.notifier).clear();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  return createDio(onUnauthorized: logout);
});
