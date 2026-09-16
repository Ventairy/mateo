part of '../mateo_surface.dart';

/// Same-frame geometry supplied by a component hosting a [MateoSurface].
///
/// This package-internal contract lets hosts contribute measured obstructions
/// without making the surface depend on any particular host component.
@internal
final class MateoSurfaceLayoutConstraints extends BoxConstraints {
  /// Creates tight surface constraints with local viewport geometry.
  MateoSurfaceLayoutConstraints({
    required Size size,
    required this.leadingExtent,
    required this.trailingExtent,
    required this.viewportExtent,
    required this.paddingOverride,
    required this.reserveLeadingExtent,
    required this.reserveTrailingExtent,
  }) : assert(leadingExtent >= 0, 'leadingExtent must be non-negative.'),
       assert(trailingExtent >= 0, 'trailingExtent must be non-negative.'),
       assert(viewportExtent >= 0, 'viewportExtent must be non-negative.'),
       super.tight(size);

  /// Complete obstruction at the top of the surface.
  final double leadingExtent;

  /// Complete obstruction at the bottom of the surface.
  final double trailingExtent;

  /// Height available to the viewport before keyboard obstruction.
  final double viewportExtent;

  /// Optional host-provided edge inset replacement.
  final EdgeInsets? paddingOverride;

  /// Whether ordinary content clears [leadingExtent].
  final bool reserveLeadingExtent;

  /// Whether ordinary content clears [trailingExtent].
  final bool reserveTrailingExtent;

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is MateoSurfaceLayoutConstraints &&
      other.leadingExtent == leadingExtent &&
      other.trailingExtent == trailingExtent &&
      other.viewportExtent == viewportExtent &&
      other.paddingOverride == paddingOverride &&
      other.reserveLeadingExtent == reserveLeadingExtent &&
      other.reserveTrailingExtent == reserveTrailingExtent;

  @override
  int get hashCode => Object.hash(
    super.hashCode,
    leadingExtent,
    trailingExtent,
    viewportExtent,
    paddingOverride,
    reserveLeadingExtent,
    reserveTrailingExtent,
  );
}
