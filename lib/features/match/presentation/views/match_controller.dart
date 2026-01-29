import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/store/user_store.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/connection/connection_handlers.dart';
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
  Timer? _rollingTimer;
  bool _isDisposed = false;

  bool hasStarted = false;
  final isWaitingNotifier = ValueNotifier(true);

  late final IConnectionHandler _connectionHandler;
  StreamSubscription? _matchSubscription;

  bool get isWaiting => isWaitingNotifier.value;
  String? get turnPlayerId => state.currentTurnPlayerId;
  bool get isMyTurn => turnPlayerId == localPlayer.id;
  bool get isRolling => state.isRolling;
  bool get isDestroying => state.isDestroying;
  bool get isEndGame => state.isEndGame;

  int get localFullScore => localPlayer.fullScore;
  int get remoteFullScore => remotePlayer!.fullScore;

  set turnPlayerId(String id) => state.currentTurnPlayerId = id;
  set isRolling(bool value) => state.isRolling = value;
  set isDestroying(bool value) => state.isDestroying = value;
  set isEndGame(bool value) => state.isEndGame = value;

  MatchController({
    required PlayerRole localPlayerRole,
    required this.roomCode,
  }) {
    UserEntity getUser() => _userStore.value!;
    state = MatchUiState(
      currentTurnPlayerId: localPlayerRole == .host ? getUser().id : null,
    );
    _connectionHandler = localPlayerRole == .host
        ? HostConnectionHandler()
        : GuestConnectionHandler();
    localPlayer = MatchPlayer(
      id: getUser().id,
      name: getUser().name,
      role: localPlayerRole,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) =>
            _handleLocalMove(row: rowIndex, col: colIndex),
      ),
    );
  }

  @override
  void dispose() {
    localPlayer.dispose();
    remotePlayer?.dispose();
    isWaitingNotifier.dispose();
    _rollingTimer?.cancel();
    _isDisposed = true;
    _matchSubscription?.cancel();
    super.dispose();
  }

  void _notifyWaiting(bool value) {
    isWaitingNotifier.value = value;
  }

  void _updateRoom(RoomEntity updatedRoom) {
    room = updatedRoom;
  }

  void _setRemotePlayer({
    required String id,
    required String name,
    required PlayerRole role,
  }) {
    remotePlayer = MatchPlayer(
      id: id,
      name: name,
      role: role,
      boardController: BoardController(
        onTileSelected: ({required rowIndex, required colIndex}) {},
      ),
    );
  }

  Future<void> asyncInit() async {
    try {
      switch (localPlayer.role) {
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

  Future<void> _connectAndSetRoom() async {
    room = await _connectionHandler.connect(
      player: localPlayer,
      roomCode: roomCode,
    );
  }

  Future<void> _hostInit() async {
    await _connectAndSetRoom();
    _listeningToMatch(room.id);
  }

  Future<void> _guestInit() async {
    void startLocally() {
      hasStarted = true;
      _notifyWaiting(false);
      _nextTurn(room);
    }

    await _connectAndSetRoom();
    _setRemotePlayer(id: room.hostId, name: room.hostName, role: .host);
    startLocally();
    _listeningToMatch(room.id);
  }

  void _listeningToMatch(String roomId) {
    bool blockMyEcho(RoomEntity updatedRoom) {
      if (updatedRoom.status == .waiting) return true;

      if (updatedRoom.isOmen) {
        if (updatedRoom.turnPlayerId == localPlayer.id) return true;
      } else {
        if (updatedRoom.lastMovePlayerId == localPlayer.id) return true;
      }

      return false;
    }

    bool triggerHostStarting(RoomEntity updatedRoom) {
      void startGlobally() {
        hasStarted = true;
        _notifyWaiting(false);
        _nextTurn(updatedRoom);
      }

      if (localPlayer.role == .host && isWaiting) {
        _setRemotePlayer(
          id: updatedRoom.guestId!,
          name: updatedRoom.guestName!,
          role: .guest,
        );
        startGlobally();
        return true;
      }

      return false;
    }

    Future<void> reactToEcho(RoomEntity updatedRoom) async {
      bool isTheFirstMove() {
        return updatedRoom.lastMove == null &&
            localPlayer.id != updatedRoom.turnPlayerId;
      }

      if (updatedRoom.isOmen) {
        _handleOmen(updatedRoom);
        return;
      } else {
        if (isTheFirstMove()) return;
        await _handleRemoteMove(updatedRoom);
        _nextTurn(updatedRoom);
      }
    }

    _matchSubscription = _repository
        .streamMatch(roomId)
        .listen(
          (updatedRoom) async {
            if (blockMyEcho(updatedRoom)) return;
            _updateRoom(updatedRoom);
            if (triggerHostStarting(updatedRoom)) return;
            await reactToEcho(updatedRoom);
          },
          onError: (e) {
            print('XOXO Erro stream: $e');
          },
        );
  }

  void _nextTurn(RoomEntity updatedRoom) {
    turnPlayerId = updatedRoom.turnPlayerId!;
    if (localPlayer.id == turnPlayerId) {
      _rollForLocal();
    } else {
      _rollForRemote();
    }
  }

  void _rollForLocal() {
    void startMatchVariable() => hasStarted = true;

    isRolling = true;
    notifyListeners();

    final omen = Random().nextInt(6) + 1;
    _rollingTimer?.cancel();
    _rollingTimer = Timer(const Duration(milliseconds: 2000), () async {
      if (_isDisposed) return;
      if (!hasStarted) startMatchVariable();

      isRolling = false;
      localPlayer.omen = omen;
      notifyListeners();

      await EchoController.echoOmen(
        room: room,
        role: localPlayer.role,
        omen: omen,
      );
    });
  }

  void _rollForRemote() {
    isRolling = true;
    notifyListeners();
  }

  void _handleOmen(RoomEntity updatedRoom) {
    final targetBoard = updatedRoom.turnPlayerId == updatedRoom.hostId
        ? updatedRoom.hostBoard
        : updatedRoom.guestBoard!;
    final omen = targetBoard.omen!;
    isRolling = false;
    remotePlayer!.omen = omen;
    notifyListeners();
  }

  Future<void> _handleLocalMove({required int row, required int col}) async {
    if (!hasStarted || !isMyTurn || isRolling || isDestroying || isEndGame) {
      return;
    }
    final diceValue = localPlayer.omen;
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
    isDestroying = true;
    await boardController.destroyDieWithValue(
      colIndex: col,
      valueToDestroy: diceValue,
    );
    if (_isDisposed) return;
    isDestroying = false;
  }

  Map<String, BoardEntity> _getNewBoards() {
    final oldBoards = {'host': room.hostBoard, 'guest': room.guestBoard};
    final newScores = {
      'host': localPlayer.role == .host ? localFullScore : remoteFullScore,
      'guest': localPlayer.role == .guest ? localFullScore : remoteFullScore,
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
}
