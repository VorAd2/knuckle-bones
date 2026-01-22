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

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    int? wins,
    int? gamesPlayed,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      wins: wins ?? this.wins,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    );
  }
}
