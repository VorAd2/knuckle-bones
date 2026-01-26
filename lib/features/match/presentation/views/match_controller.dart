import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/store/user_store.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/connection/connection_handlers.dart';
import 'package:knuckle_bones/features/match/domain/connection/i_connection_handler.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  final _userStore = GetIt.I<UserStore>();
  final _repository = GetIt.I<MatchRepository>();
  final MatchUiState state = MatchUiState();
  final isWaitingNotifier = ValueNotifier(true);
  final String roomCode;

  StreamSubscription? _matchSubscription;
  late final IConnectionHandler _connectionHandler;
  late final MatchPlayer localPlayer;
  MatchPlayer? remotePlayer;
  final PlayerRole localPlayerRole;
  late RoomEntity room;
  Timer? _rollingTimer;
  bool _isDisposed = false;

  MatchController({required this.localPlayerRole, required this.roomCode}) {
    _connectionHandler = localPlayerRole == .host
        ? HostConnectionHandler()
        : GuestConnectionHandler();
    localPlayer = MatchPlayer(
      id: user.id,
      name: user.name,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) =>
            _handleLocalInteraction(row: rowIndex, col: colIndex),
      ),
    );
  }

  UserEntity get user => _userStore.value!;
  String? get turnPlayerId => state.currentTurnPlayerId;
  bool get isMyTurn => turnPlayerId == localPlayer.id;
  MatchPlayer get turnPlayer => isMyTurn ? localPlayer : remotePlayer!;

  Future<void> init() async {
    try {
      room = await _connectionHandler.connect(user: user, roomCode: roomCode);
      if (localPlayerRole == .guest) {
        _setWaiting(false);
      }
      _listeningToMatch(room.id);
    } catch (e) {
      debugPrint("Erro ao iniciar partida: $e");
      rethrow;
    }
  }

  void _listeningToMatch(String roomId) {
    _matchSubscription = _repository
        .streamMatch(roomId)
        .listen(
          (updatedRoom) {
            _updateRoom(updatedRoom);
            if (updatedRoom.status == .waiting ||
                updatedRoom.lastMove?.playerId == user.id) {
              return;
            }
            if (localPlayerRole == .host && isWaitingNotifier.value) {
              _setWaiting(false);

              _toggleTurnPlayer();
              notifyListeners();

              // remotePlayer = MatchPlayer(
              //   id: updatedRoom.guestBoard!.playerId,
              //   name: updatedRoom.guestBoard!.playerName,
              //   boardController: BoardController(
              //     onTileSelected: ({required rowIndex, required colIndex}) {},
              //   ),
              // );
              //start match
            }
          },
          onError: (e) {
            print('XOXO Erro stream: $e');
          },
        );
  }

  ///////////////////////////////////////////////////////
  //////////////////////////////////////////////////////

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

  void _setWaiting(bool value) {
    isWaitingNotifier.value = value;
  }

  void _updateRoom(RoomEntity updatedRoom) {
    room = updatedRoom;
  }

  void _toggleTurnPlayer() {
    state.currentTurnPlayerId = isMyTurn ? remotePlayer!.id : localPlayer.id;
  }

  void _setPlayerOracleValue(int value) {
    turnPlayer.oracleValue = value;
  }

  void _triggerEndGame() {
    state.isEndGame = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _matchSubscription?.cancel();
    isWaitingNotifier.dispose();
    _isDisposed = true;
    _rollingTimer?.cancel();
    localPlayer.dispose();
    remotePlayer?.dispose();
    super.dispose();
  }
}
