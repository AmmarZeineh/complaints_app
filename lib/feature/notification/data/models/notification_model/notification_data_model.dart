import 'package:complaints_app/feature/notification/domain/entities/notification_data_entity.dart';

class NotificationDataModel {
  int? complaintId;
  int? interactionId;

  NotificationDataModel({this.complaintId, this.interactionId});

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataModel(
        complaintId: json['complaintId'] as int?,
        interactionId: json['interactionId'] as int?,
      );

  NotificationDataEntity toEntity() => NotificationDataEntity(
    complaintId: complaintId,
    interactionId: interactionId,
  );
}
