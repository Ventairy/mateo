part of 'mateo_toast.dart';

/// Builds a custom icon for a [MateoToast].
///
/// Passed to [MateoToast.iconBuilder] to override the default type-driven icon.
/// The [MateoToastState] provides the state about the toast configuration so
/// the icon can be built with the same style as the default icon.
typedef MateoToastIconBuilder = Widget Function(MateoToastState state);

/// State snapshot delivered to [MateoToast] builder callbacks.
///
/// Carries the current toast context — such as layout metrics and theme
/// colors — that builders can use to render consistent widgets.
@immutable
class MateoToastState {
  /// Creates a toast state snapshot.
  const MateoToastState({required this.iconSize, required this.iconColor});

  /// Recommended icon edge size in logical pixels.
  ///
  /// This is a recommendation, not a hard constraint. The value fits circled
  /// icons perfectly; depending on the icon shape a smaller or larger value
  /// may look better. The toast reserves a fixed layout slot regardless of
  /// the size the returned widget actually renders at.
  final double iconSize;

  /// Icon color resolved from the active Mateo Mobile theme for the toast's [MateoToastType].
  final Color iconColor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToastState &&
          other.iconSize == iconSize &&
          other.iconColor == iconColor;

  @override
  int get hashCode => Object.hash(iconSize, iconColor);
}
