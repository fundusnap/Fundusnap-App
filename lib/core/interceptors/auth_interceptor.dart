import 'package:dio/dio.dart';
import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final CustomAuthRepositoryImpl _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for auth endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    // Add access token to all other requests
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      options.headers['Authorization'] = 'Bearer ${user.accessToken}';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      try {
        final newAccessToken = await _authRepository.refreshToken();
        if (newAccessToken != null) {
          // Retry the original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final cloneReq = await Dio().request(
            opts.path,
            options: Options(method: opts.method, headers: opts.headers),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          return handler.resolve(cloneReq);
        }
      } catch (e) {
        // Refresh failed, user will be signed out by refreshToken method
      }
    }

    handler.next(err);
  }
}
