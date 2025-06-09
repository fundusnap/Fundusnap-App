import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/features/fundus_ai/presentation/cubit/list/chat_list_cubit.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_error_state.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_loaded_state.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_loading_state.dart';

class FundusAiScreen extends StatefulWidget {
  const FundusAiScreen({super.key});

  @override
  State<FundusAiScreen> createState() => _FundusAiScreenState();
}

class _FundusAiScreenState extends State<FundusAiScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatListCubit>().fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading || state is ChatListInitial) {
          return const FundusAiLoadingState();
        }
        if (state is ChatListError) {
          return FundusAiErrorState(message: state.message);
        }
        if (state is ChatListLoaded) {
          return FundusAiLoadedState(chats: state.chats);
        }
        return const Center(child: Text('An unknown state occurred.'));
      },
    );
  }
}
