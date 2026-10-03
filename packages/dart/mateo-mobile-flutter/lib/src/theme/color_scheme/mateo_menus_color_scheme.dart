part of 'mateo_color_scheme.dart';

/// The semantic color treatments for Mateo menus.
@immutable
final class MateoMenusColorScheme {
  const MateoMenusColorScheme._({required this.options});

  /// The colors of an options menu.
  final MateoOptionsMenuColorScheme options;

  /// Whether every menu treatment equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoMenusColorScheme && options == other.options;

  /// The hash of this scheme's menu treatments.
  @override
  int get hashCode => options.hashCode;
}
