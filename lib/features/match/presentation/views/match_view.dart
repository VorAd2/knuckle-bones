import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/end_dialog/end_dialog.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/oracle/oracle.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/player_avatar/player_avatar.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});
  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late final MatchController _matchController = MatchController();
  bool _isQuitting = false;

  @override
  void initState() {
    super.initState();
    _matchController.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _matchController.startMatch();
    });
  }

  @override
  void dispose() {
    _matchController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_matchController.state.isEndGame) {
      if (!mounted) return;
      _showEndDialog();
    }
  }

  void _showEndDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Result',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (dialogContext, _, _) => Center(
        child: EndGameDialog(
          localPlayer: _matchController.localPlayer,
          remotePlayer: _matchController.remotePlayer,
          onBackHome: () {
            _isQuitting = true;
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
          onClose: () {
            Navigator.pop(dialogContext);
          },
        ),
      ),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        if (_isQuitting) return SizedBox.shrink();
        return Transform.scale(
          scale: Curves.elasticOut.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (context.mounted && _matchController.state.isEndGame) {
          Navigator.of(context).pop();
          return;
        }
        final bool shouldQuit = await MyDialog.show(
          context: context,
          titleString: 'Quit the match',
          contentString:
              'Sure you want to quit the match? The progress will be lost.',
        );
        if (context.mounted && shouldQuit) {
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
                  child: _PlayerSection(
                    forTop: true,
                    matchController: _matchController,
                    player: _matchController.remotePlayer,
                    showEndDialog: _showEndDialog,
                  ),
                ),
              ),
              const SizedBox(height: 42),
              const Divider(height: 2, thickness: 1),
              const SizedBox(height: 42),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _PlayerSection(
                    forTop: false,
                    matchController: _matchController,
                    player: _matchController.localPlayer,
                    showEndDialog: _showEndDialog,
                  ),
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
  final bool forTop;
  final MatchController matchController;
  final MatchPlayer player;

  final VoidCallback showEndDialog;

  const _PlayerSection({
    required this.forTop,
    required this.matchController,
    required this.player,
    required this.showEndDialog,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: matchController,
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          spacing: 18,
          children: [
            _Shrine(
              forTop: forTop,
              matchController: matchController,
              player: player,
              showEndDialog: showEndDialog,
            ),
            Expanded(
              child: Board(
                controller: player.boardController,
                isInteractive: !forTop,
                forTop: forTop,
              ),
            ),
          ],
        ),
      ),
      builder: (context, child) {
        final isTurn = matchController.state.currentTurnPlayerId == player.id;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isTurn ? 1.0 : 0.7,
          child: child,
        );
      },
    );
  }
}

class _Shrine extends StatelessWidget {
  final bool forTop;
  final MatchController matchController;
  final MatchPlayer player;

  final VoidCallback showEndDialog;

  const _Shrine({
    required this.forTop,
    required this.matchController,
    required this.player,
    required this.showEndDialog,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (forTop) ...[
            const PlayerAvatar(),
            const SizedBox(height: 4),
            Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9),
            ),
            const SizedBox(height: 36),
            Oracle(
              forTop: forTop,
              matchController: matchController,
              player: player,
            ),
          ] else ...[
            Oracle(
              forTop: forTop,
              matchController: matchController,
              player: player,
            ),
            const SizedBox(height: 36),
            const PlayerAvatar(),
            const SizedBox(height: 4),
            Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ],
      ),
    );
  }
}
