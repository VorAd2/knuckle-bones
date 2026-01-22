import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/presentation/widgets/image_picker_sheet.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/core/utils/media_helper.dart';
import 'package:knuckle_bones/features/auth/presentation/views/auth_controller.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';

class ProfileView extends StatefulWidget {
  final UserEntity user;
  final ValueNotifier<int> tabIndexNotifier;
  final int profileTabIndex;
  const ProfileView({
    super.key,
    required this.user,
    required this.tabIndexNotifier,
    required this.profileTabIndex,
  });

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _authController = GetIt.I<AuthController>();
  final _usernameFormController = TextEditingController();
  File? _avatarFile;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _resetProfileData();
    widget.tabIndexNotifier.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _usernameFormController.dispose();
    widget.tabIndexNotifier.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    final newTabIndex = widget.tabIndexNotifier.value;
    if (newTabIndex != widget.profileTabIndex && _isEditing) {
      _onCancel();
    }
  }

  void _resetProfileData() {
    _usernameFormController.text = widget.user.name;
  }

  void _onEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void _onCancel() {
    setState(() {
      _isEditing = false;
    });
    _resetProfileData();
  }

  void _onSave() async {
    setState(() {
      _isEditing = false;
    });
    //widget.user.name = _usernameFormController.text.trim();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated successfully')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await MediaHelper.pickImage(source);
      if (file != null) {
        setState(() {
          _avatarFile = file;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error has occurred. Please, try again.'),
          ),
        );
      }
    }
  }

  void _showHistory() {
    MyDialog.alert(
      context: context,
      titleString: 'Oops',
      contentString: 'This feature has not yet been implemented',
    );
  }

  Future<void> _onSignOut() async {
    final shouldLogout = await MyDialog.show(
      context: context,
      titleString: 'Log out',
      contentString: 'Are you sure you want to log out of your account?',
    );
    if (mounted && shouldLogout) {
      _authController.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Profile', actions: _buildAppBarActions(cs)),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: Column(
          children: [
            _ProfileAvatar(
              imageFile: _avatarFile,
              isEditing: _isEditing,
              onPickImage: _pickImage,
              onRemoveImage: () {
                setState(() => _avatarFile = null);
              },
            ),
            const SizedBox(height: 48),
            _ProfileNameField(
              controller: _usernameFormController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 48),
            ThreeDButton.wide(
              backgroundColor: cs.secondaryContainer,
              foregroundColor: cs.onSecondaryContainer,
              icon: Icons.history,
              text: 'Match history',
              width: double.infinity,
              onClick: () => _showHistory(),
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
              onClick: () => _onSignOut(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(ColorScheme cs) {
    if (_isEditing) {
      return [
        IconButton(
          onPressed: _onCancel,
          icon: Icon(Icons.close, color: cs.secondary),
          tooltip: 'Cancel',
        ),
        IconButton(
          onPressed: _onSave,
          icon: Icon(Icons.save, color: cs.secondary),
          tooltip: 'Save',
        ),
      ];
    }
    return [
      IconButton(
        onPressed: _onEdit,
        icon: Icon(Icons.edit, color: cs.primary),
        tooltip: 'Edit Profile',
      ),
    ];
  }
}

class _ProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final bool isEditing;
  final Function(ImageSource) onPickImage;
  final VoidCallback onRemoveImage;

  const _ProfileAvatar({
    required this.imageFile,
    required this.isEditing,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final imageProvider = imageFile != null ? FileImage(imageFile!) : null;
    return CircleAvatar(
      radius: 70,
      backgroundImage: imageProvider,
      backgroundColor: cs.primaryContainer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (imageFile == null)
            Icon(
              Icons.person,
              size: 70,
              color: cs.onPrimaryContainer.withAlpha(127),
            ),
          if (isEditing)
            Container(
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.edit, size: 40, color: cs.onPrimaryContainer),
            ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: isEditing
                  ? () {
                      ImagePickerSheet.show(
                        context: context,
                        onPick: onPickImage,
                        onRemove: imageFile == null ? null : onRemoveImage,
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileNameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;

  const _ProfileNameField({required this.controller, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      canRequestFocus: isEditing,
      keyboardType: TextInputType.name,
      readOnly: !isEditing,
      decoration: InputDecoration(
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
  }
}
