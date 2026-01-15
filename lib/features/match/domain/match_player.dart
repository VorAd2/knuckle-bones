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

  void dispose() {
    boardController.dispose();
  }
}
