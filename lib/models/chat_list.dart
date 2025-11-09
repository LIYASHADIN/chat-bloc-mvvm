import 'package:chat_mvvm_bloc/models/login_response.dart';

class ChatList {
  final String id;
  final bool isGroupChat;
  final List<UserModel> participants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LastMessage? lastMessage;

  ChatList({
    required this.id,
    required this.isGroupChat,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      id: json['_id'],
      isGroupChat: json['isGroupChat'],
      participants: (json['participants'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class LastMessage {
  final String id;
  final String senderId;
  final String content;
  final String messageType;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'],
      senderId: json['senderId'],
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
