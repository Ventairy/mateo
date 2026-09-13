part of 'mateo_capsule_border.dart';

typedef _CapsuleCubic = ({Offset start, Offset control1, Offset control2, Offset end});
typedef _CapsuleProfile = ({Offset point, Offset tangent, double curvature, double slope, double second, double drop});

// Normalized upper-right quadrant of the portable capsule specification.
// Polynomial coefficients are fixed coefficients, not samples indexed by size.
class _MateoCapsulePath {
  _MateoCapsulePath(this.referenceRatio) {
    final z = (referenceRatio - 1) / (referenceRatio + 1);
    final baseExponent =
        2 +
        (referenceRatio - 1) *
            (3.871257456340878 +
                z *
                    (-12.88611924670383 +
                        z *
                            (52.98714338673223 +
                                z * (-93.58531994541094 + z * (76.23481388943857 - z * 23.504691269150406)))));
    final wide = math.max(0, (referenceRatio - 2) / (referenceRatio + 4));
    final shoulderEase = 4 * wide * (1 - wide);
    exponent = baseExponent * (1 - 0.01 * shoulderEase * shoulderEase * shoulderEase);
    joinFactor =
        1.13276676 +
        (referenceRatio - 1) *
            (1.2859740959239152 +
                z *
                    (6.803433630915522 +
                        z *
                            (-39.513958239342216 +
                                z * (81.06757004843966 + z * (-72.45787701452092 + z * 23.86446258146726)))));
  }

  final double referenceRatio;
  late final double exponent;
  late final double joinFactor;
  final _curves = <_CapsuleCubic>[];

  static const _shoulderIntervals = 6;
  static const double _rootHalf = math.sqrt1_2;

  // Preserve small differences at the nearly circular limit in binary64.
  static double _log1p(double value) {
    final sum = 1 + value;
    return sum == 1 ? value : math.log(sum) * value / (sum - 1);
  }

  static double _expm1(double value) {
    final exponential = math.exp(value);
    return exponential == 1 ? value : (exponential - 1) * value / math.log(exponential);
  }

  _CapsuleProfile _profile(double x) {
    final power = math.pow(x / referenceRatio, exponent).toDouble();
    final drop = -referenceRatio * _expm1(_log1p(-power) / exponent);
    final slope = -power * (referenceRatio - drop) / (x * (1 - power));
    final second = (exponent - 1) * slope / (x * (1 - power));
    final magnitude = math.sqrt(1 + slope * slope);
    return (
      point: Offset(x, 1 - drop),
      tangent: Offset(1 / magnitude, slope / magnitude),
      curvature: -second / (magnitude * magnitude * magnitude),
      slope: slope,
      second: second,
      drop: drop,
    );
  }

  void _cubic(Offset start, Offset control1, Offset control2, Offset end) {
    _curves.add((start: start, control1: control1, control2: control2, end: end));
  }

  // Two cubic Hermite intervals reproduce a quintic within the shared error
  // budget. These closed-form midpoint expressions avoid runtime fitting.
  void _quintic(Offset p0, Offset p1, Offset p2, Offset p3, Offset p4, Offset p5) {
    final middle = (p0 + p1 * 5 + p2 * 10 + p3 * 10 + p4 * 5 + p5) / 32;
    final middleVelocity = (-p0 - p1 * 3 - p2 * 2 + p3 * 2 + p4 * 3 + p5) * (5 / 16);
    _cubic(p0, p0 + (p1 - p0) * (5 / 6), middle - middleVelocity / 6, middle);
    _cubic(middle, middle + middleVelocity / 6, p5 - (p5 - p4) * (5 / 6), p5);
  }

  void _join(Offset p0, Offset tangent0, double curvature0, Offset p1, Offset tangent1, double curvature1) {
    final span = (p1 - p0).distance;
    _quintic(
      p0,
      p0 + tangent0 * (span / 5),
      p0 + tangent0 * (2 * span / 5) + Offset(tangent0.dy, -tangent0.dx) * (span * span * curvature0 / 20),
      p1 - tangent1 * (2 * span / 5) + Offset(tangent1.dy, -tangent1.dx) * (span * span * curvature1 / 20),
      p1 - tangent1 * (span / 5),
      p1,
    );
  }

  void _arc(Offset center, double radius, double start, double end) {
    final span = (end - start).abs();
    if (!span.isFinite) throw ArgumentError('The capsule cannot be represented at the requested size.');
    final intervals = math.max(1, (span / (math.pi / 4)).ceil());
    for (var i = 0; i < intervals; i++) {
      final a = start + (end - start) * i / intervals;
      final b = start + (end - start) * (i + 1) / intervals;
      final handle = 4 / 3 * math.tan((b - a) / 4) * radius;
      final p0 = center + Offset(math.cos(a), math.sin(a)) * radius;
      final p1 = center + Offset(math.cos(b), math.sin(b)) * radius;
      _cubic(
        p0,
        p0 + Offset(-math.sin(a), math.cos(a)) * handle,
        p1 - Offset(-math.sin(b), math.cos(b)) * handle,
        p1,
      );
    }
  }

