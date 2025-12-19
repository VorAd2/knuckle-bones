import 'dart:io';

import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/alternative_auth_row.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/confirm_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<StatefulWidget> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  String? _emailErrorFormMessage;
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();
  final _usernameFormController = TextEditingController();
  File? _userAvatar;

  @override
  void dispose() {
    _usernameFormController.dispose();
    _emailFormController.dispose();
    _passwordFormController.dispose();
    super.dispose();
  }

  void _onSubmit() {
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
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildAvatarSelection(cs),
                    const SizedBox(height: 48),
                    AuthForm(formKey: _formKey, configs: _getConfigs()),
                    const SizedBox(height: 32),
                    ConfirmButton(onSubmit: _onSubmit),
                    const SizedBox(height: 32),
                    Text('Or sign up with', textAlign: TextAlign.center),
                    const SizedBox(height: 14),
                    AlternativeAuthRow(
                      onGoogleAuth: _onGoogleAuth,
                      onGithubAuth: _onGithubAuth,
                    ),
                    const Spacer(),
                    _buildSigninNavigate(),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSelection(ColorScheme cs) {
    return CircleAvatar(
      radius: 70,
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Icon(
            Icons.camera_alt_rounded,
            size: 70,
            color: cs.onPrimaryContainer.withAlpha(60),
          ),
          Icon(Icons.edit, size: 55),
          Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            child: InkWell(onTap: () {}, customBorder: CircleBorder()),
          ),
        ],
      ),
    );
  }

  List<AuthFieldConfig> _getConfigs() {
    return [
      AuthFieldConfig(
        controller: _usernameFormController,
        label: 'Username',
        icon: Icons.person_2_rounded,
        validator: (v) => null,
        isPassword: false,
        keyboardType: TextInputType.name,
      ),
      AuthFieldConfig(
        controller: _emailFormController,
        label: 'Email',
        icon: Icons.mail,
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
        keyboardType: TextInputType.emailAddress,
      ),
    ];
  }

  Widget _buildSigninNavigate() {
    return TextButton(
      onPressed: () {},
      child: Text("Already have an account?"),
    );
  }
}
