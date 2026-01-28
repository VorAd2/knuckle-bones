import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/domain/match_player/match_player.dart';

abstract class IConnectionHandler {
  Future<RoomEntity> connect({
    required MatchPlayer player,
    required String roomCode,
  });
}
