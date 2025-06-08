import 'dart:io';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';

abstract class PredictionRepository {
  /// Creates a new prediction by uploading an image.
  /// Throws a [PredictionException] on failure.
  Future<Prediction> createPrediction({required File imageFile});

  /// Retrieves a list of past prediction summaries for the current user.
  /// Throws a [PredictionException] on failure.
  Future<List<PredictionSummary>> listPredictions();

  /// Retrieves the full details of a single prediction by its ID.
  /// Throws a [PredictionException] on failure.
  Future<Prediction> readPrediction({required String predictionId});
}

/// Custom exception for prediction-related errors.
class PredictionException implements Exception {
  final String message;
  final int? statusCode;

  PredictionException(this.message, {this.statusCode});

  @override
  String toString() =>
      'PredictionException: $message (Status Code: $statusCode)';
}
