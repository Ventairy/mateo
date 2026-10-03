import 'package:flutter/rendering.dart';

class ContentPaintCounter extends CustomPainter {
  int paints = 0;

  @override
  void paint(Canvas canvas, Size size) {
    paints++;
  }

  @override
  bool shouldRepaint(ContentPaintCounter oldDelegate) => false;
}
