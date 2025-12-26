import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});
  @override
  State<StatefulWidget> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final _codeFormKey = GlobalKey<FormState>();
  final _codeFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(title: 'Lobby'),
      body: _buildContent(context, cs),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: Column(
          spacing: 56,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ThreeDButton.wide(
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              icon: Icons.add,
              text: 'Create match',
              width: double.infinity,
              onClick: () {},
            ),
            ThreeDButton.wide(
              backgroundColor: cs.secondaryContainer,
              foregroundColor: cs.onSecondaryContainer,
              icon: Icons.input,
              text: 'Join match',
              width: double.infinity,
              onClick: () {
                _onJoin(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onJoin(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Type the match code'),
          content: Form(
            key: _codeFormKey,
            child: TextFormField(
              controller: _codeFieldController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (value.length < 6) return 'The code has 6 chars';
                return null;
              },
              decoration: const InputDecoration(hintText: 'Example: X79UK2'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _closeAndClear(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final code = _codeFieldController.text.trim();
                if (_validateMatchCode()) {
                  _closeAndClear(dialogContext);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(code)));
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _closeAndClear(BuildContext dialogContext) {
    Navigator.pop(dialogContext);
    _codeFieldController.clear();
  }

  bool _validateMatchCode() {
    return _codeFormKey.currentState!.validate();
  }
}
