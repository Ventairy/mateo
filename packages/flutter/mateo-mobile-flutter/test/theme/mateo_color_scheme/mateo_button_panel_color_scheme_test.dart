import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoButtonPanelColorScheme', () {
    const scheme = MateoButtonPanelColorScheme(
      background: Color(0xFFF9FAFB),
      border: Color(0xFFFFFFFF),
      shadow: Color(0x33000000),
    );

    test('when created, it should expose every supplied role', () {
      expect(scheme.background, const Color(0xFFF9FAFB));
      expect(scheme.border, Colors.white);
      expect(scheme.shadow, const Color(0x33000000));
    });

    test('when copied without overrides, it should preserve every role', () {
      expect(scheme.copyWith(), scheme);
    });

    test('when copied with an override, it should replace that role', () {
      expect(scheme.copyWith(border: Colors.black).border, Colors.black);
    });

    test('when interpolated halfway, it should blend every role', () {
      const target = MateoButtonPanelColorScheme(
        background: Color(0xFF111111),
        border: Color(0xFF222222),
        shadow: Color(0x66000000),
      );

      expect(
        MateoButtonPanelColorScheme.lerp(scheme, target, 0.5),
        MateoButtonPanelColorScheme(
          background: Color.lerp(scheme.background, target.background, 0.5)!,
          border: Color.lerp(scheme.border, target.border, 0.5)!,
          shadow: Color.lerp(scheme.shadow, target.shadow, 0.5)!,
        ),
      );
    });

    test('when roles are equal, it should produce the same hash code', () {
      const equalScheme = MateoButtonPanelColorScheme(
        background: Color(0xFFF9FAFB),
        border: Color(0xFFFFFFFF),
        shadow: Color(0x33000000),
      );

      expect(scheme.hashCode, equalScheme.hashCode);
    });
  });
}
