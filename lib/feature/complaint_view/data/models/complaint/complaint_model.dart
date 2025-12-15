import 'package:complaints_app/constants.dart';
import 'package:complaints_app/feature/complaint/data/models/government_model.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';

import 'interaction_model.dart';

class ComplaintModel {
  int? id;
  int? userId;
  int? governmentId;
  String? description;
  String? location;
  String? type;
  List<dynamic>? documents;
  List<dynamic>? images;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  GovernmentModel? government;
  List<InteractionModel>? interactions;

  ComplaintModel({
    this.id,
    this.userId,
    this.governmentId,
    this.description,
    this.location,
    this.type,
    this.documents,
    this.images,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.government,
    this.interactions,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) => ComplaintModel(
    id: json['id'] as int?,
    userId: json['userId'] as int?,
    governmentId: json['governmentId'] as int?,
    description: json['description'] as String?,
    location: json['Location'] as String?,
    type: json['type'] as String?,
    documents: json['documents'],
    images: (json['images'] as List)
        .map(
          (e) =>
              e.toString().replaceFirst('http://localhost:3000', imageBaseUrl),
        )
        .toList(),
    status: json['status'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),

    government: json['government'] == null
        ? null
        : GovernmentModel.fromJson(json['government'] as Map<String, dynamic>),
    interactions: (json['interactions'] as List<dynamic>?)
        ?.map((e) => InteractionModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'governmentId': governmentId,
    'description': description,
    'Location': location,
    'type': type,
    'documents': documents,
    'images': images,
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'government': GovernmentModel.toJson(government!),
    'interactions': interactions?.map((e) => e.toJson()).toList(),
  };

  ComplaintEntity toEntity() => ComplaintEntity(
    id: id!,
    userId: userId!,
    governmentId: governmentId!,
    description: description!,
    location: location!,
    type: type!,
    documents: documents ?? [],
    images: images ?? [],
    status: status!,
    createdAt: createdAt!,
    updatedAt: updatedAt,
    government: government!.toEntity(),
    interactions: interactions ?? [],
  );
}
