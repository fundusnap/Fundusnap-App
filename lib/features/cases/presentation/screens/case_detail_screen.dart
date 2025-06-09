import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';
import 'package:sugeye/features/prediction/presentation/cubit/detail/prediction_detail_cubit.dart';
import 'package:sugeye/features/prediction/presentation/screens/results_screen.dart';

class CaseDetailScreen extends StatelessWidget {
  final String predictionId;
  const CaseDetailScreen({super.key, required this.predictionId});

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit for this specific screen instance
    return BlocProvider(
      create: (context) =>
          PredictionDetailCubit(
            predictionRepository: RepositoryProvider.of<PredictionRepository>(
              context,
            ),
          )..fetchPredictionDetail(
            predictionId,
          ), // Create cubit and fetch data immediately
      child: BlocBuilder<PredictionDetailCubit, PredictionDetailState>(
        builder: (context, state) {
          if (state is PredictionDetailLoading ||
              state is PredictionDetailInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is PredictionDetailError) {
            return Scaffold(
              appBar: AppBar(), // So user can go back
              body: Center(child: Text('Error: ${state.message}')),
            );
          }
          if (state is PredictionDetailLoaded) {
            // Once loaded, we show the ResultScreen with the full prediction object
            return ResultScreen(prediction: state.prediction);
          }
          return const Scaffold(
            body: Center(child: Text('Something went wrong.')),
          );
        },
      ),
    );
  }
}
