import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';

part 'create_prediction_state.dart';

class CreatePredictionCubit extends Cubit<CreatePredictionState> {
  final PredictionRepository _predictionRepository;

  CreatePredictionCubit({required PredictionRepository predictionRepository})
    : _predictionRepository = predictionRepository,
      super(CreatePredictionInitial());

  Future<void> createPrediction(File imageFile) async {
    emit(CreatePredictionLoading());
    try {
      final newPrediction = await _predictionRepository.createPrediction(
        imageFile: imageFile,
      );
      emit(CreatePredictionSuccess(prediction: newPrediction));
    } on PredictionException catch (e) {
      emit(CreatePredictionError(message: e.message));
    } catch (e) {
      emit(CreatePredictionError(message: 'An unexpected error occurred: $e'));
    }
  }
}
