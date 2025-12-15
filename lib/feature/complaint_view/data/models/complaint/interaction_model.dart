class InteractionModel {
  int? id;
  int? complaintId;
   final int senderId;
  final String message;
  String? type;
  List<dynamic>? images;
  List<dynamic>? documents;
  DateTime? createdAt;

  InteractionModel({
    this.id,
    this.complaintId,
    required this.senderId,
    required this.message,
    this.type,
    this.images,
    this.documents,
    this.createdAt,
  });

  factory InteractionModel.fromJson(Map<String, dynamic> json) =>
      InteractionModel(
        id: json['id'] as int?,
        complaintId: json['complaintId'] as int?,
        senderId: json['senderId'] as int,
        message: json['message'] as String,
        type: json['type'] as String?,
        images: json['images'],
        documents: json['documents'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'complaintId': complaintId,
    'senderId': senderId,
    'message': message,
    'type': type,
    'images': images,
    'documents': documents,
    'createdAt': createdAt?.toIso8601String(),
  };
}
