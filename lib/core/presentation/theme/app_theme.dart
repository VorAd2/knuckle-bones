import 'package:flutter/material.dart';

final seed = Color(0xFF6a1256);
const redDice = Color(0xFFF54553);
final colorScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.expressive,
);

@immutable
class DiceColors extends ThemeExtension<DiceColors> {
  final Color? redDice;

  const DiceColors({required this.redDice});

  @override
  DiceColors copyWith({Color? redDice}) {
    return DiceColors(redDice: redDice ?? this.redDice);
  }

  @override
  DiceColors lerp(ThemeExtension<DiceColors>? other, double t) {
    if (other is! DiceColors) {
      return this;
    }
    return DiceColors(redDice: Color.lerp(redDice, other.redDice, t));
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    extensions: <ThemeExtension<dynamic>>[const DiceColors(redDice: redDice)],
  );
}
