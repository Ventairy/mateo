// Inspect private painter state without exposing implementation APIs.
// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
Widget _app(Widget child, {bool reduced = false, bool enabled = true, MateoThemeData? theme}) => Directionality(
  textDirection: .ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: TickerMode(
      enabled: enabled,
      child: MateoTheme(
        data: theme ?? _theme,
        child: Center(child: child),
      ),
    ),
  ),
);
Finder get _paint => find.descendant(of: find.byType(MateoLoadingIndicator), matching: find.byType(CustomPaint));
dynamic _painter(WidgetTester tester) => tester.widget<CustomPaint>(_paint).painter;

void main() {
  test('when dimensions are invalid, it should reject them', () {
    for (final value in [-1.0, double.infinity, double.nan]) {
      expect(
        () => MateoLoadingIndicatorPresentation.circular(color: _theme.colorScheme.accent, size: value),
        throwsAssertionError,
      );
      expect(
        () => MateoLoadingIndicatorPresentation.dots(color: _theme.colorScheme.accent, height: value),
        throwsAssertionError,
      );
    }
  });

  for (final circular in [true, false]) {
    final presentation = circular
        ? MateoLoadingIndicatorPresentation.circular(color: _theme.colorScheme.accent)
        : MateoLoadingIndicatorPresentation.dots(color: _theme.colorScheme.accent);
    final indicator = MateoLoadingIndicator(presentation: presentation, semanticLabel: 'Saving');
    final name = circular ? 'circular' : 'dots';
    testWidgets('when $name has unbounded space, it should retain intrinsic dimensions', (tester) async {
      await tester.pumpWidget(_app(UnconstrainedBox(child: indicator)));
      final size = tester.getSize(_paint);
      expect(size.height, circular ? 24 : 20);
      expect(size.width, closeTo(circular ? 24 : 20 / 3.9 * 8.7, 0.001));
      await tester.pumpWidget(_app(IntrinsicWidth(child: IntrinsicHeight(child: indicator))));
      expect(tester.takeException(), isNull);
    });
    testWidgets('when $name is constrained, it should respect available space', (tester) async {
      await tester.pumpWidget(_app(SizedBox(width: 8, height: 5, child: indicator)));
      final box = tester.renderObject<RenderBox>(_paint);
      final origin = box.localToGlobal(.zero);
      final end = box.localToGlobal(Offset(box.size.width, box.size.height));
      expect(end.dx - origin.dx, lessThanOrEqualTo(8.001));
      expect(end.dy - origin.dy, lessThanOrEqualTo(5.001));
      if (circular) {
        expect(box.size, const Size(8, 5));
        expect(end - origin, const Offset(8, 5));
      } else {
        expect((end.dx - origin.dx) / (end.dy - origin.dy), closeTo(8.7 / 3.9, 0.001));
      }
    });
    testWidgets('when $name has zero size, it should paint without errors', (tester) async {
      await tester.pumpWidget(
        _app(
          MateoLoadingIndicator(
            presentation: circular
                ? .circular(color: _theme.colorScheme.accent, size: 0)
                : .dots(color: _theme.colorScheme.accent, height: 0),
          ),
        ),
      );
      expect(tester.getSize(_paint), Size.zero);
      expect(tester.takeException(), isNull);
    });
    testWidgets('when $name animates, it should retain its widget layout and painter', (tester) async {
      await tester.pumpWidget(_app(indicator));
      await tester.pump();
      final widget = tester.widget(_paint);
      final painter = _painter(tester);
      final box = tester.renderObject<RenderBox>(_paint);
      final size = box.size;
      var repaints = 0;
      (painter as CustomPainter).addListener(() => repaints++);
      await tester.pump(const Duration(milliseconds: 200));
      expect(repaints, greaterThan(0));
      expect(identical(tester.widget(_paint), widget), isTrue);
      expect(identical(_painter(tester), painter), isTrue);
      expect(box.size, size);
      expect(box.debugNeedsLayout, isFalse);
    });
    testWidgets('when $name motion is disabled, it should stop and retain loading semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_app(indicator, reduced: true));
      expect(tester.binding.transientCallbackCount, 0);
      expect(find.bySemanticsLabel('Saving'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Saving')).getSemanticsData().role,
        SemanticsRole.loadingSpinner,
      );
      await tester.pumpWidget(_app(indicator));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      await tester.pumpWidget(_app(indicator, enabled: false));
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(_app(indicator));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      semantics.dispose();
    });
    testWidgets('when $name dependencies change in background, it should stay paused until resumed', (tester) async {
      await tester.pumpWidget(_app(indicator));
      tester.binding.handleAppLifecycleStateChanged(.inactive);
      await tester.pumpWidget(_app(indicator, reduced: true));
      await tester.pumpWidget(_app(indicator));
      expect(tester.binding.transientCallbackCount, 0);
      tester.binding.handleAppLifecycleStateChanged(.resumed);
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);
    });
  }
  for (final circular in [true, false]) {
    testWidgets(
      'when ${circular ? 'circular' : 'dots'} color changes, it should preserve supplied opacity without a theme',
      (tester) async {
        for (final color in [_theme.colorScheme.accent, _theme.colorScheme.text.primary.withValues(alpha: 0.5)]) {
          await tester.pumpWidget(
            Directionality(
              textDirection: .ltr,
              child: MateoLoadingIndicator(
                presentation: circular ? .circular(color: color) : .dots(color: color),
              ),
            ),
          );
          expect(_painter(tester).color, color);
          if (circular) expect(_painter(tester).trackColor, color.withValues(alpha: color.a * 0.27));
        }
      },
    );
  }
  testWidgets('when circular motion resumes, it should continue from its paused phase', (tester) async {
    final indicator = MateoLoadingIndicator(presentation: .circular(color: _theme.colorScheme.accent));
    await tester.pumpWidget(_app(indicator));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final progress = _painter(tester).progress as Animation<double>;
    final phase = progress.value;
    await tester.pumpWidget(_app(indicator, enabled: false));
    await tester.pump(const Duration(seconds: 2));
    expect(progress.value, phase);
    await tester.pumpWidget(_app(indicator));
    expect(progress.value, closeTo(phase, 0.001));
    await tester.pump(const Duration(milliseconds: 100));
    expect(progress.value, greaterThan(phase));
  });
  testWidgets('when presentation changes, it should restart with the new cycle', (tester) async {
    await tester.pumpWidget(_app(MateoLoadingIndicator(presentation: .circular(color: _theme.colorScheme.accent))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect((_painter(tester).progress as Animation<double>).value, closeTo(0.5, 0.01));
    await tester.pumpWidget(_app(MateoLoadingIndicator(presentation: .dots(color: _theme.colorScheme.accent))));
    await tester.pumpWidget(_app(MateoLoadingIndicator(presentation: .circular(color: _theme.colorScheme.accent))));
    expect((_painter(tester).progress as Animation<double>).value, 0);
  });
}
