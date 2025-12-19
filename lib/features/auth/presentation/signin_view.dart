import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum _FormFieldType { email, password }

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
                    _buildForm(),
                    const SizedBox(height: 32),
                    _buildConfirmButton(),
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

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormField(_FormFieldType.email),
          const SizedBox(height: 20),
          _buildFormField(_FormFieldType.password),
        ],
      ),
    );
  }

  TextFormField _buildFormField(_FormFieldType type) {
    final isPassword = type == _FormFieldType.password;
    return TextFormField(
      controller: isPassword ? _passwordFormController : _emailFormController,
      obscureText: isPassword,
      textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Fill in the field';
        if (!isPassword && !value.contains('@')) {
          return 'Insert a valid email';
        }
        if (isPassword && value.length < 5) {
          return 'At least 5 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: isPassword ? 'Password' : 'Email',
        prefixIcon: Icon(isPassword ? Icons.key_rounded : Icons.mail),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            debugPrint("Validado!");
          }
        },
        child: const Text(
          'Confirm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
