import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/ui/widgets/three_d_button.dart';
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
            ThreeDButton.wide(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              icon: Icons.add,
              text: 'Create match',
              width: double.infinity,
              onClick: () {},
            ),
            ThreeDButton.wide(
              backgroundColor: cs.secondary,
              foregroundColor: cs.onSecondary,
              icon: Icons.input,
              text: 'Join match',
              width: double.infinity,
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
