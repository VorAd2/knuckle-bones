class UserModel {
  final String id;
  String name;
  final String email;
  final String? avatarUrl;
  final List<Map<String, dynamic>>? matchHistory;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.matchHistory,
  });

  factory UserModel.mock() {
    return UserModel(
      id: '123',
      name: 'Ada Lovelace',
      email: 'adlace@gmail.com',
      matchHistory: _getHistory(),
    );
  }

  static List<Map<String, dynamic>>? _getHistory() {
    return null;
  }
}
