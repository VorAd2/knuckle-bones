import 'package:flutter/material.dart';

class ThreeDButton extends StatefulWidget {
  final Color buttonBackground;
  final Color buttonForeground;
  final IconData icon;
  final String? textString;
  final double? width;
  final Color? shadowColor;
  final VoidCallback onClick;

  const ThreeDButton._({
    super.key,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.icon,
    required this.onClick,
    this.textString,
    this.width,
    this.shadowColor,
  });

  factory ThreeDButton.wide({
    Key? key,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    required String text,
    required double width,
    required VoidCallback onClick,
    Color? shadowColor,
  }) {
    return ThreeDButton._(
      key: key,
      buttonBackground: backgroundColor,
      buttonForeground: foregroundColor,
      icon: icon,
      textString: text,
      width: width,
      onClick: onClick,
      shadowColor: shadowColor,
    );
  }

  factory ThreeDButton.icon({
    Key? key,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    required VoidCallback onClick,
    double? size,
    Color? shadowColor,
  }) {
    return ThreeDButton._(
      key: key,
      buttonBackground: backgroundColor,
      buttonForeground: foregroundColor,
      icon: icon,
      textString: null,
      width: size,
      shadowColor: shadowColor,
      onClick: onClick,
    );
  }

  @override
  State<StatefulWidget> createState() => _ThreeDButtonState();
}

class _ThreeDButtonState extends State<ThreeDButton> {
  static const double shadowHeight = 6;
  double position = 6;

  @override
  Widget build(BuildContext context) {
    const double totalHeight = 66;
    final double innerHeight = totalHeight - shadowHeight;
    final double actualWidth = widget.width ?? totalHeight;

    return GestureDetector(
      onTap: widget.onClick,
      onTapUp: (_) => setState(() => position = 6),
      onTapDown: (_) => setState(() => position = 0),
      onTapCancel: () => setState(() => position = 6),
      child: SizedBox(
        height: totalHeight,
        width: actualWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: innerHeight,
                decoration: BoxDecoration(
                  color:
                      widget.shadowColor ??
                      Color.lerp(widget.buttonBackground, Colors.black, 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.bounceInOut,
              bottom: position,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 70),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: innerHeight,
                decoration: BoxDecoration(
                  color: widget.buttonBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final bool isIconOnly = widget.textString == null;
    if (isIconOnly) {
      return Center(
        child: Icon(widget.icon, color: widget.buttonForeground, size: 28),
      );
    }
    return Row(
      children: [
        Icon(widget.icon, color: widget.buttonForeground),
        const Spacer(),
        Text(
          widget.textString!,
          style: TextStyle(
            color: widget.buttonForeground,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
