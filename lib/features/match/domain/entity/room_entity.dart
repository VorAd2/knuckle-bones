import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/last_move_entity.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class RoomEntity {
  final String id;
  final String code;
  MatchStatus status;
  final BoardEntity hostBoard;
  final BoardEntity? guestBoard;
  final bool isOmen;
  final LastMoveEntity? lastMove;
  final String? turnPlayerId;

  RoomEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.hostBoard,
    required this.guestBoard,
    required this.isOmen,
    required this.lastMove,
    required this.turnPlayerId,
  });

  RoomEntity copyWith({
    String? id,
    String? code,
    MatchStatus? status,
    BoardEntity? hostBoard,
    BoardEntity? guestBoard,
    bool? isOmen,
    LastMoveEntity? lastMove,
    String? turnPlayerId,
  }) {
    return RoomEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      hostBoard: hostBoard ?? this.hostBoard,
      guestBoard: guestBoard ?? this.guestBoard,
      isOmen: isOmen ?? this.isOmen,
      lastMove: lastMove ?? this.lastMove,
      turnPlayerId: turnPlayerId ?? this.turnPlayerId,
    );
  }

  @override
  String toString() {
    return '''
RoomEntity(
  id: $id,
  code: $code,
  status: $status,
  turnPlayerId: $turnPlayerId,
  hostBoard: ${hostBoard.playerName},
  guestBoard: ${guestBoard?.playerName},
  isOmen: $isOmen
  lastMove: ${lastMove ?? 'null'},
)
''';
  }
}
