import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/app.dart';
import 'package:sugeye/app/routing/routing_service.dart';

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  // _logError(code, message)
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter router = RoutingService().router;
  print("hahahah");

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    _logError(e.code, e.description);
  }

  runApp(App(router: router));
}
