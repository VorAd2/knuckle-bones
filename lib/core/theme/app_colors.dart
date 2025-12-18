import 'package:flutter/material.dart';

final seed = Color(0xFF6a1256);
const yellowDice = Color(0xFFD5D30F);
const redDice = Color(0xFFF31628);
const cyan = Color(0xFF2EC4B6);
final colorScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.expressive,
);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
  );
}
