class MatchUiState {
  bool isPlayerTopTurn;
  int currentOracleValue;
  bool isRolling;
  bool isEndGame;

  MatchUiState({
    this.isPlayerTopTurn = false,
    this.currentOracleValue = 1,
    this.isRolling = false,
    this.isEndGame = false,
  });
}
