import 'package:assan_khata_frontend/features/contact_management/domain/repositories/notification_repositories.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/resources/data_source.dart';

class SendNotification {
  final NotificationRepository repository;

  const SendNotification(this.repository);

  Future<Either<DataFailed, void>> call(SendNotificationParams params) async {
    return await repository.sendNotification(params.notification);
  }
}

class SendNotificationParams {
  final Map<String, dynamic> notification;

  SendNotificationParams({required this.notification});
}
