import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';
import 'dart:math';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  late final MatchUiState state;
  late final BoardController topBoardController;
  late final BoardController bottomBoardController;
  Timer? _rollingTimer;

  MatchController() {
    state = MatchUiState();
    topBoardController = BoardController(
      forTop: true,
      onTileSelected: ({required rowIndex, required colIndex}) =>
          _handleInteraction(isTopBoard: true, row: rowIndex, col: colIndex),
    );
    bottomBoardController = BoardController(
      forTop: false,
      onTileSelected: ({required rowIndex, required colIndex}) =>
          _handleInteraction(isTopBoard: false, row: rowIndex, col: colIndex),
    );
  }

  @override
  void dispose() {
    _rollingTimer?.cancel();
    topBoardController.dispose();
    bottomBoardController.dispose();
    super.dispose();
  }

  void startMatch() => _nextTurn(isFirstTurn: true);

  void _nextTurn({bool isFirstTurn = false}) {
    if (!isFirstTurn) _toggleTurn();
    state.isRolling = true;
    notifyListeners();
    _rollingTimer?.cancel();
    _rollingTimer = Timer(const Duration(milliseconds: 4000), () {
      final nextDice = Random().nextInt(6) + 1;
      state.isRolling = false;
      state.currentOracleValue = nextDice;
      notifyListeners();
    });
  }

  void _toggleTurn() {
    state.isPlayerTopTurn = !state.isPlayerTopTurn;
  }

  void _handleInteraction({
    required bool isTopBoard,
    required int row,
    required int col,
  }) async {
    if (!_allowInteraction(isTopBoard)) return;
    final result = _triggerMove(isTopBoard: isTopBoard, row: row, col: col);
    switch (result) {
      case MoveResult.occupied:
        break;
      case MoveResult.placed:
        final targetBoard = isTopBoard
            ? bottomBoardController
            : topBoardController;
        final diceValue = state.currentOracleValue;
        await targetBoard.destroyDieWithValue(
          colIndex: col,
          valueToDestroy: diceValue,
        );
        _nextTurn();
        break;
      case MoveResult.matchEnded:
        state.isEndGame = true;
        notifyListeners();
        break;
    }
  }

  bool _allowInteraction(bool isTopBoard) {
    if ((state.isRolling) ||
        (isTopBoard != state.isPlayerTopTurn) ||
        (state.isEndGame)) {
      return false;
    }
    return true;
  }

  MoveResult _triggerMove({
    required bool isTopBoard,
    required int row,
    required int col,
  }) {
    final activeBoard = isTopBoard ? topBoardController : bottomBoardController;
    final result = activeBoard.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: state.currentOracleValue,
    );
    return result;
  }
}
