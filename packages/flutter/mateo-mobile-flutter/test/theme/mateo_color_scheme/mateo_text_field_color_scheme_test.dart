import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoTextFieldVariantColorScheme', () {
    const scheme = MateoTextFieldVariantColorScheme(
      background: Color(0xFFF9FAFB),
      backgroundDisabled: Color(0xFFE0E1E5),
      text: Color(0xFF17181B),
      textDisabled: Color(0xFF17181B),
      placeholderResting: Color(0xFF909297),
      placeholderDisabled: Color(0xFF17181B),
      iconResting: Color(0xFFB3B3B3),
      iconFocused: Color(0xFF17181B),
      iconDisabled: Color(0xFF909297),
      caret: Color(0xFF4A5CFF),
      selectionHighlight: Color(0x4D4A5CFF),
    );

    test('when created, it should expose every supplied role', () {
      expect(scheme.background, const Color(0xFFF9FAFB));
      expect(scheme.backgroundDisabled, const Color(0xFFE0E1E5));
      expect(scheme.text, const Color(0xFF17181B));
      expect(scheme.textDisabled, const Color(0xFF17181B));
      expect(scheme.placeholderResting, const Color(0xFF909297));
      expect(scheme.placeholderDisabled, const Color(0xFF17181B));
      expect(scheme.iconResting, const Color(0xFFB3B3B3));
      expect(scheme.iconFocused, const Color(0xFF17181B));
      expect(scheme.iconDisabled, const Color(0xFF909297));
      expect(scheme.caret, const Color(0xFF4A5CFF));
      expect(scheme.selectionHighlight, const Color(0x4D4A5CFF));
    });

    test('when copied without overrides, it should preserve every role', () {
      expect(scheme.copyWith(), scheme);
    });

    test('when copied with overrides, it should replace those roles', () {
      final result = scheme.copyWith(
        background: Colors.black,
        backgroundDisabled: Colors.blue,
        iconActive: Colors.white,
      );

      expect(result.background, Colors.black);
      expect(result.backgroundDisabled, Colors.blue);
      expect(result.iconFocused, Colors.white);
    });

    test('when interpolated halfway, it should blend every role', () {
      const target = MateoTextFieldVariantColorScheme(
        background: Colors.white,
        backgroundDisabled: Colors.white,
        text: Colors.white,
        textDisabled: Colors.white,
        placeholderResting: Colors.white,
        placeholderDisabled: Colors.white,
        iconResting: Colors.white,
        iconFocused: Colors.white,
        iconDisabled: Colors.white,
        caret: Colors.white,
        selectionHighlight: Colors.white,
      );

      final result = MateoTextFieldVariantColorScheme.lerp(scheme, target, 0.5);

      expect(
        result.background,
        Color.lerp(scheme.background, target.background, 0.5),
      );
      expect(
        result.backgroundDisabled,
        Color.lerp(scheme.backgroundDisabled, target.backgroundDisabled, 0.5),
      );
      expect(result.text, Color.lerp(scheme.text, target.text, 0.5));
      expect(
        result.textDisabled,
        Color.lerp(scheme.textDisabled, target.textDisabled, 0.5),
      );
      expect(
        result.placeholderResting,
        Color.lerp(scheme.placeholderResting, target.placeholderResting, 0.5),
      );
      expect(
        result.placeholderDisabled,
        Color.lerp(scheme.placeholderDisabled, target.placeholderDisabled, 0.5),
      );
      expect(
        result.iconResting,
        Color.lerp(scheme.iconResting, target.iconResting, 0.5),
      );
      expect(
        result.iconFocused,
        Color.lerp(scheme.iconFocused, target.iconFocused, 0.5),
      );
      expect(
        result.iconDisabled,
        Color.lerp(scheme.iconDisabled, target.iconDisabled, 0.5),
      );
      expect(result.caret, Color.lerp(scheme.caret, target.caret, 0.5));
      expect(
        result.selectionHighlight,
        Color.lerp(scheme.selectionHighlight, target.selectionHighlight, 0.5),
      );
    });

    test('when roles are equal, it should produce the same hash code', () {
      expect(scheme.hashCode, scheme.copyWith().hashCode);
    });
  });

  group('MateoTextFieldColorScheme', () {
    final textField = MateoColorScheme.light().textField;

    test('when copied without overrides, it should preserve variants', () {
      expect(textField.copyWith(), textField);
    });

    test('when interpolated, it should interpolate every variant', () {
      final target = textField.copyWith(
        floating: textField.floating.copyWith(caret: Colors.black),
        filled: textField.filled.copyWith(caret: Colors.black),
      );

      expect(MateoTextFieldColorScheme.lerp(textField, target, 0), textField);
      expect(MateoTextFieldColorScheme.lerp(textField, target, 1), target);
    });
  });
}
