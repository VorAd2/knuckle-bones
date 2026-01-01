import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/oracle/oracle.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/player_avatar/player_avatar.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});
  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late final MatchController _controller = MatchController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.startMatch();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_controller.state.isEndGame) {
      if (!mounted) return;
      MyDialog.alert(
        context: context,
        titleString: 'End Game',
        contentString: 'We have a winner',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_controller.state.isEndGame && context.mounted) {
          Navigator.of(context).pop();
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _PlayerSection(
                    forTop: true,
                    matchController: _controller,
                    player: _controller.remotePlayer,
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
                    matchController: _controller,
                    player: _controller.localPlayer,
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

  const _PlayerSection({
    required this.forTop,
    required this.matchController,
    required this.player,
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
            ),
            Expanded(
              child: Board(controller: player.boardController, forTop: forTop),
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

  const _Shrine({
    required this.forTop,
    required this.matchController,
    required this.player,
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
            Text(player.name, style: TextStyle(fontSize: 9)),
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
            Text(player.name, style: TextStyle(fontSize: 9)),
          ],
        ],
      ),
    );
  }
}
