import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';
import 'board_ui_state.dart';

class BoardController extends ChangeNotifier {
  final TileSelectionCallback onTileSelected;
  final VoidCallback onRedDieEnd;
  late final BoardUiState state;
  bool _isDisposed = false;

  int get fullScore => state.fullScore;

  BoardController({required this.onTileSelected, required this.onRedDieEnd}) {
    state = _createInitialState(onTileSelected);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  BoardUiState _createInitialState(TileSelectionCallback onTileSelected) {
    List<List<TileUiState>> grid = List.generate(3, (rowIndex) {
      return List.generate(3, (colIndex) {
        return TileUiState(
          status: TileStatus.single,
          rowIndex: rowIndex,
          columnIndex: colIndex,
          onSelected: () =>
              onTileSelected(rowIndex: rowIndex, colIndex: colIndex),
        );
      });
    });
    return BoardUiState(tileStates: grid, scores: [0, 0, 0]);
  }

  TileUiState getTileState({required int rowIndex, required int colIndex}) {
    return state.tileStates[rowIndex][colIndex];
  }

  MoveResult placeDice({
    required int rowIndex,
    required int colIndex,
    required int diceValue,
  }) {
    final tileState = state.tileStates[rowIndex][colIndex];
    if (tileState.value != null) return MoveResult.occupied;

    tileState.value = diceValue;
    state.filledTiles += 1;
    _evaluateColumn(colIndex);

    notifyListeners();

    if (state.filledTiles == 9) return MoveResult.matchEnded;
    return MoveResult.ongoing;
  }

  int _calculateColumnScoreFromDie(List<int> die) {
    if (die.isEmpty) return 0;
    int columnScore = 0;
    final frequency = <int, int>{};
    for (var dice in die) {
      frequency[dice] = (frequency[dice] ?? 0) + 1;
    }
    frequency.forEach((dice, count) {
      columnScore += (dice * count) * count;
    });
    return columnScore;
  }

  int predictScoreAfterRedDie(int colIndex, int valueToDestroy) {
    int totalPredictedScore = 0;

    for (int i = 0; i < 3; i++) {
      if (i == colIndex) {
        final hypotheticalDie = <int>[];
        for (int r = 0; r < 3; r++) {
          final dice = state.tileStates[r][colIndex].value;
          if (dice != null && dice != valueToDestroy) {
            hypotheticalDie.add(dice);
          }
        }
        totalPredictedScore += _calculateColumnScoreFromDie(hypotheticalDie);
      } else {
        totalPredictedScore += state.scores[i];
      }
    }
    return totalPredictedScore;
  }

  void _evaluateColumn(int colIndex) {
    final tiles = state.tileStates;
    final valuesInColumn = <int>[];
    final Map<int, List<TileUiState>> families = {};

    for (int row = 0; row < 3; row++) {
      final tile = tiles[row][colIndex];
      final dice = tile.value;
      if (dice != null) {
        valuesInColumn.add(dice);
        if (families[dice] == null) families[dice] = [];
        families[dice]!.add(tile);
      }
    }

    families.forEach((dice, members) {
      final length = members.length;
      final status = length > 1 ? TileStatus.stacked : TileStatus.single;
      for (var tile in members) {
        tile.status = status;
      }
    });

    state.scores[colIndex] = _calculateColumnScoreFromDie(valuesInColumn);
  }

  Future<void> destroyDieWithValue({
    required int colIndex,
    required int valueToDestroy,
  }) async {
    final tiles = state.tileStates;
    final targets = <TileUiState>[];

    for (int r = 0; r < 3; r++) {
      final tile = tiles[r][colIndex];
      if (tile.value == valueToDestroy) targets.add(tile);
    }

    if (targets.isEmpty) {
      onRedDieEnd();
      return;
    }

    for (var tile in targets) {
      tile.isDestroying = true;
      state.filledTiles -= 1;
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1300));
    if (_isDisposed) return;

    for (var tile in targets) {
      tile.value = null;
      tile.isDestroying = false;
      tile.status = TileStatus.single;
    }

    _evaluateColumn(colIndex);
    notifyListeners();
  }
}
