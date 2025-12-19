import 'package:flutter/material.dart';
import 'package:knuckle_bones/features/auth/presentation/widgets/my_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: MyAppBar(title: 'Profile'));
  }
}
