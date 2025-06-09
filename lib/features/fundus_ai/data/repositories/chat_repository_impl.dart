import 'package:dio/dio.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_session.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_summary.dart';
import 'package:sugeye/features/fundus_ai/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;
  final String _baseUrl =
      "/service/chat"; // Using relative path from Dio's baseUrl

  ChatRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Map<String, String>> createChat({
    required String predictionId,
    required String query,
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/create",
        data: {"predictionID": predictionId, "query": query},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'] as Map<String, dynamic>;
        return {
          'id': data['id'] as String,
          'response': data['response'] as String,
        };
      } else {
        throw ChatException(
          response.data['message'] ?? 'Failed to create chat',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        e.response?.data['message'] ??
            e.message ??
            'An unknown network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ChatException(e.toString());
    }
  }

  @override
  Future<String> replyToChat({
    required String chatId,
    required String query,
  }) async {
    try {
      // Your friend's API uses PUT for this endpoint
      final response = await _dio.put(
        "$_baseUrl/reply",
        data: {"id": chatId, "query": query},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'] as Map<String, dynamic>;
        return data['response'] as String;
      } else {
        throw ChatException(
          response.data['message'] ?? 'Failed to send reply',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        e.response?.data['message'] ??
            e.message ??
            'An unknown network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ChatException(e.toString());
    }
  }

  @override
  Future<List<ChatSummary>> listChats() async {
    try {
      final response = await _dio.get("$_baseUrl/list");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((item) => ChatSummary.fromJson(item)).toList();
      } else {
        throw ChatException(
          response.data['message'] ?? 'Failed to list chats',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        e.response?.data['message'] ??
            e.message ??
            'An unknown network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ChatException(e.toString());
    }
  }

  @override
  Future<ChatSession> readChat({required String chatId}) async {
    try {
      final response = await _dio.get("$_baseUrl/read/$chatId");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return ChatSession.fromJson(response.data['data']);
      } else {
        throw ChatException(
          response.data['message'] ?? 'Failed to read chat',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ChatException(
        e.response?.data['message'] ??
            e.message ??
            'An unknown network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ChatException(e.toString());
    }
  }
}
