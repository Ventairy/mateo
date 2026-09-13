part of 'mateo_rounded_convex_geometry.dart';

// Numeric endpoint geometry. It never retains a border or an interpolator.
@internal
final class MateoRoundedConvexEndpoint {
  MateoRoundedConvexEndpoint.fromPoints(this.points, double width, double height) : longest = math.max(width, height) {
    _outlineEdges = _edges(points, math.min(1e-10, longest * 1e-12));
    if (_outlineEdges.length < 3) throw ArgumentError('The contour must have positive area.');
    _flatFeatures = _features(_outlineEdges, width, height);
  }

  factory MateoRoundedConvexEndpoint.fromFrame(Float64List points, double width, double height) {
    final physical = [for (var i = 0; i < points.length; i += 2) Offset(points[i] * width, points[i + 1] * height)];
    // Repeated interruptions otherwise accumulate another endpoint's edges on
    // every redirect. Keep the current silhouette within the endpoint chord
    // budget, preserving extrema, without fitting or rounding it again.
    return MateoRoundedConvexEndpoint.fromPoints(
      _compactPolygon(physical, _tolerance(_flatness, math.max(width, height))),
      width,
      height,
    );
  }

  factory MateoRoundedConvexEndpoint.fromCubics(Float64List cubics, double width, double height) {
    final points = <Offset>[];
    final tolerance = _tolerance(_flatness, math.max(width, height));
    void flatten(Offset p0, Offset p1, Offset p2, Offset p3, int depth) {
      if (math.max(_distance(p1, p0, p3), _distance(p2, p0, p3)) <= tolerance) {
        points.add(p0);
        return;
      }
      if (depth >= 24) throw ArgumentError('The endpoint cannot be represented at the requested size.');
      final a = (p0 + p1) / 2;
      final b = (p1 + p2) / 2;
      final d = (p2 + p3) / 2;
      final e = (a + b) / 2;
      final f = (b + d) / 2;
      final m = (e + f) / 2;
      flatten(p0, a, e, m, depth + 1);
      flatten(m, f, d, p3, depth + 1);
    }

    Offset p(int i) => Offset(cubics[i] * width, cubics[i + 1] * height);
    for (var i = 0; i < cubics.length; i += 8) {
      flatten(p(i), p(i + 2), p(i + 4), p(i + 6), 0);
    }
    return MateoRoundedConvexEndpoint.fromPoints(points, width, height);
  }

  final List<Offset> points;
  final double longest;
  late final List<_Edge> _outlineEdges;
  late final List<_Feature> _flatFeatures;
}
