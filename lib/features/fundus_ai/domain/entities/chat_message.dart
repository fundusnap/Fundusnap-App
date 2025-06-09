import 'package:equatable/equatable.dart';
import 'chat_role.dart';

class ChatMessage extends Equatable {
  final String content;
  final ChatRole role;
  final DateTime time;

  const ChatMessage({
    required this.content,
    required this.role,
    required this.time,
  });

  @override
  List<Object?> get props => [content, role, time];

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    try {
      return ChatMessage(
        content: json['content'] as String,
        role: ChatRole.fromString(json['role'] as String),
        time: DateTime.parse(json['time'] as String),
      );
    } catch (e) {
      throw FormatException('Failed to parse ChatMessage from JSON: $json', e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role.name,
      'time': time.toIso8601String(),
    };
  }
}
