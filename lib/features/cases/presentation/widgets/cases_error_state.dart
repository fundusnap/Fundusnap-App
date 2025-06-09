import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class CasesErrorState extends StatelessWidget {
  final PredictionListError state;

  const CasesErrorState({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.gray),
          const SizedBox(height: 16),
          Text(
            'Unable to load cases',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gray),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<PredictionListCubit>().fetchPredictions();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
