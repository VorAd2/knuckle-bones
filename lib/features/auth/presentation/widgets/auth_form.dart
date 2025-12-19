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
      child: Column(spacing: 20, children: configs.map(_buildField).toList()),
    );
  }

  Widget _buildField(AuthFieldConfig config) {
    return TextFormField(
      controller: config.controller,
      obscureText: config.isPassword,
      keyboardType: config.keyboardType,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Required';
        return config.validator(v);
      },
      decoration: InputDecoration(
        labelText: config.label,
        prefixIcon: Icon(config.icon),
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
