import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

part '_icon_recording_canvas.dart';

void main() {
  const red = Color(0xFFFF0000);
  const blue = Color(0xFF0000FF);
  Widget host(Widget child) => Directionality(
    textDirection: .ltr,
    child: Center(child: child),
  );
  Size painterSize(WidgetTester tester) => tester.getSize(find.byType(CustomPaint));
  List<Color> painterColors(WidgetTester tester) {
    final canvas = _IconRecordingCanvas();
    tester.widget<CustomPaint>(find.byType(CustomPaint)).painter!.paint(canvas, painterSize(tester));
    return canvas.colors;
  }

  Color painterColor(WidgetTester tester) => painterColors(tester).first;

  test('when background size is configured, it should support const values and reject invalid dimensions', () {
    const scope = MateoIconScope(sizeWithBackground: 42, child: SizedBox());
    expect(scope.sizeWithBackground, 42);
    for (final invalid in [-1.0, double.infinity, double.nan]) {
      expect(() => MateoIconScope(sizeWithBackground: invalid, child: const SizedBox()), throwsAssertionError);
    }
  });

  testWidgets('when scopes nest and update, background size should inherit independently of ordinary size', (
    tester,
  ) async {
    const child = MateoIconScope(size: 20, child: MateoIcon(.cross, backgroundColor: blue));
    for (final backgroundSize in [42.0, 34.0, null]) {
      await tester.pumpWidget(host(MateoIconScope(size: 30, sizeWithBackground: backgroundSize, child: child)));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(backgroundSize ?? 20));
    }
    await tester.pumpWidget(
      host(
        const MateoIconScope(
          sizeWithBackground: 42,
          child: MateoIconScope(sizeWithBackground: 34, child: MateoIcon(.cross, backgroundColor: blue)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(34));
  });

  testWidgets('when background presence changes, it should select the matching scoped size while explicit size wins', (
    tester,
  ) async {
    for (final background in [null, blue, null]) {
      await tester.pumpWidget(
        host(
          MateoIconScope(
            size: 30,
            sizeWithBackground: 42,
            child: MateoIcon(.cross, backgroundColor: background),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(background == null ? 30 : 42));
    }
    for (final explicitSize in [0.0, 18.0]) {
      await tester.pumpWidget(
        host(
          MateoIconScope(
            size: 30,
            sizeWithBackground: 42,
            child: MateoIcon(.cross, size: explicitSize, backgroundColor: blue),
          ),
        ),
      );
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(explicitSize));
    }
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 24,
          height: 24,
          child: MateoIconScope(sizeWithBackground: 42, child: MateoIcon(.cross, backgroundColor: blue)),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(24));
  });

  testWidgets('when coloring every catalog icon, it should recolor every paint through explicit and inherited colors', (
    tester,
  ) async {
    for (final icon in MateoIconData.values) {
      for (final explicit in [true, false]) {
        await tester.pumpWidget(
          host(
            MateoIconScope(
              color: blue,
              child: MateoIcon(icon, color: explicit ? red : null),
            ),
          ),
        );
        expect(tester.takeException(), isNull, reason: icon.name);
        final colors = painterColors(tester);
        expect(colors, isNotEmpty, reason: icon.name);
        expect(colors, everyElement(explicit ? red : blue), reason: icon.name);
      }
    }
  });

  Rect boundsInIcon(WidgetTester tester, Finder finder) {
    final child = tester.renderObject<RenderBox>(finder);
    final box = tester.renderObject<RenderBox>(find.byType(MateoIcon));
    return MatrixUtils.transformRect(child.getTransformTo(box), Offset.zero & child.size);
  }

  testWidgets('when sizing artwork, it should resolve square sizes and respect parent constraints', (tester) async {
    await tester.pumpWidget(host(const MateoIcon(.arrowDown)));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(20));
    await tester.pumpWidget(host(const MateoIcon(.arrowDown, size: 40)));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(40));
    expect(boundsInIcon(tester, find.byType(CustomPaint)), const Rect.fromLTWH(0, 0, 40, 40));
    await tester.pumpWidget(
      host(const SizedBox(width: 10, height: 8, child: MateoIcon(.arrowDown, size: 40))),
    );
    expect(tester.getSize(find.byType(MateoIcon)), const Size(10, 8));
    expect(boundsInIcon(tester, find.byType(CustomPaint)), const Rect.fromLTWH(1, 0, 8, 8));
  });

  testWidgets('when nesting scopes, it should inherit and update size and color independently', (tester) async {
    const child = MateoIconScope(child: MateoIcon(.cross));
    for (final size in [24.0, 32.0]) {
      await tester.pumpWidget(host(MateoIconScope(size: size, color: red, child: child)));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(size));
      expect(painterColor(tester), red);
    }
    const override = MateoIconScope(size: 18, child: MateoIcon(.cross));
    for (final color in [red, blue]) {
      await tester.pumpWidget(host(MateoIconScope(size: 32, color: color, child: override)));
      expect(tester.getSize(find.byType(MateoIcon)), const Size.square(18));
      expect(painterColor(tester), color);
    }
  });

  testWidgets('when explicit values exist, it should override each inherited property', (tester) async {
    await tester.pumpWidget(
      host(
        const MateoIconScope(
          size: 24,
          color: red,
          child: MateoIcon(.cross, size: 16, color: blue),
        ),
      ),
    );
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(16));
    expect(painterColor(tester), blue);
  });

  testWidgets('when a background is supplied, it should contain the padded artwork in a centered circle', (
    tester,
  ) async {
    for (final size in [20.0, 24.0, 48.0]) {
      await tester.pumpWidget(host(MateoIcon(.arrowUp, size: size, backgroundColor: blue)));
      expect(tester.getSize(find.byType(MateoIcon)), Size.square(size));
      expect(boundsInIcon(tester, find.byType(DecoratedBox)), Rect.fromLTWH(0, 0, size, size));
      expect(
        boundsInIcon(tester, find.byType(CustomPaint)),
        rectMoreOrLessEquals(Rect.fromLTWH(size * 0.2, size * 0.2, size * 0.6, size * 0.6)),
      );
      final decoration = tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, blue);
    }
    await tester.pumpWidget(
      host(const SizedBox(width: 40, height: 24, child: MateoIcon(.arrowUp, size: 48, backgroundColor: blue))),
    );
    expect(boundsInIcon(tester, find.byType(DecoratedBox)), const Rect.fromLTWH(8, 0, 24, 24));
    expect(
      boundsInIcon(tester, find.byType(CustomPaint)),
      rectMoreOrLessEquals(const Rect.fromLTWH(12.8, 4.8, 14.4, 14.4)),
    );
    await tester.pumpWidget(host(const MateoIconScope(size: 24, child: MateoIcon(.arrowUp, backgroundColor: blue))));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(24));
    await tester.pumpWidget(host(const MateoIcon(.arrowUp, backgroundColor: blue)));
    expect(tester.getSize(find.byType(MateoIcon)), const Size.square(20));
  });

  testWidgets('when size is zero, it should render empty with or without a background', (tester) async {
    for (final background in [null, blue]) {
      await tester.pumpWidget(host(MateoIcon(.cross, size: 0, backgroundColor: background)));
      expect(tester.getSize(find.byType(MateoIcon)), Size.zero);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('when a background is supplied, it should preserve foreground precedence and background paint', (
    tester,
  ) async {
    final palette = MateoPalette();
    final theme = MateoThemeData.light(accentColor: blue, onAccent: palette.white);
    for (final background in [palette.black, palette.white, palette.black.withValues(alpha: 0.2)]) {
      for (final (explicit, scoped, textColor, themed, expected) in [
        (blue, red, red, true, blue),
        (null, red, blue, true, red),
        (null, null, blue, true, blue),
        (null, null, null, true, theme.colorScheme.text.primary),
        (null, null, null, false, palette.black),
      ]) {
        Widget child = MateoIcon(.cross, color: explicit, backgroundColor: background);
        if (scoped != null) child = MateoIconScope(color: scoped, child: child);
        if (textColor != null) {
          child = DefaultTextStyle(
            style: TextStyle(color: textColor),
            child: child,
          );
        }
        if (themed) child = MateoTheme(data: theme, child: child);
        await tester.pumpWidget(host(child));
        expect(painterColor(tester).toARGB32(), expected.toARGB32());
        expect((tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as BoxDecoration).color, background);
      }
    }
  });

  testWidgets('when text color changes, it should update a const icon', (tester) async {
    for (final color in [red, blue]) {
      await tester.pumpWidget(
        host(
          DefaultTextStyle(
            style: TextStyle(color: color),
            child: const MateoIcon(.cross),
          ),
        ),
      );
      expect(painterColor(tester), color);
    }
    await tester.pumpWidget(host(const MateoIcon(.cross)));
    expect(painterColor(tester), const Color(0xFF000000));
  });

  testWidgets('when theme changes, it should follow primary text unless explicitly overridden', (tester) async {
    for (final accent in [red, blue]) {
      final theme = MateoThemeData.light(accentColor: accent, onAccent: MateoPalette().white);
      await tester.pumpWidget(host(MateoTheme(data: theme, child: const MateoIcon(.cross))));
      expect(painterColor(tester).toARGB32(), theme.colorScheme.text.primary.toARGB32());
    }
  });

  testWidgets('when semantics are provided, it should announce only the supplied image label', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(host(const MateoIcon(.cross)));
    expect(find.bySemanticsLabel('Close'), findsNothing);
    await tester.pumpWidget(host(const MateoIcon(.cross, backgroundColor: blue, semanticLabel: 'Close')));
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    expect(tester.getSemantics(find.byType(MateoIcon)), matchesSemantics(label: 'Close', isImage: true));
    semantics.dispose();
  });

  testWidgets('when direction changes, it should mirror artwork automatically in RTL', (tester) async {
    for (final direction in [TextDirection.rtl, TextDirection.ltr]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: const Center(child: MateoIcon(.arrowLeft, backgroundColor: blue)),
        ),
      );
      expect(find.byType(Transform), direction == TextDirection.rtl ? findsOneWidget : findsNothing);
    }
    await tester.pumpWidget(const Center(child: MateoIcon(.arrowLeft)));
    expect(find.byType(Transform), findsNothing);
  });

  testWidgets('when 3D artwork is unavailable, it should throw for that icon', (tester) async {
    await tester.pumpWidget(host(const MateoIcon(.cross, style: .threeD)));
    expect(tester.takeException(), isA<UnsupportedError>());
  });

  test('when dimensions are invalid, it should reject them', () {
    expect(() => MateoIcon(.cross, size: -1), throwsAssertionError);
    expect(() => MateoIcon(.cross, size: double.nan), throwsAssertionError);
    expect(() => MateoIconScope(size: double.infinity, child: const SizedBox()), throwsAssertionError);
  });
}
