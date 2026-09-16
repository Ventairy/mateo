import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../test_app.dart';

void main() {
  const surfaceKey = ValueKey('mateo_menu_button_menu_surface');
  const positionKey = Key('mateo_menu_button_panel_position');
  const triggerKey = Key('trigger');

  Future<void> pumpMenu(
    WidgetTester tester, {
    Offset trigger = const Offset(280, 350),
    MateoMenuPresentation presentation = const MateoMenuPresentation.context(),
    List<MateoMenuItem>? items,
    TextDirection direction = TextDirection.ltr,
    bool icon = true,
    bool settle = true,
    FocusNode? previousFocus,
    ValueNotifier<List<MateoMenuItem>>? itemList,
    bool reducedMotion = false,
    double? hitAreaSize,
    double textScale = 1,
    ValueNotifier<Offset>? position,
    ValueNotifier<bool>? visible,
    MateoButtonColorScheme? colorScheme,
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    Widget button([List<MateoMenuItem>? currentItems]) => MateoMenuButton(
      key: triggerKey,
      menuPresentation: presentation,
      buttonPresentation: icon
          ? MateoButtonPresentation.icon(
              semanticLabel: 'More',
              variant: MateoButtonVariant.primary.base,
              elevation: 1,
              hitAreaSize: hitAreaSize,
              colorScheme: colorScheme,
              iconBuilder: (state) => Icon(Icons.more_horiz, size: state.iconSize, color: state.foregroundColor),
            )
          : MateoButtonPresentation.label(
              variant: MateoButtonVariant.primary,
              label: 'More',
              colorScheme: colorScheme,
            ),
      items: currentItems ?? items ?? [MateoMenuItem(title: 'Share', onPressed: (_) {})],
    );
    Widget content(Offset offset) => Focus(
      focusNode: previousFocus,
      child: Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: itemList == null
                ? button()
                : ValueListenableBuilder<List<MateoMenuItem>>(
                    valueListenable: itemList,
                    builder: (_, values, _) {
                      return button(values);
                    },
                  ),
          ),
        ],
      ),
    );
    await tester.pumpWidget(
      TestApp(
        child: Directionality(
          textDirection: direction,
          child: MediaQuery(
            data: MediaQueryData(
              size: const Size(400, 800),
              disableAnimations: reducedMotion,
              textScaler: TextScaler.linear(textScale),
            ),
            child: visible != null
                ? ValueListenableBuilder<bool>(
                    valueListenable: visible,
                    builder: (_, show, _) => show ? content(trigger) : const SizedBox(),
                  )
                : position != null
                ? ValueListenableBuilder<Offset>(valueListenable: position, builder: (_, offset, _) => content(offset))
                : content(trigger),
          ),
        ),
      ),
    );
    previousFocus?.requestFocus();
    await tester.pump();
    await tester.tap(find.byKey(triggerKey));
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  Rect menuRect(WidgetTester tester) => tester.getRect(find.byKey(surfaceKey));
  RenderTransform transform(WidgetTester tester) =>
      tester.renderObject<RenderBox>(find.byKey(positionKey)).parent! as RenderTransform;
  void expectOnlySourceMorph(WidgetTester tester) {
    final source = tester.widget<Morph>(
      find.byKey(const ValueKey('mateo_menu_button_source_surface')),
    );
    final matchingEndpoints = tester
        .widgetList<Morph>(find.byType(Morph))
        .where((morph) => identical(morph.tag, source.tag));
    expect(matchingEndpoints, hasLength(1));
  }

  for (final direction in TextDirection.values) {
    for (final scenario in [
      (name: 'left', trigger: const Offset(280, 350), width: 120.0, pivot: const Alignment(1, 0)),
      (name: 'right', trigger: const Offset(0, 350), width: 120.0, pivot: const Alignment(-1, 0)),
      (name: 'bottom', trigger: const Offset(173.5, 350), width: 220.0, pivot: const Alignment(0, -1)),
      (name: 'top', trigger: const Offset(173.5, 700), width: 220.0, pivot: const Alignment(0, 1)),
    ]) {
      testWidgets(
        'when opening ${scenario.name} in ${direction.name}, it should keep the gap and source-facing pivot',
        (tester) async {
          await pumpMenu(
            tester,
            trigger: scenario.trigger,
            direction: direction,
            items: [
              MateoMenuItem(
                title: 'X',
                leadingIconBuilder: (_) => SizedBox(width: scenario.width - 84, height: 60),
                onPressed: (_) {},
              ),
            ],
          );
          final menu = menuRect(tester);
          final trigger = tester.getRect(find.byKey(triggerKey));
          switch (scenario.name) {
            case 'left':
              expect(menu.right, trigger.left - 12);
              expect(menu.center.dy, trigger.center.dy);
            case 'right':
              expect(menu.left, trigger.right + 12);
              expect(menu.center.dy, trigger.center.dy);
            case 'bottom':
              expect(menu.top, trigger.bottom + 12);
              expect(menu.center.dx, trigger.center.dx);
            case 'top':
              expect(menu.bottom, trigger.top - 12);
              expect(menu.center.dx, trigger.center.dx);
          }
          expect(transform(tester).alignment, scenario.pivot);
          expectOnlySourceMorph(tester);
          expect(find.byType(Scrollable), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final y in [0.0, 747.0]) {
    testWidgets('when the side menu crosses a boundary at $y, it should shift only enough to fit', (tester) async {
      await pumpMenu(
        tester,
        trigger: Offset(280, y),
        items: [
          MateoMenuItem(
            title: 'Share',
            leadingIconBuilder: (_) => const SizedBox(width: 12, height: 60),
            onPressed: (_) {},
          ),
        ],
      );
      final menu = menuRect(tester);
      if (y == 0) {
        expect(menu.top, 0);
      } else {
        expect(menu.bottom, 800);
      }
      final pivot = transform(tester).alignment! as Alignment;
      expect(pivot.x, 1);
      expect(menu.top + (pivot.y + 1) / 2 * menu.height, closeTo(y + 26.5, 1e-9));
    });
  }

  testWidgets('when no side fits, it should overlap within the viewport', (tester) async {
    await pumpMenu(
      tester,
      trigger: const Offset(173.5, 373.5),
      items: [
        MateoMenuItem(
          title: 'X',
          leadingIconBuilder: (_) => const SizedBox(width: 266, height: 676),
          onPressed: (_) {},
        ),
      ],
    );
    expect(menuRect(tester).center, const Offset(200, 400));
    expect(menuRect(tester).height, 720);
    expect(menuRect(tester).width, greaterThanOrEqualTo(350));
    expect(transform(tester).alignment, Alignment.center);
  });

  testWidgets('when context opens, it should use natural fitted width', (tester) async {
    await pumpMenu(tester);
    expect(menuRect(tester).width, lessThan(200));
  });

  for (final icon in [true, false]) {
    testWidgets('when ${icon ? 'icon' : 'label'} popup starts, its circle should use the visible trigger dimension', (
      tester,
    ) async {
      await pumpMenu(
        tester,
        icon: icon,
        settle: false,
        hitAreaSize: icon ? 90 : null,
        items: [
          MateoMenuItem(title: 'Share', onPressed: (_) {}),
          MateoMenuItem(title: 'Duplicate', onPressed: (_) {}),
        ],
      );
      final trigger = tester.getRect(find.byKey(triggerKey));
      final diameter = icon ? 53.0 : trigger.shortestSide;
      expect(transform(tester).paintBounds.size, Size.square(diameter));
      await tester.pumpAndSettle();
      expect(transform(tester).paintBounds.size, menuRect(tester).size);
    });
  }

  testWidgets('when an icon has a larger target, popup should anchor to its visible circle', (tester) async {
    await pumpMenu(tester, hitAreaSize: 90);
    final trigger = tester.getRect(find.byKey(triggerKey));
    expect(trigger.width, 90);
    expect(menuRect(tester).right, trigger.center.dx - 26.5 - 12);
    expect(menuRect(tester).center.dy, trigger.center.dy);
  });

  for (final icon in [true, false]) {
    testWidgets(
      'when ${icon ? 'icon' : 'label'} popup action is selected, it should close once and complete its future',
      (tester) async {
        var calls = 0;
        var closed = false;
        await pumpMenu(
          tester,
          icon: icon,
          trigger: const Offset(240, 350),
          items: [
            MateoMenuItem(
              title: 'Share',
              onPressed: (future) async {
                calls++;
                await future;
                closed = true;
              },
            ),
          ],
        );
        await tester.tap(find.text('Share'));
        expect(calls, 1);
        expect(closed, isFalse);
        await tester.pumpAndSettle();
        expect(closed, isTrue);
        expect(find.byKey(surfaceKey), findsNothing);
        expect(find.byKey(triggerKey), findsOneWidget);
      },
    );
  }

  testWidgets('when the visible trigger is pressed again, the barrier should close without reopening', (tester) async {
    await pumpMenu(tester);
    await tester.tapAt(tester.getCenter(find.byKey(triggerKey)));
    await tester.pumpAndSettle();
    expect(find.byKey(surfaceKey), findsNothing);
    await tester.tap(find.byKey(triggerKey));
    await tester.pumpAndSettle();
    expect(find.byKey(surfaceKey), findsOneWidget);
  });

  testWidgets('when an action is disabled, it should remain open and use disabled colors', (tester) async {
    MateoMenuItemState? state;
    await pumpMenu(
      tester,
      items: [
        MateoMenuItem(
          title: 'Disabled',
          leadingIconBuilder: (value) {
            state = value;
            return const SizedBox.square(dimension: 12);
          },
        ),
      ],
    );
    await tester.tap(find.text('Disabled'));
    await tester.pumpAndSettle();
    expect(find.byKey(surfaceKey), findsOneWidget);
    expect(state!.isEnabled, isFalse);
    expect(state!.titleColor, mateoTestColorScheme.menu.action.titleDisabled);
  });

  for (final dismissal in ['escape', 'back', 'outside']) {
    testWidgets('when dismissed by $dismissal, popup should close', (tester) async {
      await pumpMenu(tester);
      switch (dismissal) {
        case 'escape':
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        case 'back':
          await tester.binding.handlePopRoute();
        case 'outside':
          await tester.tapAt(const Offset(390, 790));
      }
      await tester.pumpAndSettle();
      expect(find.byKey(surfaceKey), findsNothing);
    });
  }

  testWidgets('when the source moves, popup should follow and recompute its side', (tester) async {
    final position = ValueNotifier(const Offset(280, 350));
    addTearDown(position.dispose);
    await pumpMenu(tester, position: position);
    expect(menuRect(tester).right, 268);
    position.value = const Offset(0, 100);
    await tester.pumpAndSettle();
    expect(menuRect(tester).left, 65);
    expect(menuRect(tester).center.dy, 126.5);
  });

  testWidgets('when keyboard and safe areas change, popup should remain in the new safe bounds', (tester) async {
    await pumpMenu(
      tester,
      trigger: const Offset(173.5, 350),
      items: [
        MateoMenuItem(
          title: 'X',
          leadingIconBuilder: (_) => const SizedBox(width: 136, height: 60),
          onPressed: (_) {},
        ),
      ],
    );
    tester.view
      ..padding = const FakeViewPadding(top: 30, left: 20, right: 25)
      ..viewInsets = const FakeViewPadding(bottom: 400);
    await tester.pumpAndSettle();
    final menu = menuRect(tester);
    expect(menu.bottom, 338);
    expect(menu.left, greaterThanOrEqualTo(32));
    expect(menu.right, lessThanOrEqualTo(363));
  });

  testWidgets('when text is enlarged, fitted menu should wrap without adding scrolling', (tester) async {
    await pumpMenu(
      tester,
      textScale: 2,
      items: [MateoMenuItem(title: 'Share item', description: 'With others', onPressed: (_) {})],
    );
    expect(menuRect(tester).height, greaterThan(82));
    expect(find.byType(Scrollable), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when height is insufficient, popup should retain normal Flutter overflow', (tester) async {
    await pumpMenu(
      tester,
      items: [for (var i = 0; i < 50; i++) MateoMenuItem(title: 'Action $i', onPressed: (_) {})],
    );
    expect(find.byType(Scrollable), findsNothing);
    expect(tester.takeException().toString(), contains('overflowed'));
  });

  testWidgets('when disposed during close, popup should complete its pending future', (tester) async {
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    var closed = false;
    await pumpMenu(
      tester,
      visible: visible,
      items: [
        MateoMenuItem(
          title: 'Share',
          onPressed: (future) async {
            await future;
            closed = true;
          },
        ),
      ],
    );
    await tester.tap(find.text('Share'));
    visible.value = false;
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(find.byKey(surfaceKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when animations are disabled, popup should immediately reach both endpoints', (tester) async {
    await pumpMenu(tester, reducedMotion: true);
    expect(tester.renderObject<RenderBox>(find.byKey(positionKey)).getTransformTo(null).entry(0, 0), 1);
    await tester.tap(find.text('Share'));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(surfaceKey), findsNothing);
  });
  for (final scenario in [
    (trigger: const Offset(280, 350), width: 120.0),
    (trigger: const Offset(0, 350), width: 120.0),
    (trigger: const Offset(173.5, 350), width: 220.0),
    (trigger: const Offset(173.5, 700), width: 220.0),
  ]) {
    testWidgets('when popup at ${scenario.trigger} animates, its pivot should stay attached during entrance and exit', (
      tester,
    ) async {
      var builds = 0;
      await pumpMenu(
        tester,
        trigger: scenario.trigger,
        settle: false,
        items: [
          MateoMenuItem(
            title: 'Share',
            onPressed: (_) {},
            leadingIconBuilder: (_) {
              builds++;
              return SizedBox(width: scenario.width == 120 ? 12 : 140, height: 60);
            },
          ),
        ],
      );
      final panel = tester.renderObject<RenderBox>(find.byKey(positionKey));
      final alignment = transform(tester).alignment! as Alignment;
      final localPivot = alignment.alongSize(panel.size);
      final origin = panel.localToGlobal(localPivot);
      final axis = scenario.width == 120 ? 0 : 1;
      final settledSize = panel.size;
      final seed = transform(tester).paintBounds;
      expect(seed.size, const Size.square(53));
      final expectedSeed = scenario.width == 120
          ? (scenario.trigger.dx == 0 ? seed.left : seed.right)
          : (scenario.trigger.dy == 700 ? seed.bottom : seed.top);
      final expectedEdge = scenario.width == 120
          ? (scenario.trigger.dx == 0 ? 0.0 : panel.size.width)
          : (scenario.trigger.dy == 700 ? panel.size.height : 0.0);
      expect(expectedSeed, expectedEdge);
      final initialScale = 53 / settledSize.longestSide;
      expect(panel.getTransformTo(null).entry(0, 0), closeTo(initialScale, 0.001));
      expect(panel.getTransformTo(null).entry(1, 1), closeTo(initialScale, 0.001));
      final fade = tester.widget<FadeTransition>(
        find.ancestor(of: find.byKey(positionKey), matching: find.byType(FadeTransition)).first,
      );
      expect(fade.opacity.value, 0);
      await tester.pump(const Duration(milliseconds: 80));
      final extent = panel.getTransformTo(null).entry(axis, axis);
      expect(extent, inExclusiveRange(initialScale, 1));
      expect(panel.getTransformTo(null).entry(0, 0), panel.getTransformTo(null).entry(1, 1));
      final growing = transform(tester).paintBounds;
      expect(growing.width, inExclusiveRange(seed.width, settledSize.width));
      expect(growing.height, inExclusiveRange(seed.height, settledSize.height));
      expect(fade.opacity.value, inExclusiveRange(0, 1));
      expect(panel.size, settledSize);
      expect((panel.localToGlobal(localPivot) - origin).distance, closeTo(0, 0.00001));
      expect(transform(tester).alignment, alignment);
      await tester.tapAt(const Offset(390, 790));
      final before = panel.getTransformTo(null).entry(axis, axis);
      await tester.pump();
      expect(panel.getTransformTo(null).entry(axis, axis), before);
      await tester.pump(const Duration(milliseconds: 40));
      expect(panel.getTransformTo(null).entry(axis, axis), lessThan(before));
      expect((panel.localToGlobal(localPivot) - origin).distance, closeTo(0, 0.00001));
      await tester.pumpAndSettle();
      expect(find.byKey(surfaceKey), findsNothing);
      expect(builds, 1);
    });
  }

  testWidgets('when dismissed, popup should restore previously focused control', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpMenu(tester, previousFocus: focus);
    expect(focus.hasFocus, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('when items change while open, popup should keep its snapshot until the next opening', (tester) async {
    final items = ValueNotifier([MateoMenuItem(title: 'Original', onPressed: (_) {})]);
    addTearDown(items.dispose);
    await pumpMenu(tester, itemList: items);
    items.value = [MateoMenuItem(title: 'Replacement', onPressed: (_) {})];
    await tester.pumpAndSettle();
    expect(find.text('Original'), findsOneWidget);
    expect(find.text('Replacement'), findsNothing);
    await tester.tapAt(const Offset(390, 790));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(triggerKey));
    await tester.pumpAndSettle();
    expect(find.text('Replacement'), findsOneWidget);
  });

  testWidgets('when trigger colors are overridden, popup should preserve them while open', (tester) async {
    await pumpMenu(
      tester,
      colorScheme: mateoTestColorScheme.buttons.primary.base.copyWith(background: Colors.orange),
    );
    final background = find.descendant(of: find.byType(MateoButton), matching: find.byType(DecoratedBox)).first;
    final decoration = tester.widget<DecoratedBox>(background).decoration as BoxDecoration;
    expect(decoration.color, Colors.orange);
    expect(decoration.boxShadow, MateoElevation.toShadows(elevation: 1, palette: mateoTestPalette));
    expectOnlySourceMorph(tester);
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    expect((tester.widget<DecoratedBox>(background).decoration as BoxDecoration).color, Colors.orange);
  });

  for (final target in ['top', 'gapBefore', 'gapAfter', 'bottom']) {
    testWidgets('when popup $target padding is pressed, the nearest action should own it', (tester) async {
      var selected = '';
      await pumpMenu(
        tester,
        items: [
          MateoMenuItem(title: 'First', onPressed: (_) => selected = 'First'),
          MateoMenuItem(title: 'Last', onPressed: (_) => selected = 'Last'),
        ],
      );
      final menu = menuRect(tester);
      final first = tester.getRect(find.ancestor(of: find.text('First'), matching: find.byType(MateoTap)));
      final y = switch (target) {
        'top' => menu.top + 1,
        'gapBefore' => first.bottom - 1,
        'gapAfter' => first.bottom + 1,
        _ => menu.bottom - 1,
      };
      await tester.tapAt(Offset(menu.center.dx, y));
      await tester.pumpAndSettle();
      expect(selected, target == 'top' || target == 'gapBefore' ? 'First' : 'Last');
    });
  }
}
