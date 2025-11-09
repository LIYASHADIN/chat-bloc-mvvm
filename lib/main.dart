import 'package:chat_mvvm_bloc/theme/app_theme.dart';
import 'package:chat_mvvm_bloc/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'services/api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/chat_repository.dart';
import 'services/socket_service.dart';

void setup() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => AuthRepository(getIt()));
  getIt.registerLazySingleton(() => ChatRepository(getIt()));
  getIt.registerLazySingleton(() => SocketService());
}

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
       theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.appGradient,
          ),
          child:  LoginPage(),
        ),
      ),
    );
  }
}
