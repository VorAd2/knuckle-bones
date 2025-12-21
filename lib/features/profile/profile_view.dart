import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/widgets/my_text_form_field.dart';
import 'package:knuckle_bones/core/widgets/three_d_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class ProfileView extends StatefulWidget {
  final _usernameFormController = TextEditingController();

  ProfileView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    widget._usernameFormController.text = 'Ada Lovelace';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Profile'),
      body: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: Column(
          children: [
            _buildGenericAvatar(cs),
            const SizedBox(height: 48),
            MyTextFormField(
              controller: widget._usernameFormController,
              label: 'Username',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 48),
            ThreeDButton(
              buttonBackground: cs.tertiary,
              buttonForeground: cs.onTertiary,
              icon: Icons.history,
              textString: 'Match history',
              onClick: () {},
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericAvatar(ColorScheme cs) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: cs.primaryContainer,
      child: Icon(Icons.person, size: 64, color: cs.onPrimaryContainer),
    );
  }
}
