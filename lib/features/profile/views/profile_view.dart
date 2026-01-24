import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knuckle_bones/core/domain/user_entity.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/core/store/user_store.dart';
import 'package:knuckle_bones/core/utils/media_helper.dart';
import 'package:knuckle_bones/features/profile/views/profile_controller.dart';
import 'package:knuckle_bones/features/profile/widgets/loading_veil.dart';
import 'package:knuckle_bones/features/profile/widgets/profile_scaffold.dart';

class ProfileView extends StatefulWidget {
  final ValueNotifier<bool> globalLoadingNotifier;
  final ValueNotifier<int> tabIndexNotifier;
  final int profileTabIndex;
  const ProfileView({
    super.key,
    required this.globalLoadingNotifier,
    required this.tabIndexNotifier,
    required this.profileTabIndex,
  });

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _userStore = GetIt.I<UserStore>();
  late ProfileController _controller;
  final _formKey = GlobalKey<FormState>();
  final _usernameFormController = TextEditingController();

  UserEntity get user => _userStore.value!;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(
      isLoadingNotifier: widget.globalLoadingNotifier,
    );
    _resetProfileData();
    widget.tabIndexNotifier.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _usernameFormController.dispose();
    _controller.dispose();
    widget.tabIndexNotifier.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    final newTabIndex = widget.tabIndexNotifier.value;
    final isEditing = _controller.isEditing;
    if (newTabIndex != widget.profileTabIndex && isEditing) {
      _onCancelIntention();
    }
  }

  void _resetProfileData() {
    _usernameFormController.text = user.name;
  }

  void _onEditIntention() {
    _controller.isEditing = true;
  }

  void _onCancelIntention() {
    _controller.isEditing = false;
    _formKey.currentState?.reset();
    _resetProfileData();
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final newName = _usernameFormController.text.trim();
    if (newName == user.name) {
      _controller.isEditing = false;
      return;
    }
    _controller.isLoading = true;
    _controller.errorText = null;

    try {
      await _controller.updateUser(
        newName: newName,
        newAvatar: _controller.avatarFile,
      );
      if (mounted) {
        _controller.isLoading = false;
        _controller.isEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        _controller.errorText = e.toString();
        _controller.isLoading = false;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await MediaHelper.pickImage(source);
      if (file != null) {
        _controller.avatarFile = file;
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
      _controller.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.isLoadingNotifier,
      builder: (_, isLoading, child) {
        return PopScope(canPop: !isLoading, child: child!);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ProfileScaffold(
              isEditingNotifier: _controller.isEditingNotifier,
              buildAppBarActions: _buildAppBarActions,
              formKey: _formKey,
              usernameFormController: _usernameFormController,
              errorTextNotifier: _controller.errorTextNotifier,
              pickImage: _pickImage,
              removeImage: () => _controller.avatarFile = null,
              avatarFileNotifier: _controller.avatarFileNotifier,
              showHistory: _showHistory,
              onSignOut: _onSignOut,
            ),
          ),
          LoadingVeil(valueNotifier: _controller.isLoadingNotifier),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(bool isEditing, ColorScheme cs) {
    if (isEditing) {
      return [
        IconButton(
          onPressed: _onCancelIntention,
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
        onPressed: _onEditIntention,
        icon: Icon(Icons.edit, color: cs.primary),
        tooltip: 'Edit Profile',
      ),
    ];
  }
}
