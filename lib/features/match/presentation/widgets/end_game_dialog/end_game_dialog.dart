import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/domain/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/player_avatar/player_avatar.dart';

class EndGameDialog extends StatelessWidget {
  final MatchPlayer localPlayer;
  final MatchPlayer remotePlayer;
  late final int localScore;
  late final int remoteScore;
  final VoidCallback onBackHome;
  final VoidCallback onClose;
  EndGameDialog({
    super.key,
    required this.localPlayer,
    required this.remotePlayer,
    required this.onBackHome,
    required this.onClose,
  }) {
    localScore = localPlayer.boardController.boardFullScore;
    remoteScore = remotePlayer.boardController.boardFullScore;
  }
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool isWin = localScore > remoteScore;
    final bool isDraw = localScore == remoteScore;
    String title = isWin ? 'VICTORY' : (isDraw ? 'DRAW' : 'DEFEAT');
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: isWin ? cs.tertiary : cs.error,
              ),
            ),
            const SizedBox(height: 42),
            _PlayerColumn(
              localPlayer: localPlayer,
              remotePlayer: remotePlayer,
              localScore: localScore,
              remoteScore: remoteScore,
            ),
            const SizedBox(height: 42),
            _HomeButton(onBackHome: onBackHome),
            const SizedBox(height: 12),
            TextButton(onPressed: onClose, child: Text('Close')),
          ],
        ),
      ),
    );
  }
}

class _PlayerColumn extends StatelessWidget {
  final MatchPlayer localPlayer;
  final MatchPlayer remotePlayer;
  final int localScore;
  final int remoteScore;
  const _PlayerColumn({
    required this.localPlayer,
    required this.remotePlayer,
    required this.localScore,
    required this.remoteScore,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 32,
      children: [
        _ScoreColumn(
          player: remotePlayer,
          score: remoteScore,
          isWinner: remoteScore >= localScore,
          isLocal: false,
        ),
        Container(height: 2, width: 180, color: Colors.white10),
        _ScoreColumn(
          player: localPlayer,
          score: localScore,
          isWinner: localScore >= remoteScore,
          isLocal: true,
        ),
      ],
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final MatchPlayer player;
  final int score;
  final bool isWinner;
  final bool isLocal;
  const _ScoreColumn({
    required this.player,
    required this.score,
    required this.isWinner,
    required this.isLocal,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlayerSignature(player: player, isWinner: isWinner, isLocal: isLocal),
        const SizedBox(height: 2),
        Text(
          '$score',
          style: TextStyle(
            color: isWinner ? Colors.white : Colors.white38,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _PlayerSignature extends StatelessWidget {
  final MatchPlayer player;
  final bool isWinner;
  final bool isLocal;
  const _PlayerSignature({
    required this.player,
    required this.isWinner,
    required this.isLocal,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isWinner ? cs.tertiary : Colors.transparent,
              width: 2,
            ),
            boxShadow: isWinner
                ? [BoxShadow(color: cs.tertiary.withAlpha(102), blurRadius: 5)]
                : [],
          ),
          child: const PlayerAvatar(),
        ),
        const SizedBox(width: 30),
        Flexible(
          child: Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeButton extends StatelessWidget {
  final VoidCallback onBackHome;
  const _HomeButton({required this.onBackHome});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onBackHome,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'BACK TO HOME',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
