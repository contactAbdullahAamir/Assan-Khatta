import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<DataFailed, void>> sendNotification(
      Map<String, dynamic> notification);

  Future<Either<DataFailed, List<NotificationModel>>> getNotifications(
      String userId);

  Future<Either<DataFailed, void>> MarkAsReadNotification(
      String notificationId);
}
