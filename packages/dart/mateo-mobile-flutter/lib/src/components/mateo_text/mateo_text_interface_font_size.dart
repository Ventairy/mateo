part of 'mateo_text.dart';

/// A semantic or custom size for Mateo interface text.
@immutable
final class MateoTextInterfaceFontSize {
  /// Creates an explicit font size in logical pixels before text scaling.
  const new custom(this.value);

  /// The standard body text size.
  static const MateoTextInterfaceFontSize body = .custom(15.7);

  /// The font size in logical pixels before text scaling.
  final double value;
}
