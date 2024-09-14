import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/features/authentication/data/models/user.dart';

class UserRemoteDatasouce {
  final ApiService apiService;

  const UserRemoteDatasouce(this.apiService);

  Future<UserModel> updateUser(Map<String, dynamic> user) async {
    try {
      final response = await apiService.put('/user/updateUser', {"user": user});
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      final response = await apiService.get('/user/getUser/$id');
      final responseBody = jsonDecode(response.body);
      return UserModel.fromJson(responseBody['user']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await apiService.get('/user/getAllUsers');
      final responseBody = jsonDecode(response.body);
      return responseBody['users']
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
