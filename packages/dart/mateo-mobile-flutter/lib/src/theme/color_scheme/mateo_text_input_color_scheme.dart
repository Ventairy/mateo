part of 'mateo_color_scheme.dart';

/// The surface and content colors of one text input treatment.
@immutable
final class MateoTextInputColorScheme {
  /// Creates a complete text input treatment for available and unavailable states.
  const MateoTextInputColorScheme({
    required this.background,
    required this.text,
    required this.placeholder,
    required this.icon,
    required this.backgroundDisabled,
    required this.textDisabled,
    required this.placeholderDisabled,
    required this.iconDisabled,
  });

  /// The surface color while available.
  final Color background;

  /// The entered text color while available.
  final Color text;

  /// The placeholder color while available.
  final Color placeholder;

  /// The icon color while available.
  final Color icon;

  /// The surface color while unavailable.
  final Color backgroundDisabled;

  /// The entered text color while unavailable.
  final Color textDisabled;

  /// The placeholder color while unavailable.
  final Color placeholderDisabled;

  /// The icon color while unavailable.
  final Color iconDisabled;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoTextInputColorScheme &&
          background == other.background &&
          text == other.text &&
          placeholder == other.placeholder &&
          icon == other.icon &&
          backgroundDisabled == other.backgroundDisabled &&
          textDisabled == other.textDisabled &&
          placeholderDisabled == other.placeholderDisabled &&
          iconDisabled == other.iconDisabled;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(
    background,
    text,
    placeholder,
    icon,
    backgroundDisabled,
    textDisabled,
    placeholderDisabled,
    iconDisabled,
  );
}
