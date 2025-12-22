import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/ui/theme/app_theme.dart';
import 'package:knuckle_bones/features/auth/presentation/auth_gate_view.dart';

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
