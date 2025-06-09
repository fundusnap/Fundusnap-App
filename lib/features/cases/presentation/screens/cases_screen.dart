import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_error_state.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_loaded_state.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PredictionListCubit>().fetchPredictions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionListCubit, PredictionListState>(
      builder: (context, state) {
        if (state is PredictionListLoading || state is PredictionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PredictionListError) {
          return CasesErrorState(state: state);
        }

        if (state is PredictionListLoaded) {
          return CasesLoadedState(state: state);
        }

        return const Center(child: Text('Something went wrong.'));
      },
    );
  }
}
