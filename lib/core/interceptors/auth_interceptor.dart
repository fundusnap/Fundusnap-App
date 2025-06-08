import 'package:dio/dio.dart';
import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';

class AuthInterceptor extends Interceptor {
  final CustomAuthRepositoryImpl _authRepository;
  final Dio _dio;

  AuthInterceptor(this._authRepository, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ? skip adding token for auth endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    // ? add access token to all other requests
    final AppUser? user = await _authRepository.getCurrentUser();
    if (user != null) {
      options.headers['Authorization'] = 'Bearer ${user.accessToken}';
    } else {
      print('No user found, request without auth: ${options.path}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      '❌ Request failed: ${err.response?.statusCode} - ${err.requestOptions.path}',
    );
    // ? handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      print('Token expired, attempting refresh...');

      try {
        final String? newAccessToken = await _authRepository.refreshToken();
        if (newAccessToken != null) {
          print('Token refreshed successfully, retrying request...');
          // ?  Update the failed request with new token
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          //  ? Retry using the same Dio instance to preserve configuration
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          print('❌ Token refresh failed - user will be signed out');
        }
      } catch (e) {
        print('❌ Token refresh error: $e');
        // ? Refresh failed, user will be signed out by refreshToken method
      }
    }

    handler.next(err);
  }
}
