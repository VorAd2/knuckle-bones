import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knuckle_bones/features/auth/presentation/signin_view.dart';
import 'package:knuckle_bones/features/auth/presentation/signup_view.dart';

class AuthGateView extends StatelessWidget {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: _buildAppBar(),
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
                        _buildFooter(cs),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Welcome',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
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

  Widget _buildFooter(ColorScheme cs) {
    return IconButton(
      onPressed: () {},
      iconSize: 32,
      icon: SvgPicture.asset(
        'assets/icons/github.svg',
        width: 32,
        height: 32,
        colorFilter: ColorFilter.mode(cs.onSurfaceVariant, BlendMode.srcIn),
      ),
      tooltip: 'Visite nosso GitHub',
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
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          colorFilter: ColorFilter.mode(cs.onPrimaryContainer, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
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
}
