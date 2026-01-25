import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/icons/app_icons.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_dialog.dart';
import 'package:knuckle_bones/core/presentation/widgets/three_d_button.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';
import 'package:knuckle_bones/features/match/data/match_repository.dart';
import 'package:knuckle_bones/features/match/presentation/views/match_view.dart';

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

  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  void _onCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            MatchView(localPlayerRole: .host, roomCode: _generateRoomCode()),
      ),
    );
  }

  void _onJoin(BuildContext context) {
    final repository = MatchRepository();
    String? errorMessage;
    bool isValidating = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setChildState) {
            return AlertDialog(
              title: const Text('Type the match code'),
              content: Form(
                key: _codeFormKey,
                child: TextFormField(
                  controller: _codeFieldController,
                  enabled: !isValidating,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length != 6) return 'The code has 6 chars';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Example: X79UK2',
                    errorText: errorMessage,
                  ),
                  onChanged: (_) {
                    if (errorMessage != null) {
                      setChildState(() => errorMessage = null);
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isValidating
                      ? null
                      : () => _closeAndClear(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isValidating
                      ? null
                      : () async {
                          if (!_validateMatchCode()) return;
                          setChildState(() {
                            isValidating = true;
                            errorMessage = null;
                          });
                          try {
                            await repository.checkCodeAvailability(
                              _codeFieldController.text,
                            );
                            if (dialogContext.mounted) {
                              final code = _codeFieldController.text;
                              _closeAndClear(dialogContext);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MatchView(
                                    localPlayerRole: .guest,
                                    roomCode: code,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            setChildState(() => errorMessage = e.toString());
                          } finally {
                            if (dialogContext.mounted) {
                              setChildState(() => isValidating = false);
                            }
                          }
                        },
                  child: isValidating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm'),
                ),
              ],
            );
          },
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
          onClick: () {
            _onCreate(context);
          },
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
        onClick: () => MyDialog.alert(
          context: context,
          titleString: 'Oops',
          contentString: 'This feature has not yet been implemented',
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
