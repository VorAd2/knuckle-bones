import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/board/board_controller.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile/tile.dart';

class Board extends StatelessWidget {
  final BoardController controller;
  final bool forTop;
  final bool isInteractive;

  const Board({
    super.key,
    required this.controller,
    required this.forTop,
    required this.isInteractive,
  });

  @override
  Widget build(BuildContext context) {
    const double textOffset = 24.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!forTop) ...[
          Transform.translate(
            offset: const Offset(0, -textOffset),
            child: _ScoreRow(controller),
          ),
        ],
        _TileGrid(controller: controller, isInteractive: isInteractive),
        if (forTop) ...[
          Transform.translate(
            offset: const Offset(0, textOffset),
            child: _ScoreRow(controller),
          ),
        ],
      ],
    );
  }
}

class _TileGrid extends StatelessWidget {
  final BoardController controller;
  final bool isInteractive;
  const _TileGrid({required this.controller, required this.isInteractive});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final rowIndex = index ~/ 3;
          final colIndex = index % 3;
          return Tile(
            boardController: controller,
            state: controller.getTileState(
              rowIndex: rowIndex,
              colIndex: colIndex,
            ),
            isInteractive: isInteractive,
          );
        },
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final BoardController controller;
  const _ScoreRow(this.controller);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Center(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final scores = controller.state.scores;
                return Text(
                  '${scores[index]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
