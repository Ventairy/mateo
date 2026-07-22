part of 'mateo_skeleton.dart';

/// Bundles the configurable visual styling for [MateoSkeleton] bones.
///
///
/// ```dart
/// // Defaults — static pill bones, theme color.
/// MateoSkeleton(child: card);
///
/// // Custom resting color + shimmer.
/// MateoSkeleton(
///   style: MateoSkeletonStyle(
///     color: Color(0xFFE2E2E2),
///     effect: MateoSkeletonShimmerEffect(),
///   ),
///   child: card,
/// );
///
/// // Squared text-line bones (no rounding).
/// MateoSkeleton(
///   style: MateoSkeletonStyle(textRadius: Radius.zero),
///   child: card,
/// );
/// ```
///
/// See also:
///  * [MateoSkeleton], the widget that consumes a [MateoSkeletonStyle].
///  * [MateoSkeletonShimmerEffect], a shimmer effect to be used with a [MateoSkeletonStyle].
///  * [MateoSkeletonFadeEffect], a fade/breathing effect to be used with a [MateoSkeletonStyle].
@immutable
class MateoSkeletonStyle {
  /// Creates a Mateo Mobile skeleton style.
  ///
  /// All fields are optional and fall back to theme / widget defaults when
  /// `null`
  const MateoSkeletonStyle({this.color, this.effect, this.textRadius});

  /// The resting fill color of the skeleton bones.
  ///
  /// When `null`, the theme's `skeleton.bone` token drives the bone color.
  /// drives the bone color. When set, this overrides the theme token for
  /// both the solid fill (no effect) and the effect's resting color
  final Color? color;

  /// The paint effect applied to the skeleton bones.
  ///
  /// When `null`, bones render as a static solid fill using [color]
  final MateoSkeletonEffect? effect;

  /// The corner radius of text-line bones.
  ///
  /// When `null`, text-line bones render as pills (radius = half the
  /// line height, the classic shimmer-text look). When set, the given
  /// [Radius] is applied to each text-line bone via
  /// [RRect.fromRectAndRadius], which clamps it to `min(width, height) / 2`.
  ///
  /// Applies **only** to text-line bones (paragraph draw calls). Other
  /// bone shapes (rects, rrects, circles, ovals, paths) keep their
  /// original geometry, exactly as before.
  final Radius? textRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MateoSkeletonStyle &&
        other.color == color &&
        other.effect == effect &&
        other.textRadius == textRadius;
  }

  @override
  int get hashCode => Object.hash(color, effect, textRadius);
}
