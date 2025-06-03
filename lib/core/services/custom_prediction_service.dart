import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomPredictionService {
  final Dio _dio = Dio();

  final String _endpointUrl =
      "https://fundusnap-prediction.cognitiveservices.azure.com/customvision/v3.0/Prediction/ffdd0da0-9f9e-4376-8924-a42d8a4d35c0/classify/iterations/V1/image";

  final String _predictionKey =
      "2NOy2892PFsVo33h3mr4X2rjJpDF15gjwIDX5EeUduejL9EvxDjoFJQQJ99BEACqBBLyXJ3w3AAAIACOG40Fh";

  Future<Map<String, dynamic>?> predictImage(File imageFile) async {
    try {
      // ? read image bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      debugPrint("Sending image to Azure: ${imageFile.path}");
      debugPrint("Endpoint: $_endpointUrl");
      debugPrint("Content-Length: ${imageBytes.length}");

      Response response = await _dio.post(
        _endpointUrl,
        data: imageBytes,
        //  Stream.fromIterable(

        //   imageBytes.map((e) => [e]),

        // ), // ?  stream of bytes
        options: Options(
          headers: {
            'Prediction-Key': _predictionKey,
            'Content-Type': 'application/octet-stream',
            // ? dio will set Content-Length automatically when using stream
          },
          //  ?  might need to handle timeouts or other dio optisno (later)
          // sendTimeout: Duration(seconds: 30),
          // receiveTimeout: Duration(seconds: 30),
        ),
      );

      debugPrint("Azure Response Status Code: ${response.statusCode}");
      debugPrint("Azure Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          debugPrint(
            "Unexpected response data type: ${response.data?.runtimeType}",
          );
          debugPrint("Response data: ${response.data}");
          return null; // Or throw an exception indicating unexpected format
        }
      }
    } on DioException catch (e) {
      debugPrint('DioError predicting image: ${e.message}');
      if (e.response != null) {
        debugPrint('DioError response data: ${e.response?.data}');
        debugPrint('DioError response headers: ${e.response?.headers}');
      } else {
        debugPrint('DioError error sending request: $e');
      }
      return null;
    } catch (e) {
      debugPrint('Unexpected error predicting image: $e');
      return null;
    }
    return null;
  }

  Future<void> pickAndPredictImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageXFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageXFile != null) {
      File imageFile = File(imageXFile.path);
      Map<String, dynamic>? predictionResult = await predictImage(imageFile);

      if (predictionResult != null) {
        debugPrint("Prediction Result: $predictionResult");
        // Example: Accessing predictions for a Custom Vision classification model
        List<dynamic>? predictions = predictionResult['predictions'];
        if (predictions != null && predictions.isNotEmpty) {
          for (var pred in predictions) {
            debugPrint(
              "Tag: ${pred['tagName']}, Probability: ${pred['probability']}",
            );
          }
        }
      }
    }
  }
}
