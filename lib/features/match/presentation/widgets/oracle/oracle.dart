import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/oracle/fast_spinner.dart';

class Oracle extends StatelessWidget {
  final bool forTop;
  final MatchController matchController;

  const Oracle({
    super.key,
    required this.forTop,
    required this.matchController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: matchController,
      builder: (context, _) {
        final isMyTurn = forTop == matchController.state.isPlayerTopTurn;
        final borderColor = isMyTurn ? cs.tertiary : cs.outlineVariant;
        return Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            border: Border.all(color: borderColor, width: isMyTurn ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: matchController.state.isRolling && isMyTurn
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: FastSpinner(color: cs.primary),
                  )
                : AppIcons.dice(
                    face: matchController.state.currentOracleValue,
                    size: 42,
                    color: cs.onSurfaceVariant,
                  ),
          ),
        );
      },
    );
  }
}
