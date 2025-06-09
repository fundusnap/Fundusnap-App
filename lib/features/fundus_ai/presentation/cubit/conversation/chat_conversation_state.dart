part of 'chat_conversation_cubit.dart';

// Enum to represent the different statuses of the chat screen
enum ChatConversationStatus {
  initial,
  loadingHistory,
  loadingReply,
  success,
  error,
}

class ChatConversationState extends Equatable {
  final ChatConversationStatus status;
  final List<ChatMessage> messages;
  final String? chatId; // The ID of the current chat session
  final String? errorMessage;

  const ChatConversationState({
    this.status = ChatConversationStatus.initial,
    this.messages = const [],
    this.chatId,
    this.errorMessage,
  });

  // copyWith allows us to create a new state instance by changing only the properties we need
  ChatConversationState copyWith({
    ChatConversationStatus? status,
    List<ChatMessage>? messages,
    String? chatId,
    String? errorMessage,
  }) {
    return ChatConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      chatId: chatId ?? this.chatId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, chatId, errorMessage];
}
