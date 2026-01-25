import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/store/user_store.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  final _userStore = GetIt.I<UserStore>();
  final _repository = MatchRepository();
  final MatchUiState state = MatchUiState();
  final isAwaitingNotifier = ValueNotifier(true);
  final String roomCode;

  late final MatchPlayer localPlayer;
  MatchPlayer? remotePlayer;
  PlayerRole localPlayerRole;
  late final RoomEntity room;
  Timer? _rollingTimer;
  bool _isDisposed = false;

  MatchController(this.localPlayerRole, this.roomCode) {
    localPlayer = MatchPlayer(
      id: user.id,
      name: user.name,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) =>
            _handleLocalInteraction(row: rowIndex, col: colIndex),
      ),
    );
  }

  Future<void> init() async {
    try {
      if (localPlayerRole == .host) {
        await createRoom();
      } else {
        await joinRoom();
      }
    } catch (e) {
      debugPrint("Erro ao iniciar partida: $e");
      rethrow;
    }
  }

  UserEntity get user => _userStore.value!;
  String? get turnPlayerId => state.currentTurnPlayerId;
  bool get isMyTurn => turnPlayerId == localPlayer.id;
  MatchPlayer get turnPlayer => isMyTurn ? localPlayer : remotePlayer!;

  void _setLoading(bool value) {
    isAwaitingNotifier.value = value;
  }

  Future<void> createRoom() async {
    try {
      final myId = localPlayer.id;
      await _insertRoomCode();
      final roomId = await _repository.createRoom(myId, roomCode);

      room = RoomEntity(id: roomId, roomCode: roomCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _insertRoomCode() async {
    await _repository.insertCode(roomCode);
  }

  Future<void> joinRoom() async {
    try {
      final myId = user.id;
      final roomId = await _repository.joinRoom(roomCode, myId);

      room = RoomEntity(id: roomId, roomCode: roomCode, status: .playing);
    } catch (e) {
      throw Exception(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // void startMatch() {
  //   final newMatch = MatchEntity(
  //     id: 'match_123',
  //     hostId: localPlayer.id,
  //     guestId: remotePlayer.id,
  //     currentTurnPlayerId: localPlayer.id,
  //     status: MatchStatus.playing,
  //   );
  //   state.match = newMatch;
  //   state.isLoading = false;
  //   _nextTurn(isFirstTurn: true);
  // }
  ///////////////////////////////////////////////////////
  //////////////////////////////////////////////////////

  void _toggleTurnPlayer() {
    state.currentTurnPlayerId = isMyTurn ? remotePlayer!.id : localPlayer.id;
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
    turnPlayer.oracleValue = value;
  }

  Future<void> _handleLocalInteraction({
    required int row,
    required int col,
  }) async {
    if (!isMyTurn || state.isRolling || state.isDestroying || state.isEndGame) {
      return;
    }

    final diceValue = turnPlayer.oracleValue;
    final result = localPlayer.boardController.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: diceValue,
    );

    switch (result) {
      case .occupied:
        return;
      case .placed:
        await _triggerRedDie(col: col, diceValue: diceValue);
        _nextTurn();
        break;
      case .matchEnded:
        await _triggerRedDie(col: col, diceValue: diceValue);
        _triggerEndGame();
    }
  }

  Future<void> _triggerRedDie({
    required int col,
    required int diceValue,
  }) async {
    state.isDestroying = true;
    await remotePlayer!.boardController.destroyDieWithValue(
      colIndex: col,
      valueToDestroy: diceValue,
    );
    if (_isDisposed) return;
    state.isDestroying = false;
  }

  Future<void> _simulateRemoteInteraction() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_isDisposed) return;

    final diceValue = turnPlayer.oracleValue;
    int col = Random().nextInt(3);
    int row = Random().nextInt(3);
    final result = remotePlayer!.boardController.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: diceValue,
    );

    switch (result) {
      case .placed:
        await localPlayer.boardController.destroyDieWithValue(
          colIndex: col,
          valueToDestroy: diceValue,
        );
        if (_isDisposed) return;
        _nextTurn();
      case .matchEnded:
        await localPlayer.boardController.destroyDieWithValue(
          colIndex: col,
          valueToDestroy: diceValue,
        );
        if (_isDisposed) return;
        _triggerEndGame();
      case .occupied:
        //maquina erra, tenta denovo
        _simulateRemoteInteraction();
    }
  }

  void _triggerEndGame() {
    state.isEndGame = true;
    notifyListeners();
  }

  @override
  void dispose() {
    isAwaitingNotifier.dispose();
    _isDisposed = true;
    _rollingTimer?.cancel();
    localPlayer.dispose();
    remotePlayer?.dispose();
    super.dispose();
  }
}
