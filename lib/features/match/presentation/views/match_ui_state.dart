class MatchUiState {
  String currentTurnPlayerId;
  int currentOracleValue;
  bool isRolling;
  bool isEndGame;

  MatchUiState({
    this.currentTurnPlayerId = '',
    this.currentOracleValue = 1,
    this.isRolling = false,
    this.isEndGame = false,
  });
}
