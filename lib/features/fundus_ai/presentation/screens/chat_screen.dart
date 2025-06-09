import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/fundus_ai/domain/repositories/chat_repository.dart';
import 'package:sugeye/features/fundus_ai/presentation/cubit/conversation/chat_conversation_cubit.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/chat_view.dart';

class ChatScreen extends StatelessWidget {
  final String? chatId;
  final String? predictionId;

  const ChatScreen({super.key, this.chatId, this.predictionId})
    : assert(
        chatId != null || predictionId != null,
        'Either chatId or predictionId must be provided',
      );

  @override
  Widget build(BuildContext context) {
    // Provide a new instance of ChatConversationCubit for this screen.
    // This is important so that each chat screen has its own independent state.
    return BlocProvider(
      create: (context) {
        final ChatConversationCubit cubit = ChatConversationCubit(
          chatRepository: RepositoryProvider.of<ChatRepository>(context),
        );
        // ONLY call loadChatHistory if chatId is NOT null
        if (chatId != null) {
          cubit.loadChatHistory(chatId!);
        }
        return cubit;
      },
      child: ChatView(
        chatId: chatId,
        predictionId: predictionId,
      ), // _ChatView remains the same
    );
  }
}
