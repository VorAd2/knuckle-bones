import 'package:knuckle_bones/features/match/data/mappers.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player/match_player.dart';

abstract class IConnectionHandler {
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  });
}

class HostConnectionHandler implements IConnectionHandler {
  final MatchRepository repository;

  HostConnectionHandler(this.repository);

  @override
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  }) async {
    final roomId = await repository.createRoom(
      roomCode: roomCode,
      hostId: player.id,
      hostName: player.name,
    );
    await repository.insertCode(roomCode: roomCode, roomId: roomId);
    return RoomEntity(
      id: roomId,
      status: .waiting,
      code: roomCode,
      hostBoard: BoardEntity(
        playerId: player.id,
        playerName: player.name,
        omen: null,
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
  final MatchRepository repository;

  GuestConnectionHandler(this.repository);
  @override
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  }) async {
    final oldRoomData = await repository.joinRoom(
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
        omen: null,
        score: null,
      ),
      isOmen: false,
      lastMove: null,
      turnPlayerId: hostBoard.playerId,
    );
  }
}
