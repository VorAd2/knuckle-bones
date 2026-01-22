import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/features/auth/presentation/views/auth_controller.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signup_view.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/alternative_auth_row.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_confirm_button.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<StatefulWidget> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _controller = GetIt.I<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();

  @override
  void dispose() {
    _emailFormController.dispose();
    _passwordFormController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailFormController.text.trim();
    final password = _passwordFormController.text.trim();
    final success = await _controller.signIn(email, password);
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Error signing in'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _onGoogleAuth() {}

  void _onGithubAuth() {}

  List<AuthFieldConfig> _getConfigs() {
    return [
      AuthFieldConfig(
        controller: _emailFormController,
        label: 'Email',
        icon: const Icon(Icons.mail_lock_rounded),
        validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
        isPassword: false,
        keyboardType: TextInputType.emailAddress,
      ),
      AuthFieldConfig(
        controller: _passwordFormController,
        label: 'Password',
        icon: const Icon(Icons.key_rounded),
        validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
        isPassword: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: const MyAppBar(title: 'Sign in'),
          body: SafeArea(
            child: IgnorePointer(ignoring: _controller.isLoading, child: child),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: cs.onPrimaryContainer.withAlpha(127),
                    ),
                  ),
                  const SizedBox(height: 48),
                  AuthForm(formKey: _formKey, configs: _getConfigs()),
                  const SizedBox(height: 32),
                  _controller.isLoading
                      ? const CircularProgressIndicator()
                      : AuthConfirmButton(onSubmit: _onSubmit),
                  const SizedBox(height: 32),
                  const Text('Or signin with', textAlign: TextAlign.center),
                  const SizedBox(height: 14),
                  AlternativeAuthRow(
                    onGoogleAuth: _onGoogleAuth,
                    onGithubAuth: _onGithubAuth,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignupView()),
                      );
                    },
                    child: const Text("Don't have an account yet?"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
