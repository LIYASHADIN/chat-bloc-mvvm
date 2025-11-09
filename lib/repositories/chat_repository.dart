import 'package:chat_mvvm_bloc/models/chat_list.dart';
import 'package:chat_mvvm_bloc/models/chat_message.dart';
import 'package:chat_mvvm_bloc/shared/constants.dart';

import '../services/api_service.dart';


class ChatRepository {
  final ApiService apiService;
  ChatRepository(this.apiService);

  Future<List<ChatList>> getUserChats(String userId) async {
    final resp = await apiService.get('${ApiConstants.userChats}/$userId');
    final list = resp.data as List;
    return list.map((e) => ChatList.fromJson(e)).toList();
  }

  Future<List<ChatMessage>> getMessages(String chatId) async {
    final resp = await apiService.get('${ApiConstants.getMessagesForMobile}/$chatId');
    final list = resp.data as List;
    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = 'text',
    String fileUrl = '',
  }) async {
    final body = {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType,
      'fileUrl': fileUrl,
    };
    await apiService.post(ApiConstants.sendMessage, body);
  }
}
