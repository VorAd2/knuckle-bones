import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/lobby/lobby_view.dart';
import 'package:knuckle_bones/features/profile/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _profileTabIndex = 1;
  final _tabIndexNotifier = ValueNotifier<int>(0);
  final _globalLoadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _globalLoadingNotifier.dispose();
    _tabIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _globalLoadingNotifier,
      builder: (context, isBusy, child) {
        return IgnorePointer(
          ignoring: isBusy,
          child: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: _tabIndexNotifier,
              builder: (context, currentIndex, _) {
                return IndexedStack(
                  index: currentIndex,
                  children: [
                    LobbyView(),
                    ProfileView(
                      globalLoadingNotifier: _globalLoadingNotifier,
                      tabIndexNotifier: _tabIndexNotifier,
                      profileTabIndex: _profileTabIndex,
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tabIndexNotifier.value,
              onDestinationSelected: (index) {
                setState(() {
                  _tabIndexNotifier.value = index;
                });
              },
              destinations: [
                NavigationDestination(icon: _getIcon(0), label: 'Lobby'),
                NavigationDestination(icon: _getIcon(1), label: 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  Icon _getIcon(int destinationIndex) {
    return switch (destinationIndex) {
      0 => Icon(
        0 == _tabIndexNotifier.value
            ? Icons.videogame_asset
            : Icons.videogame_asset_outlined,
      ),
      1 => Icon(
        1 == _tabIndexNotifier.value ? Icons.person_2 : Icons.person_2_outlined,
      ),
      _ => Icon(Icons.error),
    };
  }
}
