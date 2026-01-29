import 'package:knuckle_bones/features/match/domain/entity/board_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/last_move_entity.dart';
import 'package:knuckle_bones/features/match/domain/entity/room_entity.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

extension RoomSerialization on RoomEntity {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'status': status.name,
      'hostBoard': hostBoard.toMap(),
      'guestBoard': guestBoard!.toMap(),
      'isOmen': isOmen,
      'lastMove': lastMove!.toMap(),
      'turnPlayerId': turnPlayerId,
    };
  }
}

extension BoardSerialization on BoardEntity {
  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'omen': omen,
      'score': score,
    };
  }
}

extension LastMoveSerialization on LastMoveEntity {
  Map<String, dynamic> toMap() {
    return {'row': row, 'col': col, 'dice': dice, 'playerId': playerId};
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
      isOmen: this['isOmen'],
      turnPlayerId: this['turnPlayerId'],
    );
  }
}

extension BoardDeserialization on Map<String, dynamic> {
  BoardEntity toBoardEntity() {
    return BoardEntity(
      playerId: this['playerId'],
      playerName: this['playerName'],
      omen: this['omen'],
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
