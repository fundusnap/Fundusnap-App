import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';
import 'package:sugeye/features/prediction/domain/repositories/prediction_repository.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final Dio _dio;
  final AuthRepository _authRepository;
  // final String _baseUrl = "https://api.fundusnap.com/service/predict";

  PredictionRepositoryImpl({
    required Dio dio,
    required AuthRepository authRepository,
  }) : _dio = dio,
       _authRepository = authRepository;

  // /// Helper to get authenticated headers. Throws if not authenticated.
  // Future<Map<String, String>> _getAuthHeaders() async {
  //   final user = await _authRepository.getCurrentUser();
  //   if (user == null) {
  //     throw PredictionException(
  //       'Not authenticated. Please sign in again.',
  //       statusCode: 401,
  //     );
  //   }
  //   return {'Authorization': 'Bearer ${user.accessToken}'};
  // }

  // @override
  // Future<Prediction> createPrediction({required File imageFile}) async {
  //   try {
  //     final headers = await _getAuthHeaders();
  //     headers['Content-Type'] = 'application/octet-stream';

  //     final imageBytes = await imageFile.readAsBytes();

  //     final response = await _dio.post(
  //       "$_baseUrl/create",
  //       data: imageBytes,
  //       options: Options(headers: headers),
  //     );

  //     if (response.statusCode == 200 && response.data['status'] == 'success') {
  //       return Prediction.fromJson(response.data['data']);
  //     } else {
  //       throw PredictionException(
  //         response.data['message'] ?? 'Failed to create prediction',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw PredictionException(
  //       e.response?.data['message'] ??
  //           e.message ??
  //           'An unknown network error occurred',
  //       statusCode: e.response?.statusCode,
  //     );
  //   } catch (e) {
  //     throw PredictionException(e.toString());
  //   }
  // }

  @override
  Future<Prediction> createPrediction({required File imageFile}) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

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

  // @override
  // Future<List<PredictionSummary>> listPredictions() async {
  //   try {
  //     final headers = await _getAuthHeaders();

  //     final response = await _dio.get(
  //       "$_baseUrl/list",
  //       options: Options(headers: headers),
  //     );

  //     if (response.statusCode == 200 && response.data['status'] == 'success') {
  //       final List<dynamic> dataList = response.data['data'];
  //       return dataList
  //           .map((item) => PredictionSummary.fromJson(item))
  //           .toList();
  //     } else {
  //       throw PredictionException(
  //         response.data['message'] ?? 'Failed to list predictions',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw PredictionException(
  //       e.response?.data['message'] ??
  //           e.message ??
  //           'An unknown network error occurred',
  //       statusCode: e.response?.statusCode,
  //     );
  //   } catch (e) {
  //     throw PredictionException(e.toString());
  //   }
  // }

  @override
  Future<List<PredictionSummary>> listPredictions() async {
    try {
      final response = await _dio.get("/service/predict/list");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> dataList = response.data['data'];
        return dataList
            .map((item) => PredictionSummary.fromJson(item))
            .toList();
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

  // @override
  // Future<Prediction> readPrediction({required String predictionId}) async {
  //   try {
  //     final headers = await _getAuthHeaders();

  //     final response = await _dio.get(
  //       "$_baseUrl/read/$predictionId",
  //       options: Options(headers: headers),
  //     );

  //     if (response.statusCode == 200 && response.data['status'] == 'success') {
  //       return Prediction.fromJson(response.data['data']);
  //     } else {
  //       throw PredictionException(
  //         response.data['message'] ?? 'Failed to read prediction',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw PredictionException(
  //       e.response?.data['message'] ??
  //           e.message ??
  //           'An unknown network error occurred',
  //       statusCode: e.response?.statusCode,
  //     );
  //   } catch (e) {
  //     throw PredictionException(e.toString());
  //   }
  // }

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
