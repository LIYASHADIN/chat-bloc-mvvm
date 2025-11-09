import 'package:chat_mvvm_bloc/models/chat_list.dart';
import 'package:equatable/equatable.dart';

abstract class ChatListState extends Equatable {
  @override List<Object?> get props => [];
}
class ChatListInitial extends ChatListState {}
class ChatListLoading extends ChatListState {}
class ChatListLoaded extends ChatListState {
  final List<ChatList> chats;
  ChatListLoaded(this.chats);
  @override List<Object?> get props => [chats];
}
class ChatListError extends ChatListState {
  final String message;
  ChatListError(this.message);
  @override List<Object?> get props => [message];
}
