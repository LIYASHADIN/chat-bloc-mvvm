import 'package:chat_mvvm_bloc/models/chat_message.dart';
import 'package:chat_mvvm_bloc/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../repositories/chat_repository.dart';
import 'package:get_it/get_it.dart';
import '../../services/socket_service.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String chatId;
  final String currentUserId;
  const ChatPage({
    required this.chatName,
    required this.chatId,
    required this.currentUserId,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final repo = GetIt.instance<ChatRepository>();
  final socket = GetIt.instance<SocketService>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  bool loading = true;
  bool _initialScrollDone = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    socket.on('newMessage', (data) {
      final message = ChatMessage.fromJson(data);
      if (message.chatId == widget.chatId) {
        setState(() => messages.add(message));
        _scrollToBottom(animate: true);
      }
    });
  }

  Future<void> _loadMessages() async {
    try {
      final list = await repo.getMessages(widget.chatId);
      setState(() {
        messages = list;
        loading = false;
      });

      if (!_initialScrollDone) {
        _scrollToBottom(animate: false);
        _initialScrollDone = true;
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load messages')));
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    final provisional = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      content: text,
      messageType: 'text',
      fileUrl: '',
      createdAt: DateTime.now(),
      deletedBy: [],
      status: '',
      seenBy: [],
      sentAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() => messages.add(provisional));
    _scrollToBottom(animate: true);

    try {
      await repo.sendMessage(
        chatId: widget.chatId,
        senderId: widget.currentUserId,
        content: text,
      );

      socket.emit('sendMessage', {
        'chatId': widget.chatId,
        'senderId': widget.currentUserId,
        'content': text,
        'messageType': 'text',
        'fileUrl': '',
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Send failed')));
    }
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position.maxScrollExtent;

      if (animate) {
        _scrollController.animateTo(
          position,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.appGradient),
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.chatName}')),
        body: Column(
          children: [
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: false,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final m = messages[i];
                        final isMe = m.senderId == widget.currentUserId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.greenAccent
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(m.content),
                          ),
                        );
                      },
                    ),
            ),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Type a message'),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.black),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
