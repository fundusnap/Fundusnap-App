import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/fundus_ai/domain/entities/chat_summary.dart';
import 'package:sugeye/features/fundus_ai/domain/repositories/chat_repository.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository _chatRepository;

  ChatListCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatListInitial());

  Future<void> fetchChats() async {
    emit(ChatListLoading());
    try {
      final chats = await _chatRepository.listChats();
      emit(ChatListLoaded(chats: chats));
    } on ChatException catch (e) {
      emit(ChatListError(message: e.message));
    } catch (e) {
      emit(ChatListError(message: 'An unexpected error occurred: $e'));
    }
  }
}
