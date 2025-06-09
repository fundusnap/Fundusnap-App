import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_empty_state.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_stats_header.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_filter_bar.dart';
import 'package:sugeye/features/cases/presentation/widgets/prediction_case_card.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class CasesLoadedState extends StatelessWidget {
  final PredictionListLoaded state;

  const CasesLoadedState({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.predictions.isEmpty) {
      return const CasesEmptyState();
    }

    return Column(
      children: [
        // Statistics Header
        CasesStatsHeader(predictions: state.predictions),

        // Filter/Sort Bar
        const CasesFilterBar(),

        // Cases List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<PredictionListCubit>().fetchPredictions(),
            child: ListView.builder(
              itemCount: state.predictions.length,
              itemBuilder: (context, index) {
                final prediction = state.predictions[index];
                return PredictionCaseCard(prediction: prediction, index: index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
