import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(title: 'Lobby'));
  }
}
