import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';

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
        _SocialButton(
          icon: AppIcons.google(size: 24),
          label: 'Google',
          callback: onGoogleAuth,
        ),
        _SocialButton(
          icon: AppIcons.github(size: 32, color: cs.onSurface),
          label: 'GitHub',
          callback: onGithubAuth,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback callback;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: callback,
      icon: icon,
      label: Text(label),
    );
  }
}
