class BoardEntity {
  final String playerId;
  final String playerName;
  final int? omen;
  final int? score;

  BoardEntity({
    required this.playerId,
    required this.playerName,
    required this.omen,
    required this.score,
  });

  BoardEntity copyWith({int? omen, int? score}) {
    return BoardEntity(
      playerId: playerId,
      playerName: playerName,
      omen: omen ?? this.omen,
      score: score ?? this.score,
    );
  }
}
