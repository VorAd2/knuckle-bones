import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knuckle_bones/core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(cs),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Welcome',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    final style1 = ElevatedButton.styleFrom(
      backgroundColor: cs.secondary,
      foregroundColor: cs.onSecondary,
      shadowColor: cs.shadow,
    );
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text(
              'Poppins semibold',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Poppins medium',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Poppins regular',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(onPressed: () {}, child: Text('Press Me')),
            ElevatedButton(onPressed: () {}, child: Text('Press Me')),
            ElevatedButton(
              onPressed: () {},
              style: style1,
              child: Text('Press Me'),
            ),
            FilledButton(onPressed: () {}, child: Text('Press Me')),
            FilledButton.tonal(onPressed: () {}, child: Text('Press Me')),
            OutlinedButton(onPressed: () {}, child: Text('Press Me')),
            IconButton(onPressed: () {}, icon: Icon(Icons.soap_rounded)),
            IconButton.filled(onPressed: () {}, icon: Icon(Icons.soap_rounded)),
            IconButton.filledTonal(
              onPressed: () {},
              icon: Icon(Icons.soap_rounded),
            ),
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: cs.tertiary,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(child: Icon(Icons.person_2)),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: SizedBox(
                width: 70,
                height: 70,
                child: SvgPicture.asset(
                  'assets/icons/dice1.svg',
                  colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
                ),
              ),
              label: const Text('Hello'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: SizedBox(
                width: 70,
                height: 70,
                child: SvgPicture.asset(
                  'assets/icons/dice1.svg',
                  colorFilter: ColorFilter.mode(yellowDice, BlendMode.srcIn),
                ),
              ),
              label: const Text('Hello'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: SizedBox(
                width: 70,
                height: 70,
                child: SvgPicture.asset(
                  'assets/icons/dice1.svg',
                  colorFilter: ColorFilter.mode(redDice, BlendMode.srcIn),
                ),
              ),
              label: const Text('Hello'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.videogame_asset), label: 'Play'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
