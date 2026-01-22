import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/presentation/controllers/auth_controller.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signup_view.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/alternative_auth_row.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_confirm_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/loading_veil.dart';

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
    FocusScope.of(context).unfocus();
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
    return ListenableBuilder(
      listenable: _controller,
      builder: (_, child) {
        return PopScope(canPop: !_controller.isLoading, child: child!);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AuthScaffold(
              componentsColumn: _ComponentsColumn(
                formKey: _formKey,
                getConfigs: _getConfigs,
                onSubmit: _onSubmit,
                onGoogleAuth: _onGoogleAuth,
                onGithubAuth: _onGithubAuth,
              ),
            ),
          ),
          LoadingVeil(),
        ],
      ),
    );
  }
}

class _ComponentsColumn extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<AuthFieldConfig> Function() getConfigs;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleAuth;
  final VoidCallback onGithubAuth;

  const _ComponentsColumn({
    required this.formKey,
    required this.getConfigs,
    required this.onSubmit,
    required this.onGoogleAuth,
    required this.onGithubAuth,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
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
        AuthForm(formKey: formKey, configs: getConfigs()),
        const SizedBox(height: 32),
        AuthConfirmButton(onSubmit: onSubmit),
        const SizedBox(height: 32),
        const Text('Or signin with', textAlign: TextAlign.center),
        const SizedBox(height: 14),
        AlternativeAuthRow(
          onGoogleAuth: onGoogleAuth,
          onGithubAuth: onGithubAuth,
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => SignupView()));
          },
          child: const Text("Don't have an account yet?"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
