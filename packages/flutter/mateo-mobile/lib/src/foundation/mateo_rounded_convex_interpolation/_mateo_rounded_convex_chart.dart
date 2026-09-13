part of 'mateo_rounded_convex_evaluator.dart';

@internal
MateoRoundedConvexDescription mateoRoundedConvexDescribePoints(List<Offset> points, Size size) {
  final top = points.map((p) => p.dy).reduce(math.min);
  final support = <int>[
    for (var i = 0; i < points.length; i++)
      if ((points[i].dy - top).abs() < 1e-10) i,
  ];
  final first = support.reduce((a, b) => points[a].dx < points[b].dx ? a : b);
  final last = support.reduce((a, b) => points[a].dx > points[b].dx ? a : b);
  final start = Offset((points[first].dx + points[last].dx) / 2, top);
  final ring = <Offset>[start];
  if ((points[last] - start).distance > 1e-12) ring.add(points[last]);
  var index = (last + 1) % points.length;
  while (index != first) {
    ring.add(points[index]);
    index = (index + 1) % points.length;
  }
  if ((points[first] - start).distance > 1e-12) ring.add(points[first]);
  if ((ring.last - start).distance < 1e-12) ring.removeLast();
  var perimeter = 0.0;
  var previous = double.negativeInfinity;
  // Packed edges retain arc start/end, tangent angle, start x/y and delta x/y.
  // These numeric samples do not need an object and temporary Offsets per edge.
  const fieldsPerEdge = 7;
  final edges = Float64List(ring.length * fieldsPerEdge);
  var edgeCount = 0;
  for (var i = 0; i < ring.length; i++) {
    final start = ring[i];
    final end = ring[(i + 1) % ring.length];
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy);
    if (length < 1e-12) continue;
    var angle = math.atan2(dy, dx);
    while (angle < previous - 1e-5) {
      angle += mateoRoundedConvexTau;
    }
    angle = math.max(angle, previous);
    final offset = fieldsPerEdge * edgeCount++;
    edges[offset] = perimeter;
    edges[offset + 1] = perimeter + length;
    edges[offset + 2] = angle;
    edges[offset + 3] = start.dx;
    edges[offset + 4] = start.dy;
    edges[offset + 5] = dx;
    edges[offset + 6] = dy;
    perimeter += length;
    previous = angle;
  }
  // Read the source edge/vertex directly, without an allocated route-piece
  // list or a second lookup from an interpolated arc coordinate.
  final routeEnds = Float64List(edgeCount);
  var mean = 0.0;
  for (var i = 0; i < edgeCount; i++) {
    final offset = fieldsPerEdge * i;
    final low = edges[offset] / perimeter;
    final high = edges[offset + 1] / perimeter;
    edges[offset] = low;
    edges[offset + 1] = high;
    final angle = edges[offset + 2];
    routeEnds[i] = (high + angle / mateoRoundedConvexTau) / 2;
    mean += (high - low) * angle;
  }
  final phase = (mean / mateoRoundedConvexTau - .5) / 2;
  ({double angle, int edge, double fraction}) read(double route) {
    final lap = route.floorToDouble();
    final u = route - lap;
    var low = 0;
    var high = edgeCount;
    while (low < high) {
      final middle = (low + high) ~/ 2;
      if (routeEnds[middle] <= u) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    if (low == edgeCount) {
      final previousAngle = edges[fieldsPerEdge * (edgeCount - 1) + 2];
      final fraction = (u - routeEnds.last) / (1 - routeEnds.last);
      return (
        angle: previousAngle + fraction * (mateoRoundedConvexTau - previousAngle) + lap * mateoRoundedConvexTau,
        edge: 0,
        fraction: 0,
      );
    }
    final offset = fieldsPerEdge * low;
    final angle = edges[offset + 2];
    final routeStart = (edges[offset] + angle / mateoRoundedConvexTau) / 2;
    if (u >= routeStart) {
      return (
        angle: angle + lap * mateoRoundedConvexTau,
        edge: low,
        fraction: (u - routeStart) / (routeEnds[low] - routeStart),
      );
    }
    final previousAngle = low == 0 ? 0.0 : edges[offset - fieldsPerEdge + 2];
    final previousEnd = low == 0 ? 0.0 : routeEnds[low - 1];
    final fraction = (u - previousEnd) / (routeStart - previousEnd);
    return (
      angle: previousAngle + fraction * (angle - previousAngle) + lap * mateoRoundedConvexTau,
      edge: low,
      fraction: 0,
    );
  }

  const count = mateoRoundedConvexIntervals;
  final positions = Float64List((count + 1) * 2);
  for (var i = 0; i <= count; i++) {
    final sample = read(i / count - phase);
    final offset = fieldsPerEdge * sample.edge;
    positions[2 * i] = edges[offset + 3] + edges[offset + 5] * sample.fraction;
    positions[2 * i + 1] = edges[offset + 4] + edges[offset + 6] * sample.fraction;
  }
  final angles = Float64List(count);
  final speeds = Float64List(count);
  final polygon = Float64List(count * 2);
  for (var i = 0; i < count; i++) {
    final dx = positions[2 * i + 2] - positions[2 * i];
    final dy = positions[2 * i + 3] - positions[2 * i + 1];
    final length = math.sqrt(dx * dx + dy * dy);
    final tangent = read((i + .5) / count - phase).angle;
    var angle = length > 1e-12 ? math.atan2(dy, dx) : tangent;
    while (angle < tangent - math.pi) {
      angle += mateoRoundedConvexTau;
    }
    while (angle > tangent + math.pi) {
      angle -= mateoRoundedConvexTau;
    }
    angles[i] = angle;
    speeds[i] = math.max(length * count, mateoRoundedConvexPreparedMinimum);
    polygon[2 * i] = positions[2 * i];
    polygon[2 * i + 1] = positions[2 * i + 1];
  }
  mateoRoundedConvexFitPoints(polygon, size.width / size.longestSide, size.height / size.longestSide);
  final sites = mateoRoundedConvexArcSites(polygon, mateoRoundedConvexLocations);
  final turns = Float64List(count);
  var totalTurn = 0.0;
  for (var i = 0; i < count; i++) {
    turns[i] = math.max(0, angles[(i + 1) % count] + (i == count - 1 ? mateoRoundedConvexTau : 0) - angles[i]);
    totalTurn += turns[i];
  }
  for (var i = 0; i < count; i++) {
    turns[i] = (1 - .0001) * turns[i] * mateoRoundedConvexTau / totalTurn + .0001 * mateoRoundedConvexTau / count;
  }
  final spacings = Float64List(mateoRoundedConvexLocations);
  for (var i = 0; i < spacings.length; i++) {
    spacings[i] = math.max(
      mateoRoundedConvexPreparedMinimum,
      sites[(i + 1) % sites.length] + (i == sites.length - 1 ? 1 : 0) - sites[i],
    );
  }
  if (!angles[0].isFinite || [turns, speeds, spacings].any((values) => values.any((v) => !v.isFinite || v <= 0))) {
    throw ArgumentError('The border cannot produce a finite, positive prepared description.');
  }
  return (
    width: size.width,
    height: size.height,
    angle: angles[0],
    turns: turns,
    speeds: speeds,
    spacings: spacings,
    outline: null,
  );
}
