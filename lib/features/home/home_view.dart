import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/lobby/lobby_view.dart';
import 'package:knuckle_bones/features/profile/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final List<Widget> _views = [LobbyView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _views),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: _getIcon(0), label: 'Play'),
          NavigationDestination(icon: _getIcon(1), label: 'Profile'),
        ],
      ),
    );
  }

  Icon _getIcon(int destinationIndex) {
    return switch (destinationIndex) {
      0 => Icon(
        destinationIndex == _currentIndex
            ? Icons.videogame_asset
            : Icons.videogame_asset_outlined,
      ),
      1 => Icon(
        destinationIndex == _currentIndex
            ? Icons.person_2
            : Icons.person_2_outlined,
      ),
      _ => Icon(Icons.error),
    };
  }
}
