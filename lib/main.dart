import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/app.dart';
import 'package:sugeye/app/routing/routing_service.dart';
import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  // _logError(code, message)
  WidgetsFlutterBinding.ensureInitialized();

  final CustomAuthRepositoryImpl authRepository = CustomAuthRepositoryImpl(
    dio: Dio(),
    secureStorage: const FlutterSecureStorage(),
  );
  final AuthCubit authCubit = AuthCubit(authRepository: authRepository);
  GoRouter router = RoutingService(authCubit: authCubit).router;
  // print("hahahah");

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    _logError(e.code, e.description);
  }
  runApp(App(router: router, authCubit: authCubit));
}
