import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/feature/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  Future<Either<Failure, void>> markAsRead({required int notificationId});
}
