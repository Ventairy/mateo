part of 'mateo_button.dart';

/// Builds a [MateoButton] icon from its current state.
typedef MateoButtonIconBuilder = Widget Function(MateoButtonState state);

/// State passed to button builders.
@immutable
class MateoButtonState {
  /// Creates a button state snapshot.
  const MateoButtonState({
    required this.isEnabled,
    required this.foregroundColor,
  });

  /// Whether the button can currently be pressed.
  final bool isEnabled;

  /// Foreground color derived from the button state.
  final Color foregroundColor;
}
