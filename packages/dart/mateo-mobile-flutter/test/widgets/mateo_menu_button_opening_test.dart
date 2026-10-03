import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/surface_transform_test_widgets.dart';

void main() {
  testWidgets(
    'when a scrolled transform trigger crosses the bottom safe margin or screen edge, it should stay attached and open upward to the right',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
      addTearDown(tester.view.reset);
      final navigator = GlobalKey<NavigatorState>();
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      await tester.pumpWidget(
        MateoApp(
          navigatorKey: navigator,
          theme: surfaceTransformTheme,
          home: SingleChildScrollView(
            controller: scroll,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 1000),
                  Align(
                    alignment: .centerLeft,
                    child: MateoMenuButton(
                      animation: const .transform(),
                      buttonPresentation: const .label(label: 'Mateo Surface', variant: .secondary, width: .fit),
                      menuPresentation: .options(
                        items: const [MateoMenuOptionsPresentationItem(principal: SizedBox(width: 240, height: 130))],
                      ),
                    ),
                  ),
                  const SizedBox(height: 1000),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final offset in [244.0, 274.0, 184.0]) {
        scroll.jumpTo(offset);
        await tester.pumpAndSettle();
        final anchor = tester.getRect(find.byType(MateoMenuButton));
        await tester.tapAt(Offset(anchor.center.dx, anchor.top + 8));
        await tester.pumpAndSettle();
        final menu = tester.getRect(find.byType(MateoMenu));
        expect(menu.left, closeTo(anchor.left, .001));
        expect(menu.bottom, closeTo(anchor.bottom, .001));
        expect(menu.right, lessThanOrEqualTo(370));
        navigator.currentState!.pop();
        await tester.pumpAndSettle();
      }
    },
  );

  for (final direction in TextDirection.values) {
    for (final placement in [1, 2, 3, 4, 5]) {
      testWidgets(
        'when anchored placement $placement is needed in $direction, it should follow automatic direction priority',
        (
          tester,
        ) async {
          final offset = switch (placement) {
            1 => const Offset(380, 300),
            2 => const Offset(380, 20),
            3 => const Offset(740, 250),
            4 => const Offset(20, 250),
            _ => const Offset(380, 20),
          };
          final navigator = GlobalKey<NavigatorState>();
          await tester.pumpWidget(
            MateoApp(
              navigatorKey: navigator,
              theme: surfaceTransformTheme,
              home: Directionality(
                textDirection: direction,
                child: Stack(
                  children: [
                    Positioned(
                      left: placement == 3 ? null : offset.dx,
                      right: placement == 3 ? 20 : null,
                      top: offset.dy,
                      child: MateoMenuButton(
                        animation: const .transform(),
                        buttonPresentation: const .icon(icon: MateoIcon(.cross), variant: .secondary),
                        menuPresentation: .options(
                          items: [
                            MateoMenuOptionsPresentationItem(
                              principal: SizedBox(width: 160, height: placement == 5 ? 900 : 60),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final button = tester.getRect(find.byType(MateoMenuButton));
          await tester.tap(find.byType(MateoButton));
          await tester.pumpAndSettle();
          final menu = tester.getRect(find.byType(MateoMenu));
          final alignment = switch (placement) {
            1 => Alignment.bottomCenter,
            2 => Alignment.topCenter,
            3 => Alignment.topRight,
            4 => Alignment.topLeft,
            _ => Alignment.topRight,
          };
          expect(alignment.withinRect(menu), alignment.withinRect(button));
          if (placement == 5) expect(menu.bottom, greaterThan(600));
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
        },
      );
    }
  }

  for (final top in [200.0, 340.0]) {
    testWidgets('when neither vertical side fits at $top, it should preserve edge attachment while overflowing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: Stack(
            children: [
              Positioned(
                left: 350,
                top: top,
                child: MateoMenuButton(
                  animation: const .transform(),
                  buttonPresentation: const .icon(icon: MateoIcon(.cross), variant: .secondary),
                  menuPresentation: .options(
                    items: const [
                      MateoMenuOptionsPresentationItem(
                        principal: SizedBox(width: 100, height: 360),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final trigger = tester.getRect(find.byType(MateoMenuButton));
      await tester.tap(find.byType(MateoButton));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byType(MateoMenu));
      // No edge-attached candidate fits: retain the final left candidate.
      if (top < 300) {
        expect(panel.topRight, trigger.topRight);
        expect(panel.bottom, greaterThan(580));
      } else {
        expect(panel.bottomRight, trigger.bottomRight);
        expect(panel.top, lessThan(20));
      }
    });
  }

  testWidgets('when a menu is smaller than its trigger, it should keep a vertical edge attached', (tester) async {
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: Center(
          child: MateoMenuButton(
            animation: const .transform(),
            buttonPresentation: const .label(
              label: 'A generously sized trigger',
              variant: .secondary,
              width: .fit,
              leadingIcon: SizedBox(width: 100, height: 140),
            ),
            menuPresentation: .options(items: const [MateoMenuOptionsPresentationItem()]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final trigger = tester.getRect(find.byType(MateoMenuButton));
    await tester.tap(find.byType(MateoButton));
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byType(MateoMenu));
    expect(panel.width, lessThan(trigger.width));
    expect(panel.height, lessThan(trigger.height));
    expect(panel.topCenter, trigger.topCenter);
  });

  testWidgets(
    'when a fill menu opens, it should fill the available width and prefer downward placement at the midpoint',
    (tester) async {
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: Center(
            child: MateoMenuButton(
              animation: const .transform(),
              buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
              menuPresentation: .options(
                width: .fill,
                items: const [MateoMenuOptionsPresentationItem(principal: Text('Choice'))],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final button = tester.getRect(find.byType(MateoMenuButton));
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();
      final menu = tester.getRect(find.byType(MateoMenu));
      expect(menu.width, 760);
      expect(menu.left, 20);
      expect(menu.topCenter, button.topCenter);
    },
  );

  for (final reduced in [false, true]) {
    testWidgets('when reduced motion is $reduced, it should guard opening and closing and allow reopening', (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MateoApp(
          navigatorKey: navigator,
          theme: surfaceTransformTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
            child: child!,
          ),
          home: Center(
            child: MateoMenuButton(
              animation: const .transform(),
              buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
              menuPresentation: .options(
                items: const [MateoMenuOptionsPresentationItem(principal: Text('Choice'))],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final activate = tester.widget<MateoButton>(find.byType(MateoButton)).onPressed!;
      activate();
      activate();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      if (reduced) expect(surfaceFlight, findsNothing);
      expect(find.byType(MateoMenu), findsOneWidget);
      navigator.currentState!.pop();
      activate();
      await tester.pumpAndSettle();
      expect(find.byType(MateoMenu), findsNothing);
      expect(surfaceFlight, findsNothing);
      activate();
      await tester.pumpAndSettle();
      expect(find.byType(MateoMenu), findsOneWidget);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      for (final indicator in find.byType(MateoLoadingIndicator).evaluate()) {
        final fade = find
            .ancestor(
              of: find.byElementPredicate((element) => identical(element, indicator)),
              matching: find.byType(FadeTransition),
            )
            .first;
        expect(tester.widget<FadeTransition>(fade).opacity.value, 0);
      }
    });
  }

  for (final navigate in [false, true]) {
    testWidgets(
      'when a selection starts async work with navigation=$navigate, it should close once and restore safely',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        final pending = Completer<void>();
        var calls = 0;
        const item = MateoMenuOptionsPresentationItem(principal: Text('Choice'));
        await tester.pumpWidget(
          MateoApp(
            navigatorKey: navigator,
            theme: surfaceTransformTheme,
            home: Center(
              child: MateoMenuButton(
                animation: const .transform(),
                buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                menuPresentation: .options(items: [item]),
                onItemPressed: (selected) {
                  expect(selected, same(item));
                  calls++;
                  if (navigate) {
                    navigator.currentState!.push(
                      PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox.expand()),
                    );
                  }
                  return pending.future;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Options'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Choice'));
        await tester.pumpAndSettle();
        expect(calls, 1);
        expect(find.byType(MateoMenu), findsNothing);
        expect(surfaceFlight, findsNothing);
        pending.complete();
        if (navigate) {
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text('Options'));
        await tester.pumpAndSettle();
        expect(find.byType(MateoMenu), findsOneWidget);
      },
    );
  }

  testWidgets('when the trigger moves or disappears, it should keep the menu in place until dismissed', (
    tester,
  ) async {
    late StateSetter update;
    var present = true;
    var top = 300.0;
    await tester.pumpWidget(
      MateoApp(
        theme: surfaceTransformTheme,
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Stack(
              children: [
                if (present)
                  Positioned(
                    left: 300,
                    top: top,
                    child: MateoMenuButton(
                      animation: const .transform(),
                      buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                      menuPresentation: .options(
                        items: const [MateoMenuOptionsPresentationItem(principal: Text('Choice'))],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    final original = tester.getRect(find.byType(MateoMenu));
    update(() => top += 30);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)).top, original.top);
    update(() => top = 20);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)), original);
    update(() => present = false);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MateoMenu)), original);
    Navigator.of(tester.element(find.byType(MateoMenu))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(MateoMenu), findsNothing);
    expect(surfaceFlight, findsNothing);
    expect(tester.takeException(), isNull);
  });
  for (final scale in [0.75, 1.25]) {
    testWidgets('when the trigger has ancestor scale $scale, it should capture its bounds without scaling the menu', (
      tester,
    ) async {
      late StateSetter update;
      var ancestorScale = scale;
      var selections = 0;
      await tester.pumpWidget(
        MateoApp(
          theme: surfaceTransformTheme,
          home: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Center(
                child: Transform.scale(
                  scale: ancestorScale,
                  child: MateoMenuButton(
                    animation: const .transform(),
                    buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                    menuPresentation: .options(
                      items: const [MateoMenuOptionsPresentationItem(principal: Text('Choice'))],
                    ),
                    onItemPressed: (_) => selections++,
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final trigger = tester.renderObject<RenderBox>(find.byType(MateoMenuButton));
      final triggerBounds = MatrixUtils.transformRect(trigger.getTransformTo(null), Offset.zero & trigger.size);
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();
      Rect menuBounds() {
        final menu = tester.renderObject<RenderBox>(find.byType(MateoMenu));
        return MatrixUtils.transformRect(menu.getTransformTo(null), Offset.zero & menu.size);
      }

      final menuSize = tester.getSize(find.byType(MateoMenu));
      expect(menuBounds().width, closeTo(menuSize.width, 0.001));
      expect(menuBounds().height, closeTo(menuSize.height, 0.001));
      expect(menuBounds().topCenter.dx, closeTo(triggerBounds.topCenter.dx, 0.001));
      expect(menuBounds().topCenter.dy, closeTo(triggerBounds.topCenter.dy, 0.001));
      final captured = menuBounds();
      update(() => ancestorScale *= 0.9);
      await tester.pump();
      expect(menuBounds(), captured);
      await tester.tap(find.text('Choice'));
      await tester.pumpAndSettle();
      expect(selections, 1);
      expect(find.byType(MateoMenu), findsNothing);
      expect(surfaceFlight, findsNothing);
    });
  }

  for (final closing in [false, true]) {
    testWidgets(
      'when the trigger disappears during ${closing ? 'closing' : 'opening'}, it should finish safely and allow dismissal',
      (
        tester,
      ) async {
        final navigator = GlobalKey<NavigatorState>();
        late StateSetter update;
        var present = true;
        await tester.pumpWidget(
          MateoApp(
            navigatorKey: navigator,
            theme: surfaceTransformTheme,
            home: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return Center(
                  child: present
                      ? MateoMenuButton(
                          animation: const .transform(),
                          buttonPresentation: const .label(label: 'Options', variant: .secondary, width: .fit),
                          menuPresentation: .options(
                            items: const [MateoMenuOptionsPresentationItem(principal: Text('Choice'))],
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        final activate = tester.widget<MateoButton>(find.byType(MateoButton)).onPressed!;
        activate();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        if (closing) {
          await tester.pumpAndSettle();
          navigator.currentState!.pop();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 60));
        }
        expect(surfaceFlight, findsOneWidget);
        update(() => present = false);
        await tester.pumpAndSettle();
        activate();
        await tester.pumpAndSettle();
        if (!closing) {
          expect(find.byType(MateoMenu), findsOneWidget);
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
        }
        expect(find.byType(MateoMenu), findsNothing);
        expect(surfaceFlight, findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
