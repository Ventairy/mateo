import 'package:flutter/material.dart';

import 'mateo_color_scheme/mateo_color_scheme.dart';
import 'mateo_palette/mateo_palette.dart';
import 'mateo_theme_data.dart';
import 'mateo_typography.dart';

/// A complete Mateo theme configuration for a mobile application.
///
/// The configuration contains both appearance branches and the mode Flutter
/// uses to select between them. [MateoTheme.adaptive] follows system brightness
/// without requiring a [BuildContext]. Mateo currently authors only a light
/// appearance, so its dark branch intentionally uses the light theme until a
/// dark color scheme is available.
@immutable
final class MateoTheme {
  /// Creates a Mateo configuration that always uses the light appearance.
  ///
  /// The [accentColor] is preserved at accent step 9. Mateo's neutral scale is
  /// fixed and achromatic. The [onAccent] color is used on accent surfaces and
  /// must be contrast-checked by consumers.
  factory MateoTheme.light({
    required Color accentColor,
    required Color onAccent,
  }) {
    final lightTheme = _buildLight(
      accentColor: accentColor,
      onAccent: onAccent,
    );

    return MateoTheme._(
      lightTheme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.light,
    );
  }

  /// Creates a Mateo configuration that follows system brightness.
  ///
  /// The [accentColor] is preserved at accent step 9. Mateo's neutral scale is
  /// fixed and achromatic. The [onAccent] color is used on accent surfaces and
  /// must be contrast-checked by consumers.
  ///
  /// Both appearance branches currently contain Mateo's light theme. The dark
  /// branch is already part of this configuration so a future authored dark
  /// appearance can replace it without changing consumer APIs.
  factory MateoTheme.adaptive({
    required Color accentColor,
    required Color onAccent,
  }) {
    final lightTheme = _buildLight(
      accentColor: accentColor,
      onAccent: onAccent,
    );

    return MateoTheme._(
      lightTheme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.system,
    );
  }

  const MateoTheme._({
    required this.lightTheme,
    required this.darkTheme,
    required this.themeMode,
  });

  /// The theme used when Flutter selects the light appearance.
  final ThemeData lightTheme;

  /// The theme used when Flutter selects the dark appearance.
  ///
  /// This currently contains the light appearance until Mateo authors a dark
  /// color scheme.
  final ThemeData darkTheme;

  /// The mode Flutter uses to select an appearance branch.
  final ThemeMode themeMode;

  static ThemeData _buildLight({
    required Color accentColor,
    required Color onAccent,
  }) {
    final palette = MateoPalette(accentColor: accentColor);
    final colorScheme = MateoColorScheme.light(
      palette: palette,
      onAccent: onAccent,
    );

    return _buildThemeData(
      MateoThemeData(
        colorScheme: colorScheme,
        palette: palette,
      ),
    );
  }

  static ThemeData _buildThemeData(MateoThemeData mateoData) {
    final mateoColorScheme = mateoData.colorScheme;
    final palette = mateoData.palette;

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: palette.accent[9],
      onPrimary: mateoColorScheme.buttons.primary.accent.foreground,
      primaryContainer: palette.accent[3],
      onPrimaryContainer: palette.accent[11],
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
      inversePrimary: mateoColorScheme.inverse.accent,
      surfaceTint: palette.accent[9],
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
