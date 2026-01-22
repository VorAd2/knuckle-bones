import 'package:flutter/material.dart';

class ProfileNameField extends StatelessWidget {
  final bool isEditing;
  final TextEditingController controller;
  final ValueNotifier<String?> errorTextNotifier;

  const ProfileNameField({
    super.key,
    required this.isEditing,
    required this.controller,
    required this.errorTextNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: errorTextNotifier,
      builder: (_, errorText, _) {
        return TextFormField(
          controller: controller,
          canRequestFocus: isEditing,
          keyboardType: TextInputType.name,
          readOnly: !isEditing,
          validator: (value) {
            if (!isEditing) return null;
            if (value == null || value.trim().isEmpty) {
              return 'Username cannot be empty';
            }
            return null;
          },
          onChanged: (_) {
            if (errorTextNotifier.value != null) {
              errorTextNotifier.value = null;
            }
          },
          decoration: InputDecoration(
            errorText: errorText,
            labelText: 'Username',
            border: isEditing
                ? const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  )
                : InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            suffixIcon: isEditing ? const Icon(Icons.edit) : null,
          ),
        );
      },
    );
  }
}
