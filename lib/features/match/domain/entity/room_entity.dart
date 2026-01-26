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

  factory RoomEntity.fromMap(String roomId, Map<String, dynamic> data) {
    final hostBoard = BoardEntity.fromMap(
      Map<String, dynamic>.from(data['hostBoard']),
    );
    final guestBoard = data['guestBoard'] != null
        ? BoardEntity.fromMap(Map<String, dynamic>.from(data['guestBoard']))
        : null;
    final lastMove = data['lastMove'] != null
        ? LastMoveEntity.fromMap(Map<String, dynamic>.from(data['lastMove']))
        : null;
    return RoomEntity(
      id: roomId,
      status: MatchStatus.fromName(data['status']),
      code: data['code'] ?? '',
      hostBoard: hostBoard,
      guestBoard: guestBoard,
      lastMove: lastMove,
      turnPlayerId: data['turnPlayerId'],
    );
  }
}
