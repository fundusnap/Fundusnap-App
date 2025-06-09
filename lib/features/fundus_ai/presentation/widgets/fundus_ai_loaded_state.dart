import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_summary.dart';
import 'package:sugeye/features/fundus_ai/presentation/cubit/list/chat_list_cubit.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/chat_summary_card.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_empty_state.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_header.dart';

class FundusAiLoadedState extends StatelessWidget {
  final List<ChatSummary> chats;

  const FundusAiLoadedState({required this.chats, super.key});

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const FundusAiEmptyState();
    }

    return Column(
      children: [
        // Header with stats
        FundusAiHeader(
          title: "FundusAI Assistant",
          showStats: true,
          chatCount: chats.length,
        ),
        // Chat list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ChatListCubit>().fetchChats(),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatSummaryCard(chatSummary: chats[index], index: index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
