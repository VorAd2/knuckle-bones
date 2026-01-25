class MatchUiState {
  String? currentTurnPlayerId;
  bool isRolling;
  bool isDestroying;
  bool isEndGame;

  MatchUiState({
    this.isRolling = false,
    this.isDestroying = false,
    this.isEndGame = false,
  });
}
