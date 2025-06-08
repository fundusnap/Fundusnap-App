import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';

part 'prediction_list_state.dart';

class PredictionListCubit extends Cubit<PredictionListState> {
  final PredictionRepository _predictionRepository;

  PredictionListCubit({required PredictionRepository predictionRepository})
    : _predictionRepository = predictionRepository,
      super(PredictionListInitial());

  Future<void> fetchPredictions() async {
    emit(PredictionListLoading());
    try {
      final predictions = await _predictionRepository.listPredictions();
      emit(PredictionListLoaded(predictions: predictions));
    } on PredictionException catch (e) {
      emit(PredictionListError(message: e.message));
    } catch (e) {
      emit(PredictionListError(message: 'An unexpected error occurred: $e'));
    }
  }
}
