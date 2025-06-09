import 'package:equatable/equatable.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_message.dart';

class ChatSession extends Equatable {
  final String predictionID;
  final List<ChatMessage> chats;

  const ChatSession({required this.predictionID, required this.chats});

  @override
  List<Object?> get props => [predictionID, chats];

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    try {
      final chatList = (json['chats'] as List)
          .map(
            (chatJson) =>
                ChatMessage.fromJson(chatJson as Map<String, dynamic>),
          )
          .toList();

      return ChatSession(
        predictionID: json['predictionID'] as String,
        chats: chatList,
      );
    } catch (e) {
      throw FormatException('Failed to parse ChatSession from JSON: $json', e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'predictionID': predictionID,
      'chats': chats.map((chat) => chat.toJson()).toList(),
    };
  }
}
