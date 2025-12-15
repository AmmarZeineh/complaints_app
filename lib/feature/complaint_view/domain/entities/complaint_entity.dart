import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint_view/data/models/complaint/interaction_model.dart';

class ComplaintEntity {
  final int id;
  final int userId;
  final int governmentId;
  final String description;
  final String location;
  final String type;
  final List<dynamic> documents;
  final List<dynamic> images;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final GovernmentEntity government;
  final List<InteractionModel> interactions;

  ComplaintEntity({
    required this.id,
    required this.userId,
    required this.governmentId,
    required this.description,
    required this.location,
    required this.type,
    required this.documents,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.government,
    required this.interactions,
  });
}
