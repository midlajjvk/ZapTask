import 'package:flutter/material.dart';

class GradientOutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const GradientOutlinedTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Pick gradient based on theme
    final gradient = LinearGradient(
      colors: isDarkMode
          ? [Colors.deepPurple, Colors.purpleAccent] // dark mode
          : [Colors.blue, Colors.lightBlueAccent],   // light mode
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      padding: const EdgeInsets.all(2), // thickness of gradient border
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white, // fill background
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
