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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _PlayerSection(isTop: true),
                ),
              ),
              const SizedBox(height: 42),
              const Divider(height: 2, thickness: 1),
              const SizedBox(height: 42),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _PlayerSection(isTop: false),
                ),
              ),
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
      padding: const EdgeInsets.all(14),
      child: Row(
        spacing: 18,
        children: [
          _Shrine(isTop: isTop),
          Expanded(child: Board(isTop: isTop)),
        ],
      ),
    );
  }
}

class _Shrine extends StatelessWidget {
  final bool isTop;
  const _Shrine({required this.isTop});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTop) ...[
            const PlayerAvatar(),
            const SizedBox(height: 4),
            const Text('Ada Lovelace', style: TextStyle(fontSize: 8)),
            const SizedBox(height: 36),
            const _Oracle(),
          ] else ...[
            const _Oracle(),
            const SizedBox(height: 36),
            const PlayerAvatar(),
            const SizedBox(height: 4),
            const Text('Alan Turing', style: TextStyle(fontSize: 8)),
          ],
        ],
      ),
    );
  }
}

class _Oracle extends StatelessWidget {
  const _Oracle();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text("D6")),
    );
  }
}
