class BoardEntity {
  final String playerId;
  final String playerName;
  final int? oracle;
  final int? score;

  BoardEntity({
    required this.playerId,
    required this.playerName,
    required this.oracle,
    required this.score,
  });

  BoardEntity copyWith({int? oracle, int? score}) {
    return BoardEntity(
      playerId: playerId,
      playerName: playerName,
      oracle: oracle ?? this.oracle,
      score: score ?? this.score,
    );
  }
}
