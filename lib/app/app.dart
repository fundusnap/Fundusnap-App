import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/themes/light_mode.dart';
import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
// import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
// import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sugeye/features/prediction/data/repositories/prediction_repository_impl.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';
import 'package:sugeye/features/prediction/presentation/cubit/create/create_prediction_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/detail/prediction_detail_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class App extends StatefulWidget {
  const App({
    required this.router,
    required this.authCubit,
    required this.dio,
    super.key,
  });

  final AuthCubit authCubit;
  final GoRouter router;
  final Dio dio;

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => PredictionRepositoryImpl(
            dio: widget.dio,
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: widget.authCubit),
          BlocProvider<CreatePredictionCubit>(
            create: (_) => CreatePredictionCubit(
              predictionRepository: context.read<PredictionRepository>(),
            ),
          ),
          BlocProvider<PredictionDetailCubit>(
            create: (_) => PredictionDetailCubit(
              predictionRepository: context.read<PredictionRepository>(),
            ),
          ),
          BlocProvider<PredictionListCubit>(
            create: (_) => PredictionListCubit(
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
