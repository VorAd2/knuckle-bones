import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/infra/user_model.dart';
import 'package:knuckle_bones/core/presentation/theme/app_theme.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class ProfileView extends StatefulWidget {
  final ValueNotifier<int> tabIndexNotifier;
  final int profileTabIndex;
  const ProfileView({
    super.key,
    required this.tabIndexNotifier,
    required this.profileTabIndex,
  });

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _usernameFormController = TextEditingController();
  bool _isEditing = false;
  final _user = GetIt.I<UserModel>();

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
    _usernameFormController.text = _user.name;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Profile', actions: _buildActions()),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: Column(
          children: [
            _buildGenericAvatar(cs),
            const SizedBox(height: 48),
            _buildTextField(),
            const SizedBox(height: 48),
            ThreeDButton.wide(
              backgroundColor: cs.secondaryContainer,
              foregroundColor: cs.onSecondaryContainer,
              icon: Icons.history,
              text: 'Match history',
              width: double.infinity,
              onClick: () {},
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
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    final editingActions = [
      IconButton(
        onPressed: _onCancel,
        icon: Icon(Icons.close, color: colorScheme.secondary),
      ),
      IconButton(
        onPressed: _onSave,
        icon: Icon(Icons.save, color: colorScheme.secondary),
      ),
    ];
    return [
      if (!_isEditing)
        IconButton(
          onPressed: _onEdit,
          icon: Icon(Icons.edit, color: colorScheme.primary),
        ),
      if (_isEditing) ...editingActions,
    ];
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
    _user.name = _usernameFormController.text.trim();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated successfully')),
      );
    }
  }

  Widget _buildGenericAvatar(ColorScheme cs) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: cs.primaryContainer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.person,
            size: 70,
            color: cs.onPrimaryContainer.withAlpha(127),
          ),
          if (_isEditing)
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.edit, size: 40, color: cs.onPrimaryContainer),
            ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(onTap: _isEditing ? () {} : null),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField() {
    return TextFormField(
      controller: _usernameFormController,
      canRequestFocus: _isEditing,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        border: _isEditing
            ? const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        suffixIcon: _isEditing ? Icon(Icons.edit) : null,
      ),
    );
  }
}
