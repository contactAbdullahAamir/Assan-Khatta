import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/features/group_managment/data/models/group_model.dart';

class GroupRemoteDatasource {
  final ApiService apiService;

  const GroupRemoteDatasource(this.apiService);

  Future<GroupModel> createGroup(Map<String, dynamic> group) async {
    try {
      final response = await apiService.post('/group/create', {
        "name": group['name'],
        "description": group['description'],
        "createdBy": group['createdBy'],
      });

      // Print the raw response body for debugging
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Decode response body and handle it
        final decodedResponse = jsonDecode(response.body);

        // Ensure that decodedResponse is a Map<String, dynamic>
        if (decodedResponse is Map<String, dynamic>) {
          // Convert to GroupModel
          return GroupModel.fromJson(decodedResponse);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception("Failed to create group: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  Future<List<GroupModel>> getGroups(String id) async {
    try {
      final response = await apiService.get('/group/get-all-groups/$id');

      final responseBody = jsonDecode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody['groups'] is List) {
        final List<dynamic> groupsJson = responseBody['groups'];

        final groups = groupsJson.map((group) {
          // Convert members and admins to List<String>
          if (group['members'] is Map) {
            group['members'] =
                (group['members'] as Map).values.toList().cast<String>();
          }
          if (group['admins'] is Map) {
            group['admins'] =
                (group['admins'] as Map).values.toList().cast<String>();
          }
          return GroupModel.fromJson(group);
        }).toList();

        return groups;
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load groups: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getGroupMembers(String id) async {
    try {
      final response = await apiService.get('/group/get-members/$id');

      final responseBody = jsonDecode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('members')) {
        final membersJson = responseBody['members'] as List<dynamic>;
        return membersJson.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load group members: ${e.toString()}');
    }
  }
}
