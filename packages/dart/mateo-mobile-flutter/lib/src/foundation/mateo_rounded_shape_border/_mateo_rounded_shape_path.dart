part of 'mateo_rounded_shape_border.dart';

// Canonical coefficients from foundation/rounded-shape.md, shared by every use.
const _cornerExtent = 1.5286649465560913;
const _shoulderAngle = 0.4188790204786391;

({double extent, double angle, double b, double c, double sine, double rise}) _axis(double dimension, double radius) {
  final extent = math.min(_cornerExtent, (dimension / 2) / radius);
  if (extent == _cornerExtent) return _unfittedAxis;
  return _axisForExtent(extent);
}

final ({double extent, double angle, double b, double c, double sine, double rise}) _unfittedAxis = _axisForExtent(
  _cornerExtent,
);

({double extent, double angle, double b, double c, double sine, double rise}) _axisForExtent(double extent) {
  final angle = _shoulderAngle * ((extent - 1) / (_cornerExtent - 1));
  final q = math.tan(angle / 2);
  final square = q * q;
  return (
    extent: extent,
    angle: angle,
    b: 1 - q / 4 + 3 * q * square / 4,
    c: 1 - q,
    sine: 2 * q / (1 + square),
    rise: 2 * square / (1 + square),
  );
}

Path _mateoRoundedShapePath(Rect rect, double radius) {
  if (radius == 0) {
    return Path()..addRect(rect);
  }
  if (rect.width == rect.height && radius == rect.width / 2) {
    return Path()..addOval(rect);
  }
  final w = rect.width;
  final h = rect.height;
  final r = radius;
  final x = _axis(w, r);
  final y = w == h ? x : _axis(h, r);
  final topStartX = w - r * x.extent;
  final topControl1X = w - r * x.b;
  final topControl2X = w - r * x.c;
  final topEndX = w - r + r * x.sine;
  final topEndY = r * x.rise;
  final rightStartX = w - r * y.rise;
  final rightStartY = r - r * y.sine;
  final rightControl1Y = r * y.c;
  final rightControl2Y = r * y.b;
  final rightEndY = r * y.extent;
  final left = rect.left;
  final top = rect.top;
  final right = left + w;
  final bottom = top + h;
  final bendRadius = Radius.circular(r);
  // Reflect the same shoulder coordinates directly. Keeping the four corners
  // explicit avoids temporary point lists, iterators and transformed Offsets
  // whenever a changing surface needs a new clip or shadow outline.
  final path = Path()
    ..moveTo(rect.right, rect.center.dy)
    ..lineTo(right, top + (h - rightEndY));
  if (y.angle > 0) {
    path.cubicTo(
      right,
      top + (h - rightControl2Y),
      right,
      top + (h - rightControl1Y),
      left + rightStartX,
      top + (h - rightStartY),
    );
  }
  path.arcToPoint(Offset(left + topEndX, top + (h - topEndY)), radius: bendRadius);
  if (x.angle > 0) {
    path.cubicTo(
      left + topControl2X,
      bottom,
      left + topControl1X,
      bottom,
      left + topStartX,
      bottom,
    );
  }

  path.lineTo(left + (w - topStartX), bottom);
  if (x.angle > 0) {
    path.cubicTo(
      left + (w - topControl1X),
      bottom,
      left + (w - topControl2X),
      bottom,
      left + (w - topEndX),
      top + (h - topEndY),
    );
  }
  path.arcToPoint(Offset(left + (w - rightStartX), top + (h - rightStartY)), radius: bendRadius);
  if (y.angle > 0) {
    path.cubicTo(
      left,
      top + (h - rightControl1Y),
      left,
      top + (h - rightControl2Y),
      left,
      top + (h - rightEndY),
    );
  }

  path.lineTo(left, top + rightEndY);
  if (y.angle > 0) {
    path.cubicTo(
      left,
      top + rightControl2Y,
      left,
      top + rightControl1Y,
      left + (w - rightStartX),
      top + rightStartY,
    );
  }
  path.arcToPoint(Offset(left + (w - topEndX), top + topEndY), radius: bendRadius);
  if (x.angle > 0) {
    path.cubicTo(
      left + (w - topControl2X),
      top,
      left + (w - topControl1X),
      top,
      left + (w - topStartX),
      top,
    );
  }

  path.lineTo(left + topStartX, top);
  if (x.angle > 0) {
    path.cubicTo(
      left + topControl1X,
      top,
      left + topControl2X,
      top,
      left + topEndX,
      top + topEndY,
    );
  }
  path.arcToPoint(Offset(left + rightStartX, top + rightStartY), radius: bendRadius);
  if (y.angle > 0) {
    path.cubicTo(
      right,
      top + rightControl1Y,
      right,
      top + rightControl2Y,
      right,
      top + rightEndY,
    );
  }
  return path..close();
}
