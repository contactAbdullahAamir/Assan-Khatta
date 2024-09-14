import 'dart:convert';

import '../../../../../core/common/api_service.dart';
import '../../models/user.dart';

class AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSource({required this.apiService});

  Future<UserModel> loginUser(String email, String password) async {
    try {
      final response = await apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> registerUser(
      String name, String email, String password) async {
    try {
      final response = await apiService.post('/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
      });
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> verifyEmail(String email, String code) async {
    try {
      final response = await apiService.post('/auth/verify-email', {
        'email': email,
        'code': code,
      });
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> requestMagicLink(String email) async {
    try {
      final response = await apiService.post('/auth/magic-link', {
        'email': email,
      });
      final responseBody = jsonDecode(response.body);

      return responseBody['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> verifyMagicLink(String token) async {
    try {
      final response = await apiService.get('/auth/magic-link/$token');
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }
}
