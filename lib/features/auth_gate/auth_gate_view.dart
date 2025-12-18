import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knuckle_bones/features/auth/presentation/signin.dart';
import 'package:knuckle_bones/features/auth/presentation/signup.dart';

class AuthGateView extends StatelessWidget {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    children: [
                      const Spacer(),
                      _buildCentralContent(
                        width: width,
                        cs: cs,
                        onSignin: () => _navigateTo(context, SigninView()),
                        onSignup: () => _navigateTo(context, SignupView()),
                      ),
                      const Spacer(),
                      _buildFooter(width, cs),
                      SizedBox(height: width * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget destination) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Welcome',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCentralContent({
    required double width,
    required ColorScheme cs,
    required VoidCallback onSignin,
    required VoidCallback onSignup,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildBrandWidgets(width, cs),
        SizedBox(height: width * 0.15),
        _buildGateButtons(
          width: width,
          cs: cs,
          onSignin: onSignin,
          onSignup: onSignup,
        ),
      ],
    );
  }

  Widget _buildFooter(double width, ColorScheme cs) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        'assets/icons/github.svg',
        width: width * 0.1,
        height: width * 0.1,
        colorFilter: ColorFilter.mode(cs.onSurfaceVariant, BlendMode.srcIn),
      ),
    );
  }

  List<Widget> _buildBrandWidgets(double width, ColorScheme cs) {
    return [
      Container(
        width: width * 0.4,
        height: width * 0.4,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(width * 0.06),
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          colorFilter: ColorFilter.mode(cs.onPrimaryContainer, BlendMode.srcIn),
        ),
      ),
      SizedBox(height: width * 0.04),
      Text(
        'KnuckleBones',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: width * 0.045),
      ),
    ];
  }

  Widget _buildGateButtons({
    required double width,
    required ColorScheme cs,
    required VoidCallback onSignin,
    required VoidCallback onSignup,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: onSignin,
          child: Padding(
            padding: EdgeInsets.all(width * 0.01),
            child: Text('Sign in', style: TextStyle(fontSize: width * 0.045)),
          ),
        ),
        SizedBox(width: width * 0.06),
        FilledButton(
          onPressed: onSignup,
          child: Padding(
            padding: EdgeInsets.all(width * 0.01),
            child: Text('Sign up', style: TextStyle(fontSize: width * 0.045)),
          ),
        ),
      ],
    );
  }
}
