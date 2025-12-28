import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});
  @override
  State<StatefulWidget> createState() => _LobbyViewState();
}

enum _OpponentType { human, bot }

enum _BotDifficulty { lovelace, turing }

class _LobbyViewState extends State<LobbyView> {
  final _codeFormKey = GlobalKey<FormState>();
  final _codeFieldController = TextEditingController();
  _OpponentType _opponentTypeView = _OpponentType.human;
  _BotDifficulty _botDiff = _BotDifficulty.lovelace;

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const MyAppBar(title: 'Lobby'),
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(24),
          child: Column(
            spacing: 56,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _OpponentSegmentedButton(
                opponentTypeView: _opponentTypeView,
                onChange: (newSelection) {
                  setState(() {
                    _opponentTypeView = newSelection.first;
                  });
                },
              ),
              ..._buildMainActions(cs),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMainActions(ColorScheme cs) {
    if (_opponentTypeView == _OpponentType.human) {
      return [
        ThreeDButton.wide(
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimaryContainer,
          icon: Icons.add,
          text: 'Create match',
          width: double.infinity,
          onClick: () {},
        ),
        ThreeDButton.wide(
          backgroundColor: cs.tertiaryContainer,
          foregroundColor: cs.onTertiaryContainer,
          icon: Icons.input,
          text: 'Join match',
          width: double.infinity,
          onClick: () {
            _onJoin(context);
          },
        ),
      ];
    }
    return [
      _BotChips(
        botDiff: _botDiff,
        onSelect: (newSelection) {
          setState(() => _botDiff = newSelection);
        },
      ),
      ThreeDButton.wide(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
        icon: Icons.play_arrow,
        text: 'Start',
        width: double.infinity,
        onClick: () => MyDialog.show(
          context: context,
          titleString: 'Oops',
          contentString: 'This feature has not yet been implemented',
          onConfirm: () {},
          hasCancel: false,
          mainActionString: 'Ok',
        ),
      ),
    ];
  }
}

class _OpponentSegmentedButton extends StatelessWidget {
  final _OpponentType opponentTypeView;
  final void Function(Set<_OpponentType>) onChange;

  const _OpponentSegmentedButton({
    required this.opponentTypeView,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SegmentedButton<_OpponentType>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: _OpponentType.human,
          icon: AppIcons.peopleArrows(color: cs.onSurfaceVariant),
          label: const Text('Human'),
        ),
        ButtonSegment(
          value: _OpponentType.bot,
          icon: AppIcons.robot(color: cs.onSurfaceVariant),
          label: const Text('Robot'),
        ),
      ],
      selected: <_OpponentType>{opponentTypeView},
      onSelectionChanged: onChange,
    );
  }
}

class _BotChips extends StatelessWidget {
  final _BotDifficulty botDiff;
  final void Function(_BotDifficulty newSelection) onSelect;

  const _BotChips({required this.botDiff, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: _BotDifficulty.values.map((difficulty) {
        return ChoiceChip(
          label: Text(
            difficulty.name[0].toUpperCase() + difficulty.name.substring(1),
          ),
          selected: botDiff == difficulty,
          onSelected: (bool selected) {
            if (selected) onSelect(difficulty);
          },
        );
      }).toList(),
    );
  }
}
