import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/features/auth/presentation/views/signin_view.dart';
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
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();
  final _usernameFormController = TextEditingController();
  File? _userAvatarFile;
  final _imagePicker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _userAvatarFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error has occurred. Please, try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const MyAppBar(title: 'Sign up'),
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
    final imageProvider = _userAvatarFile != null
        ? FileImage(_userAvatarFile!)
        : null;
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: cs.primaryContainer,
            backgroundImage: imageProvider,
            child: _userAvatarFile == null
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
                onTap: _showPickerOptions,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    _userAvatarFile == null ? Icons.add_a_photo : Icons.edit,
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

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(modalContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(modalContext).pop();
                },
              ),
              if (_userAvatarFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    setState(() => _userAvatarFile = null);
                    Navigator.of(modalContext).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
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

  Widget _buildSigninNavigate() {
    return TextButton(
      onPressed: () {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => SigninView()));
      },
      child: Text('Already have an account?'),
    );
  }
}
