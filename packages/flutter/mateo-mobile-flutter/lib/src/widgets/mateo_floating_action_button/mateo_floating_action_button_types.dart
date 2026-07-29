part of 'mateo_floating_action_button.dart';

/// Builds a [MateoFloatingActionButton] icon from its presentation state.
typedef MateoFloatingActionButtonIconBuilder =
    Widget Function(MateoFloatingActionButtonIconState state);

/// The presentation state passed to a floating-button icon builder.
@immutable
class MateoFloatingActionButtonIconState {
  /// Creates a floating-button icon state snapshot.
  const MateoFloatingActionButtonIconState({
    required this.foregroundColor,
    required this.iconSize,
  });

  /// The resolved foreground color recommended for the icon.
  final Color foregroundColor;

  /// The recommended floating-button icon size.
  final double iconSize;
}
