import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';

class MatchPlayer {
  final String id;
  final String name;
  int oracleValue = 1;
  final BoardController boardController;

  MatchPlayer({
    required this.id,
    required this.name,
    required this.boardController,
  });

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
