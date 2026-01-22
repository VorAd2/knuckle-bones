class UserEntity {
  final String id;
  final String email;
  final String name;
  final int wins;
  final int gamesPlayed;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.wins = 0,
    this.gamesPlayed = 0,
  });
}
