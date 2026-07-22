import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoHeroEdgeFade', () {
    test(
      'when top and bottom are both provided, lerp should interpolate each side independently',
      () {
        final source = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(
            color: mateoTestColorScheme.buttons.danger.background,
            height: 100,
          ),
          bottom: MateoEdgeFadeStyle(
            color: mateoTestColorScheme.toast.info.icon,
            height: 50,
          ),
        );
        final destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(
            color: mateoTestColorScheme.buttons.success.background,
            height: 200,
          ),
          bottom: MateoEdgeFadeStyle(
            color: mateoTestColorScheme.toast.warning.icon,
            height: 80,
          ),
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0.5);

        expect(result.top, isNotNull);
        expect(result.top!.height, equals(150.0));
        expect(result.bottom, isNotNull);
        expect(result.bottom!.height, equals(65.0));
      },
    );

    test('when top is null on both endpoints, lerp should keep top null', () {
      const source = MateoHeroEdgeFade(bottom: MateoEdgeFadeStyle(height: 100));
      const destination = MateoHeroEdgeFade(
        bottom: MateoEdgeFadeStyle(height: 200),
      );

      final result = MateoHeroEdgeFade.lerp(source, destination, 0.5);

      expect(result.top, isNull);
      expect(result.bottom!.height, equals(150.0));
    });

    test('copyWith should update only the specified field', () {
      const original = MateoHeroEdgeFade(
        top: MateoEdgeFadeStyle(height: 100),
        bottom: MateoEdgeFadeStyle(height: 50),
      );

      final updated = original.copyWith(
        top: const MateoEdgeFadeStyle(height: 200),
      );

      expect(updated.top!.height, equals(200.0));
      expect(updated.bottom, equals(original.bottom));
    });

    test('equality should compare both sides', () {
      const a = MateoHeroEdgeFade(
        top: MateoEdgeFadeStyle(height: 100),
        bottom: MateoEdgeFadeStyle(height: 50),
      );
      const b = MateoHeroEdgeFade(
        top: MateoEdgeFadeStyle(height: 100),
        bottom: MateoEdgeFadeStyle(height: 50),
      );

      expect(a, equals(b));
    });

    test(
      'when using the default switchThreshold, lerp should preserve the current full-flight timing',
      () {
        const source = MateoHeroEdgeFade(top: MateoEdgeFadeStyle(height: 0));
        const destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0.5);

        expect(result.top!.height, equals(50.0));
      },
    );

    test(
      'when switchThreshold is 0.1, lerp should reach halfway at 5 percent of the flight',
      () {
        const source = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 0),
          switchThreshold: 0.1,
        );
        const destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0.05);

        expect(result.top!.height, equals(50.0));
      },
    );

    test(
      'when switchThreshold is 0.1, lerp should reach the destination at 10 percent of the flight',
      () {
        const source = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 0),
          switchThreshold: 0.1,
        );
        const destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0.1);

        expect(result.top!.height, equals(100.0));
      },
    );

    test(
      'when endpoints have different switchThreshold values, lerp should use the source threshold',
      () {
        const source = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 0),
          switchThreshold: 0.1,
        );
        const destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
          switchThreshold: 0.9,
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0.1);

        expect(result.top!.height, equals(100.0));
      },
    );

    test(
      'when switchThreshold is zero, lerp should switch to the destination immediately',
      () {
        const source = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 0),
          switchThreshold: 0,
        );
        const destination = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
        );

        final result = MateoHeroEdgeFade.lerp(source, destination, 0);

        expect(result.top!.height, equals(100.0));
      },
    );

    test(
      'when creating with switchThreshold below zero, it should throw an assertion error',
      () {
        expect(
          () => MateoHeroEdgeFade(switchThreshold: -0.1),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      'when creating with switchThreshold above one, it should throw an assertion error',
      () {
        expect(
          () => MateoHeroEdgeFade(switchThreshold: 1.1),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      'when copying with a switchThreshold, it should update the threshold',
      () {
        const original = MateoHeroEdgeFade(
          top: MateoEdgeFadeStyle(height: 100),
        );

        final updated = original.copyWith(switchThreshold: 0.1);

        expect(updated.switchThreshold, equals(0.1));
      },
    );
  });
}
