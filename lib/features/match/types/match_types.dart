typedef TileSelectionCallback =
    void Function({required int rowIndex, required int colIndex});

enum TileStatus { single, stacked }

enum MoveResult { occupied, placed, matchEnded }

enum MatchStatus { waiting, playing, finished }

enum CodeStatus { virgin, used }
