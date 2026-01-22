import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/presentation/controllers/auth_controller.dart';

class ProfileController {
  final _authController = GetIt.I<AuthController>();
  final isLoadingNotifier = ValueNotifier(false);
  final isEditingNotifier = ValueNotifier(false);
  final avatarFileNotifier = ValueNotifier<File?>(null);
  final errorTextNotifier = ValueNotifier<String?>(null);

  bool get isEditing => isEditingNotifier.value;
  File? get avatarFile => avatarFileNotifier.value;
  set isEditing(bool value) => isEditingNotifier.value = value;
  set isLoading(bool value) => isLoadingNotifier.value = value;
  set avatarFile(File? value) => avatarFileNotifier.value = value;
  set errorText(String? value) => errorTextNotifier.value = value;

  void dispose() {
    isEditingNotifier.dispose();
    isLoadingNotifier.dispose();
    avatarFileNotifier.dispose();
    errorTextNotifier.dispose();
  }

  Future<void> updateProfile({required String newName, File? newAvatar}) async {
    await _authController.updateProfile(name: newName, avatar: newAvatar);
  }

  void signOut() {
    _authController.signOut();
  }
}
