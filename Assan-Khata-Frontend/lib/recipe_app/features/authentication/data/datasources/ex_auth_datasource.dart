import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';

class ExAuthDatasource {
  final ApiService apiService;

  ExAuthDatasource({required this.apiService});

  Future<String> login(String email, String password) async {
    try {
      final result = await apiService.post('/external-api/login/', {
        'email': email,
        'password': password,
      });
      final responseBody = jsonDecode(result.body);
      return responseBody['accessToken'];
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }
}
