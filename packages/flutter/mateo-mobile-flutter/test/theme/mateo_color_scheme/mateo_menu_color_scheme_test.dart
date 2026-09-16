import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoMenuColorScheme', () {
    const scheme = MateoMenuColorScheme(
      background: Color(0xFF010101),
      title: Color(0xFF020202),
      titleDisabled: Color(0xFF030303),
      description: Color(0xFF040404),
      descriptionDisabled: Color(0xFF050505),
      icon: Color(0xFF060606),
      iconDisabled: Color(0xFF070707),
      scrim: Color(0xFF080808),
    );

    test('when created, it should expose every supplied role', () {
      expect(scheme.background, const Color(0xFF010101));
      expect(scheme.title, const Color(0xFF020202));
      expect(scheme.titleDisabled, const Color(0xFF030303));
      expect(scheme.description, const Color(0xFF040404));
      expect(scheme.descriptionDisabled, const Color(0xFF050505));
      expect(scheme.icon, const Color(0xFF060606));
      expect(scheme.iconDisabled, const Color(0xFF070707));
      expect(scheme.scrim, const Color(0xFF080808));
    });

    test('when copied, it should replace only supplied roles', () {
      final copied = scheme.copyWith(
        background: Colors.pink,
        descriptionDisabled: Colors.orange,
      );

      expect(copied.background, Colors.pink);
      expect(copied.descriptionDisabled, Colors.orange);
      expect(copied.title, scheme.title);
      expect(copied.iconDisabled, scheme.iconDisabled);
      expect(scheme.copyWith(), scheme);
      expect(scheme.copyWith().hashCode, scheme.hashCode);
    });

    test('when interpolated, it should blend every role', () {
      const target = MateoMenuColorScheme(
        background: Colors.white,
        title: Colors.white,
        titleDisabled: Colors.white,
        description: Colors.white,
        descriptionDisabled: Colors.white,
        icon: Colors.white,
        iconDisabled: Colors.white,
        scrim: Colors.white,
      );
      final midpoint = MateoMenuColorScheme.lerp(
        scheme,
        target,
        0.5,
      );

      expect(
        midpoint.background,
        Color.lerp(scheme.background, target.background, 0.5),
      );
      expect(midpoint.title, Color.lerp(scheme.title, target.title, 0.5));
      expect(
        midpoint.titleDisabled,
        Color.lerp(scheme.titleDisabled, target.titleDisabled, 0.5),
      );
      expect(
        midpoint.description,
        Color.lerp(scheme.description, target.description, 0.5),
      );
      expect(
        midpoint.descriptionDisabled,
        Color.lerp(
          scheme.descriptionDisabled,
          target.descriptionDisabled,
          0.5,
        ),
      );
      expect(midpoint.icon, Color.lerp(scheme.icon, target.icon, 0.5));
      expect(
        midpoint.iconDisabled,
        Color.lerp(scheme.iconDisabled, target.iconDisabled, 0.5),
      );
      expect(midpoint.scrim, Color.lerp(scheme.scrim, target.scrim, 0.5));
    });
  });

  group('Theme menu colors', () {
    test('when using the light theme, it should provide each presentation role', () {
      final palette = MateoPalette();
      final menu = MateoColorScheme.light(palette: palette).menu;

      for (final scheme in [menu.action, menu.context]) {
        expect(scheme.background, Colors.black);
        expect(scheme.title, Colors.white);
        expect(scheme.titleDisabled, palette.neutral[9]);
        expect(scheme.description, palette.neutral[7]);
        expect(scheme.descriptionDisabled, palette.neutral[11]);
        expect(scheme.icon, palette.neutral[1]);
        expect(scheme.iconDisabled, Colors.white.withValues(alpha: 0.45));
        expect(scheme.scrim, Colors.transparent);
      }
    });

    test('when copied and interpolated, it should preserve independent presentation roles', () {
      final source = MateoColorScheme.light().menu;
      final replacement = source.copyWith(
        action: source.action.copyWith(background: Colors.purple),
        context: source.context.copyWith(scrim: Colors.orange),
      );
      final midpoint = MateoMenusColorScheme.lerp(source, replacement, 0.5);

      expect(source.copyWith(), source);
      expect(source.copyWith().hashCode, source.hashCode);
      expect(replacement.action.background, Colors.purple);
      expect(replacement.context.scrim, Colors.orange);
      expect(
        midpoint.action.background,
        Color.lerp(source.action.background, Colors.purple, 0.5),
      );
      expect(
        midpoint.context.scrim,
        Color.lerp(source.context.scrim, Colors.orange, 0.5),
      );
    });

    test('when replacing menu colors, the complete scheme should retain them', () {
      final source = MateoColorScheme.light();
      final replacement = source.menu.action.copyWith(
        background: Colors.purple,
      );
      final changed = source.copyWith(menu: source.menu.copyWith(action: replacement));

      expect(changed.menu.action, replacement);
      expect(changed.menu.context, source.menu.context);
      expect(MateoColorScheme.lerp(source, changed, 0), source);
      expect(
        MateoColorScheme.lerp(source, changed, 0.5).menu.action.background,
        Color.lerp(source.menu.action.background, Colors.purple, 0.5),
      );
    });
  });
}
