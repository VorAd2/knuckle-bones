import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const ConfirmButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onSubmit,
        child: const Text(
          'Confirm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
