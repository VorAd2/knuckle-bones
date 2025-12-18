import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/theme/app_colors.dart';
import 'package:knuckle_bones/features/auth_gate/auth_gate_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KnuckleBones',
      theme: buildAppTheme(),
      home: const AuthGateView(),
    );
  }
}
