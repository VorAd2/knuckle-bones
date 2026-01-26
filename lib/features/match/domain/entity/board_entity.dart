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

  BoardEntity copyWith(int oracle, int score) {
    return BoardEntity(
      playerId: playerId,
      playerName: playerName,
      oracle: oracle,
      score: score,
    );
  }

  static Map<String, dynamic> toMap(
    String playerId,
    String playerName,
    int? oracle,
    int? score,
  ) {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'oracle': oracle,
      'score': score,
    };
  }

  factory BoardEntity.fromMap(Map<String, dynamic> boardMap) {
    return BoardEntity(
      playerId: boardMap['playerId'] ?? '',
      playerName: boardMap['playerName'] ?? '',
      oracle: boardMap['oracle'],
      score: boardMap['score'],
    );
  }
}
