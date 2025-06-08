import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/themes/light_mode.dart';
import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
// import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sugeye/features/prediction/data/repositories/prediction_repository_impl.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';
import 'package:sugeye/features/prediction/presentation/cubit/create/create_prediction_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/detail/prediction_detail_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class App extends StatefulWidget {
  const App({
    required this.router,
    required this.authRepository,
    required this.authCubit,
    required this.dio,
    super.key,
  });

  final AuthCubit authCubit;
  final AuthRepository authRepository;
  final GoRouter router;
  final Dio dio;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: widget.authRepository),
        RepositoryProvider<PredictionRepository>(
          create: (context) => PredictionRepositoryImpl(dio: widget.dio),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: widget.authCubit),
          BlocProvider<CreatePredictionCubit>(
            create: (context) => CreatePredictionCubit(
              predictionRepository: context.read<PredictionRepository>(),
            ),
          ),
          BlocProvider<PredictionDetailCubit>(
            create: (context) => PredictionDetailCubit(
              predictionRepository: context.read<PredictionRepository>(),
            ),
          ),
          BlocProvider<PredictionListCubit>(
            create: (context) => PredictionListCubit(
              predictionRepository: context.read<PredictionRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Fundusnap',
          theme: sugeyeLightTheme,
          routerConfig: widget.router,
        ),
      ),
    );
  }
}
