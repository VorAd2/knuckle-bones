import 'package:flutter/material.dart';

class LoadingVeil extends StatelessWidget {
  final String roomCode;
  const LoadingVeil({super.key, required this.roomCode});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.black.withAlpha(110),
      child: Center(
        child: Container(
          width: 240,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Room Code',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
              const SizedBox(height: 24),
              Text(roomCode, style: TextStyle(fontSize: 26)),
              const SizedBox(height: 24),
              Text('Waiting guest ...'),
            ],
          ),
        ),
      ),
    );
  }
}
