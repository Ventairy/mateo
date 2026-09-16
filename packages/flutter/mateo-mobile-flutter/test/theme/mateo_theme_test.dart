import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoTheme.light', () {
    test('when created, it should build a light-only configuration with Mateo extensions', () {
      final configuration = MateoTheme.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      );
      final theme = configuration.lightTheme;
      final mateo = theme.extension<MateoThemeData>();

      expect(configuration.themeMode, ThemeMode.light);
      expect(configuration.darkTheme, same(configuration.lightTheme));
      expect(theme.brightness, Brightness.light);
      expect(theme.useMaterial3, isTrue);
      expect(theme.textTheme.bodyMedium?.fontFamily, MateoTypography.fontFamily);
      expect(theme.textTheme.bodyMedium?.letterSpacing, MateoTypography.letterSpacing);
      expect(mateo, isNotNull);
      expect(theme.scaffoldBackgroundColor, mateo!.colorScheme.background);
      expect(theme.colorScheme.primary, mateo.palette.accent[9]);
      expect(theme.colorScheme.onPrimary, mateo.colorScheme.buttons.primary.accent.foreground);
      expect(theme.colorScheme.scrim, mateo.colorScheme.overlay.scrim);
    });

    test('when accent is customized, it should retain the default Mateo neutral scale', () {
      const accent = Color(0xFF00A86B);
      const onAccent = Color(0xFF101A16);
      final mateo = MateoTheme.light(
        accentColor: accent,
        onAccent: onAccent,
      ).lightTheme.extension<MateoThemeData>()!;

      expect(mateo.palette.accent[9], accent);
      expect(mateo.palette.neutral.colors, MateoPalette().neutral.colors);
      expect(mateo.colorScheme.buttons.primary.accent.background, accent);
      expect(mateo.colorScheme.buttons.primary.accent.foreground, onAccent);
      expect(mateo.colorScheme.buttons.primary.accent.foreground, onAccent);
      expect(mateo.colorScheme.text.primary, mateo.palette.neutral[12]);
    });

    test('when created, it should map fixed achromatic neutrals into Material roles', () {
      final theme = MateoTheme.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      ).lightTheme;
      final mateo = theme.extension<MateoThemeData>()!;

      expect(mateo.palette.neutral.colors, MateoPalette().neutral.colors);
      expect(theme.colorScheme.onSurface, mateo.colorScheme.text.primary);
      expect(theme.colorScheme.outline, mateo.palette.neutral[8]);
      expect(theme.colorScheme.outlineVariant, mateo.palette.neutral[6]);
    });

    test('when mapping Material roles, it should use Mateo primitives and semantics', () {
      final theme = MateoTheme.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      ).lightTheme;
      final mateo = theme.extension<MateoThemeData>()!;
      final palette = mateo.palette;

      expect(theme.colorScheme.primaryContainer, palette.accent[3]);
      expect(theme.colorScheme.secondary, palette.teal[9]);
      expect(theme.colorScheme.tertiary, palette.orange[9]);
      expect(theme.colorScheme.error, palette.red[10]);
      expect(theme.colorScheme.surface, mateo.colorScheme.background);
      expect(theme.colorScheme.onSurface, mateo.colorScheme.text.primary);
      expect(theme.colorScheme.outline, palette.neutral[8]);
      expect(theme.colorScheme.outlineVariant, palette.neutral[6]);
    });
  });

  group('MateoTheme.adaptive', () {
    test('when created, it should expose both branches and follow system mode', () {
      final configuration = MateoTheme.adaptive(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      );

      expect(configuration.themeMode, ThemeMode.system);
      expect(configuration.lightTheme, isNotNull);
      expect(configuration.darkTheme, same(configuration.lightTheme));
      expect(configuration.lightTheme.brightness, Brightness.light);
      expect(configuration.darkTheme.brightness, Brightness.light);
      expect(
        configuration.lightTheme.extension<MateoThemeData>()!.palette.neutral.colors,
        MateoPalette().neutral.colors,
      );
    });
  });

  test('when MateoThemeData is copied and interpolated, it should retain palette and colors', () {
    final a = MateoTheme.light(
      accentColor: const Color(0xFF4A5CFF),
      onAccent: const Color(0xFFFFFFFF),
    ).lightTheme.extension<MateoThemeData>()!;
    final changedScheme = a.colorScheme.copyWith(background: Colors.black);
    final b = a.copyWith(colorScheme: changedScheme);

    expect(b.palette, a.palette);
    expect(b.colorScheme.background, Colors.black);
    expect(a.lerp(b, 0).colorScheme, a.colorScheme);
    expect(a.lerp(b, 1).colorScheme, b.colorScheme);
  });
}
