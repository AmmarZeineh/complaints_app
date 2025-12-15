import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';

class GovernmentModel {
  final int id;
  final String name;
  GovernmentModel({required this.id, required this.name});

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(id: json["id"], name: json["name"]);
  }
  factory GovernmentModel.toJson(GovernmentModel government) {
    return GovernmentModel(id: government.id, name: government.name);
  }

  static List<GovernmentModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => GovernmentModel.fromJson(e)).toList();
  }

  GovernmentEntity toEntity() {
    return GovernmentEntity(id: id, name: name);
  }
}
