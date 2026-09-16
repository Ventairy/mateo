// Fixed variant configuration belongs in its constructor.
// ignore_for_file: avoid_field_initializers_in_const_classes

part of '../../mateo_page_transition.dart';

/// A page transition with attached movement.
final class MateoPageTransitionPush extends MateoPageTransition {
  /// Creates a push page transition.
  ///
  /// Durations must be nonnegative. An omitted [reverseDuration] uses [duration].
  const MateoPageTransitionPush({
    super.direction = .up,
    super.duration = const .new(milliseconds: 600),
    Duration? reverseDuration,
  }) : curve = Curves.easeInOutCubic,
       super._(reverseDuration: reverseDuration ?? duration);

  /// The easing of attached page movement.
  final Curve curve;

  @override
  Widget buildIncoming({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  }) => _MateoPageTransitionMotion(
    child: child,
    builder: (child, {required useLinearProgress}) => _MateoPushPageTransitionView(
      animation: animation,
      transition: this,
      outgoing: false,
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
  }) => _MateoPageTransitionMotion(
    child: child,
    builder: (child, {required useLinearProgress}) => _MateoPushPageTransitionView(
      animation: animation,
      transition: this,
      outgoing: true,
      allowSnapshotting: allowSnapshotting,
      useLinearProgress: useLinearProgress,
      child: child,
    ),
  );
}
