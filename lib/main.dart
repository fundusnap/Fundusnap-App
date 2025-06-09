import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/app.dart';
import 'package:sugeye/app/routing/routing_service.dart';
import 'package:sugeye/core/interceptors/auth_interceptor.dart';
import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.fundusnap.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ? logging interceptor for debugging
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print(object),
    ),
  );

  final CustomAuthRepositoryImpl authRepository = CustomAuthRepositoryImpl(
    dio: dio,
    secureStorage: const FlutterSecureStorage(),
  );

  //?  Add auth interceptor after creating authRepository
  dio.interceptors.add(AuthInterceptor(authRepository, dio));

  final AuthCubit authCubit = AuthCubit(authRepository: authRepository);
  GoRouter router = RoutingService(authCubit: authCubit).router;

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    _logError(e.code, e.description);
  }
  runApp(
    App(
      router: router,
      authRepository: authRepository,
      authCubit: authCubit,
      dio: dio,
    ),
  );
}
