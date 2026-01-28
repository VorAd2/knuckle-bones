import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/domain/match_player/match_player.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/oracle/oracle.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/player_avatar/player_avatar.dart';

class Shrine extends StatelessWidget {
  final bool forTop;
  final MatchController matchController;
  final MatchPlayer player;

  const Shrine({
    super.key,
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

class ShrineMock extends StatelessWidget {
  const ShrineMock({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PlayerAvatar(),
          const SizedBox(height: 4),
          Text(
            'Player',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9),
          ),
          const SizedBox(height: 36),
          OracleMock(),
        ],
      ),
    );
  }
}
