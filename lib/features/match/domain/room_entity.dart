import 'package:knuckle_bones/features/match/types/match_types.dart';

class RoomEntity {
  final String id;
  final String roomCode;
  MatchStatus status;

  RoomEntity({
    required this.id,
    required this.roomCode,
    this.status = MatchStatus.waiting,
  });
}
