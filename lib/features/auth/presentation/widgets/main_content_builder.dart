import 'package:flutter/material.dart';

class MainContentBuilder extends StatelessWidget {
  final Widget componentsColumn;

  const MainContentBuilder({super.key, required this.componentsColumn});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: IntrinsicHeight(child: componentsColumn),
        ),
      ),
    );
  }
}
