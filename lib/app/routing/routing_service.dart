import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/layout_scaffold_with_nav.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:sugeye/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:sugeye/features/cases/presentation/screens/case_detail_screen.dart';
import 'package:sugeye/features/fundus_ai/presentation/screens/chat_screen.dart';
import 'package:sugeye/features/fundus_ai/presentation/screens/fundus_ai_screen.dart';
import 'package:sugeye/features/home/presentation/screens/home_screen.dart';
import 'package:sugeye/features/cases/presentation/screens/cases_screen.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/presentation/screens/results_screen.dart';
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
    debugLogDiagnostics: false,
    initialLocation: Routes.signInScreen,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = authCubit.state;
      final String currentPath =
          state.matchedLocation; // ? path of the route that was matched

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

      // Handle authenticated state
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
        return null;
      }

      // Handle unauthenticated states (AuthUnauthenticated, AuthInitial, AuthError)
      if (!isAuthRoute) {
        print(
          "[GoRouter Redirect] Unauthenticated, not on AuthRoute: Redirecting to ${Routes.signInScreen}",
        );
        return Routes.signInScreen;
      }
      // Already on auth route and unauthenticated - no redirect needed
      print("[GoRouter Redirect] Unauthenticated on AuthRoute: No redirect.");
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

      // GoRoute(
      //   parentNavigatorKey:
      //       _rootNavigatorKey, // Ensures it's a full-screen route
      //   name: Routes.chat, // A single 'chat' route
      //   path: '/chat', // A simple, clean path
      //   builder: (context, state) {
      //     // We'll pass arguments in the 'extra' parameter
      //     final args = state.extra as Map<String, String?>?;
      //     final chatId = args?['chatId'];
      //     final predictionId = args?['predictionId'];

      //     if (chatId == null && predictionId == null) {
      //       return const Scaffold(
      //         body: Center(
      //           child: Text("Chat ID or Prediction ID is required."),
      //         ),
      //       );
      //     }  // Pass the IDs to the ChatScreen
      //     return ChatScreen(chatId: chatId, predictionId: predictionId);
      //   },
      // ),
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   name: Routes.chat,
      //   path: '/chat',
      //   builder: (context, state) {
      //     // Expect Map<String, dynamic> consistently
      //     final args = state.extra as Map<String, dynamic>?;
      //     final chatId = args?['chatId'] as String?;
      //     final predictionId = args?['predictionId'] as String?;

      //     if (chatId == null && predictionId == null) {
      //       return const Scaffold(
      //         body: Center(
      //           child: Text("Chat ID or Prediction ID is required."),
      //         ),
      //       );
      //     }
      //     return ChatScreen(chatId: chatId, predictionId: predictionId);
      //   },
      // ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: Routes.chat,
        path: '/chat',
        builder: (context, state) {
          try {
            final extra = state.extra;
            String? chatId;
            String? predictionId;

            // Safe type handling
            if (extra is Map) {
              chatId = extra['chatId']?.toString();
              predictionId = extra['predictionId']?.toString();
            }

            if (chatId == null && predictionId == null) {
              debugPrint(
                'Chat route error: No chatId or predictionId provided. Extra: $extra',
              );
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.paleCarmine,
                      ),
                      SizedBox(height: 16),
                      Text("Chat ID or Prediction ID is required."),
                      Text(
                        "Please try again.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ChatScreen(chatId: chatId, predictionId: predictionId);
          } catch (e, stackTrace) {
            debugPrint('Chat route casting error: $e');
            debugPrint('Stack trace: $stackTrace');
            debugPrint('Extra data: ${state.extra}');
            debugPrint('Extra type: ${state.extra.runtimeType}');

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.paleCarmine,
                    ),
                    const SizedBox(height: 16),
                    const Text("Navigation Error"),
                    Text(
                      "Error: $e",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
        },
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
                        routes: [
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            name: Routes.cameraResult,
                            path: Routes.cameraResult,
                            builder: (context, state) {
                              Prediction? prediction =
                                  state.extra as Prediction?;
                              if (prediction == null) {
                                return const Scaffold(
                                  body: Center(
                                    child: Text("Prediction data not found."),
                                  ),
                                );
                              }
                              return ResultScreen(prediction: prediction);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: Routes.upload,
                    path: Routes.upload,
                    builder: (context, state) => const UploadScreen(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        name: Routes.uploadResult,
                        path: Routes.uploadResult,
                        builder: (context, state) {
                          Prediction? prediction = state.extra as Prediction?;
                          if (prediction == null) {
                            return const Scaffold(
                              body: Center(
                                child: Text("Prediction data not found."),
                              ),
                            );
                          }
                          return ResultScreen(prediction: prediction);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // ? fundus ai screen (this will show all the possible chat available)
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.fundusAi,
                path: Routes.fundusAi,
                builder: (context, state) => const FundusAiScreen(),
                // routes: [
                // ? this will be the chat screen (if you see more better routing than feel free to suggest)
                // GoRoute(
                //   name: Routes.chat,
                //   path: ':chatId',
                //   builder: (context, state) {
                //     final String? chatId = state.pathParameters['chatId'];
                //     if (chatId == null) {
                //       return const Scaffold(
                //         body: Center(child: Text("Chat ID is missing.")),
                //       );
                //     }
                //     return ChatScreen();
                //   },
                // ),

                // ],
              ),
            ],
          ),
          // ? cases screen
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: Routes.cases,
                path: Routes.cases,
                builder: (context, state) => const CasesScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: Routes.caseDetail,
                    path:
                        ':predictionId', // Path with a parameter, e.g., /cases/some-uuid
                    builder: (context, state) {
                      final String? predictionId =
                          state.pathParameters['predictionId'];
                      if (predictionId == null) {
                        return const Scaffold(
                          body: Center(child: Text("Case ID is missing.")),
                        );
                      }
                      return CaseDetailScreen(predictionId: predictionId);
                    },
                  ),
                ],
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
