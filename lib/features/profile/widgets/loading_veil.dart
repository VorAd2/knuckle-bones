import 'package:flutter/material.dart';

class LoadingVeil extends StatelessWidget {
  final ValueNotifier valueNotifier;
  const LoadingVeil({super.key, required this.valueNotifier});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        if (!valueNotifier.value) return const SizedBox.shrink();
        return Container(
          color: Colors.black.withAlpha(127),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
