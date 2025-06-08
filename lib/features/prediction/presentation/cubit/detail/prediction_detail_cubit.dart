import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';

part 'prediction_detail_state.dart';

class PredictionDetailCubit extends Cubit<PredictionDetailState> {
  final PredictionRepository _predictionRepository;

  PredictionDetailCubit({required PredictionRepository predictionRepository})
    : _predictionRepository = predictionRepository,
      super(PredictionDetailInitial());

  Future<void> fetchPredictionDetail(String predictionId) async {
    emit(PredictionDetailLoading());
    try {
      final prediction = await _predictionRepository.readPrediction(
        predictionId: predictionId,
      );
      emit(PredictionDetailLoaded(prediction: prediction));
    } on PredictionException catch (e) {
      emit(PredictionDetailError(message: e.message));
    } catch (e) {
      emit(PredictionDetailError(message: 'An unexpected error occurred: $e'));
    }
  }
}
