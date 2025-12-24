import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:knuckle_bones/core/domain/session_controller.dart';
import 'package:knuckle_bones/core/ui/theme/app_theme.dart';
import 'package:knuckle_bones/core/ui/widgets/my_text_form_field.dart';
import 'package:knuckle_bones/core/ui/widgets/three_d_button.dart';
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
  final _session = GetIt.I<SessionController>();
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
    _usernameFormController.text = _session.currentUser.name;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Profile', actions: _buildActions()),
      body: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: Column(
          children: [
            _buildGenericAvatar(cs),
            const SizedBox(height: 48),
            MyTextFormField(
              controller: _usernameFormController,
              label: 'Username',
              keyboardType: TextInputType.name,
              isEditing: _isEditing,
            ),
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

  void _onSave() {
    setState(() {
      _isEditing = false;
    });
    _session.editUsername(_usernameFormController.text.trim());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Name updated successfully')));
  }

  Widget _buildGenericAvatar(ColorScheme cs) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: cs.primaryContainer,
      child: Icon(Icons.person, size: 64, color: cs.onPrimaryContainer),
    );
  }
}
