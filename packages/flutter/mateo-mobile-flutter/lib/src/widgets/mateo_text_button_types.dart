part of 'mateo_text_button.dart';

/// Builds a [MateoTextButton] icon from its current state.
typedef MateoTextButtonIconBuilder =
    Widget Function(MateoTextButtonIconState state);

/// State passed to [MateoTextButtonIconBuilder].
@immutable
class MateoTextButtonIconState {
  /// Creates a text button icon state snapshot.
  const MateoTextButtonIconState({
    required this.isEnabled,
    required this.recommendedIconColor,
  });

  /// Whether the button can currently be pressed.
  final bool isEnabled;

  /// Recommended foreground color for the icon.
  final Color recommendedIconColor;
}
