part of 'prediction_detail_cubit.dart';

abstract class PredictionDetailState extends Equatable {
  const PredictionDetailState();

  @override
  List<Object> get props => [];
}

final class PredictionDetailInitial extends PredictionDetailState {}

final class PredictionDetailLoading extends PredictionDetailState {}

final class PredictionDetailLoaded extends PredictionDetailState {
  final Prediction prediction;

  const PredictionDetailLoaded({required this.prediction});

  @override
  List<Object> get props => [prediction];
}

final class PredictionDetailError extends PredictionDetailState {
  final String message;

  const PredictionDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
