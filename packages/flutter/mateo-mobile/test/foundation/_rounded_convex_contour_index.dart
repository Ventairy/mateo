part of 'mateo_rounded_convex_interpolation_test.dart';

// Test-only spatial index for the two-sided endpoint quality check.
final class _MateoRoundedConvexContourIndex {
  _MateoRoundedConvexContourIndex(this.points, this.start, this.end) {
    for (var i = start; i <= end; i++) {
      final point = points[i % points.length];
      left = math.min(left, point.dx);
      right = math.max(right, point.dx);
      top = math.min(top, point.dy);
      bottom = math.max(bottom, point.dy);
    }
    if (end - start > 8) {
      final middle = (start + end) ~/ 2;
      before = _MateoRoundedConvexContourIndex(points, start, middle);
      after = _MateoRoundedConvexContourIndex(points, middle, end);
    }
  }

  final List<Offset> points;
  final int start;
  final int end;
  double left = double.infinity;
  double right = double.negativeInfinity;
  double top = double.infinity;
  double bottom = double.negativeInfinity;
  _MateoRoundedConvexContourIndex? before;
  _MateoRoundedConvexContourIndex? after;

  bool isNear(Offset point, double squaredTolerance) {
    final dx = math.max(0, math.max(left - point.dx, point.dx - right));
    final dy = math.max(0, math.max(top - point.dy, point.dy - bottom));
    if (dx * dx + dy * dy > squaredTolerance) return false;
    if (before != null) return before!.isNear(point, squaredTolerance) || after!.isNear(point, squaredTolerance);
    for (var i = start; i < end; i++) {
      final a = points[i];
      final delta = points[(i + 1) % points.length] - a;
      final offset = point - a;
      final projection = delta.distanceSquared == 0
          ? 0.0
          : ((offset.dx * delta.dx + offset.dy * delta.dy) / delta.distanceSquared).clamp(0.0, 1.0);
      if ((offset - delta * projection).distanceSquared <= squaredTolerance) return true;
    }
    return false;
  }
}
