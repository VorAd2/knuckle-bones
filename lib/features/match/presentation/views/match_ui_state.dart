class MatchUiState {
  bool isPlayerTopTurn;
  int currentOracleValue;
  bool isRolling;
  bool isGameOver;

  MatchUiState({
    this.isPlayerTopTurn = false,
    this.currentOracleValue = 1,
    this.isRolling = false,
    this.isGameOver = false,
  });
}
