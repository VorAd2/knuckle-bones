import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';

abstract class IConnectionHandler {
  Future<RoomEntity> connect({
    required UserEntity user,
    required String roomCode,
  });
}
