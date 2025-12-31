import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/core/presentation/theme/app_theme.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';

class Tile extends StatelessWidget {
  final BoardController boardController;
  final TileUiState Function() getState;

  const Tile({
    super.key,
    required this.boardController,
    required this.getState,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final diceColors = Theme.of(context).extension<DiceColors>();
    return Material(
      color: cs.surfaceBright,
      borderRadius: BorderRadius.circular(12),
      elevation: 2.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: getState().onSelected,
        child: Center(
          child: ListenableBuilder(
            listenable: boardController,
            builder: (context, _) {
              final value = getState().value;
              return value == null
                  ? SizedBox.shrink()
                  : _getIconForValue(
                      val: value,
                      color: _getColor(cs: cs, role: getState().role),
                    );
            },
          ),
        ),
      ),
    );
  }

  Color _getColor({required ColorScheme cs, required TileRole role}) {
    switch (role) {
      case TileRole.alone:
        return cs.onSurfaceVariant;
      case TileRole.paired:
        return cs.tertiary;
    }
  }

  Widget _getIconForValue({required int val, required Color color}) {
    if (val < 1 || val > 6) {
      return Icon(Icons.error, size: 40, color: Colors.red);
    }
    return AppIcons.dice(face: val, color: color);
  }
}
