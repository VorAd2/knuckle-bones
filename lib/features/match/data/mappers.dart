import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/last_move_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

extension BoardSerialization on BoardEntity {
  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'oracle': oracle,
      'score': score,
    };
  }
}

extension RoomDeserialization on Map<String, dynamic> {
  RoomEntity toRoomEntity(String roomId) {
    final hostBoard = (this['hostBoard'] as Map<String, dynamic>)
        .toBoardEntity();
    final guestBoard = this['guestBoard'] != null
        ? (this['guestBoard'] as Map<String, dynamic>).toBoardEntity()
        : null;
    final lastMove = this['lastMove'] != null
        ? (this['lastMove'] as Map<String, dynamic>).toLastMoveEntity()
        : null;
    return RoomEntity(
      id: roomId,
      code: this['code'] ?? '',
      status: MatchStatus.fromName(this['status']),
      hostBoard: hostBoard,
      guestBoard: guestBoard,
      lastMove: lastMove,
      turnPlayerId: this['turnPlayerId'],
    );
  }
}

extension BoardDeserialization on Map<String, dynamic> {
  BoardEntity toBoardEntity() {
    return BoardEntity(
      playerId: this['playerId'],
      playerName: this['playerName'],
      oracle: this['oracle'],
      score: this['score'],
    );
  }
}

extension LastMoveDeserialization on Map<String, dynamic> {
  LastMoveEntity toLastMoveEntity() {
    return LastMoveEntity(
      row: this['row'],
      col: this['col'],
      dice: this['dice'],
      playerId: this['playerId'],
    );
  }
}
