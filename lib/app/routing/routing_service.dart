import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/layout_scaffold_with_nav.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/features/home/presentation/screens/home_screen.dart';
import 'package:sugeye/features/patients/screens/patients_screen.dart';
import 'package:sugeye/features/profile/presentation/screens/profile_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/camera_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/display_picture_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/scan_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/upload_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);

final GlobalKey<NavigatorState> _subNavigator = GlobalKey<NavigatorState>(
  debugLabel: "sub",
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
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // ? scan screen
          StatefulShellBranch(
            // navigatorKey: _subNavigator,
            routes: [
              GoRoute(
                name: Routes.scan,
                path: Routes.scan,
                builder: (context, state) => const ScanScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    // parentNavigatorKey: _subNavigator,
                    name: Routes.camera,
                    path: Routes.camera,
                    builder: (context, state) => const CameraScreen(),
                    routes: [
                      // GoRoute(
                      //   name: Routes.displayPicture,
                      //   path: Routes.displayPicture
                      //   ,
                      //   builder: (context, state) => const DisplayPictureScreen(imagePath: imagePath)
                      //   )
                    ],
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: Routes.upload,
                    path: Routes.upload,
                    builder: (context, state) => const UploadScreen(),
                  ),
                ],
              ),
            ],
          ),
          // ? patients screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.patients,
                path: Routes.patients,
                builder: (context, state) => const PatientsScreen(),
              ),
            ],
          ),
          // ? profile screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.profile,
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
