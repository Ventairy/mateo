part of 'mateo_rounded_shape_border.dart';

// Canonical coefficients from foundation/rounded-shape.md, shared by every use.
const _cornerExtent = 1.5286649465560913;
const _shoulderAngle = 0.4188790204786391;

({double extent, double angle, double b, double c, double sine, double rise}) _axis(double dimension, double radius) {
  final extent = math.min(_cornerExtent, (dimension / 2) / radius);
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
  final y = _axis(h, r);
  final top = [
    Offset(w - r * x.extent, 0),
    Offset(w - r * x.b, 0),
    Offset(w - r * x.c, 0),
    Offset(w - r + r * x.sine, r * x.rise),
  ];
  final right = [
    Offset(w - r * y.rise, r - r * y.sine),
    Offset(w, r * y.c),
    Offset(w, r * y.b),
    Offset(w, r * y.extent),
  ];
  final path = Path()..moveTo(rect.right, rect.center.dy);
  for (var corner = 0; corner < 4; corner++) {
    final reverse = corner.isEven;
    Offset transform(Offset p) =>
        rect.topLeft +
        switch (corner) {
          0 => Offset(p.dx, h - p.dy),
          1 => Offset(w - p.dx, h - p.dy),
          2 => Offset(w - p.dx, p.dy),
          _ => p,
        };
    final first = (reverse ? right.reversed : top).map(transform).toList();
    final last = (reverse ? top.reversed : right).map(transform).toList();
    path.lineTo(first.first.dx, first.first.dy);
    void cubic(List<Offset> p) {
      path.cubicTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy, p[3].dx, p[3].dy);
    }

    if ((reverse ? y.angle : x.angle) > 0) cubic(first);
    path.arcToPoint(last.first, radius: .circular(r));
    if ((reverse ? x.angle : y.angle) > 0) cubic(last);
  }
  return path..close();
}
