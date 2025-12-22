import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/ui/icons/app_icons.dart';

class AlternativeAuthRow extends StatelessWidget {
  final VoidCallback onGoogleAuth;
  final VoidCallback onGithubAuth;

  const AlternativeAuthRow({
    super.key,
    required this.onGoogleAuth,
    required this.onGithubAuth,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        _socialButton(
          icon: AppIcons.google(size: 24),
          label: 'Google',
          callback: onGoogleAuth,
        ),
        _socialButton(
          icon: AppIcons.github(size: 32, color: cs.onSurface),
          label: 'GitHub',
          callback: onGithubAuth,
        ),
      ],
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String label,
    required VoidCallback callback,
  }) {
    return OutlinedButton.icon(
      onPressed: callback,
      icon: icon,
      label: Text(label),
    );
  }
}
