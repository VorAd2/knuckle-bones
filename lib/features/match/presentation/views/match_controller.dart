import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'dart:math';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  late final MatchUiState state;
  late final BoardController topBoardController;
  late final BoardController bottomBoardController;
  bool _isDisposed = false;

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

  void _handleInteraction({
    required bool isTopBoard,
    required int row,
    required int col,
  }) {
    if (state.isRolling) return;
    if (isTopBoard != state.isPlayerTopTurn) return;
    final activeBoard = isTopBoard ? topBoardController : bottomBoardController;
    final success = activeBoard.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: state.currentOracleValue,
    );
    if (success) _nextTurn();
  }

  void _nextTurn({bool isFirstTurn = false}) {
    if (!isFirstTurn) _togglePlayerTurn();
    state.isRolling = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (_isDisposed) return;
      final nextDice = Random().nextInt(6) + 1;
      state.isRolling = false;
      state.currentOracleValue = nextDice;
      notifyListeners();
    });
  }

  void _togglePlayerTurn() {
    state.isPlayerTopTurn = !state.isPlayerTopTurn;
  }

  void startMatch() => _nextTurn(isFirstTurn: true);

  @override
  void dispose() {
    _isDisposed = true;
    topBoardController.dispose();
    bottomBoardController.dispose();
    super.dispose();
  }
}
