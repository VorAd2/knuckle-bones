import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';

class MatchView extends StatelessWidget {
  const MatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
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
              Expanded(child: _buildPlayerArea(isTop: true, context: context)),
              const Divider(height: 2, thickness: 2),
              Expanded(child: _buildPlayerArea(isTop: false, context: context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerArea({
    required bool isTop,
    required BuildContext context,
  }) {
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
                  _buildAvatarPlaceholder(),
                  const SizedBox(height: 16),
                  _buildDicePlaceholder(),
                ] else ...[
                  _buildDicePlaceholder(),
                  const SizedBox(height: 16),
                  _buildAvatarPlaceholder(),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: _buildBoardPlaceholder()),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return const CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey,
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildDicePlaceholder() {
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

  Widget _buildBoardPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: const Center(child: Text("Tabuleiro 3x3")),
    );
  }
}
