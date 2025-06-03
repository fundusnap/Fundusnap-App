import 'dart:async';
import 'dart:convert'; // For jsonEncode if needed, and for potential error parsing
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';
import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart'; // Your abstract class

const String _accessTokenKey = 'access_token';
const String _refreshTokenKey = 'refresh_token';
const String _userEmailKey =
    'user_email'; // If you want to store email separately

class CustomAuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  // final String _baseUrl = "https://api.fundusnap.com/user/auth/email";
  final String _baseUrl = "https://api.fundusnap.com/user/auth";

  // Stream controller for authStateChanges
  // Using BehaviorSubject would allow new listeners to get the last emitted value immediately.
  // For simplicity, a StreamController.broadcast() is also fine, but you'd manage initial state carefully.
  // Let's use a simple StreamController for now and discuss BehaviorSubject if needed.
  final StreamController<AppUser?> _authStateController =
      StreamController<AppUser?>.broadcast();

  CustomAuthRepositoryImpl({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
  }) : _dio = dio,
       _secureStorage = secureStorage {
    // You might want to check initial auth state when repository is created
    // and emit it to the stream, e.g., by calling getCurrentUser()
    // For now, it will emit when login/logout happens.
  }

  Future<void> _storeTokensAndUser(AppUser user) async {
    await _secureStorage.write(key: _accessTokenKey, value: user.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: user.refreshToken);
    await _secureStorage.write(key: _userEmailKey, value: user.email);
    _authStateController.add(
      user,
    ); // Notify listeners of new authenticated user
  }

  Future<void> _clearTokensAndUser() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userEmailKey);
    _authStateController.add(null); // Notify listeners user is unauthenticated
  }

  @override
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/email/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          // The API returns email within the data object, let's use AppUser.fromJson
          // Ensure your AppUser.fromJson can handle the structure under 'data'
          // Or manually construct:
          final userData = responseData['data'] as Map<String, dynamic>;
          final appUser = AppUser(
            email: userData['email'] as String,
            accessToken: userData['access_token'] as String,
            refreshToken: userData['refresh_token'] as String,
          );

          await _storeTokensAndUser(appUser);
          return appUser;
        } else {
          // Handle cases where status is not 'success' or data is missing
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error:
                responseData['message'] ??
                'Login failed: Unexpected response format',
          );
        }
      }
      return null; // Should ideally not be reached if statusCode is 200 but data is null
    } on DioException catch (e) {
      // Handle Dio errors (network, 4xx, 5xx)
      // You can parse e.response?.data for specific error messages from your backend
      print("SignIn DioError: ${e.response?.data ?? e.message}");
      _authStateController.add(null);
      return null;
    } catch (e) {
      print("SignIn CatchAll Error: $e");
      _authStateController.add(null);
      return null;
    }
  }

  @override
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password, // Corrected typo from 'passwored'
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/email/register",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Or 201 Created for register
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final userData = responseData['data'] as Map<String, dynamic>;
          final appUser = AppUser(
            email: userData['email'] as String,
            accessToken: userData['access_token'] as String,
            refreshToken: userData['refresh_token'] as String,
          );
          // Typically, after sign-up, the user is also signed in.
          await _storeTokensAndUser(appUser);
          return appUser;
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error:
                responseData['message'] ??
                'Sign up failed: Unexpected response format',
          );
        }
      }
      return null;
    } on DioException catch (e) {
      print("SignUp DioError: ${e.response?.data ?? e.message}");
      _authStateController.add(
        null,
      ); // Assuming sign-up failure means unauthenticated
      return null;
    } catch (e) {
      print("SignUp CatchAll Error: $e");
      _authStateController.add(null);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    // TODO: Call a backend /logout endpoint if it exists and is necessary
    // For example, to invalidate the refresh token on the server side.
    // try {
    //   await _dio.post("$_baseUrl/logout", options: Options(headers: {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'}));
    // } catch (e) {
    //   // Handle error, but proceed with local sign out anyway
    //   print("Error calling backend logout: $e");
    // }
    await _clearTokensAndUser();
    print("User signed out, tokens cleared.");
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final accessToken = await _secureStorage.read(key: _accessTokenKey);
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      final email = await _secureStorage.read(key: _userEmailKey);

      if (accessToken != null && refreshToken != null && email != null) {
        // Here, you might want to validate if the accessToken is still valid
        // (e.g., by decoding it if it's a JWT and checking expiry, or making a quick /me API call).
        // For now, we'll assume if tokens exist, the user is "current".
        final currentUser = AppUser(
          email: email,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        _authStateController.add(
          currentUser,
        ); // Ensure stream reflects current user
        return currentUser;
      }
      _authStateController.add(null); // No user found
      return null;
    } catch (e) {
      print("Error getting current user: $e");
      _authStateController.add(null);
      return null;
    }
  }

  @override
  Stream<AppUser?> get authStateChanges => _authStateController.stream;

  // ?  would typically be called by a Dio interceptor when a 401 is received.
  Future<String?> refreshToken() async {
    final storedRefreshToken = await _secureStorage.read(key: _refreshTokenKey);
    final storedEmail = await _secureStorage.read(
      key: _userEmailKey,
    ); // Still useful for AppUser object

    if (storedRefreshToken == null || storedEmail == null) {
      print("Refresh token or email not found in storage. Cannot refresh.");
      await signOut();
      return null;
    }

    print(
      "Attempting to refresh token for email: $storedEmail using Bearer token in header.",
    );

    try {
      final response = await _dio.post(
        "$_baseUrl/refresh-token", // Endpoint: /user/auth/refresh-token
        data: {},
        // Or use 'data: null' if no body is expected at all. {} is safer for POST with JSON content type.
        options: Options(
          headers: {
            // The refresh token itself is sent as a Bearer token here
            'Authorization': 'Bearer $storedRefreshToken',
            'Content-Type':
                'application/json', // Usually good to keep, even with an empty body for POST
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final tokenData = responseData['data'] as Map<String, dynamic>;

          final newAccessToken = tokenData['access_token'] as String;
          final newRefreshToken =
              tokenData['refresh_token']
                  as String; // Backend rotates refresh tokens
          final emailFromResponse =
              tokenData['email'] as String? ?? storedEmail;

          final updatedUser = AppUser(
            email: emailFromResponse,
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          await _storeTokensAndUser(
            updatedUser,
          ); // Stores new tokens and updates authStateController
          print(
            "Token refresh successful. New access token obtained via Bearer refresh.",
          );
          return newAccessToken;
        } else {
          print(
            "Token refresh failed: API status not 'success' or data missing. Response: ${response.data}",
          );
          await signOut();
          return null;
        }
      } else {
        print(
          "Token refresh failed: HTTP ${response.statusCode}. Response: ${response.data}",
        );
        await signOut();
        return null;
      }
    } on DioException catch (e) {
      print("DioError refreshing token: ${e.response?.data ?? e.message}");
      await signOut();
      return null;
    } catch (e) {
      print("Unexpected error refreshing token: $e");
      await signOut();
      return null;
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
