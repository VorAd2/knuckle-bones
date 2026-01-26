class LastMoveEntity {
  final int row;
  final int col;
  final int dice;
  final String playerId;

  LastMoveEntity({
    required this.col,
    required this.row,
    required this.dice,
    required this.playerId,
  });

  factory LastMoveEntity.fromMap(Map<String, dynamic> data) {
    return LastMoveEntity(
      row: data['row'],
      col: data['col'],
      dice: data['dice'],
      playerId: data['playerId'],
    );
  }
}
