typedef TileSelectionCallback =
    void Function({required int rowIndex, required int colIndex});

enum TileStatus { single, stacked }

enum MoveResult { occupied, ongoing, matchEnded }

enum MatchStatus {
  waiting,
  playing,
  finished;

  static MatchStatus fromName(String name) {
    switch (name) {
      case 'playing':
        return playing;
      case 'finished':
        return finished;
      case 'waiting':
      default:
        return waiting;
    }
  }
}

enum CodeStatus { virgin, used }
