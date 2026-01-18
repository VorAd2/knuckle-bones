import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/core/presentation/theme/app_theme.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile_ui_state.dart';
import 'package:knuckle_bones/features/match/types/match_types.dart';

class Tile extends StatelessWidget {
  final BoardController boardController;
  final TileUiState state;
  final bool isInteractive;

  const Tile({
    super.key,
    required this.boardController,
    required this.state,
    required this.isInteractive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final diceColors = Theme.of(context).extension<DiceColors>()!;
    return Material(
      color: cs.surfaceBright,
      borderRadius: BorderRadius.circular(12),
      elevation: 2.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isInteractive ? state.onSelected : null,
        child: Center(
          child: ListenableBuilder(
            listenable: boardController,
            builder: (context, _) {
              final value = state.value;
              return AnimatedScale(
                duration: const Duration(
                  milliseconds: 1200,
                ), // Um pouco menor que o await do controller
                curve: Curves.easeInOut,
                scale: state.isDestroying ? 0.0 : 1.0,
                child: value == null
                    ? const SizedBox.shrink()
                    : _getIconForValue(
                        val: value,
                        color: state.isDestroying
                            ? diceColors.redDice!
                            : _getColor(cs: cs, status: state.status),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getColor({required ColorScheme cs, required TileStatus status}) {
    switch (status) {
      case TileStatus.single:
        return cs.onSurfaceVariant;
      case TileStatus.stacked:
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
