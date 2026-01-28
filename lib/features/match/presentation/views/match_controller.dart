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
import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/last_move_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/views/echo_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'match_ui_state.dart';

class MatchController extends ChangeNotifier {
  late final MatchUiState state;
  final _userStore = GetIt.I<UserStore>();
  final _repository = GetIt.I<MatchRepository>();

  late RoomEntity room;
  final String roomCode;
  late final MatchPlayer localPlayer;
  MatchPlayer? remotePlayer;
  final PlayerRole localPlayerRole;

  late final IConnectionHandler _connectionHandler;
  StreamSubscription? _matchSubscription;

  Timer? _rollingTimer;
  bool _isDisposed = false;

  final isWaitingNotifier = ValueNotifier(true);

  MatchController({required this.localPlayerRole, required this.roomCode}) {
    state = MatchUiState(
      currentTurnPlayerId: localPlayerRole == .host ? user.id : null,
    );
    _connectionHandler = localPlayerRole == .host
        ? HostConnectionHandler()
        : GuestConnectionHandler();
    localPlayer = MatchPlayer(
      id: user.id,
      name: user.name,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) =>
            _handleLocalMove(row: rowIndex, col: colIndex),
      ),
    );
  }

  bool hasStarted = false;
  bool get isWaiting => isWaitingNotifier.value;
  bool get isEndGame => state.isEndGame;
  bool get isRolling => state.isRolling;
  String? get turnPlayerId => state.currentTurnPlayerId;
  bool get isMyTurn => turnPlayerId == localPlayer.id;
  UserEntity get user => _userStore.value!;

  int get localFullScore => localPlayer.boardController.fullScore;
  int get remoteFullScore => remotePlayer!.boardController.fullScore;

  Future<void> asyncInit() async {
    try {
      switch (localPlayerRole) {
        case .host:
          await _hostInit();
          break;
        case .guest:
          await _guestInit();
      }
    } catch (e) {
      debugPrint("Erro ao iniciar partida: $e");
      rethrow;
    }
  }

  void _notifyWaiting(bool value) {
    isWaitingNotifier.value = value;
  }

  void _updateRoom(RoomEntity updatedRoom) {
    room = updatedRoom;
  }

  Future<void> _hostInit() async {
    room = await _connectionHandler.connect(user: user, roomCode: roomCode);
    _listeningToMatch(room.id);
  }

  Future<void> _guestInit() async {
    room = await _connectionHandler.connect(user: user, roomCode: roomCode);

    remotePlayer = MatchPlayer(
      id: room.hostBoard.playerId,
      name: room.hostBoard.playerName,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) {},
      ),
    );

    hasStarted = true;
    _notifyWaiting(false);
    _nextTurn(room);

    _listeningToMatch(room.id);
  }

  void _listeningToMatch(String roomId) {
    _matchSubscription = _repository
        .streamMatch(roomId)
        .listen(
          (updatedRoom) async {
            if (updatedRoom.status == .waiting) return;

            if (updatedRoom.isOmen) {
              if (updatedRoom.turnPlayerId == localPlayer.id) return;
            } else {
              if (updatedRoom.lastMove?.playerId == localPlayer.id) return;
            }

            _updateRoom(updatedRoom);

            if (localPlayerRole == .host && isWaiting) {
              remotePlayer = MatchPlayer(
                id: updatedRoom.guestBoard!.playerId,
                name: updatedRoom.guestBoard!.playerName,
                boardController: BoardController(
                  onTileSelected: ({required rowIndex, required colIndex}) {},
                ),
              );
              hasStarted = true;
              _notifyWaiting(false);
              _nextTurn(updatedRoom);
              return;
            }

            if (updatedRoom.isOmen) {
              _handleOmen(updatedRoom);
              return;
            } else {
              if (updatedRoom.lastMove == null &&
                  localPlayer.id != updatedRoom.turnPlayerId) {
                return;
              }
              await _handleRemoteMove(updatedRoom);
              _nextTurn(updatedRoom);
            }
          },
          onError: (e) {
            print('XOXO Erro stream: $e');
          },
        );
  }

  ///////////////////////////////////////////////////////
  //////////////////////////////////////////////////////

  void _nextTurn(RoomEntity updatedRoom) {
    state.currentTurnPlayerId = updatedRoom.turnPlayerId;
    if (localPlayer.id == turnPlayerId) {
      _rollForLocal();
    } else {
      _rollForRemote();
    }
  }

  void _rollForLocal() {
    void startMatchVariable() => hasStarted = true;

    state.isRolling = true;
    notifyListeners();

    final oracle = Random().nextInt(6) + 1;
    _rollingTimer?.cancel();
    _rollingTimer = Timer(const Duration(milliseconds: 2000), () async {
      if (!hasStarted) startMatchVariable();

      state.isRolling = false;
      localPlayer.oracleValue = oracle;
      notifyListeners();

      await EchoController.echoOracle(
        room: room,
        role: localPlayerRole,
        oracle: oracle,
      );
    });
  }

  void _rollForRemote() {
    state.isRolling = true;
    notifyListeners();
  }

  void _handleOmen(RoomEntity updatedRoom) {
    final targetBoard =
        updatedRoom.turnPlayerId == updatedRoom.hostBoard.playerId
        ? updatedRoom.hostBoard
        : updatedRoom.guestBoard!;
    final oracle = targetBoard.oracle!;
    state.isRolling = false;
    remotePlayer!.oracleValue = oracle;
    notifyListeners();
  }

  Future<void> _handleLocalMove({required int row, required int col}) async {
    if (!hasStarted ||
        !isMyTurn ||
        state.isRolling ||
        state.isDestroying ||
        state.isEndGame) {
      return;
    }
    final diceValue = localPlayer.oracleValue;
    final result = localPlayer.boardController.placeDice(
      rowIndex: row,
      colIndex: col,
      diceValue: diceValue,
    );
    switch (result) {
      case .occupied:
        return;
      case .placed:
        await _triggerRedDie(
          col: col,
          diceValue: diceValue,
          boardController: remotePlayer!.boardController,
        );

        final newBoards = _getNewBoards();
        room = room.copyWith(
          isOmen: false,
          hostBoard: newBoards['host'],
          guestBoard: newBoards['guest'],
          lastMove: LastMoveEntity(
            col: col,
            row: row,
            dice: diceValue,
            playerId: localPlayer.id,
          ),
          turnPlayerId: remotePlayer!.id,
        );

        _nextTurn(room);

        try {
          await EchoController.echoMove(
            room: room,
            row: row,
            col: col,
            dice: diceValue,
            triggerPlayerId: localPlayer.id,
            opponnentPlayerId: remotePlayer!.id,
          );
        } catch (e) {
          // _revertTurn();
          print("Erro ao sincronizar: $e");
        }
        break;
      case .matchEnded:
      //
    }
  }

  Future<void> _handleRemoteMove(RoomEntity updatedRoom) async {
    final lastMove = updatedRoom.lastMove!;
    final diceValue = lastMove.dice;
    final result = remotePlayer!.boardController.placeDice(
      rowIndex: lastMove.row,
      colIndex: lastMove.col,
      diceValue: diceValue,
    );
    switch (result) {
      case .occupied:
        return;
      case .placed:
        await _triggerRedDie(
          col: lastMove.col,
          diceValue: diceValue,
          boardController: localPlayer.boardController,
        );
        room = updatedRoom;
        _nextTurn(room);
        break;
      case .matchEnded:
      //
    }
  }

  Future<void> _triggerRedDie({
    required int col,
    required int diceValue,
    required BoardController boardController,
  }) async {
    state.isDestroying = true;
    await boardController.destroyDieWithValue(
      colIndex: col,
      valueToDestroy: diceValue,
    );
    if (_isDisposed) return;
    state.isDestroying = false;
  }

  Map<String, BoardEntity> _getNewBoards() {
    final oldBoards = {'host': room.hostBoard, 'guest': room.guestBoard};
    final newScores = {
      'host': localPlayerRole == .host ? localFullScore : remoteFullScore,
      'guest': localPlayerRole == .guest ? localFullScore : remoteFullScore,
    };

    final newHostBoard = oldBoards['host']!.copyWith(score: newScores['host']);
    final newGuestBoard = oldBoards['guest']!.copyWith(
      score: newScores['guest'],
    );

    return {'host': newHostBoard, 'guest': newGuestBoard};
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
