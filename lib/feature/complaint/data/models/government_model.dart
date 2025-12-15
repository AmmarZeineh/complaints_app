import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';

class GovernmentModel extends GovernmentEntity {
  GovernmentModel({required super.id, required super.name});

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(id: json["id"], name: json["name"]);
  }

  static List<GovernmentModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => GovernmentModel.fromJson(e)).toList();
  }
}
