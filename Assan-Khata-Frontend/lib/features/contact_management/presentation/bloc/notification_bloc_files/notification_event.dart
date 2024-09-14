sealed class NotificationEvent {}

final class NotificationSend extends NotificationEvent {
  final Map<String, dynamic> notification;

  NotificationSend({required this.notification});
}

final class NotificationGet extends NotificationEvent {
  final String userId;

  NotificationGet({required this.userId});
}

final class MarkAsReadNotificationEvent extends NotificationEvent {
  final String notificationId;

  MarkAsReadNotificationEvent({required this.notificationId});
}
