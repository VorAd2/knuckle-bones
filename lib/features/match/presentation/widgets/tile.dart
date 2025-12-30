import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int? value;
  final VoidCallback onTap;

  const Tile({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceBright,
      borderRadius: BorderRadius.circular(12),
      elevation: 2.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(child: value == null ? null : _getIconForValue(value!)),
      ),
    );
  }

  Widget _getIconForValue(int val) {
    IconData iconData;
    switch (val) {
      case 1:
        iconData = Icons.looks_one;
        break;
      case 2:
        iconData = Icons.looks_two;
        break;
      case 3:
        iconData = Icons.looks_3;
        break;
      case 4:
        iconData = Icons.looks_4;
        break;
      case 5:
        iconData = Icons.looks_5;
        break;
      case 6:
        iconData = Icons.looks_6;
        break;
      default:
        iconData = Icons.error;
    }
    return Icon(iconData, size: 40, color: Colors.deepPurple);
  }
}
