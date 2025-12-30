import 'dart:math';
import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/match/presentation/widgets/tile.dart';

class Board extends StatefulWidget {
  final bool isTop;
  const Board({super.key, required this.isTop});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<int?> boardState = List.generate(9, (index) => null);

  void _handleTileTap(int index) {
    if (boardState[index] == null) {
      setState(() {
        boardState[index] = Random().nextInt(6) + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double textOffset = 24.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isTop) ...[
          Transform.translate(
            offset: const Offset(0, -textOffset),
            child: const _ScoreRow(),
          ),
        ],
        _TileGrid(
          getTileValue: (index) => boardState[index],
          onTap: (index) => _handleTileTap(index),
        ),
        if (widget.isTop) ...[
          Transform.translate(
            offset: const Offset(0, textOffset),
            child: const _ScoreRow(),
          ),
        ],
      ],
    );
  }
}

class _TileGrid extends StatelessWidget {
  final int? Function(int index) getTileValue;
  final void Function(int index) onTap;
  const _TileGrid({required this.getTileValue, required this.onTap});
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
          return Tile(value: getTileValue(index), onTap: () => onTap(index));
        },
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow();
  @override
  Widget build(BuildContext context) {
    const mockScores = [36, 2, 7];
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Center(
            child: Text(
              '${mockScores[index]}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        );
      }),
    );
  }
}
