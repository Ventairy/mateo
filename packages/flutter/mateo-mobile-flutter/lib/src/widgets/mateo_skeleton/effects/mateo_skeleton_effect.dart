part of 'package:mateo_mobile/src/widgets/mateo_skeleton/mateo_skeleton.dart';

abstract class MateoSkeletonEffect {
  const MateoSkeletonEffect();

  Paint buildPaint({
    required Rect bounds,
    required double t,
    required MateoColorScheme colorScheme,
    required MateoSkeletonStyle style,
  });
}

/// A skeleton effect that does not require an active animation ticker.
///
/// Extend this class to create static effects. Only [buildPaint] is needed.
///
/// ```dart
/// class MyDimmedEffect extends MateoSkeletonStaticEffectBase {
///   const MyDimmedEffect();
///
///   @override
///   Paint buildPaint({required Rect bounds, required double t, required MateoColorScheme colorScheme, required MateoSkeletonStyle style}) {
///     return Paint()..color = colorScheme.skeleton.bone.withValues(alpha: 0.5);
///   }
/// }
/// ```
abstract class MateoSkeletonStaticEffectBase extends MateoSkeletonEffect {
  /// Creates a Mateo static skeleton effect.
  const MateoSkeletonStaticEffectBase();

  /// Builds the [Paint] used to fill skeleton bones for the current frame.
  ///
  /// Called once per paint cycle with `t = 0`. [bounds] is the skeleton's
  /// rect in the parent canvas coordinate space. [colorScheme] is the active
  /// [MateoColorScheme] theme palette.
  @override
  Paint buildPaint({
    required Rect bounds,
    required double t,
    required MateoColorScheme colorScheme,
    required MateoSkeletonStyle style,
  });
}

/// A skeleton effect that plays a repeating animation cycle.
///
/// Extend this class to create animated effects. Override [duration],
/// [lowerBound], and [upperBound] to customize the animation timing.
///
/// ```dart
/// class MyPulseEffect extends MateoSkeletonAnimatedEffectBase {
///   const MyPulseEffect();
///
///   @override
///   Duration get duration => const Duration(milliseconds: 1000);
///   @override
///   double get lowerBound => 0.0;
///   @override
///   double get upperBound => math.pi * 2;
///
///   @override
///   Paint buildPaint({required Rect bounds, required double t, required MateoColorScheme colorScheme, required MateoSkeletonStyle style}) {
///     final alpha = (0.5 + 0.5 * math.sin(t)).clamp(0.0, 1.0);
///     return Paint()..color = colorScheme.skeleton.bone.withValues(alpha: alpha);
///   }
/// }
/// ```
///
/// See also:
///  * [MateoSkeletonShimmerEffect], the built-in animated shimmer sweep effect.
abstract class MateoSkeletonAnimatedEffectBase extends MateoSkeletonEffect {
  /// Creates a Mateo animated skeleton effect.
  const MateoSkeletonAnimatedEffectBase();

  /// Builds the [Paint] used to fill skeleton bones for the current frame.
  ///
  /// Called on every paint frame with the current animation value `t`
  /// between [lowerBound] and [upperBound]. [bounds] is the skeleton's
  /// rect in the parent canvas coordinate space. [colorScheme] is the active
  /// [MateoColorScheme] theme palette.
  @override
  Paint buildPaint({
    required Rect bounds,
    required double t,
    required MateoColorScheme colorScheme,
    required MateoSkeletonStyle style,
  });

  /// The duration of one animation cycle.
  Duration get duration => const Duration(milliseconds: 1500);

  /// The lower bound of the animation controller value passed as `t` to
  /// [buildPaint].
  double get lowerBound => -0.5;

  /// The upper bound of the animation controller value passed as `t` to
  /// [buildPaint].
  double get upperBound => 1.5;
}
