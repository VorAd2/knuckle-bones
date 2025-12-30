import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/player_avatar.dart';

class MatchView extends StatelessWidget {
  const MatchView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final bool shouldQuit = await MyDialog.show(
          context: context,
          titleString: 'Quit the match',
          contentString:
              'Sure you want to quit the match? The progress will be lost.',
        );
        if (shouldQuit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _PlayerSection(isTop: true)),
              const Divider(height: 2, thickness: 2),
              Expanded(child: _PlayerSection(isTop: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerSection extends StatelessWidget {
  final bool isTop;
  const _PlayerSection({required this.isTop});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isTop) ...[
                  const PlayerAvatar(),
                  const SizedBox(height: 16),
                  const _Oracle(), //rolagem do dado
                ] else ...[
                  const _Oracle(), //rolagem do dado
                  const SizedBox(height: 16),
                  const PlayerAvatar(),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: const Board()),
        ],
      ),
    );
  }
}

class _Oracle extends StatelessWidget {
  const _Oracle();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text("D6")),
    );
  }
}
