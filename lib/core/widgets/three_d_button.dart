import 'package:flutter/material.dart';

class ThreeDButton extends StatefulWidget {
  final Color buttonBackground;
  final Color buttonForeground;
  final IconData icon;
  final String textString;
  final VoidCallback onClick;

  const ThreeDButton({
    super.key,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.icon,
    required this.textString,
    required this.onClick,
  });

  @override
  State<StatefulWidget> createState() => _ThreeDButtonState();
}

class _ThreeDButtonState extends State<ThreeDButton> {
  static const double shadowHeight = 6;
  double position = 6;

  @override
  Widget build(BuildContext context) {
    final double height = 66 - shadowHeight;
    return GestureDetector(
      onTap: widget.onClick,
      onTapUp: (_) {
        setState(() {
          position = 6;
        });
      },
      onTapDown: (_) {
        setState(() {
          position = 0;
        });
      },
      onTapCancel: () {
        setState(() {
          position = 6;
        });
      },
      child: SizedBox(
        height: height + shadowHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: Color.lerp(widget.buttonBackground, Colors.black, 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: position,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 70),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: height,
                decoration: BoxDecoration(
                  color: widget.buttonBackground,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.buttonForeground,
                      fontWeight: FontWeight.w700,
                    ),
                    const Spacer(),
                    Text(
                      widget.textString,
                      style: TextStyle(
                        color: widget.buttonForeground,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
