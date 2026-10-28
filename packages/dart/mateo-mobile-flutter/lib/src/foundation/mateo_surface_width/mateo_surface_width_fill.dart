part of 'mateo_surface_width.dart';

/// A fill width request for a Mateo surface.
final class MateoSurfaceWidthFill extends MateoSurfaceWidth {
  /// Creates a fill width request, optionally capped by [maxWidth].
  const MateoSurfaceWidthFill({this.maxWidth})
    : assert(
        maxWidth == null || (maxWidth >= 0 && maxWidth < double.infinity),
        'maxWidth must be finite and nonnegative.',
      ),
      super._();

  /// The maximum requested total width in logical pixels, including padding.
  ///
  /// A null cap fills the parent's finite available width. A supplied cap also
  /// allows filling under unbounded width. Parent minimum constraints may
  /// require a width larger than this cap.
  final double? maxWidth;

  /// Whether both values describe the same width request.
  @override
  bool operator ==(Object other) => other is MateoSurfaceWidthFill && maxWidth == other.maxWidth;

  /// The hash of this width request.
  @override
  int get hashCode => Object.hash(MateoSurfaceWidthFill, maxWidth);
}