  void _buildQuarter() {
    final joinX = referenceRatio * (1 - 1 / joinFactor);
    final junction = _profile(joinX);
    final diagonal = Offset(referenceRatio - 1 + _rootHalf, _rootHalf);
    final tangentRatio = -junction.slope;
    final d = (joinX - tangentRatio * (junction.point.dy + referenceRatio - 1)) / (1 - tangentRatio);
    final radius = (referenceRatio - d - 1 + _rootHalf) * math.sqrt2;
    final chord = diagonal - junction.point;
    final center =
        (junction.point + diagonal) / 2 -
        Offset(-chord.dy, chord.dx) / chord.distance * math.sqrt(radius * radius - chord.distanceSquared / 4);
    final arcStart = math.atan2(junction.point.dy - center.dy, junction.point.dx - center.dx);
    final arcEnd = math.atan2(diagonal.dy - center.dy, diagonal.dx - center.dx);
    final blend = 0.12 * (1 - 1 / referenceRatio);
    final before = _profile(joinX - blend);
    final afterAngle = arcStart - blend;
    final after = center + Offset(math.cos(afterAngle), math.sin(afterAngle)) * radius;
    final vEnd = -exponent * math.log(before.point.dx / referenceRatio);
    final vStart = 16 - _log1p(-1 / referenceRatio);
    var previous = _profile(referenceRatio * math.exp(-vStart / exponent));

    // The first three controls are collinear: zero curvature at the straight.
    // The final handle and previous control match the profile's tangent and
    // curvature exactly. The very short flat tail vanishes at the circle limit.
    final tangentX = -previous.drop / previous.slope;
    final control2X = previous.point.dx - tangentX;
    final tangentLength = math.sqrt(tangentX * tangentX + previous.drop * previous.drop);
    final control1X =
        control2X - 1.5 * previous.curvature * tangentLength * tangentLength * tangentLength / previous.drop;
    final start = Offset(control1X * control1X / control2X, 1);
    _cubic(const Offset(0, 1), Offset(start.dx / 3, 1), Offset(start.dx * (2 / 3), 1), start);
    _cubic(start, Offset(control1X, 1), Offset(control2X, 1), previous.point);

    for (var i = 1; i <= _shoulderIntervals; i++) {
      final next = _profile(referenceRatio * math.exp(-(vStart + (vEnd - vStart) * i / _shoulderIntervals) / exponent));
      final dx = next.point.dx - previous.point.dx;
      final velocity0 = Offset(dx, dx * previous.slope);
      final velocity1 = Offset(dx, dx * next.slope);
      _quintic(
        previous.point,
        previous.point + velocity0 * 0.2,
        previous.point + velocity0 * 0.4 + Offset(0, dx * dx * previous.second / 20),
        next.point - velocity1 * 0.4 + Offset(0, dx * dx * next.second / 20),
        next.point - velocity1 * 0.2,
        next.point,
      );
      previous = next;
    }

    _join(
      before.point,
      before.tangent,
      before.curvature,
      after,
      Offset(math.sin(afterAngle), -math.cos(afterAngle)),
      1 / radius,
    );
    _arc(center, radius, afterAngle, arcEnd + blend);
    _join(
      center + Offset(math.cos(arcEnd + blend), math.sin(arcEnd + blend)) * radius,
      Offset(math.sin(arcEnd + blend), -math.cos(arcEnd + blend)),
      1 / radius,
      diagonal,
      const Offset(_rootHalf, -_rootHalf),
      1,
    );
    _arc(Offset(referenceRatio - 1, 0), 1, math.pi / 4, 0);
  }

  Path create(Rect rect, double extension, {void Function(MateoBorderCubic)? onCubic}) {
    if (!exponent.isFinite || !joinFactor.isFinite) return Path();
    if (referenceRatio == 1) {
      _arc(Offset.zero, 1, math.pi / 2, 0);
    } else {
      _buildQuarter();
    }
    final path = Path();
    final halfShort = rect.shortestSide / 2;
    final horizontal = rect.width >= rect.height;
    final centerX = rect.center.dx;
    final centerY = rect.center.dy;
    double x(Offset point, double sx, double sy) =>
        centerX + (horizontal ? (point.dx + extension) * sx : point.dy * sy) * halfShort;
    double y(Offset point, double sx, double sy) =>
        centerY + (horizontal ? -point.dy * sy : (point.dx + extension) * sx) * halfShort;
    if (onCubic == null) path.moveTo(x(const Offset(0, 1), 1, 1), y(const Offset(0, 1), 1, 1));
    for (final (sx, sy, reverse) in [(1.0, 1.0, false), (1.0, -1.0, true), (-1.0, -1.0, false), (-1.0, 1.0, true)]) {
      if (!reverse && onCubic == null) {
        path.lineTo(x(const Offset(0, 1), sx, sy), y(const Offset(0, 1), sx, sy));
      }
      for (var i = 0; i < _curves.length; i++) {
        final curve = _curves[reverse ? _curves.length - 1 - i : i];
        final control1 = reverse ? curve.control2 : curve.control1;
        final control2 = reverse ? curve.control1 : curve.control2;
        final end = reverse ? curve.start : curve.end;
        if (onCubic != null) {
          final start = reverse ? curve.end : curve.start;
          onCubic((
            start: Offset(x(start, sx, sy), y(start, sx, sy)),
            control1: Offset(x(control1, sx, sy), y(control1, sx, sy)),
            control2: Offset(x(control2, sx, sy), y(control2, sx, sy)),
            end: Offset(x(end, sx, sy), y(end, sx, sy)),
          ));
        } else {
          path.cubicTo(
            x(control1, sx, sy),
            y(control1, sx, sy),
            x(control2, sx, sy),
            y(control2, sx, sy),
            x(end, sx, sy),
            y(end, sx, sy),
          );
        }
      }
    }
    if (onCubic == null) path.close();
    return path;
  }
}
