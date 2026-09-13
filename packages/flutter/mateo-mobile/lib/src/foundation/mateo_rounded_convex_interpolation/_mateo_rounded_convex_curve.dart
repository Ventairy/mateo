part of 'mateo_rounded_convex_evaluator.dart';

final class _MateoRoundedConvexCurve {
  _MateoRoundedConvexCurve({required this.intervals, required this.locations})
    : _prefix = .new(intervals),
      _polygon = .new(intervals * 2),
      _lengths = .new(intervals + 1),
      _controls = .new(locations * 2),
      _cubics = .new(locations * 8);

  final int intervals;
  final int locations;
  final Float64List _prefix;
  final Float64List _polygon;
  final Float64List _lengths;
  final Float64List _controls;
  final Float64List _cubics;

  Float64List reconstruct(MateoRoundedConvexDescription endpoint) {
    final width = endpoint.width;
    final height = endpoint.height;
    var totalTurn = 0.0;
    var totalWeight = 0.0;
    for (var i = 0; i < intervals; i++) {
      totalTurn += endpoint.turns[i];
      totalWeight += endpoint.speeds[i];
    }
    var angle = endpoint.angle;
    var x = 0.0;
    var y = 0.0;
    var prefix = 0.0;
    for (var i = 0; i < intervals; i++) {
      final weight = endpoint.speeds[i];
      _polygon[2 * i] = x;
      _polygon[2 * i + 1] = y;
      _prefix[i] = prefix;
      x += weight * math.cos(angle);
      y += weight * math.sin(angle);
      prefix += weight;
      angle += mateoRoundedConvexTau * endpoint.turns[i] / totalTurn;
    }
    // Apply weighted closure to prefix positions, combining correction and
    // bounds measurement without retaining a separate direction vector.
    final meanX = x / totalWeight;
    final meanY = y / totalWeight;
    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;
    for (var i = 0; i < intervals; i++) {
      final px = _polygon[2 * i] - _prefix[i] * meanX;
      final py = _polygon[2 * i + 1] - _prefix[i] * meanY;
      _polygon[2 * i] = px;
      _polygon[2 * i + 1] = py;
      minX = math.min(minX, px);
      maxX = math.max(maxX, px);
      minY = math.min(minY, py);
      maxY = math.max(maxY, py);
    }
    final extentX = maxX - minX;
    final extentY = maxY - minY;
    if (!extentX.isFinite || !extentY.isFinite || extentX <= 0 || extentY <= 0) {
      throw ArgumentError('The contour must have positive finite area.');
    }
    // Physical proportions affect arc lengths. Cubic construction and its final
    // fit commute with this affine transform, so keep the polygon untransformed.
    final longest = math.max(width, height);
    final scaleX = (width / longest) / extentX;
    final scaleY = (height / longest) / extentY;
    _lengths[0] = 0;
    for (var i = 0; i < intervals; i++) {
      final next = i + 1 == intervals ? 0 : i + 1;
      final dx = (_polygon[2 * next] - _polygon[2 * i]) * scaleX;
      final dy = (_polygon[2 * next + 1] - _polygon[2 * i + 1]) * scaleY;
      _lengths[i + 1] = _lengths[i] + math.sqrt(dx * dx + dy * dy);
    }
    final perimeter = _lengths.last;
    var totalGap = 0.0;
    for (var i = 0; i < locations; i++) {
      totalGap += endpoint.spacings[i];
    }
    var arc = 0.0;
    var edge = 0;
    for (var i = 0; i < locations; i++) {
      final target = perimeter * arc / totalGap;
      while (edge < intervals - 1 && _lengths[edge + 1] <= target) {
        edge++;
      }
      final fraction = (target - _lengths[edge]) / (_lengths[edge + 1] - _lengths[edge]);
      final next = (edge + 1) % intervals;
      for (var axis = 0; axis < 2; axis++) {
        _controls[2 * i + axis] = (1 - fraction) * _polygon[2 * edge + axis] + fraction * _polygon[2 * next + axis];
      }
      arc += endpoint.spacings[i];
    }
    // Borrowed until the next evaluation. The frame border copies these values
    // into its own native path before returning to a consumer.
    final cubics = _cubics;
    for (var i = 0; i < locations; i++) {
      final previous = (i + locations - 1) % locations;
      final next = (i + 1) % locations;
      final after = (i + 2) % locations;
      for (var axis = 0; axis < 2; axis++) {
        final a = _controls[2 * previous + axis];
        final b = _controls[2 * i + axis];
        final c = _controls[2 * next + axis];
        final d = _controls[2 * after + axis];
        cubics[8 * i + axis] = (a + 4 * b + c) / 6;
        cubics[8 * i + 2 + axis] = (2 * b + c) / 3;
        cubics[8 * i + 4 + axis] = (b + 2 * c) / 3;
        cubics[8 * i + 6 + axis] = (b + 4 * c + d) / 6;
      }
    }
    _fitCubics(cubics);
    return cubics;
  }

  static void _fitCubics(Float64List cubics) {
    for (var axis = 0; axis < 2; axis++) {
      var minimum = double.infinity;
      var maximum = double.negativeInfinity;
      void include(double value) {
        minimum = math.min(minimum, value);
        maximum = math.max(maximum, value);
      }

      for (var i = axis; i < cubics.length; i += 8) {
        final p0 = cubics[i];
        final p1 = cubics[i + 2];
        final p2 = cubics[i + 4];
        final p3 = cubics[i + 6];
        include(p0);
        include(p3);
        // The derivative Bezier controls sharing a sign prove monotonicity.
        if ((p0 <= p1 && p1 <= p2 && p2 <= p3) || (p0 >= p1 && p1 >= p2 && p2 >= p3)) continue;
        final a = -p0 + 3 * p1 - 3 * p2 + p3;
        final b = 2 * (p0 - 2 * p1 + p2);
        final c = p1 - p0;
        void includeRoot(double t) {
          if (t <= 0 || t >= 1) return;
          final u = 1 - t;
          include(u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3);
        }

        if (a == 0) {
          if (b != 0) includeRoot(-c / b);
        } else {
          final discriminant = b * b - 4 * a * c;
          if (discriminant >= 0) {
            final q = -.5 * (b + (b < 0 ? -1 : 1) * math.sqrt(discriminant));
            includeRoot(q / a);
            if (q != 0) includeRoot(c / q);
          }
        }
      }
      final extent = maximum - minimum;
      if (!extent.isFinite || extent <= 0) throw ArgumentError('The interpolated contour is not representable.');
      final center = (minimum + maximum) / 2;
      for (var i = axis; i < cubics.length; i += 2) {
        cubics[i] = (cubics[i] - center) / extent;
      }
    }
  }
}
