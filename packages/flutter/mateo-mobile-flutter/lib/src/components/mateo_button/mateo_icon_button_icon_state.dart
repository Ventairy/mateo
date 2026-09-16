part of 'mateo_button.dart';

/// Resolved button state with the icon presentation's recommended size.
@immutable
class MateoIconButtonIconState extends MateoButtonState {
  /// Creates an icon state snapshot.
  const MateoIconButtonIconState({
    required super.isEnabled,
    required super.isInteractive,
    required super.isPressed,
    required super.isLoading,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.borderRadius,
    required this.iconSize,
    super.elevation,
  });

  /// Recommended icon size, in logical pixels.
  final double iconSize;
}
