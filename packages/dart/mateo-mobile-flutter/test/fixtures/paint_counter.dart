import 'package:flutter/rendering.dart';

class PaintCounter extends CustomPainter {
  PaintCounter({required this.onPaint, required this.color});

  final VoidCallback onPaint;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint();
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PaintCounter oldDelegate) => color != oldDelegate.color;
}
