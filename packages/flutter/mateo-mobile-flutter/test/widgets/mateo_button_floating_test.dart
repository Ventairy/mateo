import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  Widget button({
    FutureOr<void> Function()? onPressed,
    bool isLoading = false,
    double size = 53,
    double? hitAreaSize,
    double iconSize = 22,
    MateoButtonColorScheme? colorScheme,
    MateoIconButtonIconBuilder? iconBuilder,
  }) => TestApp(
    child: Center(
      child: MateoButton(
        onPressed: onPressed,
        isLoading: isLoading,
        presentation: MateoButtonPresentation.icon(
          variant: MateoButtonVariant.primary.base,
          elevation: 1,
          semanticLabel: 'Go back',
          buttonSize: size,
          hitAreaSize: hitAreaSize,
          iconSize: iconSize,
          colorScheme: colorScheme,
          iconBuilder:
              iconBuilder ?? (state) => Icon(Icons.arrow_back, color: state.foregroundColor, size: state.iconSize),
        ),
      ),
    ),
  );

  testWidgets('when an elevated icon button is used, it should preserve dimensions and themed colors', (
    tester,
  ) async {
    MateoIconButtonIconState? state;
    await tester.pumpWidget(
      button(
        onPressed: () {},
        iconBuilder: (value) {
          state = value;
          return const Icon(Icons.arrow_back);
        },
      ),
    );
    expect(tester.getSize(find.byKey(const Key('mateo_button_container'))), const Size.square(53));
    expect(tester.getSize(find.byKey(const Key('mateo_button_icon_box'))), const Size.square(22));
    expect(state!.backgroundColor, mateoTestColorScheme.buttons.primary.base.background);
    expect(state!.foregroundColor, mateoTestColorScheme.buttons.primary.base.foreground);
    expect(state!.elevation, 1);
    expect(tester.widget<MateoTap>(find.byType(MateoTap)).animation, MateoTapAnimationType.scale);
  });

  testWidgets('when a larger target is supplied, it should center the circle and activate the outer area', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      button(
        size: 40,
        hitAreaSize: 60,
        iconSize: 16,
        onPressed: () {
          calls++;
        },
      ),
    );
    final target = find.byKey(const Key('mateo_button_tap_target'));
    final circle = find.byKey(const Key('mateo_button_container'));
    expect(tester.getSize(target), const Size.square(60));
    expect(tester.getSize(circle), const Size.square(40));
    expect(tester.getCenter(target), tester.getCenter(circle));
    await tester.tapAt(tester.getTopLeft(target) + const Offset(1, 30));
    expect(calls, 1);
  });

  testWidgets('when disabled, it should expose disabled semantics and scheme colors', (tester) async {
    final semantics = tester.ensureSemantics();
    MateoIconButtonIconState? state;
    await tester.pumpWidget(
      button(
        iconBuilder: (value) {
          state = value;
          return const Icon(Icons.arrow_back);
        },
      ),
    );
    expect(state!.isEnabled, isFalse);
    expect(state!.backgroundColor, mateoTestColorScheme.buttons.primary.base.backgroundDisabled);
    expect(state!.foregroundColor, mateoTestColorScheme.buttons.primary.base.foregroundDisabled);
    expect(
      tester.getSemantics(find.byType(MateoTap)),
      matchesSemantics(
        label: 'Go back',
        isButton: true,
        hasEnabledState: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('when a scheme overrides an elevated button, it should retain shadows and use overridden state colors', (
    tester,
  ) async {
    final scheme = mateoTestColorScheme.buttons.primary.base.copyWith(
      background: Colors.blue,
      foreground: Colors.yellow,
      backgroundPressed: Colors.orange,
    );
    MateoIconButtonIconState? state;
    await tester.pumpWidget(
      button(
        onPressed: () {},
        colorScheme: scheme,
        iconBuilder: (value) {
          state = value;
          return const Icon(Icons.arrow_back);
        },
      ),
    );
    expect(state!.backgroundColor, Colors.blue);
    expect(state!.foregroundColor, Colors.yellow);
    expect(state!.elevation, 1);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(MateoButton)));
    await tester.pump();
    expect(state!.backgroundColor, Colors.orange);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'when asynchronous work overlaps external loading, it should prevent repeated presses until both finish',
    (tester) async {
      final completion = Completer<void>();
      var calls = 0;
      Future<void> press() {
        calls++;
        return completion.future;
      }

      await tester.pumpWidget(button(onPressed: press));
      await tester.tap(find.byType(MateoButton));
      await tester.pump(const Duration(milliseconds: 51));
      await tester.pump(const Duration(milliseconds: 301));
      expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
      await tester.tap(find.byType(MateoButton));
      expect(calls, 1);
      await tester.pumpWidget(button(onPressed: press, isLoading: true));
      completion.complete();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
      await tester.pumpWidget(button(onPressed: press));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
    },
  );

  testWidgets('when reduced motion is enabled, it should switch loading without transitions', (tester) async {
    final completion = Completer<void>();
    await tester.pumpWidget(
      TestApp(
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MateoButton(
            onPressed: () => completion.future,
            presentation: MateoButtonPresentation.icon(
              variant: MateoButtonVariant.primary.base,
              elevation: 1,
              semanticLabel: 'Go back',
              iconBuilder: (_) => const Icon(Icons.arrow_back),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(MateoButton));
    await tester.pump(const Duration(milliseconds: 51));
    expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
    completion.complete();
    await tester.pump();
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  test('when a target is smaller than its circle, it should reject the presentation', () {
    expect(
      () => MateoButtonPresentation.icon(
        variant: MateoButtonVariant.primary.base,
        elevation: 1,
        buttonSize: 53,
        hitAreaSize: 40,
        iconBuilder: (_) => const Icon(Icons.add),
      ),
      throwsAssertionError,
    );
  });
}
