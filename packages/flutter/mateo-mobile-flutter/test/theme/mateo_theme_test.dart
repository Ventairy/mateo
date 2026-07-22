import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoTheme.light', () {
    test('builds a light Material theme with Mateo extensions', () {
      final theme = MateoTheme.light();
      final mateo = theme.extension<MateoThemeData>();

      expect(theme.brightness, Brightness.light);
      expect(theme.useMaterial3, isTrue);
      expect(
        theme.textTheme.bodyMedium?.fontFamily,
        MateoTypography.fontFamily,
      );
      expect(
        theme.textTheme.bodyMedium?.letterSpacing,
        MateoTypography.letterSpacing,
      );
      expect(mateo, isNotNull);
      expect(theme.scaffoldBackgroundColor, mateo!.colorScheme.background);
      expect(theme.colorScheme.primary, mateo.palette.primary[9]);
      expect(
        theme.colorScheme.onPrimary,
        mateo.colorScheme.buttons.primary.foreground,
      );
      expect(theme.colorScheme.scrim, mateo.colorScheme.overlay.scrim);
    });

    test('maps the default primary through the palette and color scheme', () {
      final mateo = MateoTheme.light().extension<MateoThemeData>()!;

      expect(
        mateo.colorScheme.buttons.primary.background,
        mateo.palette.primary[9],
      );
    });

    test('regenerates primary and neutral from a custom seed', () {
      const seed = Color(0xFF00A86B);
      const onPrimary = Color(0xFF101A16);
      final mateo = MateoTheme.light(
        primaryColor: seed,
        onPrimary: onPrimary,
      ).extension<MateoThemeData>()!;

      expect(mateo.palette.primary[9], seed);
      expect(mateo.colorScheme.buttons.primary.background, seed);
      expect(mateo.colorScheme.buttons.primary.foreground, onPrimary);
      expect(mateo.colorScheme.controls.indicatorForeground, onPrimary);
      expect(mateo.colorScheme.text.primary, mateo.palette.neutral[12]);
    });

    test('maps onPrimary to Material and Mateo primary surfaces', () {
      const onPrimary = Color(0xFF171221);
      final theme = MateoTheme.light(onPrimary: onPrimary);
      final mateo = theme.extension<MateoThemeData>()!;

      expect(theme.colorScheme.onPrimary, onPrimary);
      expect(mateo.colorScheme.buttons.primary.foreground, onPrimary);
      expect(mateo.colorScheme.controls.indicatorForeground, onPrimary);
    });

    test('maps Material roles from Mateo primitives and semantics', () {
      final theme = MateoTheme.light();
      final mateo = theme.extension<MateoThemeData>()!;
      final palette = mateo.palette;

      expect(theme.colorScheme.primaryContainer, palette.primary[3]);
      expect(theme.colorScheme.secondary, palette.teal[9]);
      expect(theme.colorScheme.tertiary, palette.orange[9]);
      expect(theme.colorScheme.error, palette.red[10]);
      expect(theme.colorScheme.surface, mateo.colorScheme.background);
      expect(theme.colorScheme.onSurface, mateo.colorScheme.text.primary);
      expect(theme.colorScheme.outline, palette.neutral[8]);
      expect(theme.colorScheme.outlineVariant, palette.neutral[6]);
    });
  });

  test('MateoThemeData copyWith and lerp retain palette and colors', () {
    final a = MateoTheme.light().extension<MateoThemeData>()!;
    final changedScheme = a.colorScheme.copyWith(background: Colors.black);
    final b = a.copyWith(colorScheme: changedScheme);

    expect(b.palette, a.palette);
    expect(b.colorScheme.background, Colors.black);
    expect(a.lerp(b, 0).colorScheme, a.colorScheme);
    expect(a.lerp(b, 1).colorScheme, b.colorScheme);
  });
}
