import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/auth/presentation/signup_view.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/alternative_auth_row.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/confirm_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';
import 'package:knuckle_bones/features/home/home_view.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<StatefulWidget> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();

  @override
  void dispose() {
    _emailFormController.dispose();
    _passwordFormController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final email = _emailFormController.text.trim();
    final password = _passwordFormController.text.trim();
    if (email == 'admin' && password == 'admin') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
    }
    if (_formKey.currentState!.validate()) {
      debugPrint('Validado');
    }
  }

  void _onGoogleAuth() {}

  void _onGithubAuth() {}

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Sign up'),
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
                    AlternativeAuthRow(
                      onGoogleAuth: _onGoogleAuth,
                      onGithubAuth: _onGithubAuth,
                    ),
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
        icon: Icon(Icons.mail_lock_rounded),
        validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
        isPassword: false,
        keyboardType: TextInputType.emailAddress,
      ),
      AuthFieldConfig(
        controller: _passwordFormController,
        label: 'Password',
        icon: Icon(Icons.key_rounded),
        validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
        isPassword: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];
  }

  Widget _buildSignupNavigate() {
    return TextButton(
      onPressed: () {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => SignupView()));
      },
      child: Text("Don't have an account yet?"),
    );
  }
}
