import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';

class ComplaintModel {
  final int id;
  final String type;
  final String description;
  String? image;
  final int governmentId;
  final int userId;
  final String state;
  final String date;

  ComplaintModel({
    required this.id,
    required this.type,
    required this.description,
    this.image,
    required this.governmentId,
    required this.userId,
    required this.state,
    required this.date,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      image: json['image'],
      governmentId: json['governmentId'],
      userId: json['userId'],
      date: json['createdAt'],
      state: json['status'],
    );
  }

  factory ComplaintModel.toJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      image: json['image'],
      governmentId: json['governmentId'],
      userId: json['userId'],
      date: json['createdAt'],
      state: json['status'],
    );
  }

  ComplaintEntity toEntity() {
    return ComplaintEntity(type: type, date: date, state: state);
  }
}
