import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zaptask/widget/text_gradiant.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showText = true; // show ZapTask after animation ends
        });

        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isDarkMode: widget.isDarkMode,
                onThemeToggle: widget.onThemeToggle,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: CurvedZPainter(progress: _animation.value),
                  size: const Size(300, 300),
                );
              },
            ),
            // Only show text after animation completes
            if (_showText)
              Positioned(
                bottom: 1, // adjust the position as needed
                child: AnimatedOpacity(
                  opacity: _showText ? 1 : 0,
                  duration: const Duration(seconds:1),

                  child: GradientText(
                    text: "ZapTask",
                    fontSize: 32,
                  )


                ),
              ),

          ],
        ),

      ),
    );
  }
}

class CurvedZPainter extends CustomPainter {
  final double progress;

  CurvedZPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.purpleAccent.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    final Path path = Path();

    // Start top left
    path.moveTo(0, size.height * 0.1);

    // Top curve
    path.quadraticBezierTo(
      size.width * 0.5, size.height * -0.1,
      size.width, size.height * 0.1,
    );

    // Middle diagonal
    path.lineTo(0, size.height * 0.6);

    // Bottom curve
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.9,
      size.width, size.height * 0.6,
    );

    // Animate path
    final PathMetrics metrics = path.computeMetrics();
    final Path animatedPath = Path();

    for (final metric in metrics) {
      final length = metric.length * progress;
      animatedPath.addPath(metric.extractPath(0, length), Offset.zero);
    }

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedZPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
