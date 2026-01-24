import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/core/store/user_store.dart';
import 'package:knuckle_bones/features/profile/widgets/profile_avatar.dart';
import 'package:knuckle_bones/features/profile/widgets/profile_name_field.dart';

class ProfileScaffold extends StatelessWidget {
  final _userStore = GetIt.I<UserStore>();
  final ValueNotifier<bool> isEditingNotifier;
  final List<Widget> Function(bool, ColorScheme) buildAppBarActions;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameFormController;
  final ValueNotifier<String?> errorTextNotifier;
  final ValueNotifier<File?> avatarFileNotifier;
  final Future<void> Function(ImageSource) pickImage;
  final VoidCallback removeImage;
  final VoidCallback showHistory;
  final VoidCallback onSignOut;

  ProfileScaffold({
    super.key,
    required this.isEditingNotifier,
    required this.buildAppBarActions,
    required this.formKey,
    required this.usernameFormController,
    required this.errorTextNotifier,
    required this.avatarFileNotifier,
    required this.pickImage,
    required this.removeImage,
    required this.showHistory,
    required this.onSignOut,
  });

  UserEntity get user => _userStore.value!;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: isEditingNotifier,
      builder: (_, isEditing, _) {
        return Scaffold(
          appBar: MyAppBar(
            title: 'Profile',
            actions: buildAppBarActions(isEditing, cs),
          ),
          body: Padding(
            padding: const EdgeInsetsGeometry.all(24),
            child: Column(
              children: [
                ProfileAvatar(
                  isEditing: isEditing,
                  onPickImage: pickImage,
                  onRemoveImage: removeImage,
                ),
                const SizedBox(height: 48),
                Form(
                  key: formKey,
                  child: ProfileNameField(
                    isEditing: isEditing,
                    controller: usernameFormController,
                    errorTextNotifier: errorTextNotifier,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 60),
                    Column(
                      spacing: 8,
                      children: [
                        Text(
                          'Games Played',
                          style: TextStyle(color: cs.onSurface.withAlpha(220)),
                        ),
                        Text(
                          (user.gamesPlayed).toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      spacing: 8,
                      children: [
                        Text(
                          'Wins',
                          style: TextStyle(color: cs.onSurface.withAlpha(220)),
                        ),
                        Text(
                          (user.wins).toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
                const SizedBox(height: 48),
                ThreeDButton.wide(
                  backgroundColor: cs.secondaryContainer,
                  foregroundColor: cs.onSecondaryContainer,
                  icon: Icons.history,
                  text: 'Match history',
                  width: double.infinity,
                  onClick: () => showHistory(),
                ),
                const SizedBox(height: 48),
                ThreeDButton.icon(
                  backgroundColor: cs.surfaceContainerHighest,
                  foregroundColor: Colors.red,
                  icon: Icons.logout,
                  shadowColor: Color.lerp(
                    cs.surfaceContainerHighest,
                    Colors.black,
                    0.3,
                  ),
                  onClick: () => onSignOut(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
