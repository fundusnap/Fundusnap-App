import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/app.dart';
import 'package:sugeye/app/routing/routing_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter router = RoutingService().router;
  runApp(App(router: router));
}
