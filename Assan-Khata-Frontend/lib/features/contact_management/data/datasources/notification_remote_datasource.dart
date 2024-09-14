import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/notification_model.dart';

class NotificationRemoteDatasource {
  final ApiService apiService;

  const NotificationRemoteDatasource(this.apiService);

  Future<void> sendNotification(Map<String, dynamic> notification) async {
    try {
      await apiService
          .post('/notification/create', {"notification": notification});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await apiService.get('/notification/$userId');
      final responseBody = response.body;

      // Check if responseBody is a String, and decode it
      final List<dynamic> jsonResponse =
          jsonDecode(responseBody) as List<dynamic>;

      // Map each item in the list to NotificationModel
      return jsonResponse
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  Future<void> markAsReadNotification(String notificationId) async {
    try {
      final response =
          await apiService.put('/notification/$notificationId', {});
      final responseBody = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }
}
