import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/features/match/data/mappers.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/connection/i_connection_handler.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player/match_player.dart';

final _repository = GetIt.I<MatchRepository>();

class HostConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  }) async {
    final roomId = await _repository.createRoom(
      roomCode: roomCode,
      hostId: player.id,
      hostName: player.name,
    );
    await _repository.insertCode(roomCode: roomCode, roomId: roomId);
    return RoomEntity(
      id: roomId,
      status: .waiting,
      code: roomCode,
      hostBoard: BoardEntity(
        playerId: player.id,
        playerName: player.name,
        oracle: null,
        score: null,
      ),
      guestBoard: null,
      isOmen: false,
      lastMove: null,
      turnPlayerId: player.id,
    );
  }
}

class GuestConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  }) async {
    final oldRoomData = await _repository.joinRoom(
      roomCode: roomCode,
      guestId: player.id,
      guestName: player.name,
    );
    final hostBoard = (oldRoomData['hostBoard'] as Map<String, dynamic>)
        .toBoardEntity();
    return RoomEntity(
      status: .playing,
      id: oldRoomData['id'],
      code: roomCode,
      hostBoard: hostBoard,
      guestBoard: BoardEntity(
        playerId: player.id,
        playerName: player.name,
        oracle: null,
        score: null,
      ),
      isOmen: false,
      lastMove: null,
      turnPlayerId: hostBoard.playerId,
    );
  }
}
