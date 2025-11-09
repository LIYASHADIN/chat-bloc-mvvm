

import 'package:chat_mvvm_bloc/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
          print('➡️ url [${options.method}] ${options.uri}');

      return handler.next(options);
    }));
  }

  Future<Response> post(String path, Map<String, dynamic> body) async {
    return _dio.post(path, data: body);
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }
}
