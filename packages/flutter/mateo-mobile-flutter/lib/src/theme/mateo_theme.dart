import 'package:flutter/material.dart';

import 'mateo_color_scheme/mateo_color_scheme.dart';
import 'mateo_palette/mateo_palette.dart';
import 'mateo_theme_data.dart';
import 'mateo_typography.dart';

/// Factory for Mateo [ThemeData] objects.
///
/// Material components and Mateo widgets resolve from the same semantic scheme,
/// preventing framework defaults from drifting away from package tokens.
abstract final class MateoTheme {
  /// Creates a Mateo Mobile light theme from [primaryColor] and [onPrimary].
  ///
  /// When omitted, Mateo violet and white are used. A custom [primaryColor]
  /// regenerates both the primary and neutral scales. [onPrimary] defines the
  /// foreground on primary surfaces and must be contrast-checked by consumers.
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: MateoTheme.light(),
  ///   home: const HomeScreen(),
  /// )
  /// ```
  static ThemeData light({Color? primaryColor, Color? onPrimary}) {
    final palette = MateoPalette(primaryColor: primaryColor);
    final colorScheme = MateoColorScheme.light(
      palette: palette,
      onPrimary: onPrimary,
    );

    return _build(MateoThemeData(colorScheme: colorScheme, palette: palette));
  }

  static ThemeData _build(MateoThemeData mateoData) {
    final mateoColorScheme = mateoData.colorScheme;
    final palette = mateoData.palette;

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: palette.primary[9],
      onPrimary: mateoColorScheme.buttons.primary.foreground,
      primaryContainer: palette.primary[3],
      onPrimaryContainer: palette.primary[11],
      secondary: palette.teal[9],
      onSecondary: palette.teal[12],
      secondaryContainer: palette.teal[3],
      onSecondaryContainer: palette.teal[11],
      tertiary: palette.orange[9],
      onTertiary: palette.orange[12],
      tertiaryContainer: palette.orange[3],
      onTertiaryContainer: palette.orange[11],
      error: palette.red[10],
      onError: Colors.white,
      errorContainer: palette.red[3],
      onErrorContainer: palette.red[11],
      surface: mateoColorScheme.background,
      onSurface: mateoColorScheme.text.primary,
      onSurfaceVariant: mateoColorScheme.text.secondary,
      outline: palette.neutral[8],
      outlineVariant: palette.neutral[6],
      shadow: const Color(0xFF000000),
      scrim: mateoColorScheme.overlay.scrim,
      inverseSurface: mateoColorScheme.inverse.background,
      onInverseSurface: mateoColorScheme.inverse.onBackground,
      inversePrimary: mateoColorScheme.inverse.primary,
      surfaceTint: palette.primary[9],
    );
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: MateoTypography.fontFamily,
      scaffoldBackgroundColor: mateoData.colorScheme.background,
      extensions: [mateoData],
    );

    return theme.copyWith(textTheme: _applyTypography(theme.textTheme));
  }

  static TextTheme _applyTypography(TextTheme textTheme) {
    return TextTheme(
      displayLarge: _applyTextPrimitives(textTheme.displayLarge),
      displayMedium: _applyTextPrimitives(textTheme.displayMedium),
      displaySmall: _applyTextPrimitives(textTheme.displaySmall),
      headlineLarge: _applyTextPrimitives(textTheme.headlineLarge),
      headlineMedium: _applyTextPrimitives(textTheme.headlineMedium),
      headlineSmall: _applyTextPrimitives(textTheme.headlineSmall),
      titleLarge: _applyTextPrimitives(textTheme.titleLarge),
      titleMedium: _applyTextPrimitives(textTheme.titleMedium),
      titleSmall: _applyTextPrimitives(textTheme.titleSmall),
      bodyLarge: _applyTextPrimitives(textTheme.bodyLarge),
      bodyMedium: _applyTextPrimitives(textTheme.bodyMedium),
      bodySmall: _applyTextPrimitives(textTheme.bodySmall),
      labelLarge: _applyTextPrimitives(textTheme.labelLarge),
      labelMedium: _applyTextPrimitives(textTheme.labelMedium),
      labelSmall: _applyTextPrimitives(textTheme.labelSmall),
    );
  }

  static TextStyle? _applyTextPrimitives(TextStyle? style) => style?.copyWith(
    fontFamily: MateoTypography.fontFamily,
    letterSpacing: MateoTypography.letterSpacing,
  );
}
