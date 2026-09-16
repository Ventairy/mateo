part of 'mateo_color_scheme.dart';

/// The semantic colors for sheet presentation.
@immutable
final class MateoSheetColorScheme {
  /// Creates the color roles of a sheet.
  const MateoSheetColorScheme({required this.scrim});

  /// The translucent color that dims content behind a sheet.
  final Color scrim;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) => identical(this, other) || other is MateoSheetColorScheme && scrim == other.scrim;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => scrim.hashCode;
}
