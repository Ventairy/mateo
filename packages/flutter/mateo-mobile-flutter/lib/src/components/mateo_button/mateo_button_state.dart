part of 'mateo_button.dart';

/// State passed to button builders.
@immutable
class MateoButtonState {
  /// Creates a button state snapshot.
  const MateoButtonState({
    required this.isEnabled,
    required this.isInteractive,
    required this.isPressed,
    required this.isLoading,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    this.elevation = 0,
  });

  /// Whether the button has an enabled callback and uses enabled colors.
  ///
  /// This remains `true` while a temporarily non-interactive button is loading.
  /// Use [isInteractive] when the builder needs the current input state.
  final bool isEnabled;

  /// Whether the button currently accepts presses.
  final bool isInteractive;

  /// Whether the button is currently pressed.
  final bool isPressed;

  /// Whether the button is currently presenting its loading state.
  final bool isLoading;

  /// Background color derived from the button state.
  final Color backgroundColor;

  /// Foreground color derived from the button state.
  final Color foregroundColor;

  /// Physical distance of this button surface from its surrounding content.
  ///
  /// The authored value remains unchanged while the button is pressed,
  /// disabled, or loading. Custom backgrounds may use or ignore this value.
  final double elevation;

  /// Border radius used by the default button background.
  final BorderRadius borderRadius;
}
