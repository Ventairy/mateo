import 'dart:convert';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile_draft/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette.white);

Future<void> main() async {
  final interpolation = MateoRoundedConvexInterpolation(
    begin: (shape: const MateoCapsuleBorder(), size: const Size(144, 48)),
    end: (shape: const MateoRoundedRectangleBorder(radius: 24), size: const Size(240, 280)),
  );
  Widget scenario(String name, ShapeBorder border, Size size) => GoldenTestScenario(
    name: name,
    child: SizedBox(
      width: 300,
      height: 340,
      child: Center(
        child: DecoratedBox(
          decoration: ShapeDecoration(color: _theme.colorScheme.accent, shape: border),
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: border),
            child: SizedBox.fromSize(
              size: size,
              child: Align(
                alignment: .centerLeft,
                child: FractionallySizedBox(
                  widthFactor: .5,
                  heightFactor: 1,
                  child: ColoredBox(color: _theme.colorScheme.text.primary),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await goldenTest(
    'when a surface changes outline, it should preserve faithful endpoint fills and clips',
    fileName: 'mateo_rounded_convex_interpolation',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(
          columns: 3,
          children: [
            scenario('Native beginning', interpolation.begin.shape, interpolation.begin.size),
            for (final t in [0.0, .00001, .5, .99999, 1.0])
              scenario('Progress $t', interpolation.lerp(t).border, interpolation.lerp(t).size),
            scenario('Native ending', interpolation.end.shape, interpolation.end.size),
            for (final t in [-.1, 1.1])
              scenario('Rebound $t', interpolation.lerp(t).border, interpolation.lerp(t).size),
          ],
        ),
      ),
    ),
  );
  final reference = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-convex-interpolation/reference.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final outlines = {
    for (final raw in reference['endpoints'] as List<dynamic>) (raw as Map<String, dynamic>)['id'] as String: raw,
  };
  final shoulders = <Widget>[];
  for (final id in ['soft-triangle', 'soft-pentagon', 'kite']) {
    final data = outlines[id]!;
    final transition = MateoRoundedConvexInterpolation(
      begin: interpolation.begin,
      end: (
        shape: _FixtureBorder(data['cubics'] as List<dynamic>),
        size: Size((data['width'] as num).toDouble(), (data['height'] as num).toDouble()),
      ),
    );
    for (final t in [.25, .5, .75]) {
      final frame = transition.lerp(t);
      shoulders.add(scenario('$id at $t', frame.border, frame.size));
    }
  }
  await goldenTest(
    'when straight sides meet different corners, shoulders should round with matching fills and clips',
    fileName: 'mateo_rounded_convex_interpolation_shoulders',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(columns: 3, children: shoulders),
      ),
    ),
  );
  final sources = jsonDecode(
    File('../../../design-system/foundation/assets/rounded-convex-interpolation/source-outlines.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>;
  final rows = {
    for (final raw in sources['shapes'] as List<dynamic>) (raw as Map<String, dynamic>)['id'] as String: raw,
  };
  ({ShapeBorder shape, Size size}) endpoint(String id) {
    final data = rows[id]!;
    return (
      shape: _FixtureBorder(data['cubics'] as List<dynamic>),
      size: Size((data['width'] as num).toDouble(), (data['height'] as num).toDouble()),
    );
  }

  final movement = <Widget>[];
  for (final (a, b) in [('triangle', 'hexagon'), ('soft-triangle', 'soft-hexagon'), ('pentagon', 'triangle')]) {
    final transition = MateoRoundedConvexInterpolation(begin: endpoint(a), end: endpoint(b));
    for (final t in [.25, .5, .75]) {
      final frame = transition.lerp(t);
      movement.add(scenario('$a to $b at $t', frame.border, frame.size));
    }
  }
  await goldenTest(
    'when triangles change outline, it should keep corners and sides in one rounded transition',
    fileName: 'mateo_rounded_convex_interpolation_movement',
    builder: () => MateoTheme(
      data: _theme,
      child: ColoredBox(
        color: _theme.colorScheme.background,
        child: GoldenTestGroup(columns: 3, children: movement),
      ),
    ),
  );
}

final class _FixtureBorder extends ShapeBorder {
  const _FixtureBorder(this.cubics);
  final List<dynamic> cubics;
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  ShapeBorder scale(double t) => this;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Offset point(dynamic raw) {
      final p = raw as List<dynamic>;
      return Offset(
        rect.left + ((p[0] as num).toDouble() + .5) * rect.width,
        rect.top + ((p[1] as num).toDouble() + .5) * rect.height,
      );
    }

    final first = point((cubics.first as List<dynamic>).first);
    final path = Path()..moveTo(first.dx, first.dy);
    for (final raw in cubics) {
      final c = raw as List<dynamic>;
      final a = point(c[1]);
      final b = point(c[2]);
      final end = point(c[3]);
      path.cubicTo(a.dx, a.dy, b.dx, b.dy, end.dx, end.dy);
    }
    return path..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
