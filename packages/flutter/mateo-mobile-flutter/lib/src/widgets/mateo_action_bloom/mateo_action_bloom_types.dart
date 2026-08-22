part of 'mateo_action_bloom.dart';

/// Builds the widget anchored by a [MateoActionBloomSurface].
@internal
typedef MateoActionBloomSurfaceBuilder = Widget Function(BuildContext context);

/// A builder for a [MateoActionBloomAction] icon's presentation state.
typedef MateoActionBloomActionIconBuilder = Widget Function(MateoActionBloomActionIconState state);

/// A callback that handles a selected [MateoActionBloomAction].
///
/// The [feedbackAnimation] future completes when the action's press feedback
/// ends. Await it before navigation or another disruptive operation, or ignore
/// it when the action should continue immediately.
typedef MateoActionBloomActionCallback = Future<void> Function(Future<void> feedbackAnimation);

/// A state snapshot passed to [MateoActionBloomActionIconBuilder].
@immutable
class MateoActionBloomActionIconState {
  /// Creates an action-icon state snapshot.
  const MateoActionBloomActionIconState({
    required this.animationProgress,
    required this.foregroundColor,
    required this.iconSize,
  });

  /// The owning bloom's transform progress from closed at `0` to open at `1`.
  final double animationProgress;

  /// The resolved foreground color recommended for the action icon.
  final Color foregroundColor;

  /// The recommended action icon size.
  final double iconSize;
}
