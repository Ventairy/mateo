import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('when constructing MateoMessageBubble', () {
    testWidgets('without a message, it should throw AssertionError', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            direction: MateoMessageDirection.incoming,
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('with an empty text widget, it should render', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            message: Text(''),
            direction: MateoMessageDirection.incoming,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('with a zero-sized message widget, it should render', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            message: SizedBox.shrink(),
            direction: MateoMessageDirection.outgoing,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('while typing without a message, it should not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            direction: MateoMessageDirection.incoming,
            isTyping: true,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
      expect(find.bySubtype<Text>(), findsNothing);
    });

    testWidgets('while typing with a message widget, it should not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            message: Text(''),
            direction: MateoMessageDirection.outgoing,
            isTyping: true,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('with invalid constraints, it should throw AssertionError', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: MateoMessageBubble(
            message: Text('Message'),
            direction: MateoMessageDirection.incoming,
            constraints: BoxConstraints(minWidth: 20, maxWidth: 10),
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });
  });

  testWidgets('it should render the original plain text and emoji unchanged', (
    tester,
  ) async {
    const message = '  Hello 👋🏽\nHow are you?  ';
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text(message),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );

    expect(find.text(message, findRichText: true), findsOneWidget);
    expect(tester.widget<Text>(find.bySubtype<Text>()).data, message);
  });

  testWidgets('with custom content, it should inherit Mateo text and icon foregrounds', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, key: ValueKey('custom_icon')),
              Text('Custom content'),
            ],
          ),
          direction: MateoMessageDirection.outgoing,
        ),
      ),
    );

    final expected = mateoTestColorScheme.messageBubble.outgoing.onSolid;
    final textContext = tester.element(find.text('Custom content'));
    final iconContext = tester.element(find.byKey(const ValueKey('custom_icon')));

    expect(DefaultTextStyle.of(textContext).style.color, expected);
    expect(IconTheme.of(iconContext).color, expected);
  });

  testWidgets('with explicit custom styling, it should preserve the message styling', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text(
            'Custom color',
            style: TextStyle(color: Colors.green, fontSize: 24),
          ),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Custom color'));
    expect(text.style?.color, Colors.green);
    expect(text.style?.fontSize, 24);
  });

  testWidgets('when settled, it should retain no transition widgets or layers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('A settled message'),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );

    final bubble = find.byType(MateoMessageBubble);
    final dynamic surface = _surface(tester);
    expect(find.descendant(of: bubble, matching: find.byType(AnimatedSwitcher)), findsNothing);
    expect(find.descendant(of: bubble, matching: find.byType(FadeTransition)), findsNothing);
    expect(find.descendant(of: bubble, matching: find.byType(ClipPath)), findsNothing);
    expect(find.descendant(of: bubble, matching: find.byType(Stack)), findsNothing);
    expect(surface.controller, isNull);
    expect(surface.alwaysNeedsCompositing, isFalse);
    expect(surface.geometryIsAnimating, isFalse);
    expect(surface.hasContentTransition, isFalse);
    expect(surface.hasTransitionLayers, isFalse);
  });

  testWidgets('when a settled wrapper rebuilds, it should not dirty paint', (
    tester,
  ) async {
    late StateSetter rebuildBubble;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            rebuildBubble = setState;
            return const MateoMessageBubble(
              message: Text('A settled message'),
              direction: MateoMessageDirection.incoming,
            );
          },
        ),
      ),
    );

    final surface = _surface(tester);
    expect(surface.debugNeedsPaint, isFalse);

    rebuildBubble(() {});
    await tester.pump(null, EnginePhase.build);

    expect(_surface(tester), same(surface));
    expect(surface.debugNeedsPaint, isFalse);

    await tester.pump();
  });

  for (final direction in MateoMessageDirection.values) {
    testWidgets('with $direction, it should resolve the authored colors and typography', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoMessageBubble(
            message: Text('Message'),
            direction: direction,
          ),
        ),
      );

      final expected = switch (direction) {
        MateoMessageDirection.incoming => mateoTestColorScheme.messageBubble.incoming,
        MateoMessageDirection.outgoing => mateoTestColorScheme.messageBubble.outgoing,
      };
      final dynamic surface = _surface(tester);
      final style = DefaultTextStyle.of(
        tester.element(find.bySubtype<Text>()),
      ).style;

      expect(surface.backgroundColor, expected.solid);
      expect(style.color, expected.onSolid);
      expect(style.fontFamily, MateoTypography.fontFamily);
      expect(style.fontSize, 16.5);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.height, 1.25);
      expect(style.letterSpacing, MateoTypography.letterSpacing);
    });

    testWidgets('while typing with $direction, it should use the directional surface and typing color', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoMessageBubble(
            direction: direction,
            isTyping: true,
          ),
        ),
      );

      final expectedSurface = switch (direction) {
        MateoMessageDirection.incoming => mateoTestColorScheme.messageBubble.incoming.solid,
        MateoMessageDirection.outgoing => mateoTestColorScheme.messageBubble.outgoing.solid,
      };
      final dynamic surface = _surface(tester);
      final indicator = tester.widget<MateoDotsLoadingIndicator>(
        find.byType(MateoDotsLoadingIndicator),
      );

      expect(surface.backgroundColor, expectedSurface);
      expect(indicator.color, mateoTestColorScheme.messageBubble.typingIndicator);
      expect(_effectiveBodyRadius(tester), closeTo(_bodyRect(tester).height / 2, 0.001));
    });
  }

  testWidgets('it should use direction-specific theme overrides', (tester) async {
    const customOutgoing = MateoColorVariantColorScheme(
      solid: Colors.pink,
      onSolid: Colors.yellow,
    );
    final customColors = mateoTestColorScheme.copyWith(
      messageBubble: mateoTestColorScheme.messageBubble.copyWith(
        outgoing: customOutgoing,
        typingIndicator: Colors.green,
      ),
    );
    final customTheme = mateoTestTheme.copyWith(
      extensions: [
        mateoTestThemeData.copyWith(colorScheme: customColors),
      ],
    );

    await tester.pumpWidget(
      TestApp(
        theme: customTheme,
        child: const MateoMessageBubble(
          message: Text('Custom'),
          direction: MateoMessageDirection.outgoing,
        ),
      ),
    );

    final dynamic surface = _surface(tester);
    final style = DefaultTextStyle.of(
      tester.element(find.bySubtype<Text>()),
    ).style;
    expect(surface.backgroundColor, customOutgoing.solid);
    expect(style.color, customOutgoing.onSolid);
  });

  testWidgets('while typing, it should use the theme typing indicator override', (
    tester,
  ) async {
    final customColors = mateoTestColorScheme.copyWith(
      messageBubble: mateoTestColorScheme.messageBubble.copyWith(
        typingIndicator: Colors.green,
      ),
    );
    final customTheme = mateoTestTheme.copyWith(
      extensions: [
        mateoTestThemeData.copyWith(colorScheme: customColors),
      ],
    );

    await tester.pumpWidget(
      TestApp(
        theme: customTheme,
        child: const MateoMessageBubble(
          direction: MateoMessageDirection.incoming,
          isTyping: true,
        ),
      ),
    );

    final indicator = tester.widget<MateoDotsLoadingIndicator>(
      find.byType(MateoDotsLoadingIndicator),
    );
    expect(indicator.color, Colors.green);
  });

  testWidgets('it should shrink-wrap a short message', (tester) async {
    await tester.pumpWidget(
      const TestApp(
        child: SizedBox(
          width: 300,
          child: Align(
            alignment: Alignment.centerLeft,
            child: MateoMessageBubble(
              message: Text('Short'),
              direction: MateoMessageDirection.incoming,
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder).width, lessThan(300));
  });

  testWidgets('with maximum constraints, it should cap the complete bubble and wrap text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('This message should wrap within its authored maximum width.'),
          direction: MateoMessageDirection.incoming,
          constraints: BoxConstraints(maxWidth: 140),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder).width, 140);
    expect(
      tester.getSize(find.bySubtype<Text>()).height,
      greaterThan(16.5 * 1.25),
    );
  });

  testWidgets('with loose constraints, a short message should still shrink-wrap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('Short'),
          direction: MateoMessageDirection.outgoing,
          constraints: BoxConstraints(maxWidth: 240),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder).width, lessThan(240));
  });

  testWidgets('with constraints, a tighter parent constraint should still win', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: SizedBox(
          width: 110,
          child: MateoMessageBubble(
            message: Text('The parent remains the final layout authority.'),
            direction: MateoMessageDirection.incoming,
            constraints: BoxConstraints(maxWidth: 180),
          ),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder).width, 110);
  });

  testWidgets('with minimum constraints, it should expand the complete bubble', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: SizedBox(width: 12, height: 8),
          direction: MateoMessageDirection.incoming,
          constraints: BoxConstraints(minWidth: 220, minHeight: 100),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder), const Size(220, 100));
  });

  testWidgets('with tight constraints, it should constrain both bubble dimensions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: SizedBox(width: 400, height: 400),
          direction: MateoMessageDirection.outgoing,
          constraints: BoxConstraints.tightFor(width: 180, height: 90),
        ),
      ),
    );

    expect(tester.getSize(_surfaceFinder), const Size(180, 90));
  });

  testWidgets('when constraints change, it should preserve the message subtree', (
    tester,
  ) async {
    const messageKey = ValueKey('stateful_custom_message');
    var constraints = const BoxConstraints(maxWidth: 240);
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: const StatefulBuilder(
                key: messageKey,
                builder: _buildStatefulMessage,
              ),
              direction: MateoMessageDirection.incoming,
              constraints: constraints,
            );
          },
        ),
      ),
    );

    final initialElement = tester.element(find.byKey(messageKey));
    setBubbleState(
      () => constraints = const BoxConstraints(minWidth: 180, maxWidth: 200),
    );
    await tester.pump();

    expect(identical(tester.element(find.byKey(messageKey)), initialElement), isTrue);
  });

  testWidgets('when maximum constraints widen, it should retarget from its visible size', (
    tester,
  ) async {
    var maxWidth = 120.0;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('This message begins narrow and then uses a much wider authored maximum width.'),
              direction: MateoMessageDirection.incoming,
              constraints: BoxConstraints(maxWidth: maxWidth),
            );
          },
        ),
      ),
    );

    final initialSize = tester.getSize(_surfaceFinder);
    final initialSurface = _surface(tester);
    setBubbleState(() => maxWidth = 240);
    await tester.pump();

    final dynamic surface = _surface(tester);
    expect(identical(surface, initialSurface), isTrue);
    expect(tester.getSize(_surfaceFinder), initialSize);
    expect(surface.controller, isNotNull);

    await tester.pump(const Duration(milliseconds: 100));
    final intermediateSize = tester.getSize(_surfaceFinder);
    expect(intermediateSize.width, greaterThan(initialSize.width));
    expect(intermediateSize.height, lessThan(initialSize.height));

    await tester.pumpAndSettle();
    final settledSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    expect(settledSize.width, greaterThan(initialSize.width));
    expect(settledSize.width, lessThanOrEqualTo(240));
    expect(settledSize.height, lessThan(initialSize.height));
    expect(settledSize.width, closeTo(textSize.width + 65, 0.001));
    expect(settledSize.height, closeTo(textSize.height + 51, 0.001));
  });

  testWidgets('when constraints change from null to finite, it should keep morphing in place', (
    tester,
  ) async {
    double? maxWidth;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text(
                'This naturally wide message becomes a narrow wrapped bubble without replacing its surface.',
              ),
              direction: MateoMessageDirection.incoming,
              constraints: maxWidth == null ? null : BoxConstraints(maxWidth: maxWidth!),
            );
          },
        ),
      ),
    );

    final initialSurface = _surface(tester);
    final initialSize = tester.getSize(_surfaceFinder);
    setBubbleState(() => maxWidth = 140);
    await tester.pump();

    final dynamic surface = _surface(tester);
    expect(surface, same(initialSurface));
    expect(tester.getSize(_surfaceFinder), initialSize);
    expect(surface.controller, isNotNull);

    await tester.pump(const Duration(milliseconds: 100));
    final intermediateSize = tester.getSize(_surfaceFinder);
    expect(intermediateSize.width, lessThan(initialSize.width));
    expect(intermediateSize.height, greaterThan(initialSize.height));

    await tester.pumpAndSettle();
    final settledSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    expect(settledSize.width, closeTo(140, 0.001));
    expect(settledSize.height, greaterThan(initialSize.height));
    expect(settledSize.height, closeTo(textSize.height + 51, 0.001));
  });

  testWidgets('when constraints change from finite to null, it should keep morphing in place', (
    tester,
  ) async {
    double? maxWidth = 140;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('This wrapped message returns to its natural wide size without replacing its surface.'),
              direction: MateoMessageDirection.outgoing,
              constraints: maxWidth == null ? null : BoxConstraints(maxWidth: maxWidth!),
            );
          },
        ),
      ),
    );

    final initialSurface = _surface(tester);
    final initialSize = tester.getSize(_surfaceFinder);
    setBubbleState(() => maxWidth = null);
    await tester.pump();

    final dynamic surface = _surface(tester);
    expect(surface, same(initialSurface));
    expect(tester.getSize(_surfaceFinder), initialSize);
    expect(surface.controller, isNotNull);

    await tester.pump(const Duration(milliseconds: 100));
    final intermediateSize = tester.getSize(_surfaceFinder);
    expect(intermediateSize.width, greaterThan(initialSize.width));
    expect(intermediateSize.height, lessThan(initialSize.height));

    await tester.pumpAndSettle();
    final settledSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    expect(settledSize.width, greaterThan(initialSize.width));
    expect(settledSize.height, lessThan(initialSize.height));
    expect(settledSize.width, closeTo(textSize.width + 65, 0.001));
    expect(settledSize.height, closeTo(textSize.height + 51, 0.001));
  });

  testWidgets('when maximum constraints narrow, it should retarget from its visible size', (
    tester,
  ) async {
    var maxWidth = 240.0;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('This message starts with a generous cap and then wraps into a narrower bubble.'),
              direction: MateoMessageDirection.incoming,
              constraints: BoxConstraints(maxWidth: maxWidth),
            );
          },
        ),
      ),
    );

    final initialSurface = _surface(tester);
    final initialSize = tester.getSize(_surfaceFinder);
    setBubbleState(() => maxWidth = 120);
    await tester.pump();

    final dynamic surface = _surface(tester);
    expect(surface, same(initialSurface));
    expect(tester.getSize(_surfaceFinder), initialSize);
    expect(surface.controller, isNotNull);

    await tester.pump(const Duration(milliseconds: 100));
    final intermediateSize = tester.getSize(_surfaceFinder);
    expect(intermediateSize.width, lessThan(initialSize.width));
    expect(intermediateSize.height, greaterThan(initialSize.height));

    await tester.pumpAndSettle();
    final settledSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    expect(settledSize.width, closeTo(120, 0.001));
    expect(settledSize.height, greaterThan(initialSize.height));
    expect(settledSize.height, closeTo(textSize.height + 51, 0.001));
  });

  testWidgets('when constraints narrow below the insets, it should not snap at the endpoint', (
    tester,
  ) async {
    var maxWidth = 120.0;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('Tiny target'),
              direction: MateoMessageDirection.outgoing,
              constraints: BoxConstraints(maxWidth: maxWidth),
            );
          },
        ),
      ),
    );

    final initialSize = tester.getSize(_surfaceFinder);
    setBubbleState(() => maxWidth = 1);
    await tester.pump();
    expect(tester.getSize(_surfaceFinder), initialSize);

    await tester.pump(const Duration(milliseconds: 200));
    final nearEndpointWidth = tester.getSize(_surfaceFinder).width;
    expect(nearEndpointWidth.isFinite, isTrue);
    expect(nearEndpointWidth, greaterThan(1));
    expect(nearEndpointWidth, lessThan(initialSize.width));

    await tester.pump(const Duration(milliseconds: 99));
    expect(tester.getSize(_surfaceFinder).width, lessThan(10));

    await tester.pump(const Duration(milliseconds: 1));
    expect(tester.getSize(_surfaceFinder).width, closeTo(1, 0.001));

    await tester.pumpAndSettle();
    expect(tester.getSize(_surfaceFinder).width, closeTo(1, 0.001));
  });

  testWidgets('with IntrinsicHeight, constraints should wrap without clipping text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: IntrinsicHeight(
          child: MateoMessageBubble(
            message: Text('Intrinsic measurement should use the authored cap and preserve every wrapped line.'),
            direction: MateoMessageDirection.outgoing,
            constraints: BoxConstraints(maxWidth: 140),
          ),
        ),
      ),
    );

    final surfaceSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    final surfaceOrigin = tester.getTopLeft(_surfaceFinder);
    final bodyRect = _bodyRect(tester).shift(surfaceOrigin);
    final textRect = tester.getRect(find.bySubtype<Text>());

    expect(surfaceSize.width, closeTo(140, 0.001));
    expect(textSize.height, greaterThan(16.5 * 1.25));
    expect(surfaceSize.height, closeTo(textSize.height + 51, 0.001));
    expect(bodyRect.contains(textRect.topLeft), isTrue);
    expect(bodyRect.contains(textRect.bottomRight), isTrue);
    expect(_hasSurfaceClipLayer(tester), isFalse);
  });

  testWidgets('with exceptionally narrow constraints, it should remain finite', (
    tester,
  ) async {
    for (final width in [1.0, 20.0, 40.0]) {
      for (final direction in MateoMessageDirection.values) {
        for (final isTyping in [false, true]) {
          await tester.pumpWidget(
            TestApp(
              child: MediaQuery(
                data: const MediaQueryData(disableAnimations: true),
                child: MateoMessageBubble(
                  message: isTyping ? null : const Text('Narrow'),
                  direction: direction,
                  constraints: BoxConstraints(maxWidth: width),
                  isTyping: isTyping,
                ),
              ),
            ),
          );

          final size = tester.getSize(_surfaceFinder);
          expect(tester.takeException(), isNull);
          expect(size.width.isFinite, isTrue);
          expect(size.height.isFinite, isTrue);
          expect(size.width, inInclusiveRange(0, width));
          expect(size.height, greaterThanOrEqualTo(0));
        }
      }
    }
  });

  testWidgets('it should wrap and grow within parent constraints', (tester) async {
    await tester.pumpWidget(
      TestApp(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 180),
          child: MateoMessageBubble(
            message: Text('This longer message wraps over several lines inside its parent.'),
            direction: MateoMessageDirection.outgoing,
          ),
        ),
      ),
    );

    final surfaceSize = tester.getSize(_surfaceFinder);
    final textSize = tester.getSize(find.bySubtype<Text>());
    expect(surfaceSize.width, lessThanOrEqualTo(180));
    expect(textSize.height, greaterThan(16.5 * 1.25));
    expect(surfaceSize.height, greaterThan(textSize.height));
  });

  testWidgets('with RTL text, it should wrap without changing the physical tail side', (
    tester,
  ) async {
    const message = 'مرحبًا، هذه رسالة طويلة يجب أن تلتف على عدة أسطر بشكل طبيعي.';
    for (final direction in MateoMessageDirection.values) {
      await tester.pumpWidget(
        TestApp(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MateoMessageBubble(
              message: Text(message),
              direction: direction,
              constraints: BoxConstraints(maxWidth: 150),
            ),
          ),
        ),
      );

      final dynamic paragraph = tester.renderObject<RenderBox>(
        find.bySubtype<Text>(),
      );
      final dynamic surface = _surface(tester);
      final surfaceSize = tester.getSize(_surfaceFinder);
      final dotCenter = surface.dotCenter as Offset;

      expect(paragraph.textDirection, TextDirection.rtl);
      expect(tester.getSize(find.bySubtype<Text>()).height, greaterThan(16.5 * 1.25));
      expect(surfaceSize.width, lessThanOrEqualTo(150));
      switch (direction) {
        case MateoMessageDirection.incoming:
          expect(dotCenter.dx, 6);
        case MateoMessageDirection.outgoing:
          expect(dotCenter.dx, surfaceSize.width - 6);
      }
    }
  });

  testWidgets('when text scaling grows, it should retarget from its visible size', (
    tester,
  ) async {
    var textScale = 1.0;
    late StateSetter setBubbleState;
    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: const MateoMessageBubble(
                message: Text('A message that wraps naturally when its text grows.'),
                direction: MateoMessageDirection.outgoing,
                constraints: BoxConstraints(maxWidth: 190),
              ),
            );
          },
        ),
      ),
    );

    final initialSize = tester.getSize(_surfaceFinder);
    final initialTextSize = tester.getSize(find.bySubtype<Text>());
    final initialSurface = _surface(tester);
    setBubbleState(() => textScale = 2);
    await tester.pump();

    final dynamic surface = _surface(tester);
    expect(identical(surface, initialSurface), isTrue);
    expect(tester.getSize(_surfaceFinder), initialSize);
    expect(surface.controller, isNotNull);

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(_surfaceFinder).height, greaterThan(initialSize.height));

    await tester.pumpAndSettle();
    final settledSize = tester.getSize(_surfaceFinder);
    final scaledTextSize = tester.getSize(find.bySubtype<Text>());
    expect(scaledTextSize.height, greaterThan(initialTextSize.height));
    expect(settledSize.width, lessThanOrEqualTo(190));
    expect(settledSize.height, greaterThan(initialSize.height));
    expect(settledSize.height, closeTo(scaledTextSize.height + 51, 0.001));
  });

  testWidgets('it should delegate the message baseline through its body padding', (
    tester,
  ) async {
    const siblingKey = ValueKey('message_bubble_baseline_sibling');
    await tester.pumpWidget(
      TestApp(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: const [
            MateoMessageBubble(
              message: Text('Baseline'),
              direction: MateoMessageDirection.incoming,
            ),
            Text(
              'Sibling',
              key: siblingKey,
              style: TextStyle(
                fontFamily: MateoTypography.fontFamily,
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
                height: 1.25,
                letterSpacing: MateoTypography.letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );

    final messageText = find.descendant(
      of: find.byType(MateoMessageBubble),
      matching: find.bySubtype<Text>(),
    );
    expect(
      tester.getTopLeft(messageText).dy,
      closeTo(tester.getTopLeft(find.byKey(siblingKey)).dy, 0.001),
    );
    expect(
      tester.getTopLeft(messageText).dy - tester.getTopLeft(_surfaceFinder).dy,
      18,
    );
  });

  testWidgets('its effective corners should grow with height and stop at 32', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('Single line'),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );

    expect(_effectiveBodyRadius(tester), closeTo(_bodyRect(tester).height / 2, 0.001));

    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('Line one\nLine two\nLine three\nLine four\nLine five'),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(_surfaceFinder).height, greaterThan(64));
    expect(_effectiveBodyRadius(tester), 32);
  });

  testWidgets('it should mirror its sculpted tail for incoming and outgoing messages', (
    tester,
  ) async {
    for (final direction in MateoMessageDirection.values) {
      await tester.pumpWidget(
        TestApp(
          child: MateoMessageBubble(message: Text('Message'), direction: direction),
        ),
      );

      final dynamic surface = _surface(tester);
      final size = tester.getSize(_surfaceFinder);
      final dotCenter = surface.dotCenter as Offset;
      final dotRadius = surface.dotRadius as double;
      final textOffset = tester.getTopLeft(find.bySubtype<Text>()) - tester.getTopLeft(_surfaceFinder);

      expect(surface.direction, direction);
      expect(dotRadius, 5);
      expect(dotCenter.dy, size.height - 6);
      switch (direction) {
        case MateoMessageDirection.incoming:
          expect(textOffset, const Offset(41, 18));
          expect(dotCenter.dx, 6);
        case MateoMessageDirection.outgoing:
          expect(textOffset, const Offset(24, 18));
          expect(dotCenter.dx, size.width - 6);
      }
    }
  });

  testWidgets('it should hit-test only its body, connected tail, and dot', (
    tester,
  ) async {
    for (final direction in MateoMessageDirection.values) {
      var pointerDowns = 0;
      await tester.pumpWidget(
        TestApp(
          child: Listener(
            onPointerDown: (_) => pointerDowns += 1,
            child: MateoMessageBubble(
              message: Text('Message'),
              direction: direction,
            ),
          ),
        ),
      );

      final dynamic surface = _surface(tester);
      final surfaceOrigin = tester.getTopLeft(_surfaceFinder);
      final surfaceSize = tester.getSize(_surfaceFinder);
      final body = _bodyRect(tester);
      final textRect = tester.getRect(find.bySubtype<Text>());
      final textOffset = textRect.topLeft - surfaceOrigin;
      final bodyPaddingPoint = Offset(textOffset.dx + 4, 8);
      final tailPoint = switch (direction) {
        MateoMessageDirection.incoming => Offset(
          body.left - 1,
          body.bottom - 8,
        ),
        MateoMessageDirection.outgoing => Offset(
          body.right + 1,
          body.bottom - 8,
        ),
      };
      final dotPoint = surface.dotCenter as Offset;
      final transparentCorner = switch (direction) {
        MateoMessageDirection.incoming => const Offset(1, 1),
        MateoMessageDirection.outgoing => Offset(surfaceSize.width - 1, 1),
      };

      expect(textRect.contains(surfaceOrigin + bodyPaddingPoint), isFalse);
      expect(body.contains(tailPoint), isFalse);
      expect(surface.shapePath.contains(tailPoint), isTrue);
      expect(surface.shapePath.contains(dotPoint), isFalse);
      expect(surface.shapePath.contains(transparentCorner), isFalse);

      await tester.tapAt(surfaceOrigin + bodyPaddingPoint);
      await tester.tapAt(surfaceOrigin + tailPoint);
      await tester.tapAt(surfaceOrigin + dotPoint);
      expect(pointerDowns, 3);

      await tester.tapAt(surfaceOrigin + transparentCorner);
      expect(pointerDowns, 3);
    }
  });

  testWidgets('when typing completes, it should morph and fade the complete content', (
    tester,
  ) async {
    var isTyping = true;
    Widget? message;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190),
              child: MateoMessageBubble(
                message: message,
                direction: MateoMessageDirection.incoming,
                isTyping: isTyping,
              ),
            );
          },
        ),
      ),
    );

    final typingSize = tester.getSize(_surfaceFinder);
    final initialSurface = _surface(tester);
    setBubbleState(() {
      message = const Text('This answer expands across multiple lines.');
      isTyping = false;
    });
    await tester.pump();

    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
    expect(find.text('This answer expands across multiple lines.'), findsOneWidget);
    final dynamic forwardSurface = _surface(tester);
    expect(identical(forwardSurface, initialSurface), isTrue);
    expect(forwardSurface.controller.duration, const Duration(milliseconds: 450));
    expect(forwardSurface.geometryCurve, Curves.easeOutBack);
    expect(forwardSurface.geometryIsAnimating, isTrue);
    expect(forwardSurface.hasContentTransition, isTrue);
    expect(forwardSurface.messageOpacity, 0);
    expect(forwardSurface.typingOpacity, 1);

    await tester.pump(const Duration(milliseconds: 80));
    final earlySize = tester.getSize(_surfaceFinder);
    final earlyOpacity = forwardSurface.messageOpacity as double;

    await tester.pump(const Duration(milliseconds: 120));
    final midpointSize = tester.getSize(_surfaceFinder);
    const forwardRawProgress = 200 / 450;
    final expectedMessageOpacity = Curves.easeOutCubic.transform(
      (forwardRawProgress - 0.15) / 0.85,
    );
    final expectedTypingOpacity = Curves.easeInCubic.transform(
      1 - forwardRawProgress,
    );
    expect(midpointSize.width, greaterThan(typingSize.width));
    expect(midpointSize.height, greaterThan(typingSize.height));
    expect(
      forwardSurface.messageOpacity,
      closeTo(expectedMessageOpacity, 0.000001),
    );
    expect(
      forwardSurface.typingOpacity,
      closeTo(expectedTypingOpacity, 0.000001),
    );
    expect(forwardSurface.usesSurfaceMessageFade, isTrue);
    expect(forwardSurface.messageUsesOpacityLayer, isFalse);

    await tester.pumpAndSettle();
    final messageSize = tester.getSize(_surfaceFinder);
    expect(earlyOpacity, lessThan(0.2));
    expect(earlySize.height, greaterThan(typingSize.height));
    expect(midpointSize.height, greaterThan(messageSize.height));
    expect(find.byType(MateoDotsLoadingIndicator), findsNothing);
    expect(find.text('This answer expands across multiple lines.'), findsOneWidget);
    expect(forwardSurface.hasContentTransition, isFalse);
    expect(forwardSurface.hasTransitionLayers, isFalse);

    setBubbleState(() => isTyping = true);
    await tester.pump();

    final dynamic reverseSurface = _surface(tester);
    expect(identical(reverseSurface, forwardSurface), isTrue);
    expect(reverseSurface.geometryCurve, Curves.easeInOutCubic);
    expect(reverseSurface.controller.duration, const Duration(milliseconds: 300));

    await tester.pump(const Duration(milliseconds: 75));
    final reverseSize = tester.getSize(_surfaceFinder);
    expect(reverseSize.width, lessThan(messageSize.width));
    expect(reverseSize.width, greaterThan(typingSize.width));
    expect(
      reverseSurface.messageOpacity,
      closeTo(Curves.easeInCubic.transform(0.75), 0.000001),
    );
    expect(
      reverseSurface.typingOpacity,
      closeTo(Curves.easeOutCubic.transform(0.25), 0.000001),
    );

    await tester.pump(const Duration(milliseconds: 226));
    await tester.pump();
    expect(tester.getSize(_surfaceFinder), typingSize);
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
    expect(find.bySubtype<Text>(), findsNothing);
    expect(_hasSurfaceClipLayer(tester), isFalse);
    expect(
      _transitionLayerState(reverseSurface),
      const {
        'clip': false,
        'messageFade': false,
        'messageCache': false,
        'typingFade': false,
      },
    );
  });

  testWidgets('during a transition, it should expose and hit-test only the target content', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var isTyping = false;
    var taps = 0;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Semantics(
                label: 'Custom message action',
                button: true,
                child: GestureDetector(
                  key: const ValueKey('custom_message_action'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => taps += 1,
                  child: const SizedBox(
                    width: 100,
                    height: 30,
                    child: Center(child: Text('Open')),
                  ),
                ),
              ),
              direction: MateoMessageDirection.incoming,
              isTyping: isTyping,
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('custom_message_action')));
    expect(taps, 1);
    expect(find.bySemanticsLabel(RegExp('Custom message action')), findsOneWidget);

    setBubbleState(() => isTyping = true);
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('custom_message_action')),
      warnIfMissed: false,
    );
    expect(taps, 1);
    expect(find.bySemanticsLabel(RegExp('Custom message action')), findsNothing);

    semantics.dispose();
  });

  testWidgets('with custom content, it should use a true subtree fade', (
    tester,
  ) async {
    var isTyping = true;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.check), Text('Done')],
              ),
              direction: MateoMessageDirection.outgoing,
              isTyping: isTyping,
            );
          },
        ),
      ),
    );

    setBubbleState(() => isTyping = false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    final dynamic surface = _surface(tester);
    expect(surface.usesSurfaceMessageFade, isFalse);
    expect(surface.messageUsesOpacityLayer, isTrue);

    await tester.pumpAndSettle();
    expect(surface.messageUsesOpacityLayer, isFalse);
  });

  testWidgets(
    'when typing becomes an exceptionally short message, it should stay clipped through the fade tail',
    (tester) async {
      var isTyping = true;
      late StateSetter setBubbleState;

      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              setBubbleState = setState;
              return MateoMessageBubble(
                message: Text('i'),
                direction: MateoMessageDirection.outgoing,
                isTyping: isTyping,
              );
            },
          ),
        ),
      );

      final typingSize = tester.getSize(_surfaceFinder);
      setBubbleState(() => isTyping = false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      final dynamic surface = _surface(tester);
      expect(surface.geometryIsAnimating, isFalse);
      expect(surface.hasContentTransition, isTrue);
      expect(tester.getSize(_surfaceFinder).width, lessThan(typingSize.width));
      expect(_hasSurfaceClipLayer(tester), isTrue);

      await tester.pump(const Duration(milliseconds: 101));
      await tester.pump();

      expect(surface.hasContentTransition, isFalse);
      expect(
        _transitionLayerState(surface),
        const {
          'clip': false,
          'messageFade': false,
          'messageCache': false,
          'typingFade': false,
        },
      );
      expect(_hasSurfaceClipLayer(tester), isFalse);
    },
  );

  testWidgets('with a translucent surface, it should preserve a true content fade', (
    tester,
  ) async {
    const translucentIncoming = MateoColorVariantColorScheme(
      solid: Color(0x80FF4D51),
      onSolid: Colors.white,
    );
    final customColors = mateoTestColorScheme.copyWith(
      messageBubble: mateoTestColorScheme.messageBubble.copyWith(
        incoming: translucentIncoming,
      ),
    );
    final customTheme = mateoTestTheme.copyWith(
      extensions: [
        mateoTestThemeData.copyWith(colorScheme: customColors),
      ],
    );
    var isTyping = true;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        theme: customTheme,
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('Transparent message'),
              direction: MateoMessageDirection.incoming,
              isTyping: isTyping,
            );
          },
        ),
      ),
    );

    setBubbleState(() => isTyping = false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    final dynamic surface = _surface(tester);
    expect(surface.usesSurfaceMessageFade, isFalse);
    expect(surface.messageUsesOpacityLayer, isTrue);

    await tester.pumpAndSettle();
    expect(surface.messageUsesOpacityLayer, isFalse);
  });

  testWidgets('when the target changes during resizing, it should retarget without jumping', (
    tester,
  ) async {
    Widget message = const Text('Short');
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190),
              child: MateoMessageBubble(
                message: message,
                direction: MateoMessageDirection.outgoing,
              ),
            );
          },
        ),
      ),
    );

    setBubbleState(
      () => message = const Text('A longer answer that wraps onto a second line.'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final sizeBeforeRetarget = tester.getSize(_surfaceFinder);

    setBubbleState(
      () => message = const Text(
        'A still longer answer that keeps changing and wraps onto several lines.',
      ),
    );
    await tester.pump();
    final sizeAfterRetarget = tester.getSize(_surfaceFinder);

    expect(sizeAfterRetarget.width, closeTo(sizeBeforeRetarget.width, 0.001));
    expect(sizeAfterRetarget.height, closeTo(sizeBeforeRetarget.height, 0.001));

    await tester.pump(const Duration(milliseconds: 80));
    final sizeDuringRetarget = tester.getSize(_surfaceFinder);
    expect(sizeDuringRetarget.height, greaterThan(sizeAfterRetarget.height));

    await tester.pumpAndSettle();
    expect(tester.getSize(_surfaceFinder).height, greaterThan(sizeDuringRetarget.height));
  });

  testWidgets('when the surface expands, it should clip only at its rounded boundary', (
    tester,
  ) async {
    var isTyping = true;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('Message'),
              direction: MateoMessageDirection.incoming,
              isTyping: isTyping,
            );
          },
        ),
      ),
    );
    setBubbleState(() => isTyping = false);
    await tester.pump();

    final bubble = find.byType(MateoMessageBubble);
    final dynamic surface = _surface(tester);
    expect(surface.geometryIsAnimating, isTrue);
    expect(surface.hasTransitionLayers, isTrue);
    expect(find.descendant(of: bubble, matching: find.byType(ClipPath)), findsNothing);
    expect(
      find.descendant(of: bubble, matching: find.byType(ClipRect)),
      findsNothing,
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(surface.geometryIsAnimating, isFalse);
    expect(surface.hasContentTransition, isTrue);

    await tester.pump(const Duration(milliseconds: 151));
    await tester.pump();
    expect(surface.hasContentTransition, isFalse);
    expect(surface.hasTransitionLayers, isFalse);
  });

  testWidgets('when typing changes rapidly, it should settle on the latest state', (
    tester,
  ) async {
    var isTyping = true;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            setBubbleState = setState;
            return MateoMessageBubble(
              message: Text('Final response'),
              direction: MateoMessageDirection.outgoing,
              isTyping: isTyping,
            );
          },
        ),
      ),
    );

    final initialSurface = _surface(tester);
    setBubbleState(() => isTyping = false);
    await tester.pump();
    final dynamic surface = _surface(tester);
    final controller = surface.controller;
    expect(identical(surface, initialSurface), isTrue);
    expect(find.bySubtype<Text>(), findsOneWidget);
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 75));
    final sizeBeforeFirstRetarget = tester.getSize(_surfaceFinder);
    final messageOpacityBeforeFirstRetarget = surface.messageOpacity as double;
    final typingOpacityBeforeFirstRetarget = surface.typingOpacity as double;
    setBubbleState(() => isTyping = true);
    await tester.pump();
    expect(tester.getSize(_surfaceFinder), sizeBeforeFirstRetarget);
    expect(
      surface.messageOpacity,
      closeTo(messageOpacityBeforeFirstRetarget, 0.000001),
    );
    expect(
      surface.typingOpacity,
      closeTo(typingOpacityBeforeFirstRetarget, 0.000001),
    );
    expect(identical(surface.controller, controller), isTrue);
    expect(find.bySubtype<Text>(), findsOneWidget);
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 75));
    final sizeBeforeSecondRetarget = tester.getSize(_surfaceFinder);
    final messageOpacityBeforeSecondRetarget = surface.messageOpacity as double;
    final typingOpacityBeforeSecondRetarget = surface.typingOpacity as double;
    setBubbleState(() => isTyping = false);
    await tester.pump();
    expect(tester.getSize(_surfaceFinder), sizeBeforeSecondRetarget);
    expect(
      surface.messageOpacity,
      closeTo(messageOpacityBeforeSecondRetarget, 0.000001),
    );
    expect(
      surface.typingOpacity,
      closeTo(typingOpacityBeforeSecondRetarget, 0.000001),
    );
    expect(identical(surface.controller, controller), isTrue);
    expect(find.bySubtype<Text>(), findsOneWidget);
    expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Final response'), findsOneWidget);
    expect(find.byType(MateoDotsLoadingIndicator), findsNothing);
    expect(surface.hasTransitionLayers, isFalse);
  });

  testWidgets('when animations are disabled, it should switch states immediately', (
    tester,
  ) async {
    var isTyping = true;
    late StateSetter setBubbleState;

    await tester.pumpWidget(
      TestApp(
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: StatefulBuilder(
            builder: (context, setState) {
              setBubbleState = setState;
              return MateoMessageBubble(
                message: Text('Ready'),
                direction: MateoMessageDirection.incoming,
                isTyping: isTyping,
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedSwitcher), findsNothing);
    final dynamic surface = _surface(tester);
    expect(surface.controller, isNull);
    await tester.pumpAndSettle();

    setBubbleState(() => isTyping = false);
    await tester.pump();

    expect(find.text('Ready'), findsOneWidget);
    expect(find.byType(MateoDotsLoadingIndicator), findsNothing);
    expect(surface.hasContentTransition, isFalse);
  });

  testWidgets(
    'when animations become disabled mid-morph, it should finish immediately with static dots',
    (tester) async {
      var isTyping = false;
      var disableAnimations = false;
      late StateSetter setBubbleState;

      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              setBubbleState = setState;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  disableAnimations: disableAnimations,
                ),
                child: MateoMessageBubble(
                  message: Text('Ready'),
                  direction: MateoMessageDirection.incoming,
                  isTyping: isTyping,
                ),
              );
            },
          ),
        ),
      );

      final initialSurface = _surface(tester);
      setBubbleState(() => isTyping = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));

      final dynamic surface = _surface(tester);
      expect(identical(surface, initialSurface), isTrue);
      expect(surface.hasContentTransition, isTrue);
      expect(find.bySubtype<Text>(), findsOneWidget);
      expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);

      setBubbleState(() => disableAnimations = true);
      await tester.pump();

      final settledSize = tester.getSize(_surfaceFinder);
      expect(identical(_surface(tester), surface), isTrue);
      expect(surface.controller, isNull);
      expect(surface.hasContentTransition, isFalse);
      expect(_hasSurfaceClipLayer(tester), isFalse);
      expect(
        _transitionLayerState(surface),
        const {
          'clip': false,
          'messageFade': false,
          'messageCache': false,
          'typingFade': false,
        },
      );
      expect(surface.messageOpacity, 0);
      expect(surface.typingOpacity, 1);
      expect(find.bySubtype<Text>(), findsNothing);
      expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
      expect(_dotsPainter(tester).animated, isFalse);

      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.getSize(_surfaceFinder), settledSize);
      expect(find.bySubtype<Text>(), findsNothing);
      expect(find.byType(MateoDotsLoadingIndicator), findsOneWidget);
      expect(_dotsPainter(tester).animated, isFalse);
    },
  );

  testWidgets('while typing, it should expose localized loading semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          direction: MateoMessageDirection.incoming,
          isTyping: true,
          typingSemanticsLabel: 'Mateo is typing',
        ),
      ),
    );

    final properties = _semantics(tester).properties;
    expect(properties.label, 'Mateo is typing');
    expect(properties.liveRegion, isTrue);
    expect(properties.role, SemanticsRole.loadingSpinner);

    semantics.dispose();
  });

  testWidgets('when typing completes, it should restore message semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      const TestApp(
        child: MateoMessageBubble(
          message: Text('The answer is ready'),
          direction: MateoMessageDirection.incoming,
        ),
      ),
    );

    final messageSemantics = tester.getSemantics(find.text('The answer is ready'));
    expect(messageSemantics.label, 'The answer is ready');
    final wrapperProperties = _semantics(tester).properties;
    expect(wrapperProperties.label, isNull);
    expect(wrapperProperties.liveRegion, isFalse);
    expect(wrapperProperties.role, isNull);

    semantics.dispose();
  });
}

