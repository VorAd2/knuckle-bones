import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/core/presentation/widgets/image_picker_sheet.dart';
import 'package:knuckle_bones/core/utils/media_helper.dart';
import 'package:knuckle_bones/core/presentation/controllers/auth_controller.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signin_view.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/alternative_auth_row.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_form.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_confirm_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/loading_veil.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<StatefulWidget> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _controller = GetIt.I<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();
  final _usernameFormController = TextEditingController();
  File? _userAvatarFile;

  @override
  void dispose() {
    _usernameFormController.dispose();
    _emailFormController.dispose();
    _passwordFormController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final success = await _controller.signUp(
      email: _emailFormController.text.trim(),
      password: _passwordFormController.text.trim(),
      name: _usernameFormController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      //TODO enviar avatar para cloudinary
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Error signing up'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _onGoogleAuth() {}

  void _onGithubAuth() {}

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await MediaHelper.pickImage(source);
      if (file != null) {
        setState(() {
          _userAvatarFile = file;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error has occurred. Please, try again.'),
          ),
        );
      }
    }
  }

  List<AuthFieldConfig> _getConfigs() {
    return [
      AuthFieldConfig(
        controller: _usernameFormController,
        label: 'Username',
        icon: Icon(Icons.person_2_rounded),
        validator: (v) => null,
        isPassword: false,
        keyboardType: TextInputType.name,
      ),
      AuthFieldConfig(
        controller: _emailFormController,
        label: 'Email',
        icon: Icon(Icons.mail),
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
        keyboardType: TextInputType.emailAddress,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final avatarSelector = _AvatarSelector(
      avatarFile: _userAvatarFile,
      onPick: _pickImage,
      onRemove: _userAvatarFile == null
          ? null
          : () => setState(() => _userAvatarFile = null),
    );
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
                avatarSelector: avatarSelector,
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

class _AvatarSelector extends StatelessWidget {
  final File? avatarFile;
  final Function(ImageSource) onPick;
  final VoidCallback? onRemove;

  const _AvatarSelector({
    required this.avatarFile,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final imageProvider = avatarFile != null ? FileImage(avatarFile!) : null;
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: cs.primaryContainer,
            backgroundImage: imageProvider,
            child: avatarFile == null
                ? Icon(
                    Icons.person,
                    size: 70,
                    color: cs.onPrimaryContainer.withAlpha(127),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Material(
              color: cs.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  ImagePickerSheet.show(
                    context: context,
                    onPick: onPick,
                    onRemove: onRemove,
                  );
                },
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    avatarFile == null ? Icons.add_a_photo : Icons.edit,
                    color: cs.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentsColumn extends StatelessWidget {
  final _AvatarSelector avatarSelector;
  final GlobalKey<FormState> formKey;
  final List<AuthFieldConfig> Function() getConfigs;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleAuth;
  final VoidCallback onGithubAuth;
  const _ComponentsColumn({
    required this.avatarSelector,
    required this.formKey,
    required this.getConfigs,
    required this.onSubmit,
    required this.onGoogleAuth,
    required this.onGithubAuth,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        avatarSelector,
        const SizedBox(height: 48),
        AuthForm(formKey: formKey, configs: getConfigs()),
        const SizedBox(height: 32),
        AuthConfirmButton(onSubmit: onSubmit),
        const SizedBox(height: 32),
        const Text('Or sign up with', textAlign: TextAlign.center),
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
            ).pushReplacement(MaterialPageRoute(builder: (_) => SigninView()));
          },
          child: Text('Already have an account?'),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
