import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          icon: SvgPicture.asset(
            'assets/icons/google.svg',
            width: 24,
            height: 24,
          ),
          label: 'Google',
          callback: onGoogleAuth,
        ),
        _socialButton(
          icon: SvgPicture.asset(
            'assets/icons/github.svg',
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
          ),
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
