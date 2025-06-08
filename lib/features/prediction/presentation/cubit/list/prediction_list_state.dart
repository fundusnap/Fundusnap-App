part of 'prediction_list_cubit.dart';

abstract class PredictionListState extends Equatable {
  const PredictionListState();

  @override
  List<Object> get props => [];
}

final class PredictionListInitial extends PredictionListState {}

final class PredictionListLoading extends PredictionListState {}

final class PredictionListLoaded extends PredictionListState {
  final List<PredictionSummary> predictions;

  const PredictionListLoaded({required this.predictions});

  @override
  List<Object> get props => [predictions];
}

final class PredictionListError extends PredictionListState {
  final String message;

  const PredictionListError({required this.message});

  @override
  List<Object> get props => [message];
}
