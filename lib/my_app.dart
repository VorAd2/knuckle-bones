import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/theme/app_colors.dart';
import 'package:knuckle_bones/features/home/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KnuckleBones',
      theme: buildAppTheme(),
      home: const HomeView(),
    );
  }
}
