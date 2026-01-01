import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';

class BoardUiState {
  final List<List<TileUiState>> tileStates;
  List<int> scores;
  int filledTiles = 0;

  BoardUiState({required this.tileStates, required this.scores});
}
