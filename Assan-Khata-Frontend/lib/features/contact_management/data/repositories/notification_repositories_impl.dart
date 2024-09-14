import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/data/datasources/notification_remote_datasource.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/notification_model.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/repositories/notification_repositories.dart';
import 'package:fpdart/src/either.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRemoteDatasource notificationRemoteDatasource;

  NotificationRepositoryImpl(this.notificationRemoteDatasource);

  @override
  Future<Either<DataFailed, void>> sendNotification(
      Map<String, dynamic> notification) async {
    try {
      await notificationRemoteDatasource.sendNotification(notification);
      return Right(notification);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, List<NotificationModel>>> getNotifications(
      String userId) async {
    try {
      final notifications =
          await notificationRemoteDatasource.getNotifications(userId);
      return Right(notifications);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, void>> MarkAsReadNotification(
      String notificationId) async {
    try {
      final result = await notificationRemoteDatasource
          .markAsReadNotification(notificationId);

      return Right(null);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}
