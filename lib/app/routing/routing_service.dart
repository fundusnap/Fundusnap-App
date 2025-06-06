import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/layout_scaffold_with_nav.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:sugeye/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:sugeye/features/home/presentation/screens/home_screen.dart';
import 'package:sugeye/features/patients/screens/patients_screen.dart';
import 'package:sugeye/features/profile/presentation/screens/profile_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/camera_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/display_picture_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/scan_screen.dart';
import 'package:sugeye/features/scan/presentation/screens/upload_screen.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class RoutingService {
  final AuthCubit authCubit;
  RoutingService({required this.authCubit});

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    // initialLocation: Routes.home,
    initialLocation: Routes.signInScreen,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = authCubit.state;
      final String currentPath =
          state.matchedLocation; // The path of the route that was matched

      print(
        "[GoRouter Redirect] Current AuthState: $authState, Current Path: $currentPath",
      );

      final bool isAuthRoute =
          (currentPath == Routes.signInScreen ||
          currentPath == Routes.signUpScreen);

      if (authState is AuthLoading) {
        print("[GoRouter Redirect] AuthLoading: No redirect.");
        return null;
      }

      if (authState is AuthAuthenticated) {
        if (isAuthRoute) {
          print(
            "[GoRouter Redirect] Authenticated on AuthRoute: Redirecting to ${Routes.home}",
          );
          return Routes.home;
        }
        print(
          "[GoRouter Redirect] Authenticated, not on AuthRoute: No redirect.",
        );
      } else {
        // AuthUnauthenticated, AuthInitial, AuthError
        // If NOT authenticated and NOT on an auth route, redirect to signIn.
        // This protects all other routes.
        if (!isAuthRoute && currentPath == Routes.signInScreen) {
          print(
            "[GoRouter Redirect] Unauthenticated, not on AuthRoute: Redirecting to ${Routes.signInScreen}",
          );
          return Routes.signInScreen;
        }
        if (!isAuthRoute && currentPath == Routes.signUpScreen) {
          print(
            "[GoRouter Redirect] Unauthenticated, not on AuthRoute: Redirecting to ${Routes.signUpScreen}",
          );
          return Routes.signUpScreen;
        }

        print("[GoRouter Redirect] Unauthenticated on AuthRoute: No redirect.");
      }
      return null;
    },

    routes: [
      GoRoute(
        name: Routes.signInScreen,
        path: Routes.signInScreen,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        name: Routes.signUpScreen,
        path: Routes.signUpScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
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
            routes: [
              GoRoute(
                name: Routes.scan,
                path: Routes.scan,
                builder: (context, state) => const ScanScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: Routes.camera,
                    path: Routes.camera,
                    builder: (context, state) => const CameraScreen(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        name: Routes.displayPicture,
                        path: Routes.displayPicture,
                        builder: (context, state) {
                          String? imagePath = state.extra as String?;
                          // print("Image path from routing service: $imagePath");
                          if (imagePath == null) {
                            return const Scaffold(
                              body: Center(child: Text("Image Path Not Found")),
                            );
                          }
                          return DisplayPictureScreen(imagePath: imagePath);
                        },
                      ),
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
