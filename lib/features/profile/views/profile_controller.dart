import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/data/user_repository.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/presentation/controllers/auth_controller.dart';

class ProfileController {
  final ValueNotifier<bool> isLoadingNotifier;
  final _authController = GetIt.I<AuthController>();
  final _userRepository = GetIt.I<UserRepository>();
  final isEditingNotifier = ValueNotifier(false);
  final avatarFileNotifier = ValueNotifier<File?>(null);
  final errorTextNotifier = ValueNotifier<String?>(null);

  ProfileController({required this.isLoadingNotifier});

  bool get isEditing => isEditingNotifier.value;
  File? get avatarFile => avatarFileNotifier.value;
  set isEditing(bool value) => isEditingNotifier.value = value;
  set isLoading(bool value) => isLoadingNotifier.value = value;
  set avatarFile(File? value) => avatarFileNotifier.value = value;
  set errorText(String? value) => errorTextNotifier.value = value;

  void dispose() {
    isEditingNotifier.dispose();
    avatarFileNotifier.dispose();
    errorTextNotifier.dispose();
  }

  Future<void> updateUser({
    required String newName,
    required File? newAvatar,
    required ValueNotifier<UserEntity> userNotifier,
  }) async {
    await _userRepository.updateUser(newName: newName, avatar: newAvatar);
    final oldLocalUser = userNotifier.value;
    userNotifier.value = oldLocalUser.copyWith(name: newName);
  }

  void signOut() {
    _authController.signOut();
  }
}
