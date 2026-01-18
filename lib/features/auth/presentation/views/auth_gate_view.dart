import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signin_view.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signup_view.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthGateView extends StatelessWidget {
  const AuthGateView({super.key});

  Future<void> _openGithub(BuildContext context) async {
    final githubUrl = 'https://github.com/VorAd2';
    final Uri url = Uri.parse(githubUrl);
    try {
      final bool success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!success) {
        if (!context.mounted) return;
        _showPopup(context, 'The link could not be opened');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showPopup(context, 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: const MyAppBar(title: 'Welcome'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ..._buildBrandWidgets(textTheme, cs),
                            const SizedBox(height: 64),
                            _GateButtonsRow(
                              onSignin: () =>
                                  _navigateTo(context, SigninView()),
                              onSignup: () =>
                                  _navigateTo(context, SignupView()),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _openGithub(context);
                          },
                          iconSize: 32,
                          icon: AppIcons.github(
                            size: 32,
                            color: cs.onSurfaceVariant,
                          ),
                          tooltip: 'Visit me',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget destination) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  List<Widget> _buildBrandWidgets(TextTheme textTheme, ColorScheme cs) {
    return [
      Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(32),
        child: AppIcons.logo(color: cs.onPrimaryContainer),
      ),
      const SizedBox(height: 24),
      Text(
        'KnuckleBones',
        style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: cs.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ops!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _GateButtonsRow extends StatelessWidget {
  final VoidCallback onSignin;
  final VoidCallback onSignup;
  static final _buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(120, 50),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  const _GateButtonsRow({required this.onSignin, required this.onSignup});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: onSignin,
          style: _buttonStyle,
          child: const Text('Sign in'),
        ),
        const SizedBox(width: 24),
        FilledButton(
          onPressed: onSignup,
          style: _buttonStyle,
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}
