import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/painting.dart';

// Native borders share their actual controls with endpoint preparation.
@internal
typedef MateoBorderCubic = ({Offset start, Offset control1, Offset control2, Offset end});

@internal
List<Offset> mateoBorderContour(List<MateoBorderCubic> cubics, double tolerance) {
  final points = <Offset>[];
  final toleranceSquared = tolerance * tolerance;
  // Scalar subdivision retains only the final boundary points. Intermediate
  // control points do not need Offset objects or a cubic record at each split.
  void flatten(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, int depth) {
    final dx = x3 - x0;
    final dy = y3 - y0;
    final chordSquared = dx * dx + dy * dy;
    final ax = x1 - x0;
    final ay = y1 - y0;
    final bx = x2 - x0;
    final by = y2 - y0;
    final cross1 = ax * dy - ay * dx;
    final cross2 = bx * dy - by * dx;
    final limit = toleranceSquared * chordSquared;
    final flat = chordSquared == 0
        ? ax * ax + ay * ay <= toleranceSquared && bx * bx + by * by <= toleranceSquared
        : cross1 * cross1 <= limit && cross2 * cross2 <= limit;
    if (flat) {
      if (points.last.dx != x3 || points.last.dy != y3) points.add(Offset(x3, y3));
      return;
    }
    if (depth == 24) throw ArgumentError('The border cannot be represented at the requested size.');
    final ax0 = (x0 + x1) / 2;
    final ay0 = (y0 + y1) / 2;
    final ax1 = (x1 + x2) / 2;
    final ay1 = (y1 + y2) / 2;
    final ax2 = (x2 + x3) / 2;
    final ay2 = (y2 + y3) / 2;
    final bx0 = (ax0 + ax1) / 2;
    final by0 = (ay0 + ay1) / 2;
    final bx1 = (ax1 + ax2) / 2;
    final by1 = (ay1 + ay2) / 2;
    final middleX = (bx0 + bx1) / 2;
    final middleY = (by0 + by1) / 2;
    flatten(x0, y0, ax0, ay0, bx0, by0, middleX, middleY, depth + 1);
    flatten(middleX, middleY, bx1, by1, ax2, ay2, x3, y3, depth + 1);
  }

  for (final cubic in cubics) {
    // A native border may supply separate curved spans joined by straight sides.
    // Keep each new span's start while omitting shared consecutive endpoints.
    if (points.isEmpty || points.last != cubic.start) points.add(cubic.start);
    flatten(
      cubic.start.dx,
      cubic.start.dy,
      cubic.control1.dx,
      cubic.control1.dy,
      cubic.control2.dx,
      cubic.control2.dy,
      cubic.end.dx,
      cubic.end.dy,
      0,
    );
  }
  return points;
}
