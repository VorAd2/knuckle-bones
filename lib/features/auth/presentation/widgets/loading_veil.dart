import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/features/auth/presentation/views/auth_controller.dart';

class LoadingVeil extends StatelessWidget {
  final _authController = GetIt.I<AuthController>();
  LoadingVeil({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authController,
      builder: (context, child) {
        if (!_authController.isLoading) return const SizedBox.shrink();
        return Container(
          color: Colors.black.withAlpha(127),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
