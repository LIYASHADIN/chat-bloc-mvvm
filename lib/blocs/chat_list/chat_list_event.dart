import 'package:equatable/equatable.dart';
class ChatListEvent extends Equatable {
  @override List<Object?> get props => [];
}
class LoadChats extends ChatListEvent {
  final String userId;
  LoadChats(this.userId);
  @override List<Object?> get props => [userId];
}
