import 'package:chat_mvvm_bloc/shared/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    socket = IO.io(ApiConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Authorization': 'Bearer $token'},
    });
    socket!.connect();

    socket!.onConnect((_) {
      print('Socket connected: ${socket!.id}');
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  void emit(String event, dynamic data) {
    if (socket?.connected == true) socket!.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void dispose() {
    socket?.disconnect();
    socket = null;
  }
}
