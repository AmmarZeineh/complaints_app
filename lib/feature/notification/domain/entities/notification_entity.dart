
import 'package:complaints_app/feature/notification/domain/entities/notification_data_entity.dart';

class NotificationEntity {
  int? id;
  int? userId;
  String? title;
  String? body;
  String? type;
  NotificationDataEntity? data;
  bool? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  NotificationEntity({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.type,
    this.data,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  
}
