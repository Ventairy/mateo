part of 'mateo_color_scheme.dart';

/// The surface and content colors of an options menu.
@immutable
final class MateoOptionsMenuColorScheme {
  /// Creates the color roles of an options menu.
  const MateoOptionsMenuColorScheme({
    required this.background,
    required this.leading,
    required this.principal,
    required this.supporting,
  });

  /// The panel background color.
  final Color background;

  /// The default monochrome leading color.
  final Color leading;

  /// The default principal content color.
  final Color principal;

  /// The default supporting content color.
  final Color supporting;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoOptionsMenuColorScheme &&
          background == other.background &&
          leading == other.leading &&
          principal == other.principal &&
          supporting == other.supporting;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(background, leading, principal, supporting);
}
