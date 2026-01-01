import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';
import 'board_ui_state.dart';

class BoardController extends ChangeNotifier {
  final TileSelectionCallback onTileSelected;
  late final BoardUiState state;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  BoardController({required this.onTileSelected}) {
    state = _createInitialState(onTileSelected);
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

    return MoveResult.placed;
  }

  Future<bool> destroyDieWithValue({
    required int colIndex,
    required int valueToDestroy,
  }) async {
    final tiles = state.tileStates;
    final targets = <TileUiState>[];

    for (int r = 0; r < 3; r++) {
      final tile = tiles[r][colIndex];
      if (tile.value == valueToDestroy) targets.add(tile);
    }

    if (targets.isEmpty) return false;

    // Fase 1: Animação
    for (var tile in targets) {
      tile.isDestroying = true;
      state.filledTiles -= 1;
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1100));
    if (_isDisposed) return false;

    // Fase 2: Limpeza
    for (var tile in targets) {
      tile.value = null;
      tile.isDestroying = false;
      tile.status = TileStatus.single;
    }
    _evaluateColumn(colIndex);
    notifyListeners();
    return true;
  }

  void _evaluateColumn(int colIndex) {
    final tiles = state.tileStates;
    final Map<int, List<TileUiState>> valueGroups = {};
    int newColScore = 0;

    for (int row = 0; row < 3; row++) {
      final tile = tiles[row][colIndex];
      final val = tile.value;
      if (val != null) {
        newColScore += val;
        if (valueGroups[val] == null) valueGroups[val] = [];
        valueGroups[val]!.add(tile);
      }
    }

    valueGroups.forEach((val, list) {
      final status = list.length > 1 ? TileStatus.stacked : TileStatus.single;
      for (var tile in list) {
        tile.status = status;
      }
    });

    state.scores[colIndex] = newColScore;
  }
}
