import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double? fontSize;
  final Color? coreColor;
  final Color? craftColor;
  final FontWeight? fontWeight;
  final double? letterSpacing;

  const LogoWidget({
    super.key,
    this.fontSize,
    this.coreColor,
    this.craftColor,
    this.fontWeight,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.bold,
          letterSpacing: letterSpacing ?? 1.5,
        ),
        children: [
          TextSpan(
            text: 'CORE',
            style: TextStyle(color: coreColor ?? Colors.black),
          ),
          TextSpan(
            text: 'CRAFT',
            style: TextStyle(
              color: craftColor ?? const Color(0xFF8B0000), // Dark red/maroon
            ),
          ),
        ],
      ),
    );
  }
}
