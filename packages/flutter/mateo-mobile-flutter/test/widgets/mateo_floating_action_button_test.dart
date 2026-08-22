import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  late List<MethodCall> hapticCalls;

  setUp(() {
    hapticCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        hapticCalls.add(call);
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  group('MateoFloatingActionButton', () {
    testWidgets('when tapped, it should invoke onPressed once', (tester) async {
      var invocationCount = 0;

      await tester.pumpWidget(
        TestApp(child: _button(onPressed: () => invocationCount += 1)),
      );

      await tester.tap(find.byType(MateoFloatingActionButton));
      await tester.pump();

      expect(invocationCount, 1);
    });

    testWidgets(
      'when onPressed completes synchronously, it should not show the loading indicator',
      (tester) async {
        await tester.pumpWidget(TestApp(child: _button(onPressed: () {})));

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump(const Duration(milliseconds: 51));

        expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      },
    );

    testWidgets(
      'when onPressed returns a pending future, it should replace the icon with a circular loading indicator',
      (tester) async {
        final completer = Completer<void>();

        await tester.pumpWidget(
          TestApp(child: _button(onPressed: () => completer.future)),
        );

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump(const Duration(milliseconds: 51));
        await tester.pump(const Duration(milliseconds: 351));

        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsNothing);

        completer.complete();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 351));

        expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      },
    );

    testWidgets(
      'when onPressed future completes before the delay, it should keep the icon visible',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: _button(onPressed: () => Future<void>.value())),
        );

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 51));

        expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      },
    );

    testWidgets(
      'when a press future is pending, it should ignore repeated taps',
      (tester) async {
        final completer = Completer<void>();
        var invocationCount = 0;

        await tester.pumpWidget(
          TestApp(
            child: _button(
              onPressed: () {
                invocationCount += 1;
                return completer.future;
              },
            ),
          ),
        );

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump(const Duration(milliseconds: 51));
        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump();

        expect(invocationCount, 1);
        expect(
          tester
              .widget<Semantics>(
                find.byKey(const Key('mateo_floating_action_button_semantics')),
              )
              .properties
              .enabled,
          isFalse,
        );

        completer.complete();
        await tester.pump();
      },
    );

    testWidgets(
      'when isLoading is true, it should show the circular indicator and ignore taps',
      (tester) async {
        var invocationCount = 0;

        await tester.pumpWidget(
          TestApp(
            child: _button(
              isLoading: true,
              onPressed: () => invocationCount += 1,
            ),
          ),
        );

        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsNothing);

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump();

        expect(invocationCount, 0);
      },
    );

    testWidgets('when isLoading returns to false, it should restore the icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(child: _button(isLoading: true, onPressed: () {})),
      );

      await tester.pumpWidget(
        TestApp(child: _button(isLoading: false, onPressed: () {})),
      );
      await tester.pump(const Duration(milliseconds: 351));

      expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets(
      'when external loading overlaps a press future, it should wait for both sources before restoring the icon',
      (tester) async {
        final completer = Completer<void>();

        await tester.pumpWidget(
          TestApp(
            child: _button(isLoading: false, onPressed: () => completer.future),
          ),
        );
        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump(const Duration(milliseconds: 51));
        await tester.pump(const Duration(milliseconds: 351));

        await tester.pumpWidget(
          TestApp(
            child: _button(isLoading: true, onPressed: () => completer.future),
          ),
        );
        completer.complete();
        await tester.pump();

        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);

        await tester.pumpWidget(
          TestApp(
            child: _button(isLoading: false, onPressed: () => completer.future),
          ),
        );
        await tester.pump(const Duration(milliseconds: 351));

        expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      },
    );

    testWidgets(
      'when loading switches in and out, it should quickly scale and fade both contents',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: _button(isLoading: false, onPressed: () {})),
        );

        await tester.pumpWidget(
          TestApp(child: _button(isLoading: true, onPressed: () {})),
        );
        await tester.pump(const Duration(milliseconds: 175));

        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AnimatedSwitcher),
            matching: find.byType(ScaleTransition),
          ),
          findsNWidgets(2),
        );
        expect(
          find.descendant(
            of: find.byType(AnimatedSwitcher),
            matching: find.byType(FadeTransition),
          ),
          findsNWidgets(2),
        );

        await tester.pump(const Duration(milliseconds: 176));
        await tester.pumpWidget(
          TestApp(child: _button(isLoading: false, onPressed: () {})),
        );
        await tester.pump(const Duration(milliseconds: 175));

        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AnimatedSwitcher),
            matching: find.byType(ScaleTransition),
          ),
          findsNWidgets(2),
        );
        expect(
          find.descendant(
            of: find.byType(AnimatedSwitcher),
            matching: find.byType(FadeTransition),
          ),
          findsNWidgets(2),
        );

        await tester.pump(const Duration(milliseconds: 176));

        expect(find.byType(MateoCircularLoadingIndicator), findsNothing);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      },
    );

    testWidgets(
      'when loading switches with reduced motion, it should replace content immediately',
      (tester) async {
        Widget buildButton({required bool isLoading}) => TestApp(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: _button(isLoading: isLoading, onPressed: () {}),
          ),
        );

        await tester.pumpWidget(buildButton(isLoading: false));
        await tester.pumpWidget(buildButton(isLoading: true));

        expect(find.byType(AnimatedSwitcher), findsNothing);
        expect(find.byType(MateoCircularLoadingIndicator), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      },
    );

    testWidgets(
      'when loading, it should use the enabled foreground for the arc and a muted track',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: _button(isLoading: true, onPressed: () {})),
        );

        final indicator = tester.widget<MateoCircularLoadingIndicator>(
          find.byType(MateoCircularLoadingIndicator),
        );
        final foreground = mateoTestColorScheme.buttons.floating.foreground;

        expect(indicator.color, foreground);
        expect(indicator.trackColor, foreground.withValues(alpha: 0.24));
        expect(indicator.size, 30);
      },
    );

    testWidgets(
      'when the enlarged loading indicator exceeds the button inset, it should clamp its size',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoFloatingActionButton(
              semanticLabel: 'Create',
              size: 40,
              iconSize: 35,
              isLoading: true,
              iconBuilder: (state) => Icon(Icons.add, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(
          tester
              .widget<MateoCircularLoadingIndicator>(
                find.byType(MateoCircularLoadingIndicator),
              )
              .size,
          28,
        );
      },
    );

    testWidgets('when rendered, it should expose the provided semantic label', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: _button(onPressed: () {})));

      expect(
        tester
            .widget<Semantics>(
              find.byKey(const Key('mateo_floating_action_button_semantics')),
            )
            .properties
            .label,
        'Go back',
      );
    });

    testWidgets(
      'when onPressed is null, it should render disabled and ignore taps',
      (tester) async {
        await tester.pumpWidget(TestApp(child: _button(onPressed: null)));

        final semantics = tester.widget<Semantics>(
          find.byKey(const Key('mateo_floating_action_button_semantics')),
        );

        expect(semantics.properties.enabled, isFalse);
        expect(semantics.properties.onTap, isNull);

        await tester.tap(find.byType(MateoFloatingActionButton));
        await tester.pump();

        expect(
          hapticCalls.where((call) => call.method == 'HapticFeedback.vibrate'),
          isEmpty,
        );
      },
    );

    testWidgets('when onPressed is null, it should use the disabled colors', (
      tester,
    ) async {
      MateoFloatingActionButtonIconState? iconState;
      await tester.pumpWidget(
        TestApp(
          child: _button(
            onPressed: null,
            iconBuilder: (state) {
              iconState = state;
              return Icon(
                Icons.lock,
                color: state.foregroundColor,
                size: state.iconSize,
              );
            },
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byKey(const Key('mateo_floating_action_button_visual')),
              matching: find.byType(Material),
            )
            .first,
      );

      expect(
        (material.color, iconState?.foregroundColor),
        (
          mateoTestColorScheme.buttons.floating.backgroundDisabled,
          mateoTestColorScheme.buttons.floating.foregroundDisabled,
        ),
      );
    });

    testWidgets(
      'when rendered with defaults, it should use the standard dimensions',
      (tester) async {
        MateoFloatingActionButtonIconState? iconState;

        await tester.pumpWidget(
          TestApp(
            child: _button(
              onPressed: () {},
              iconBuilder: (state) {
                iconState = state;
                return Icon(
                  Icons.arrow_back,
                  color: state.foregroundColor,
                  size: state.iconSize,
                );
              },
            ),
          ),
        );

        expect(
          (
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_tap_target')),
            ),
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_icon_box')),
            ),
            iconState?.iconSize,
          ),
          (const Size.square(53), const Size.square(22), 22),
        );
      },
    );

    testWidgets(
      'when colors and border are customized, it should use the provided values',
      (tester) async {
        MateoFloatingActionButtonIconState? iconState;
        const borderSide = BorderSide(color: Colors.orange, width: 3);

        await tester.pumpWidget(
          TestApp(
            child: MateoFloatingActionButton(
              semanticLabel: 'Create',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.yellow,
              borderSide: borderSide,
              iconBuilder: (state) {
                iconState = state;
                return Icon(
                  Icons.add,
                  color: state.foregroundColor,
                  size: state.iconSize,
                );
              },
              onPressed: () {},
            ),
          ),
        );

        final material = tester.widget<Material>(
          find
              .descendant(
                of: find.byKey(
                  const Key('mateo_floating_action_button_tap_target'),
                ),
                matching: find.byType(Material),
              )
              .first,
        );

        expect(
          (
            material.color,
            material.shape as CircleBorder,
            iconState?.foregroundColor,
          ),
          (Colors.blue, const CircleBorder(side: borderSide), Colors.yellow),
        );
      },
    );

    testWidgets(
      'when the tap target exceeds the visual size, it should center the circle and accept taps across the target',
      (tester) async {
        var invocationCount = 0;
        await tester.pumpWidget(
          TestApp(
            child: MateoFloatingActionButton(
              semanticLabel: 'Close',
              size: 40,
              tapTargetSize: 44,
              iconSize: 16,
              iconBuilder: (state) => Icon(Icons.close, size: state.iconSize),
              onPressed: () => invocationCount += 1,
            ),
          ),
        );
        final tapTarget = find.byKey(
          const Key('mateo_floating_action_button_tap_target'),
        );
        final visual = find.byKey(
          const Key('mateo_floating_action_button_visual'),
        );

        expect(
          (
            tester.getSize(tapTarget),
            tester.getSize(visual),
            tester.getCenter(tapTarget),
            tester.getCenter(visual),
          ),
          (
            const Size.square(44),
            const Size.square(40),
            tester.getCenter(visual),
            tester.getCenter(visual),
          ),
        );

        await tester.tapAt(tester.getTopLeft(tapTarget) + const Offset(1, 22));
        await tester.pump();

        expect(invocationCount, 1);
      },
    );

    testWidgets(
      'when size and iconSize are customized, it should use both dimensions',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoFloatingActionButton(
              semanticLabel: 'Create',
              size: 64,
              iconSize: 30,
              iconBuilder: (state) => Icon(Icons.add, size: state.iconSize),
              onPressed: () {},
            ),
          ),
        );

        expect(
          (
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_tap_target')),
            ),
            tester.getSize(
              find.byKey(const Key('mateo_floating_action_button_icon_box')),
            ),
          ),
          (const Size.square(64), const Size.square(30)),
        );
      },
    );

    testWidgets('when tapped, it should trigger light impact feedback', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: _button(onPressed: () {})));

      await tester.tap(find.byType(MateoFloatingActionButton));
      await tester.pump();

      expect(
        hapticCalls.any(
          (call) => call.method == 'HapticFeedback.vibrate' && call.arguments == 'HapticFeedbackType.lightImpact',
        ),
        isTrue,
      );
    });

    testWidgets(
      'when size is not positive, it should reject the invalid dimension',
      (_) async {
        expect(
          () => MateoFloatingActionButton(
            semanticLabel: 'Create',
            size: 0,
            iconBuilder: (state) => const Icon(Icons.add),
            onPressed: () {},
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'when iconSize is not positive, it should reject the invalid dimension',
      (_) async {
        expect(
          () => MateoFloatingActionButton(
            semanticLabel: 'Create',
            iconSize: double.infinity,
            iconBuilder: (state) => const Icon(Icons.add),
            onPressed: () {},
          ),
          throwsAssertionError,
        );
      },
    );
  });
}

MateoFloatingActionButton _button({
  required FutureOr<void> Function()? onPressed,
  MateoFloatingActionButtonIconBuilder? iconBuilder,
  bool isLoading = false,
}) {
  return MateoFloatingActionButton(
    semanticLabel: 'Go back',
    iconBuilder:
        iconBuilder ??
        (state) => Icon(
          Icons.arrow_back,
          color: state.foregroundColor,
          size: state.iconSize,
        ),
    onPressed: onPressed,
    isLoading: isLoading,
  );
}
