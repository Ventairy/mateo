import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoSkeletonStyle', () {
    test('when two instances have the same fields, it should be equal', () {
      const a = MateoSkeletonStyle();
      const b = MateoSkeletonStyle();

      expect(a, equals(b));
    });

    test('when color differs, it should not be equal', () {
      final a = MateoSkeletonStyle(color: mateoTestColorScheme.background);
      final b = MateoSkeletonStyle(
        color: mateoTestColorScheme.colors.neutral.solid,
      );

      expect(a, isNot(equals(b)));
    });

    test('when effect differs, it should not be equal', () {
      final a = const MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect());
      final b = const MateoSkeletonStyle();

      expect(a, isNot(equals(b)));
    });

    test('when textRadius differs, it should not be equal', () {
      const a = MateoSkeletonStyle(textRadius: Radius.zero);
      const b = MateoSkeletonStyle(textRadius: Radius.circular(8));

      expect(a, isNot(equals(b)));
    });

    test(
      'when all fields are null, the default constructor should create a const instance',
      () {
        const style = MateoSkeletonStyle();

        expect(style.color, isNull);
        expect(style.effect, isNull);
        expect(style.textRadius, isNull);
      },
    );

    test(
      'when hashing two equal styles, it should produce the same hashCode',
      () {
        final a = MateoSkeletonStyle(
          color: mateoTestColorScheme.inverse.background,
          textRadius: Radius.circular(4),
        );
        final b = MateoSkeletonStyle(
          color: mateoTestColorScheme.inverse.background,
          textRadius: Radius.circular(4),
        );

        expect(a.hashCode, equals(b.hashCode));
      },
    );

    test('when passing color, it should be stored', () {
      final style = MateoSkeletonStyle(
        color: mateoTestColorScheme.text.secondary,
      );

      expect(style.color, equals(mateoTestColorScheme.text.secondary));
    });

    test('when passing textRadius, it should be stored', () {
      const style = MateoSkeletonStyle(textRadius: Radius.circular(12));

      expect(style.textRadius, equals(const Radius.circular(12)));
    });

    test('when passing effect, it should be stored', () {
      const style = MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect());

      expect(style.effect, isA<MateoSkeletonShimmerEffect>());
    });
  });
}
