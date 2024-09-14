import 'package:assan_khata_frontend/features/contact_management/domain/usecases/notification_usecases/markasread_notifcation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../domain/usecases/notification_usecases/get_notifications_by_receiver_id.dart';
import '../../../domain/usecases/notification_usecases/send_notification.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendNotification _sendNotification;
  final GetNotificationsByReceiverId _getNotificationsByReceiverId;
  final MarkAsReadNotificationUseCase _markAsReadNotificationUseCase;

  NotificationBloc({
    required SendNotification sendNotification,
    required GetNotificationsByReceiverId getNotificationsByReceiverId,
    required MarkAsReadNotificationUseCase markAsReadNotificationUseCase,
  })  : _sendNotification = sendNotification,
        _getNotificationsByReceiverId = getNotificationsByReceiverId,
        _markAsReadNotificationUseCase = markAsReadNotificationUseCase,
        super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      NotificationLoading();
    });
    on<NotificationSend>(_onSendNotification);
    on<NotificationGet>(_getNotifications);
    on<MarkAsReadNotificationEvent>(_markAsReadNotification);
  }

  Future<void> _onSendNotification(
    NotificationSend event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await _sendNotification(
          SendNotificationParams(notification: event.notification));
      result.fold(
        (failure) {
          emit(NotificationFailure(
              message: failure.errorMessage ?? 'An unknown error occurred'));
        },
        (_) {
          emit(NotificationSuccess('Notification succeeded'));
        },
      );
    } catch (e) {
      emit(NotificationFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _getNotifications(
    NotificationGet event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _getNotificationsByReceiverId(
        GetNotificationsByReceiverIdParams(receiverId: event.userId));
    result.fold(
      (failure) {
        emit(NotificationFailure(
            message: failure.errorMessage ?? 'An unknown error occurred'));
      },
      (notifications) {
        emit(NotificationGetSuccess(notifications: notifications));
      },
    );
  }

  Future<void> _markAsReadNotification(
    MarkAsReadNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await _markAsReadNotificationUseCase(
          MarkAsReadNotificationUseCaseParams(
              notificationId: event.notificationId));
      result.fold(
        (failure) {
          emit(NotificationFailure(
              message: failure.errorMessage ?? 'An unknown error occurred'));
        },
        (_) {
          emit(NotificationSuccess("Notification deleted"));
        },
      );
    } catch (e) {
      emit(NotificationFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }
}

class NotificationSocket {
  final IO.Socket _socket;
  final NotificationBloc _notificationBloc;

  NotificationSocket({
    required String serverUrl,
    required NotificationBloc notificationBloc,
  })  : _notificationBloc = notificationBloc,
        _socket = IO.io(serverUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        }) {
    _socket.onConnect((_) {});

    _socket.on('notification', (data) {
      // Handle real-time notifications
      // Dispatch an event to the NotificationBloc to update UI
      _notificationBloc.add(NotificationSend(
        notification: data as Map<String, dynamic>, // Ensure correct type
      ));
    });

    _socket.connect();
  }
}
