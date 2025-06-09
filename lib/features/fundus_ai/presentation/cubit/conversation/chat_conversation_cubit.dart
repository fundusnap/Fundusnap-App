import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_message.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_role.dart';
import 'package:sugeye/features/fundus_ai/domain/repositories/chat_repository.dart';

part 'chat_conversation_state.dart';

class ChatConversationCubit extends Cubit<ChatConversationState> {
  final ChatRepository _chatRepository;

  ChatConversationCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const ChatConversationState());

  /// To be called when opening an existing chat from the history list.
  Future<void> loadChatHistory(String chatId) async {
    emit(state.copyWith(status: ChatConversationStatus.loadingHistory));
    try {
      final session = await _chatRepository.readChat(chatId: chatId);
      emit(
        state.copyWith(
          status: ChatConversationStatus.success,
          messages: session.chats,
          chatId: chatId,
        ),
      );
    } on ChatException catch (e) {
      emit(
        state.copyWith(
          status: ChatConversationStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatConversationStatus.error,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  /// To be called to send a message. It handles both creating a new chat and replying to an existing one.
  Future<void> sendMessage({
    required String query,
    String?
    predictionId, // Provide this for the VERY FIRST message of a new chat
  }) async {
    // Optimistic UI Update: Add the user's message to the list immediately
    final userMessage = ChatMessage(
      content: query,
      role: ChatRole.user,
      time: DateTime.now(),
    );
    final currentMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);

    emit(
      state.copyWith(
        messages: currentMessages,
        status:
            ChatConversationStatus.loadingReply, // Show loading for AI response
      ),
    );

    try {
      if (state.chatId == null) {
        // --- This is a NEW chat ---
        if (predictionId == null) {
          throw const ChatException(
            "Prediction ID is required to start a new chat.",
          );
        }
        final result = await _chatRepository.createChat(
          predictionId: predictionId,
          query: query,
        );
        final newChatId = result['id']!;
        final aiResponseContent = result['response']!;

        final assistantMessage = ChatMessage(
          content: aiResponseContent,
          role: ChatRole.assistant,
          time: DateTime.now(),
        );
        emit(
          state.copyWith(
            status: ChatConversationStatus.success,
            messages: [...currentMessages, assistantMessage],
            chatId: newChatId, // Store the new chat ID for future replies
          ),
        );
      } else {
        // --- This is a REPLY to an existing chat ---
        final aiResponseContent = await _chatRepository.replyToChat(
          chatId: state.chatId!,
          query: query,
        );

        final assistantMessage = ChatMessage(
          content: aiResponseContent,
          role: ChatRole.assistant,
          time: DateTime.now(),
        );
        emit(
          state.copyWith(
            status: ChatConversationStatus.success,
            messages: [...currentMessages, assistantMessage],
          ),
        );
      }
    } on ChatException catch (e) {
      // If an error occurs, update the state to show it.
      // You could also add a "failed to send" status to the last user message here.
      emit(
        state.copyWith(
          status: ChatConversationStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatConversationStatus.error,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
