import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  late List<MethodCall> hapticCalls;

  setUp(() {
    hapticCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          hapticCalls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
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
              .ancestor(
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
          (call) =>
              call.method == 'HapticFeedback.vibrate' &&
              call.arguments == 'HapticFeedbackType.lightImpact',
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
  required VoidCallback onPressed,
  MateoFloatingActionButtonIconBuilder? iconBuilder,
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
  );
}
