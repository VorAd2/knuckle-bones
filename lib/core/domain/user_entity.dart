import 'dart:io';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final File? avatarFile;
  final int wins;
  final int gamesPlayed;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarFile,
    this.wins = 0,
    this.gamesPlayed = 0,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    File? avatarFile,
    int? wins,
    int? gamesPlayed,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarFile: avatarFile ?? this.avatarFile,
      wins: wins ?? this.wins,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    );
  }
}
