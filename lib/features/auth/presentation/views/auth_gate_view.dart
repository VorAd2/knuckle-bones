import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signin_view.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signup_view.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthGateView extends StatelessWidget {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Welcome'),
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
                        _buildCentralContent(
                          textTheme: textTheme,
                          cs: cs,
                          onSignin: () => _navigateTo(context, SigninView()),
                          onSignup: () => _navigateTo(context, SignupView()),
                        ),
                        const Spacer(),
                        _buildFooter(context, cs),
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => destination));
  }

  Widget _buildCentralContent({
    required TextTheme textTheme,
    required ColorScheme cs,
    required VoidCallback onSignin,
    required VoidCallback onSignup,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildBrandWidgets(textTheme, cs),
        const SizedBox(height: 64),
        _buildGateButtons(onSignin: onSignin, onSignup: onSignup),
      ],
    );
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

  Widget _buildGateButtons({
    required VoidCallback onSignin,
    required VoidCallback onSignup,
  }) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(120, 50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: onSignin,
          style: buttonStyle,
          child: const Text('Sign in'),
        ),
        const SizedBox(width: 24),
        FilledButton(
          onPressed: onSignup,
          style: buttonStyle,
          child: const Text('Sign up'),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme cs) {
    final githubUrl = 'https://github.com/VorAd2';
    Future<void> openGithub(BuildContext context) async {
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

    return IconButton(
      onPressed: () {
        openGithub(context);
      },
      iconSize: 32,
      icon: AppIcons.github(size: 32, color: cs.onSurfaceVariant),
      tooltip: 'Visit me',
    );
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
