import 'package:flutter/material.dart';

class AuthFieldConfig {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  AuthFieldConfig({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    required this.isPassword,
    required this.keyboardType,
  });
}

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<AuthFieldConfig> configs;

  const AuthForm({super.key, required this.formKey, required this.configs});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20,
        children: configs.map((config) => _AuthField(config: config)).toList(),
      ),
    );
  }
}

class _AuthField extends StatefulWidget {
  final AuthFieldConfig config;

  const _AuthField({required this.config});

  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.config.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.config.controller,
      obscureText: _isObscure,
      keyboardType: widget.config.keyboardType,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Obrigatório';
        return widget.config.validator(v);
      },
      decoration: InputDecoration(
        labelText: widget.config.label,
        prefixIcon: Icon(widget.config.icon),
        suffixIcon: widget.config.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _toggleVisibility,
              )
            : null,
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
}
