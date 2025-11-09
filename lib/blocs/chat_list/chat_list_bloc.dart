import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';
import '../../repositories/chat_repository.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository repository;
  ChatListBloc(this.repository) : super(ChatListInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatListLoading());
      try {
        final chats = await repository.getUserChats(event.userId);
        emit(ChatListLoaded(chats));
      } catch (e) {
        emit(ChatListError(e.toString()));
      }
    });
  }
}
