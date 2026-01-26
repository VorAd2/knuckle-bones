import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/features/match/data/mappers.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/connection/i_connection_handler.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';

final _repository = GetIt.I<MatchRepository>();

class HostConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required UserEntity user,
    required String roomCode,
  }) async {
    final roomId = await _repository.createRoom(
      roomCode: roomCode,
      hostId: user.id,
      hostName: user.name,
    );
    await _repository.insertCode(roomCode: roomCode, roomId: roomId);
    return RoomEntity(
      id: roomId,
      status: .waiting,
      code: roomCode,
      hostBoard: BoardEntity(
        playerId: user.id,
        playerName: user.name,
        oracle: null,
        score: null,
      ),
      guestBoard: null,
      lastMove: null,
      turnPlayerId: null,
    );
  }
}

class GuestConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required UserEntity user,
    required String roomCode,
  }) async {
    final oldRoomData = await _repository.joinRoom(
      roomCode: roomCode,
      guestId: user.id,
      guestName: user.name,
    );
    final hostBoard = (oldRoomData['hostBoard'] as Map<String, dynamic>)
        .toBoardEntity();
    return RoomEntity(
      status: .playing,
      id: oldRoomData['id'],
      code: roomCode,
      hostBoard: hostBoard,
      guestBoard: BoardEntity(
        playerId: user.id,
        playerName: user.name,
        oracle: null,
        score: null,
      ),
      lastMove: null,
      turnPlayerId: hostBoard.playerId,
    );
  }
}
