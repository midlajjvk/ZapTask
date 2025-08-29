import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientText({
    Key? key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detect theme mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pick gradient colors based on theme
    final List<Color> colors = isDark
        ? [Colors.deepPurpleAccent, Colors.purpleAccent] // Dark mode gradient
        : [Colors.blue, Colors.lightBlueAccent]; // Light mode gradient

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Needed so gradient shows
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
