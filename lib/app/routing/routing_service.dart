import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/layout_scaffold_with_nav.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/features/home/presentation/screens/home_screen.dart';
import 'package:sugeye/features/patients/screens/patients_screen.dart';
import 'package:sugeye/features/profile/presentation/screens/profile_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/scan_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);

class RoutingService {
  RoutingService();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LayoutScaffoldWithNav(
            navigationShell: navigationShell,
            shellLocation: state.matchedLocation,
          );
        },
        branches: [
          // ? home screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.home,
                path: Routes.home,
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
          // ? scan screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.scan,
                path: Routes.scan,
                builder: (context, state) => ScanScreen(),
              ),
            ],
          ),
          // ? patients screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.patients,
                path: Routes.patients,
                builder: (context, state) => PatientsScreen(),
              ),
            ],
          ),
          // ? profile screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.profile,
                path: Routes.profile,
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
