import 'package:flutter/material.dart';

class NodePainter extends CustomPainter {
  final int itemCount;
  NodePainter(this.itemCount);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw the line
    canvas.drawLine(Offset(10, 0), Offset(10, size.height), paint);

    // Calculate spacing based on itemCount
    // double nodeSpacing = size.height / (itemCount - 1);
    double nodeSpacing = size.height / (6 - 1);

    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(10, nodeSpacing * i), 5,
          paint); // Adjust circle size if needed
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
