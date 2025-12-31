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
                  : _getIconForValue(val: value, cs: cs, dc: diceColors!);
            },
          ),
        ),
      ),
    );
  }

  Widget _getIconForValue({
    required int val,
    required ColorScheme cs,
    required DiceColors dc,
  }) {
    switch (val) {
      case 1:
        return AppIcons.dice(face: 1, color: cs.onSurfaceVariant);
      case 2:
        return AppIcons.dice(face: 2, color: cs.tertiary);
      case 3:
        return AppIcons.dice(face: 3, color: cs.onSurfaceVariant);
      case 4:
        return AppIcons.dice(face: 4, color: dc.redDice);
      case 5:
        return AppIcons.dice(face: 5, color: cs.onSurfaceVariant);
      case 6:
        return AppIcons.dice(face: 6, color: cs.tertiary);
      default:
        return Icon(Icons.error, size: 40, color: Colors.red);
    }
  }
}
