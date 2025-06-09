import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final Dio _dio;

  PredictionRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Prediction> createPrediction({required File imageFile}) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();

      final response = await _dio.post(
        "/service/predict/create",
        data: imageBytes,
        options: Options(headers: {'Content-Type': 'application/octet-stream'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return Prediction.fromJson(response.data['data']);
      } else {
        throw PredictionException(
          response.data['message'] ?? 'Failed to create prediction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw PredictionException(
        e.response?.data['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<PredictionSummary>> listPredictions() async {
    try {
      final response = await _dio.get("/service/predict/list");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((item) {
          return PredictionSummary.fromJson(item);
        }).toList();
      } else {
        throw PredictionException(
          response.data['message'] ?? 'Failed to list predictions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw PredictionException(
        e.response?.data['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Prediction> readPrediction({required String predictionId}) async {
    try {
      final response = await _dio.get("/service/predict/read/$predictionId");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return Prediction.fromJson(response.data['data']);
      } else {
        throw PredictionException(
          response.data['message'] ?? 'Failed to read prediction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw PredictionException(
        e.response?.data['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
