import '../../../domain/entities/notification_entity.dart';

sealed class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final success;

  const NotificationSuccess(this.success);
}

class NotificationFailure extends NotificationState {
  final String message;

  const NotificationFailure({required this.message});
}

class NotificationGetSuccess extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationGetSuccess({required this.notifications});
}
