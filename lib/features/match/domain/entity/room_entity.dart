import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/last_move_entity.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class RoomEntity {
  final String id;
  final String code;
  MatchStatus status;
  final BoardEntity hostBoard;
  final BoardEntity? guestBoard;
  final LastMoveEntity? lastMove;
  final String? turnPlayerId;

  RoomEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.hostBoard,
    required this.guestBoard,
    required this.lastMove,
    required this.turnPlayerId,
  });
}
