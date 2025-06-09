part of 'chat_list_cubit.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

final class ChatListInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {}

final class ChatListLoaded extends ChatListState {
  final List<ChatSummary> chats;

  const ChatListLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

final class ChatListError extends ChatListState {
  final String message;

  const ChatListError({required this.message});

  @override
  List<Object> get props => [message];
}
