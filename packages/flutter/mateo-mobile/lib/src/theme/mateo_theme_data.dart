import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'color_scheme/mateo_color_scheme.dart';
import 'palette/mateo_palette.dart';

/// A consistent palette and semantic color scheme for a Mateo appearance.
///
/// Customize only the accent pair. The palette and semantic roles are derived
/// together so changes cannot leave them out of sync.
/// Dark appearance currently resolves to light until its colors are authored.
@immutable
final class MateoThemeData {
  /// Creates the light appearance from [accentColor] and [onAccent].
  ///
  /// The accent must be opaque. The foreground is preserved exactly; choose
  /// an [onAccent] with sufficient contrast for the intended content.
  factory MateoThemeData.light({required Color accentColor, required Color onAccent}) {
    final palette = MateoPalette(accentColor: accentColor);
    return MateoThemeData._(
      brightness: .light,
      palette: palette,
      colorScheme: MateoColorScheme.light(palette: palette, onAccent: onAccent),
    );
  }

  /// Creates the current fallback for a requested dark appearance.
  ///
  /// Both [accentColor] and [onAccent] are passed to [MateoThemeData.light].
  /// Until dark colors are authored, this returns the light appearance and
  /// [brightness] remains [Brightness.light].
  factory MateoThemeData.dark({required Color accentColor, required Color onAccent}) =>
      MateoThemeData.light(accentColor: accentColor, onAccent: onAccent);

  const MateoThemeData._({required this.brightness, required this.palette, required this.colorScheme});

  /// The resolved appearance, including the current light fallback for dark.
  final Brightness brightness;

  /// The primitive palette used to derive [colorScheme].
  final MateoPalette palette;

  /// The shared and component semantic colors for this appearance.
  final MateoColorScheme colorScheme;

  /// The consistent theme with optional [accentColor] and [onAccent] replaced.
  MateoThemeData copyWith({Color? accentColor, Color? onAccent}) {
    final create = switch (brightness) {
      .light => MateoThemeData.light,
      .dark => MateoThemeData.dark,
    };
    return create(
      accentColor: accentColor ?? colorScheme.accent,
      onAccent: onAccent ?? colorScheme.onAccent,
    );
  }

  /// Whether both themes have the same appearance, palette, and semantic colors.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoThemeData &&
          brightness == other.brightness &&
          palette == other.palette &&
          colorScheme == other.colorScheme;

  /// The hash of the appearance, palette, and semantic colors.
  @override
  int get hashCode => Object.hash(brightness, palette, colorScheme);
}
