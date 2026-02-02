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
  final Color? redDie;

  const DiceColors({required this.redDie});

  @override
  DiceColors copyWith({Color? redDice}) {
    return DiceColors(redDie: redDice ?? this.redDie);
  }

  @override
  DiceColors lerp(ThemeExtension<DiceColors>? other, double t) {
    if (other is! DiceColors) {
      return this;
    }
    return DiceColors(redDie: Color.lerp(redDie, other.redDie, t));
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    extensions: <ThemeExtension<dynamic>>[const DiceColors(redDie: redDice)],
  );
}
