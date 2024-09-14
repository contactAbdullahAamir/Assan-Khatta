import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/notification_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/notification_repositories.dart';

class GetNotificationsByReceiverId {
  final NotificationRepository _notificationRepository;

  GetNotificationsByReceiverId(this._notificationRepository);

  Future<Either<DataFailed, List<NotificationEntity>>> call(
      GetNotificationsByReceiverIdParams params) async {
    return await _notificationRepository.getNotifications(params.receiverId);
  }
}

class GetNotificationsByReceiverIdParams {
  final String receiverId;

  GetNotificationsByReceiverIdParams({required this.receiverId});
}
