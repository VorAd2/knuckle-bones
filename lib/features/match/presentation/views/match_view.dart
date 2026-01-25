import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/domain/player_role.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/end_game_dialog/end_game_dialog.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/loading_veil/loading_veil.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/shrine/shrine.dart';

class MatchView extends StatefulWidget {
  final PlayerRole localPlayerRole;
  final String roomCode;
  const MatchView({
    super.key,
    required this.localPlayerRole,
    required this.roomCode,
  });
  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late final MatchController _matchController;
  bool _isQuitting = false;

  @override
  void initState() {
    super.initState();
    _matchController = MatchController(
      localPlayerRole: widget.localPlayerRole,
      roomCode: widget.roomCode,
    );
    _matchController.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _matchController.init();
      } catch (e) {
        if (!mounted) return;
        await MyDialog.alert(
          context: context,
          titleString: "Erro",
          contentString: "Não foi possível entrar na sala.",
        );
        if (!mounted) return;
        Navigator.pop(context);
      }
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
          remotePlayer: _matchController.remotePlayer!,
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
    return ValueListenableBuilder(
      valueListenable: _matchController.isAwaitingNotifier,
      builder: (_, isAwaiting, child) {
        return Stack(
          children: [
            child!,
            if (isAwaiting) LoadingVeil(roomCode: _matchController.roomCode),
          ],
        );
      },
      child: _MatchScaffold(_matchController),
    );
  }
}

class _MatchScaffold extends StatelessWidget {
  final MatchController matchController;
  const _MatchScaffold(this.matchController);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (context.mounted && matchController.state.isEndGame) {
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
                    matchController: matchController,
                    player: matchController.remotePlayer,
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
                    matchController: matchController,
                    player: matchController.localPlayer,
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
  final MatchPlayer? player;

  const _PlayerSection({
    required this.forTop,
    required this.matchController,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: matchController,
      builder: (context, child) {
        final isTurn = matchController.state.currentTurnPlayerId == player?.id;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isTurn ? 1.0 : 0.7,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Row(
          spacing: 18,
          children: [
            if (player == null) ...[
              ShrineMock(),
              Expanded(child: BoardMock()),
            ] else ...[
              Shrine(
                forTop: forTop,
                matchController: matchController,
                player: player!,
              ),
              Expanded(
                child: Board(
                  controller: player!.boardController,
                  isInteractive: !forTop,
                  forTop: forTop,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
