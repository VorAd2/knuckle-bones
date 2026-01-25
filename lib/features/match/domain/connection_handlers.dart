import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/i_connection_handler.dart';
import 'package:knuckle_bones/features/match/domain/room_entity.dart';

final _repository = GetIt.I<MatchRepository>();

class HostConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required UserEntity user,
    required String roomCode,
  }) async {
    await _repository.insertCode(roomCode);
    final roomId = await _repository.createRoom(
      hostId: user.id,
      roomCode: roomCode,
    );
    return RoomEntity(id: roomId, roomCode: roomCode);
  }
}

class GuestConnectionHandler implements IConnectionHandler {
  @override
  Future<RoomEntity> connect({
    required UserEntity user,
    required String roomCode,
  }) async {
    final roomId = await _repository.joinRoom(
      roomCode: roomCode,
      guestId: user.id,
    );
    return RoomEntity(id: roomId, roomCode: roomCode, status: .playing);
  }
}
