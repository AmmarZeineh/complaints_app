class UserEntity {
  final int id;
  final String accessToken;
  final String name;
  final String email;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? accessToken,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
