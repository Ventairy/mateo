part of 'mateo_icon_button.dart';

/// Builds a [MateoIconButton] icon from its current state.
typedef MateoIconButtonIconBuilder =
    Widget Function(MateoIconButtonIconState state);

/// State passed to [MateoIconButtonIconBuilder].
@immutable
class MateoIconButtonIconState {
  /// Creates an icon button state snapshot.
  const MateoIconButtonIconState({
    required this.isEnabled,
    required this.recommendedIconColor,
    required this.iconSize,
  });

  /// Whether the button can currently be pressed.
  final bool isEnabled;

  /// Recommended foreground color for the icon.
  final Color recommendedIconColor;

  /// Recommended icon size.
  final double iconSize;
}
