import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/notification_repositories.dart';

class MarkAsReadNotificationUseCase {
  final NotificationRepository _notificationRepository;

  MarkAsReadNotificationUseCase(this._notificationRepository);

  Future<Either<DataFailed, void>> call(
      MarkAsReadNotificationUseCaseParams params) async {
    return await _notificationRepository.MarkAsReadNotification(
        params.notificationId);
  }
}

class MarkAsReadNotificationUseCaseParams {
  final String notificationId;

  MarkAsReadNotificationUseCaseParams({required this.notificationId});
}
