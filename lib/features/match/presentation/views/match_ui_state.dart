class MatchUiState {
  String currentTurnPlayerId;
  int currentOracleValue;
  bool isRolling;
  bool isDestroying;
  bool isEndGame;

  MatchUiState({
    this.currentTurnPlayerId = '',
    this.currentOracleValue = 1,
    this.isRolling = false,
    this.isDestroying = false,
    this.isEndGame = false,
  });
}
