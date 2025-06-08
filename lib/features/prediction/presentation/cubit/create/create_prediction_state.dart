part of 'create_prediction_cubit.dart';

abstract class CreatePredictionState extends Equatable {
  const CreatePredictionState();

  @override
  List<Object> get props => [];
}

final class CreatePredictionInitial extends CreatePredictionState {}

final class CreatePredictionLoading extends CreatePredictionState {}

// On success, we emit the full prediction object we got back
final class CreatePredictionSuccess extends CreatePredictionState {
  final Prediction prediction;

  const CreatePredictionSuccess({required this.prediction});

  @override
  List<Object> get props => [prediction];
}

final class CreatePredictionError extends CreatePredictionState {
  final String message;

  const CreatePredictionError({required this.message});

  @override
  List<Object> get props => [message];
}
