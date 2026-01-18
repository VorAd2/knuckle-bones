import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_text_form_field.dart';

class AuthFieldConfig {
  final TextEditingController controller;
  final String label;
  final Icon icon;
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
        children: configs.map((config) {
          return MyTextFormField(
            controller: config.controller,
            label: config.label,
            icon: config.icon,
            isPassword: config.isPassword,
            keyboardType: config.keyboardType,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              return config.validator(v);
            },
          );
        }).toList(),
      ),
    );
  }
}
