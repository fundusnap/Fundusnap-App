import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_message.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_role.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/markdown_content.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.role == ChatRole.user;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment: isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Avatar only for AI messages
            if (!isUserMessage)
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.bleachedCedar,
                  size: 48,
                ),
              ),
            // Message bubble
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? AppColors.veniceBlue
                    : AppColors.bleachedCedar,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUserMessage ? 16 : 4),
                  bottomRight: Radius.circular(isUserMessage ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bleachedCedar.withAlpha(12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: isUserMessage
                  ? Text(
                      message.content,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  : MarkdownContent(content: message.content),
            ),
          ],
        ),
      ),
    );
  }
}
