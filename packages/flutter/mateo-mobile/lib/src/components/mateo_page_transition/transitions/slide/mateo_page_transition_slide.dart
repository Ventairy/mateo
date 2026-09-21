// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of '../../mateo_page_transition.dart';

/// A page transition that moves the destination over a stationary page.
final class MateoPageTransitionSlide extends MateoPageTransition {
  /// Creates a slide page transition.
  ///
  /// Durations must be nonnegative.
  const MateoPageTransitionSlide({
    super.direction = .up,
    super.duration = const .new(milliseconds: 320),
    super.reverseDuration = const .new(milliseconds: 260),
  }) : openingCurve = const _MateoSlideOpeningCurve(),
       closingCurve = const _MateoSlideClosingCurve(),
       super._();

  /// The easing used when the destination opens.
  final Curve openingCurve;

  /// The easing used when the destination closes.
  final Curve closingCurve;

  @override
  Widget buildIncoming({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  }) => _MateoPageTransitionMotion(
    child: child,
    builder: (child, {required useLinearProgress}) => _MateoSlidePageTransitionView(
      animation: animation,
      transition: this,
      useLinearProgress: useLinearProgress,
      child: child,
    ),
  );

  @override
  Widget buildOutgoing({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  }) => child;
}
