import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';
import 'board_ui_state.dart';

class BoardController extends ChangeNotifier {
  final TileSelectionCallback onTileSelected;
  late final BoardUiState state;

  BoardController({required bool forTop, required this.onTileSelected}) {
    state = _createInitialState(forTop, onTileSelected);
  }

  BoardUiState _createInitialState(
    bool forTop,
    TileSelectionCallback onTileSelected,
  ) {
    List<List<TileUiState>> grid = List.generate(3, (rowIndex) {
      return List.generate(3, (colIndex) {
        return TileUiState(
          value: null,
          rowIndex: rowIndex,
          columnIndex: colIndex,
          onSelected: () =>
              onTileSelected(rowIndex: rowIndex, colIndex: colIndex),
        );
      });
    });
    return BoardUiState(forTop: forTop, tileStates: grid, scores: [0, 0, 0]);
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
    if (tileState.value != null) return MoveResult.notEmpty;
    tileState.value = diceValue;
    state.filledTiles += 1;
    state.scores = _calculateScores();
    notifyListeners();
    if (state.filledTiles == 9) {
      return MoveResult.endgame;
    }
    return MoveResult.success;
  }

  List<int> _calculateScores() {
    return List.generate(3, (col) {
      int score = 0;
      for (int row = 0; row < 3; row++) {
        final value = state.tileStates[row][col].value;
        score += value ?? 0;
      }
      return score;
    });
  }
}
