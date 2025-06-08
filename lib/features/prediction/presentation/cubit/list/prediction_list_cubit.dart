import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
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

  // Add method to handle new predictions
  void addNewPrediction(Prediction prediction) {
    final currentState = state;
    if (currentState is PredictionListLoaded) {
      // Convert Prediction to PredictionSummary
      final newSummary = PredictionSummary(
        id: prediction.id,
        name: prediction.name,
        description: prediction.description,
        imageURL: prediction.imageURL,
        created: prediction.created,
      );

      // Add to the beginning of the list (most recent first)
      final updatedPredictions = [newSummary, ...currentState.predictions];
      emit(PredictionListLoaded(predictions: updatedPredictions));
    }
  }

  // Refresh method for pull-to-refresh
  Future<void> refreshPredictions() async {
    // Don't show loading for refresh - just fetch in background
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
