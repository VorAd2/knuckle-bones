class UserEntity {
  final String id;
  final String email;
  String name;
  String avatarUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  factory UserEntity.mock() {
    return UserEntity(
      id: '12345',
      name: 'Ada Lovelace',
      email: 'adlace@knucklebones.com',
      avatarUrl: '',
    );
  }
}
