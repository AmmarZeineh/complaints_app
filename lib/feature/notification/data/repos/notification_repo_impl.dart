import 'package:complaints_app/constants.dart';
import 'package:complaints_app/core/errors/failure.dart';
import 'package:complaints_app/core/services/api.dart';
import 'package:complaints_app/feature/notification/data/models/notification_model/notification_model.dart';
import 'package:complaints_app/feature/notification/domain/entities/notification_entity.dart';
import 'package:complaints_app/feature/notification/domain/repos/notification_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationRepoImpl implements NotificationRepo {
  final Api _api;

  NotificationRepoImpl(this._api);
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      var response = await _api.get(url: '$baseUrl/test-notification');
      List<NotificationEntity> notifications = [];
      for (var i = 0; i < response.length; i++) {
        notifications.add(NotificationModel.fromJson(response[i]).toEntity());
      }
      return right(notifications);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required int notificationId,
  }) async {
    try {
      await _api.patch(url: '$baseUrl/test-notification/$notificationId/read');
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
