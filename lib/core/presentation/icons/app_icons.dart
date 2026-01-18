import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons {
  static ColorFilter? _getColorFilter(Color? color) {
    if (color == null) return null;
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  static Widget logo({double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/brands/logo.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }

  static Widget google({double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/brands/google.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }

  static Widget github({double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/brands/github.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }

  static Widget peopleArrows({double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/others/people_arrows.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }

  static Widget robot({double size = 24, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/others/robot.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }

  static Widget dice({required int face, double size = 58, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/die/dice$face.svg',
      width: size,
      height: size,
      colorFilter: _getColorFilter(color),
    );
  }
}