Widget _buildStatefulMessage(BuildContext context, StateSetter setState) => const Text('Stateful message');

final _surfaceFinder = find.byKey(
  const ValueKey('mateo_message_bubble_surface'),
);

RenderBox _surface(WidgetTester tester) => tester.renderObject<RenderBox>(_surfaceFinder);

dynamic _dotsPainter(WidgetTester tester) {
  final customPaint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(MateoDotsLoadingIndicator),
      matching: find.byType(CustomPaint),
    ),
  );
  return customPaint.painter;
}

Map<String, bool> _transitionLayerState(dynamic surface) => {
  'clip': surface.hasClipLayer as bool,
  'messageFade': surface.messageFadeHasLayer as bool,
  'messageCache': surface.messageCacheHasLayer as bool,
  'typingFade': surface.typingFadeHasLayer as bool,
};

bool _hasSurfaceClipLayer(WidgetTester tester) {
  final rootLayer = tester.binding.renderViews.single.debugLayer;
  if (rootLayer == null) return false;
  final surfaceSize = tester.getSize(_surfaceFinder);
  final bodySize = Size(
    surfaceSize.width - 17,
    surfaceSize.height - 15,
  );
  return rootLayer.depthFirstIterateChildren().whereType<ClipRRectLayer>().any(
    (layer) => layer.clipRRect?.outerRect.size == bodySize,
  );
}

Semantics _semantics(WidgetTester tester) => tester.widget<Semantics>(
  find.descendant(
    of: find.byType(MateoMessageBubble),
    matching: find.byType(Semantics),
  ),
);

Rect _bodyRect(WidgetTester tester) {
  final surfaceSize = tester.getSize(_surfaceFinder);
  final dynamic surface = _surface(tester);
  final tailWidth = surfaceSize.width < 17 ? surfaceSize.width : 17.0;
  final tailHeight = surfaceSize.height < 15 ? surfaceSize.height : 15.0;
  return switch (surface.direction as MateoMessageDirection) {
    MateoMessageDirection.incoming => Rect.fromLTRB(
      tailWidth,
      0,
      surfaceSize.width,
      surfaceSize.height - tailHeight,
    ),
    MateoMessageDirection.outgoing => Rect.fromLTRB(
      0,
      0,
      surfaceSize.width - tailWidth,
      surfaceSize.height - tailHeight,
    ),
  };
}

double _effectiveBodyRadius(WidgetTester tester) {
  final body = _bodyRect(tester);
  final normalizedRadius = body.shortestSide / 2;
  return normalizedRadius < 32 ? normalizedRadius : 32;
}
