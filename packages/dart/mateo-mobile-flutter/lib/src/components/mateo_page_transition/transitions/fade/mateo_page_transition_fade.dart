// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of '../../mateo_page_transition.dart';

/// A full-page opacity transition over a stationary previous page.
final class MateoPageTransitionFade extends MateoPageTransition {
  /// Creates a fade with a gentle arrival and a shorter return.
  ///
  /// Durations must be nonnegative. Opening defaults to 600 milliseconds and
  /// closing to 300 milliseconds, independently of a custom opening duration.
  const MateoPageTransitionFade({
    super.duration = const .new(milliseconds: 600),
    super.reverseDuration = const .new(milliseconds: 300),
  }) : openingCurve = const _MateoFadeOpeningCurve(),
       closingCurve = const _MateoFadeClosingCurve(),
       super._();

  /// The opacity gained as the destination opens.
  final Curve openingCurve;

  /// The opacity lost as the destination closes.
  final Curve closingCurve;

  @override
  Widget buildIncoming({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  }) => _MateoPageTransitionMotion(
    animation: animation,
    child: child,
    builder: (child, animation, {required useLinearProgress}) => _MateoFadePageTransitionView(
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
