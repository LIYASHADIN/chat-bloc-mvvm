import 'package:chat_mvvm_bloc/models/login_response.dart';
import 'package:chat_mvvm_bloc/shared/constants.dart';

import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService apiService;
  AuthRepository(this.apiService);

 Future<LoginResponse> login({
  required String email,
  required String password,
  required String role,
}) async {

      final body = {'email': email, 'password': password, 'role': role};
      print("url $body");
      try {
         final response = await apiService.post(
            ApiConstants.login, body
          );

          if (response.statusCode == 200) {
            return LoginResponse.fromJson(response.data);
          } else {
            throw Exception("Login failed");
          }
      } catch (e) {
        print("error  url$e");
        throw Exception('Login failed: $e');
      }
     
    }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }
}
