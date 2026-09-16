part of 'mateo_select.dart';

/// Presentation state supplied to builders owned by a [MateoSelect].
///
/// This state is intentionally named for the complete select so future builder
/// capabilities can be added without replacing an icon-specific public type.
@immutable
class MateoSelectState {
  /// Creates a select presentation-state snapshot.
  const MateoSelectState({
    required this.iconSize,
    required this.recommendedIconColor,
  });

  /// Recommended logical-pixel size for an option's icon glyph.
  final double iconSize;

  /// Recommended default color for an option's icon visual.
  ///
  /// An icon may use another color when that color carries useful meaning.
  final Color recommendedIconColor;
}
