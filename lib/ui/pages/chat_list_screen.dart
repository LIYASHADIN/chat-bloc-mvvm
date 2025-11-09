import 'package:chat_mvvm_bloc/theme/app_theme.dart';
import 'package:chat_mvvm_bloc/ui/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat_repository.dart';
import 'package:get_it/get_it.dart';
import '../../blocs/chat_list/chat_list_bloc.dart';
import '../../blocs/chat_list/chat_list_event.dart';
import '../../blocs/chat_list/chat_list_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.instance<ChatRepository>();

    return BlocProvider(
      create: (_) => ChatListBloc(repo)..add(LoadChats('')),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.appGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: FutureBuilder<String?>(
              future: _getUserName(),
              builder: (context, snapshot) {
                final name = snapshot.data ?? 'User';
                return Text('Welcome $name 👋');
              },
            ),
          ),
          body: FutureBuilder<String?>(
            future: _getUserId(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final userId = snap.data!;
              context.read<ChatListBloc>().add(LoadChats(userId));

              return BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatListLoaded) {
                    if (state.chats.isEmpty) {
                      return const Center(
                          child: Text('No chats found',
                              style: TextStyle(color: Colors.black)));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.chats.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: Colors.black12,
                        height: 1,
                      ),
                      itemBuilder: (context, i) {
                        final c = state.chats[i];
                        final participant = c.participants.firstWhere(
                          (p) => p.id != userId,
                          orElse: () => c.participants.first,
                        );

                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatPage(chatId: c.id, currentUserId: userId,chatName: participant.name,),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            color: Colors.transparent, 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      participant.name.isEmpty
                                          ? c.id
                                          : participant.name,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      c.lastMessage?.content ?? 'No messages yet',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right, color: Colors.black),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatListError) {
                    return Center(
                        child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.white),
                    ));
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }
}
