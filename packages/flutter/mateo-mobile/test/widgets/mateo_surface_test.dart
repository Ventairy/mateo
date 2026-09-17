import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  const color = Color(0xFF123456);
  Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) => Directionality(
    textDirection: direction,
    child: Center(child: child),
  );

  test('when shape configuration is omitted or compared, it should retain closed value defaults', () {
    expect(const MateoSurface(child: SizedBox()).shape, isNull);
    expect(const MateoSurface.scrollable(child: SizedBox()).shape, isNull);
    expect(const MateoViewSurface(child: SizedBox()).shape, isNull);
    expect(const MateoViewSurface.scrollable(child: SizedBox()).shape, isNull);
    expect(const MateoSurfaceShape.capsule(), const MateoSurfaceShape.capsule());
    expect(const MateoSurfaceShape.none(), isNot(const MateoSurfaceShape.capsule()));
    expect((const MateoSurfaceShape.none()).hashCode, (const MateoSurfaceShape.none()).hashCode);
    expect((const MateoSurfaceShape.capsule()).hashCode, (const MateoSurfaceShape.capsule()).hashCode);
    expect((const MateoViewSurfaceShape.none()).hashCode, (const MateoViewSurfaceShape.none()).hashCode);
  });

  testWidgets('when capsule proportions change, it should clip hit testing to the current outline', (tester) async {
    for (final size in [const Size(80, 80), const Size(108, 80), const Size(320, 40), const Size(40, 160)]) {
      var taps = 0;
      await tester.pumpWidget(
        host(
          MateoSurface(
            color: color,
            width: .custom(size.width),
            height: .custom(size.height),
            shape: const .capsule(),
            child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox.expand()),
          ),
        ),
      );
      final origin = tester.getTopLeft(find.byType(MateoSurface));
      await tester.tapAt(origin + const Offset(1, 1));
      expect(taps, 0);
      await tester.tapAt(origin + size.center(Offset.zero));
      expect(taps, 1);
    }
    var taps = 0;
    await tester.pumpWidget(
      host(
        MateoSurface(
          color: color,
          width: const .custom(80),
          height: const .custom(80),
          child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox.expand()),
        ),
      ),
    );
    await tester.tapAt(tester.getTopLeft(find.byType(MateoSurface)) + const Offset(1, 1));
    expect(taps, 1);
  });

  testWidgets('when dimensions are omitted, it should size around padded content', (tester) async {
    await tester.pumpWidget(
      host(const MateoSurface(color: color, padding: .all(10), child: SizedBox(width: 40, height: 20))),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(60, 40));
  });

  testWidgets('when dimensions are supplied, it should include padding and respect parent constraints', (tester) async {
    const child = SizedBox(key: ValueKey('content'));
    await tester.pumpWidget(
      host(const MateoSurface(color: color, width: .custom(100), height: .custom(80), padding: .all(10), child: child)),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(100, 80));
    expect(tester.getSize(find.byKey(const ValueKey('content'))), const Size(80, 60));
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 50,
          height: 30,
          child: MateoSurface(color: color, width: .custom(100), height: .custom(80), child: child),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoSurface)), const Size(50, 30));
    await tester.pumpWidget(
      host(const MateoSurface(color: color, width: .custom(0), height: .custom(0), child: child)),
    );
    expect(tester.getSize(find.byType(MateoSurface)), Size.zero);
  });

  testWidgets('when color is omitted, it should resolve the current Mateo background', (tester) async {
    final theme = MateoThemeData.light(accentColor: color, onAccent: MateoPalette().white);
    await tester.pumpWidget(
      host(
        MateoTheme(
          data: theme,
          child: const MateoSurface(child: SizedBox(width: 20, height: 20)),
        ),
      ),
    );
    expect(tester.widget<ColoredBox>(find.byType(ColoredBox)).color, theme.colorScheme.background);
    await tester.pumpWidget(host(const MateoSurface(color: color, child: SizedBox(width: 20, height: 20))));
    expect(tester.widget<ColoredBox>(find.byType(ColoredBox)).color, color);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when content reaches rounded corners, it should clip painting and hit testing', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        MateoSurface(
          color: color,
          width: const .custom(100),
          height: const .custom(100),
          shape: const .capsule(),
          child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox.expand()),
        ),
      ),
    );
    final origin = tester.getTopLeft(find.byType(MateoSurface));
    await tester.tapAt(origin + const Offset(1, 1));
    expect(taps, 0);
    await tester.tapAt(origin + const Offset(50, 50));
    expect(taps, 1);
    expect(
      tester.widgetList<ClipPath>(find.byType(ClipPath)).map((clip) => clip.clipBehavior),
      everyElement(Clip.antiAlias),
    );
  });

  testWidgets('when direction changes, it should resolve directional padding and retain its shape', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          const MateoSurface(
            color: color,
            width: .custom(100),
            height: .custom(80),
            shape: .capsule(),
            padding: EdgeInsetsDirectional.only(start: 12, end: 4),
            child: SizedBox(key: ValueKey('content')),
          ),
          direction: direction,
        ),
      );
      final origin = tester.getTopLeft(find.byType(MateoSurface));
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('content'))).dx - origin.dx,
        direction == TextDirection.ltr ? 12 : 4,
      );
      final clips = tester.widgetList<ClipPath>(find.byType(ClipPath));
      expect(
        clips.map((clip) => (clip.clipper! as ShapeBorderClipper).shape),
        everyElement(const MateoRoundedShapeBorder.capsule()),
      );
    }
  });

  testWidgets('when content has semantics, it should retain the child label and action', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        MateoSurface(
          color: color,
          child: Semantics(label: 'Open', button: true, onTap: () {}, child: const SizedBox(width: 40, height: 40)),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Open')),
      matchesSemantics(label: 'Open', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('when padding is negative, it should reject the invalid layout', (tester) async {
    await tester.pumpWidget(host(const MateoSurface(color: color, padding: .all(-1), child: SizedBox())));
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('when elevation changes, it should update shadows without changing layout or hit bounds', (tester) async {
    final theme = MateoThemeData.light(accentColor: color, onAccent: MateoPalette().white);
    var taps = 0;
    for (final elevation in [0.0, 0.5, 1.0, 2.0]) {
      await tester.pumpWidget(
        host(
          MateoTheme(
            data: theme,
            child: MateoSurface(
              width: const .custom(100),
              height: const .custom(80),
              elevation: MateoElevation(level: elevation),
              shape: const .capsule(),
              child: GestureDetector(behavior: .opaque, onTap: () => taps++, child: const SizedBox.expand()),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoSurface)), const Size(100, 80));
      final decoration = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<ShapeDecoration>()
          .single;
      expect(decoration.shadows, MateoElevation(level: elevation).toShadowList(palette: theme.palette));
      final clips = tester.widgetList<ClipPath>(find.byType(ClipPath));
      expect(clips.map((clip) => (clip.clipper! as ShapeBorderClipper).shape), everyElement(decoration.shape));
      expect(
        find.ancestor(
          of: find.byType(ClipPath).first,
          matching: find.byWidgetPredicate(
            (widget) => widget is DecoratedBox && widget.decoration is ShapeDecoration,
          ),
        ),
        findsOneWidget,
      );
      final origin = tester.getTopLeft(find.byType(MateoSurface));
      await tester.tapAt(origin + const Offset(50, 85));
      await tester.tapAt(origin + const Offset(1, 1));
      expect(taps, 0);
    }
  });

  testWidgets('when a raised surface has no theme, it should report the missing theme', (tester) async {
    await tester.pumpWidget(
      host(MateoSurface(color: color, elevation: MateoElevation(level: 1), child: const SizedBox())),
    );
    expect(tester.takeException(), isFlutterError);
  });
}
