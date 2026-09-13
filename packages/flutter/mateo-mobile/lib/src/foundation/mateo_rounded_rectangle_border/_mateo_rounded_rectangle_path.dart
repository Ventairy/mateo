part of 'mateo_rounded_rectangle_border.dart';

class _MateoRoundedRectanglePath {
  static final List<Offset> _hodograph = _createHodograph();
  static final List<Offset> _controls = _createControls();
  static final double _extent = _curvatureAtMidpoint();
  static final List<List<Offset>> _cubics = _approximate(_controls);

  static Offset _multiply(Offset a, Offset b) => Offset(a.dx * b.dx - a.dy * b.dy, a.dx * b.dy + a.dy * b.dx);

  static List<Offset> _createHodograph() {
    final root = math.sqrt(2);
    final a = (20 + root) / 140;
    final b = (10 + 4 * root) / 140;
    final c = (12 + 9 * root) / 140;
    final eigenvalue = (a + c + math.sqrt((a - c) * (a - c) + 4 * b * b)) / 2;
    final divisor = math.sqrt(b * b + (eigenvalue - a) * (eigenvalue - a)) * math.sqrt(eigenvalue);
    final lambda = b / divisor;
    final mu = (eigenvalue - a) / divisor;
    return [Offset(lambda, 0), Offset(mu, 0), Offset(mu / root, mu / root), Offset(lambda / root, lambda / root)];
  }

  static List<Offset> _createControls() {
    const third = [1, 3, 3, 1];
    const sixth = [1, 6, 15, 20, 15, 6, 1];
    final controls = <Offset>[Offset.zero];
    for (var k = 0; k <= 6; k++) {
      var velocity = Offset.zero;
      for (var i = math.max(0, k - 3); i <= math.min(3, k); i++) {
        velocity += _multiply(_hodograph[i], _hodograph[k - i]) * (third[i] * third[k - i] / sixth[k]);
      }
      controls.add(controls.last + velocity / 7);
    }
    return controls;
  }

  static double _curvatureAtMidpoint() {
    final w = (_hodograph[0] + _hodograph[1] * 3 + _hodograph[2] * 3 + _hodograph[3]) / 8;
    final derivative =
        ((_hodograph[1] - _hodograph[0]) + (_hodograph[2] - _hodograph[1]) * 2 + (_hodograph[3] - _hodograph[2])) * .75;
    return 2 * (w.dx * derivative.dy - w.dy * derivative.dx) / (w.distanceSquared * w.distanceSquared);
  }

  // Cubic Hermite conversion preserves endpoint positions and tangents.
  // Elevating it to degree seven bounds the entire difference polynomial by
  // its control vectors. Cache normalized curves once, independently of size.
  // The bound precedes Flutter Path's native coordinate quantization.
  static List<List<Offset>> _approximate(List<Offset> controls) {
    final cubic = [
      controls.first,
      controls.first + (controls[1] - controls.first) * (7 / 3),
      controls.last + (controls[6] - controls.last) * (7 / 3),
      controls.last,
    ];
    var elevated = cubic;
    for (var degree = 4; degree <= 7; degree++) {
      elevated = [
        elevated.first,
        for (var i = 1; i < degree; i++) elevated[i - 1] * (i / degree) + elevated[i] * (1 - i / degree),
        elevated.last,
      ];
    }
    if (List.generate(8, (i) => (controls[i] - elevated[i]).distance).reduce(math.max) <= 1e-6 / _extent) {
      return [cubic];
    }
    var row = controls;
    final left = <Offset>[row.first];
    final right = <Offset>[row.last];
    while (row.length > 1) {
      row = [for (var i = 1; i < row.length; i++) (row[i - 1] + row[i]) / 2];
      left.add(row.first);
      right.add(row.last);
    }
    return [..._approximate(left), ..._approximate(right.reversed.toList())];
  }

  static Path create(Rect rect, double radius, {void Function(MateoBorderCubic)? onCubic}) {
    final extent = _extent * math.min(radius, rect.shortestSide / (2 * _extent));
    final starts = [
      Offset(rect.right - extent, rect.top),
      Offset(rect.right, rect.bottom - extent),
      Offset(rect.left + extent, rect.bottom),
      Offset(rect.left, rect.top + extent),
    ];
    final path = Path();
    for (var corner = 0; corner < 4; corner++) {
      final origin = starts[corner];
      Offset transform(Offset point) => switch (corner) {
        0 => Offset(origin.dx + point.dx * extent, origin.dy + point.dy * extent),
        1 => Offset(origin.dx - point.dy * extent, origin.dy + point.dx * extent),
        2 => Offset(origin.dx - point.dx * extent, origin.dy - point.dy * extent),
        _ => Offset(origin.dx + point.dy * extent, origin.dy - point.dx * extent),
      };

      if (onCubic == null) {
        final start = transform(_cubics.first.first);
        if (corner == 0) {
          path.moveTo(start.dx, start.dy);
        } else {
          path.lineTo(start.dx, start.dy);
        }
      }
      for (final cubic in _cubics) {
        final a = transform(cubic[1]);
        final b = transform(cubic[2]);
        final end = transform(cubic[3]);
        if (onCubic != null) {
          onCubic((start: transform(cubic[0]), control1: a, control2: b, end: end));
        } else {
          path.cubicTo(a.dx, a.dy, b.dx, b.dy, end.dx, end.dy);
        }
      }
    }
    if (onCubic == null) path.close();
    return path;
  }
}
