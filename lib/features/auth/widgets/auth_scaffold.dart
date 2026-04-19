import 'package:flutter/material.dart';
import 'package:knuckle_bones/core/presentation/widgets/my_app_bar.dart';
import 'package:knuckle_bones/features/auth/widgets/main_content_builder.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final Widget componentsColumn;
  const AuthScaffold({
    super.key,
    required this.title,
    required this.componentsColumn,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: SafeArea(
        child: MainContentBuilder(componentsColumn: componentsColumn),
      ),
    );
  }
}
