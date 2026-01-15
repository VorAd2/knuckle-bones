import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart'; // Importe a nova entidade
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  late final MatchUiState state;
  late final MatchPlayer localPlayer;
  late final MatchPlayer remotePlayer;
  Timer? _rollingTimer;
  bool _isDisposed = false;

  MatchController() {
    state = MatchUiState();
    _initializePlayers();
  }

  bool get isMyTurn => state.currentTurnPlayerId == localPlayer.id;
  MatchPlayer get currentPlayer => isMyTurn ? localPlayer : remotePlayer;

  @override
  void dispose() {
    _isDisposed = true;
    _rollingTimer?.cancel();
    localPlayer.dispose();
    remotePlayer.dispose();
    super.dispose();
  }

  void _initializePlayers() {
    localPlayer = MatchPlayer(
      id: 'p_local',
      name: 'Ada Lovelace',
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) =>
            _handleLocalInteraction(row: rowIndex, col: colIndex),
      ),
    );
    remotePlayer = MatchPlayer(
      id: 'p_remote',
      name: 'Alan Turing',
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) {},
      ),
    );
    state.currentTurnPlayerId = localPlayer.id;
  }

  void startMatch() => _nextTurn(isFirstTurn: true);

  void _toggleTurnPlayer() {
    state.currentTurnPlayerId = isMyTurn ? remotePlayer.id : localPlayer.id;
  }

  void _nextTurn({bool isFirstTurn = false}) {
    if (!isFirstTurn) _toggleTurnPlayer();
    state.isRolling = true;
    notifyListeners();
    _roll();
  }

  void _roll() {
    final nextDice = Random().nextInt(6) + 1;
    _rollingTimer?.cancel();
    _rollingTimer = Timer(const Duration(milliseconds: 2000), () {
      state.isRolling = false;
      _setPlayerOracleValue(nextDice);
      notifyListeners();

      if (!isMyTurn) {
        _simulateRemoteInteraction();
      }
    });
  }

  void _setPlayerOracleValue(int value) {
    currentPlayer.oracleValue = value;
  }

  Future<void> _handleLocalInteraction({
    required int row,
    required int col,
  }) async {
    if (!isMyTurn || state.isRolling || state.isDestroying || state.isEndGame) {
      return;
    }

    final diceValue = currentPlayer.oracleValue;
    final result = localPlayer.boardController.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: diceValue,
    );
    switch (result) {
      case .occupied:
        return;
      case .placed:
        state.isDestroying = true;
        await remotePlayer.boardController.destroyDieWithValue(
          colIndex: col,
          valueToDestroy: diceValue,
        );
        if (_isDisposed) return;
        state.isDestroying = false;
        _nextTurn();
        break;
      case .matchEnded:
        _triggerEndGame();
    }
  }

  Future<void> _simulateRemoteInteraction() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_isDisposed) return;
    final diceValue = currentPlayer.oracleValue;
    int col = Random().nextInt(3);
    int row = Random().nextInt(3);
    final result = remotePlayer.boardController.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: diceValue,
    );
    if (result == MoveResult.placed) {
      await localPlayer.boardController.destroyDieWithValue(
        colIndex: col,
        valueToDestroy: diceValue,
      );
      if (_isDisposed) return;
      _nextTurn();
    } else if (result == MoveResult.matchEnded) {
      _triggerEndGame();
    } else {
      // Maquina erra, tenta denovo
      _simulateRemoteInteraction();
    }
  }

  void _triggerEndGame() {
    state.isEndGame = true;
    notifyListeners();
  }
}
