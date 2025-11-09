import 'package:chat_mvvm_bloc/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;

  bool isLoading = false;
  String? error;
  LoginResponse? user;

  LoginViewModel(this.repository);

  Future<bool> login(String email, String password, String role) async {
    isLoading = true; error = null; notifyListeners();
    try {
      user = await repository.login(email: email, password: password, role: role);
       final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', user!.token);
    await prefs.setString('user_id', user!.user.id);
    await prefs.setString('userName', user!.user.name);

      isLoading = false; notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false; notifyListeners();
      return false;
    }
  }
}
