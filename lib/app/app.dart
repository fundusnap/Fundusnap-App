import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/themes/light_mode.dart';
// import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
// import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

class App extends StatefulWidget {
  const App({required this.router, required this.authCubit, super.key});

  final AuthCubit authCubit;
  final GoRouter router;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return
    // MultiRepositoryProvider(
    //   providers: [
    //     // RepositoryProvider<AuthRepository>(
    //     //   create: (_) => CustomAuthRepositoryImpl(
    //     //     dio: Dio(),
    //     //     secureStorage: const FlutterSecureStorage(),
    //     //   ),
    //     // ),
    //   ],
    //   child:
    MultiBlocProvider(
      providers: [
        // BlocProvider<AuthCubit>(
        //   create: (context) =>
        //       AuthCubit(authRepository: context.read<AuthRepository>()),
        // ),
        BlocProvider<AuthCubit>.value(value: widget.authCubit),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Sugeye',
        theme: sugeyeLightTheme,
        routerConfig: widget.router,
      ),
    );
    // );
  }
}
