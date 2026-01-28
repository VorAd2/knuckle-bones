import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';

class MatchPlayer {
  final String id;
  final String name;
  int oracleValue = 1;
  final PlayerRole role;
  final BoardController boardController;

  MatchPlayer({
    required this.id,
    required this.name,
    required this.role,
    required this.boardController,
  });

  int get fullScore => boardController.fullScore;

  @override
  String toString() {
    return '''
MatchPlayer(
  id: $id,
  name: $name,
  oracleValue: $oracleValue,
  boardController: ${boardController.runtimeType},
)
''';
  }

  void dispose() {
    boardController.dispose();
  }
}
