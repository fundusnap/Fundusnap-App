import 'package:sugeye/features/fundus_ai/domain/entities/chat_session.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_summary.dart';

abstract class ChatRepository {
  /// Starts a new chat session related to a specific prediction.
  /// Returns a map containing the new `chatId` and the AI's first `response`.
  /// Throws a [ChatException] on failure.
  Future<Map<String, String>> createChat({
    required String predictionId,
    required String query,
  });

  /// Sends a follow-up message to an existing chat session.
  /// Returns the AI's new response string.
  /// Throws a [ChatException] on failure.
  Future<String> replyToChat({required String chatId, required String query});

  /// Retrieves a list of all past chat summaries for the current user.
  /// Throws a [ChatException] on failure.
  Future<List<ChatSummary>> listChats();

  /// Retrieves the full message history for a single chat session.
  /// Throws a [ChatException] on failure.
  Future<ChatSession> readChat({required String chatId});
}

/// Custom exception for chat-related errors.
class ChatException implements Exception {
  final String message;
  final int? statusCode;

  const ChatException(this.message, {this.statusCode});

  @override
  String toString() => 'ChatException: $message (Status Code: $statusCode)';
}
