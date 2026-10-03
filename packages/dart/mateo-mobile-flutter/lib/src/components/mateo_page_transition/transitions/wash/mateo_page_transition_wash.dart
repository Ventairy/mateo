// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of '../../mateo_page_transition.dart';

/// A feathered page reveal.
final class MateoPageTransitionWash extends MateoPageTransition {
  /// Creates a wash page transition.
  ///
  /// Durations must be nonnegative. An omitted [reverseDuration] uses [duration].
  const MateoPageTransitionWash({
    super.direction = .up,
    super.duration = const .new(milliseconds: 600),
    Duration? reverseDuration,
  }) : openingCurve = Curves.easeInOutSine,
       closingCurve = Curves.easeOutQuad,
       opacityCurve = Curves.easeInOutCubic,
       super._(reverseDuration: reverseDuration ?? duration);

  /// The easing of the expanding reveal.
  final Curve openingCurve;

  /// The easing of the collapsing reveal.
  final Curve closingCurve;

  /// The easing of the reveal opacity.
  final Curve opacityCurve;

  @override
  Widget buildIncoming({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  }) => _MateoPageTransitionMotion(
    child: child,
    builder: (child, {required useLinearProgress}) => _MateoWashPageTransitionView(
      animation: animation,
      transition: this,
      allowSnapshotting: allowSnapshotting,
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
