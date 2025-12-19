import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/confirm_button.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<StatefulWidget> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Validado');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildGenericAvatar(cs),
                    const SizedBox(height: 48),
                    AuthForm(formKey: _formKey, configs: _getConfigs()),
                    const SizedBox(height: 32),
                    ConfirmButton(onSubmit: _onSubmit),
                    const SizedBox(height: 32),
                    Text('Or signin with', textAlign: TextAlign.center),
                    const SizedBox(height: 14),
                    _buildAltSignin(cs),
                    const Spacer(),
                    _buildSignupNavigate(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Sign in',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildGenericAvatar(ColorScheme cs) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: cs.primaryContainer,
      child: Icon(Icons.person, size: 64, color: cs.onPrimaryContainer),
    );
  }

  List<AuthFieldConfig> _getConfigs() {
    return [
      AuthFieldConfig(
        controller: _emailFormController,
        label: 'Email',
        icon: Icons.mail_lock_rounded,
        validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
        isPassword: false,
        keyboardType: TextInputType.emailAddress,
      ),
      AuthFieldConfig(
        controller: _passwordFormController,
        label: 'Password',
        icon: Icons.key_rounded,
        validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
        isPassword: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];
  }

  Widget _buildAltSignin(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        _socialButton(
          SvgPicture.asset('assets/icons/google.svg', width: 24, height: 24),
          'Google',
        ),
        _socialButton(
          SvgPicture.asset(
            'assets/icons/github.svg',
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
          ),
          'GitHub',
        ),
      ],
    );
  }

  Widget _socialButton(Widget icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: icon,
      label: Text(label),
    );
  }

  Widget _buildSignupNavigate() {
    return TextButton(
      onPressed: () {},
      child: Text("Don't have an account yet?"),
    );
  }
}
