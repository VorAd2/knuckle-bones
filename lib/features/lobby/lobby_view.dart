import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/widgets/three_d_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Lobby'),
      body: _buildContent(cs),
    );
  }

  Widget _buildContent(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: Column(
          spacing: 56,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ThreeDButton(
              buttonBackground: cs.primary,
              buttonForeground: cs.onPrimary,
              icon: Icons.add,
              textString: 'Create match',
              onClick: () {},
            ),
            ThreeDButton(
              buttonBackground: cs.secondary,
              buttonForeground: cs.onSecondary,
              icon: Icons.start,
              textString: 'Join match',
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
