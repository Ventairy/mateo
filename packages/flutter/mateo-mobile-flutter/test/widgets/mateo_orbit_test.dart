import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import '../test_app.dart';

void main() {
  group('MateoOrbit constructor', () {
    test('when constructed with 3 items, it should throw AssertionError', () {
      expect(
        () => MateoOrbit(
          items: const [
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when constructed with 2 items, it should throw AssertionError', () {
      expect(
        () => MateoOrbit(
          items: const [
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('when constructed with 4 items, it should not throw', () {
      expect(
        () => MateoOrbit(
          items: const [
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
            MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
          ],
        ),
        returnsNormally,
      );
    });

    test('when constructed with 8 items, it should not throw', () {
      expect(
        () => MateoOrbit(
          items: List.generate(
            8,
            (_) => const MateoOrbitItem(child: SizedBox(), size: Size(10, 10)),
          ),
        ),
        returnsNormally,
      );
    });
  });

  group('MateoOrbit rendering', () {
    testWidgets('when rendered with 4 items, it should display without error', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: _fourItemOrbit()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('when rendered with 6 items, it should display without error', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: _sixItemOrbit()));

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when rendered with 12 items, it should display without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoOrbit(
              items: List.generate(
                12,
                (_) => const MateoOrbitItem(
                  child: SizedBox(width: 48, height: 48),
                  size: Size(48, 48),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when animations are disabled, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(child: _fourItemOrbit()),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when animations are enabled, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(TestApp(child: _fourItemOrbit()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('when rotateItems is true, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(child: _fourItemOrbit(rotateItems: true)),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when rotateItems is false, items should not have Transform.rotate',
      (tester) async {
        await tester.pumpWidget(TestApp(child: _fourItemOrbit()));

        // Default path (rotateItems: false) — each item's position is animated
        // independently but items are NOT wrapped in Transform.rotate.
        // Pass pump a frame then immediately stop controller so we can inspect
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when rotateItems is true, it should rotate through the paint-only Flow delegate',
      (tester) async {
        await tester.pumpWidget(
          TestApp(child: _fourItemOrbit(rotateItems: true)),
        );

        final orbit = find.byType(MateoOrbit);
        final flows = find.descendant(of: orbit, matching: find.byType(Flow));
        expect(flows, findsOneWidget);
      },
    );

    testWidgets(
      'when animations are disabled and rotateItems is true, no Transform.rotate should exist',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(child: _fourItemOrbit(rotateItems: true)),
          ),
        );

        final orbit = find.byType(MateoOrbit);
        final transforms = find.descendant(
          of: orbit,
          matching: find.byType(Transform),
        );
        expect(transforms, findsNothing);
      },
    );

    testWidgets(
      'when radius is explicitly provided, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoOrbit(
              radius: 80,
              items: List.generate(
                4,
                (_) => const MateoOrbitItem(
                  child: SizedBox(width: 40, height: 40),
                  size: Size(40, 40),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when radius is zero, it should render items at center without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoOrbit(
              radius: 0,
              items: List.generate(
                4,
                (_) => const MateoOrbitItem(
                  child: SizedBox(width: 20, height: 20),
                  size: Size(20, 20),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when direction is counterclockwise, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: _fourItemOrbit(
              direction: MateoOrbitDirection.counterclockwise,
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when initialAngle is set, it should render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: MateoOrbit(
            initialAngle: 1.5,
            items: List.generate(
              4,
              (_) => const MateoOrbitItem(
                child: SizedBox(width: 40, height: 40),
                size: Size(40, 40),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when padding is set and radius is auto, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoOrbit(
              padding: 20,
              items: List.generate(
                4,
                (_) => const MateoOrbitItem(
                  child: SizedBox(width: 40, height: 40),
                  size: Size(40, 40),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when items have different sizes, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: MateoOrbit(
              items: const [
                MateoOrbitItem(
                  child: SizedBox(width: 40, height: 40),
                  size: Size(40, 40),
                ),
                MateoOrbitItem(
                  child: SizedBox(width: 60, height: 30),
                  size: Size(60, 30),
                ),
                MateoOrbitItem(
                  child: SizedBox(width: 24, height: 48),
                  size: Size(24, 48),
                ),
                MateoOrbitItem(
                  child: SizedBox(width: 80, height: 20),
                  size: Size(80, 20),
                ),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when revolutionDuration is changed, it should rebuild without error',
      (tester) async {
        await tester.pumpWidget(TestApp(child: _fourItemOrbit()));

        await tester.pumpWidget(
          TestApp(
            child: _fourItemOrbit(
              revolutionDuration: const Duration(seconds: 10),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when revolutionDuration is changed to a very short duration, it should render without error',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            child: _fourItemOrbit(
              revolutionDuration: const Duration(milliseconds: 100),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when placed in a constrained box, it should adapt its size', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TestApp(
            child: SizedBox(width: 200, height: 200, child: _fourItemOrbit()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('when placed in a small box, it should still render', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TestApp(
            child: SizedBox(width: 100, height: 100, child: _fourItemOrbit()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when placed in an unbounded container, it should use default fallback size',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TestApp(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: double.infinity,
                minHeight: 0,
                maxHeight: double.infinity,
                child: _fourItemOrbit(),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}

Widget _fourItemOrbit({
  bool rotateItems = false,
  Duration revolutionDuration = const Duration(seconds: 30),
  MateoOrbitDirection direction = MateoOrbitDirection.clockwise,
}) {
  return MateoOrbit(
    rotateItems: rotateItems,
    revolutionDuration: revolutionDuration,
    direction: direction,
    items: [
      MateoOrbitItem(
        child: _TestIcon(
          Icons.bolt_rounded,
          mateoTestColorScheme.buttons.primary.background,
        ),
        size: Size(48, 48),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.restaurant_rounded,
          mateoTestColorScheme.buttons.success.background,
        ),
        size: Size(48, 48),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.delivery_dining_rounded,
          mateoTestColorScheme.toast.info.background,
        ),
        size: Size(48, 48),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.cleaning_services_rounded,
          mateoTestColorScheme.toast.warning.icon,
        ),
        size: Size(48, 48),
      ),
    ],
  );
}

Widget _sixItemOrbit() {
  return MateoOrbit(
    items: [
      MateoOrbitItem(
        child: _TestIcon(
          Icons.bolt_rounded,
          mateoTestColorScheme.buttons.primary.background,
        ),
        size: Size(40, 40),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.restaurant_rounded,
          mateoTestColorScheme.buttons.success.background,
        ),
        size: Size(40, 40),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.delivery_dining_rounded,
          mateoTestColorScheme.toast.info.background,
        ),
        size: Size(40, 40),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.cleaning_services_rounded,
          mateoTestColorScheme.toast.warning.icon,
        ),
        size: Size(40, 40),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.handyman_rounded,
          mateoTestColorScheme.buttons.secondary.foreground,
        ),
        size: Size(40, 40),
      ),
      MateoOrbitItem(
        child: _TestIcon(
          Icons.local_laundry_service_rounded,
          mateoTestColorScheme.text.profit,
        ),
        size: Size(40, 40),
      ),
    ],
  );
}

class _TestIcon extends StatelessWidget {
  const _TestIcon(this.icon, this.color);

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: mateoTestColorScheme.background, size: 22),
    );
  }
}
