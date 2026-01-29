import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';

class EchoController {
  static final _repository = GetIt.I<MatchRepository>();

  static Future<void> echoOmen({
    required RoomEntity room,
    required PlayerRole role,
    required int omen,
  }) async {
    await _repository.echoOmen(room: room, role: role, omen: omen);
  }

  static Future<void> echoMove({required RoomEntity room}) async {
    await _repository.echoMove(room: room);
  }
}
