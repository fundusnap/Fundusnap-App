import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/fundus_ai/presentation/cubit/conversation/chat_conversation_cubit.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/chat_message_bubble.dart';

class ChatView extends StatefulWidget {
  final String? chatId;
  final String? predictionId;

  const ChatView({this.chatId, this.predictionId, super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final query = _textController.text.trim();
    if (query.isNotEmpty) {
      // Access the cubit via context.read() to call the method
      final cubit = context.read<ChatConversationCubit>();

      // The cubit handles whether to 'create' or 'reply'
      cubit.sendMessage(query: query, predictionId: widget.predictionId);
      _textController.clear();
      // Wait a moment for the new message to be added to the state before scrolling
      Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FundusAI'),
        backgroundColor: AppColors.angelBlue,
        // foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocConsumer<ChatConversationCubit, ChatConversationState>(
        listener: (context, state) {
          if (state.status == ChatConversationStatus.success) {
            // After AI replies, scroll to bottom
            Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
          }
          if (state.status == ChatConversationStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred'),
                  backgroundColor: AppColors.paleCarmine,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == ChatConversationStatus.loadingHistory) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.angelBlue),
                  SizedBox(height: 16),
                  Text(
                    'Loading chat history...',
                    style: TextStyle(color: AppColors.gray),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true, // To show latest messages at the bottom
                        padding: const EdgeInsets.all(16.0),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          // Because the list is reversed, we access messages from the end
                          final message =
                              state.messages[state.messages.length - 1 - index];
                          return ChatMessageBubble(message: message);
                        },
                      ),
              ),
              if (state.status == ChatConversationStatus.loadingReply)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.angelBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'FundusAI is thinking...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              _buildTextComposer(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask FundusAI about your scan results or\ngeneral questions about diabetic retinopathy',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    final isLoading =
        context.watch<ChatConversationCubit>().state.status ==
        ChatConversationStatus.loadingReply;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.angelBlue,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 8,
            color: AppColors.bleachedCedar.withAlpha(25),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  minLines: 1,
                  controller: _textController,
                  enabled: !isLoading,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Ask about your results...',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => isLoading ? null : _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                // color: isLoading ? Colors.grey.shade300 : AppColors.angelBlue,
                color: isLoading ? Colors.grey.shade300 : AppColors.veniceBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: isLoading ? Colors.grey.shade500 : Colors.white,
                ),
                onPressed: isLoading ? null : _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
